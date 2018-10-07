/******************************************************/
/**                                                  **/
/**      Features/AutoWalls.mm                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-16                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "AutoWalls.h"

CAutoWalls::CAutoWalls() {}

void CAutoWalls::TraceLine(Vector vecAbsStart, Vector vecAbsEnd, unsigned int mask, C_CSPlayer* ignore, trace_t* ptr) {
    Ray_t ray;
    ray.Init(vecAbsStart, vecAbsEnd);
    CTraceFilter filter;
    filter.pSkip = ignore;
    
    Trace->TraceRay(ray, mask, &filter, ptr);
}

float CAutoWalls::GetHitgroupDamageMultiplier(int iHitGroup) {
    switch (iHitGroup) {
        case HITGROUP_GENERIC:
            return 1.0f;
        case HITGROUP_HEAD:
            return 4.0f;
        case HITGROUP_CHEST:
            return 1.0f;
        case HITGROUP_STOMACH:
            return 1.25f;
        case HITGROUP_LEFTARM:
            return 1.0f;
        case HITGROUP_RIGHTARM:
            return 1.0f;
        case HITGROUP_LEFTLEG:
            return 0.75f;
        case HITGROUP_RIGHTLEG:
            return 0.75f;
        case HITGROUP_GEAR:
            return 1.0f;
        default:
            return 1.0f;
    }
}

bool CAutoWalls::TraceToExit(Vector &end, trace_t *enter_trace, Vector start, Vector dir, trace_t *exit_trace) {
    float distance = 0.0f;
    
    while (distance <= 90.0f) {
        distance += 4.0f;
        end = start + dir * distance;
        
        auto point_contents = Trace->GetPointContents(end, MASK_SHOT_HULL | CONTENTS_HITBOX, NULL);
        
        if (point_contents & MASK_SHOT_HULL && (!(point_contents & CONTENTS_HITBOX))) {
            continue;
        }
        
        auto new_end = end - (dir * 4.0f);
        
        TraceLine(end, new_end, 0x4600400B, 0, exit_trace);
        if (exit_trace->startsolid && exit_trace->surface.flags & SURF_HITBOX) {
            TraceLine(end, start, 0x600400B, (C_CSPlayer*)exit_trace->m_pEntityHit, exit_trace);
            
            if ((exit_trace->fraction < 1.0f || exit_trace->allsolid) && !exit_trace->startsolid) {
                end = exit_trace->endpos;
                return true;
            }
            continue;
        }
        
        if (!(exit_trace->fraction < 1.0 || exit_trace->allsolid || exit_trace->startsolid ) || exit_trace->startsolid) {
            if (exit_trace->m_pEntityHit) {
                if (enter_trace->m_pEntityHit && enter_trace->m_pEntityHit == EntList->GetClientEntity(0)) {
                    return true;
                }
            }
            continue;
        }
        
        if (((exit_trace->surface.flags >> 7) & 1) && !((enter_trace->surface.flags >> 7) & 1)) {
            continue;
        }
        
        if (exit_trace->plane.normal.Dot(dir) <= 1.0f) {
            auto fraction = exit_trace->fraction * 4.0f;
            end = end - (dir * fraction);
            return true;
        }
    }
    return false;
}

void CAutoWalls::ScaleDamage(int hitgroup, C_CSPlayer* enemy, float weapon_armor_ratio, float & current_damage) {
    current_damage *= GetHitgroupDamageMultiplier(hitgroup);

    if (enemy->GetArmor() > 0) {
        if (hitgroup == (int)HitGroups::HITGROUP_HEAD) {
            if (enemy->HasHelmet()) {
                current_damage *= weapon_armor_ratio;
            }
        } else {
            current_damage *= weapon_armor_ratio;
        }
    }
}

bool CAutoWalls::HandleBulletPenetration(WeaponCSInfo_t* weaponInfo, FireBulletData &data) {
    surfacedata_t *enter_surface_data = Physics->GetSurfaceData(data.enter_trace.surface.surfaceProps);
    int enter_material = enter_surface_data->game.material;
    
    float enter_surf_penetration_mod = enter_surface_data->game.flPenetrationModifier;
    
    data.trace_length += data.enter_trace.fraction * data.trace_length_remaining;
    data.current_damage *= pow(weaponInfo->m_flRangeModifier, data.trace_length * 0.002f);
    
    if (data.trace_length > 3000.f || enter_surf_penetration_mod < 0.1f) {
        data.penetrate_count = 0;
    }
    
    if (data.penetrate_count <= 0) {
        return false;
    }
    
    Vector dummy;
    trace_t trace_exit;
    if (!TraceToExit(dummy, &data.enter_trace, data.enter_trace.endpos, data.direction, &trace_exit)) {
        return false;
    }
    
    surfacedata_t *exit_surface_data = Physics->GetSurfaceData(trace_exit.surface.surfaceProps);
    int exit_material = exit_surface_data->game.material;
    
    float exit_surf_penetration_mod = exit_surface_data->game.flPenetrationModifier;
    float final_damage_modifier = 0.16f;
    float combined_penetration_modifier = 0.0f;
    
    if (((data.enter_trace.contents & CONTENTS_GRATE) != 0) || (enter_material == 89) || (enter_material == 71)) {
        combined_penetration_modifier = 3.0f;
        final_damage_modifier = 0.05f;
    } else {
        combined_penetration_modifier = ( enter_surf_penetration_mod + exit_surf_penetration_mod ) * 0.5f;
    }
    
    if (enter_material == exit_material) {
        if (exit_material == 87 || exit_material == 85) {
            combined_penetration_modifier = 3.0f;
        } else if (exit_material == 76) {
            combined_penetration_modifier = 2.0f;
        }
    }
    
    float v34 = fmaxf(0.f, 1.0f / combined_penetration_modifier);
    float v35 = (data.current_damage * final_damage_modifier) + v34 * 3.0f * fmaxf(0.0f, (3.0f / weaponInfo->m_flPenetration) * 1.25f);
    float thickness = (trace_exit.endpos - data.enter_trace.endpos).Length();
    
    thickness *= thickness;
    thickness *= v34;
    thickness /= 24.0f;
    
    float lost_damage = fmaxf(0.0f, v35 + thickness);
    
    if (lost_damage > data.current_damage) {
        return false;
    }
    
    if (lost_damage >= 0.0f) {
        data.current_damage -= lost_damage;
    }
    
    if (data.current_damage < 1.0f) {
        return false;
    }
    
    data.src = trace_exit.endpos;
    data.penetrate_count--;
    
    return true;
}

bool CAutoWalls::SimulateFireBullet(C_CSPlayer* pLocal, C_BaseCombatWeapon* pWeapon, FireBulletData &data) {
    if (!pLocal) {
        return false;
    }
    
    data.penetrate_count = 4;
    data.trace_length = 0.0f;
    WeaponCSInfo_t* weaponData = pWeapon->GetCSWpnData();
    if (weaponData == NULL) {
        return false;
    }
    
    data.current_damage = (float)weaponData->m_iDamage;
    while (data.penetrate_count > 0 && data.current_damage >= 1.0f) {
        data.trace_length_remaining = weaponData->m_flRange - data.trace_length;
        Vector end = data.src + data.direction * data.trace_length_remaining;
        TraceLine(data.src, end, MASK_SHOT, pLocal, &data.enter_trace);
        
        Ray_t ray;
        ray.Init(data.src, end + data.direction * 40.f);
        Trace->TraceRay(ray, MASK_SHOT, &data.filter, &data.enter_trace);
        
        TraceLine(data.src, end + data.direction * 40.f, MASK_SHOT, pLocal, &data.enter_trace);
        if (data.enter_trace.fraction == 1.0f) {
            return false;
        }
        
        if (data.enter_trace.hitgroup <= HitGroups::HITGROUP_RIGHTLEG && data.enter_trace.hitgroup > HitGroups::HITGROUP_GENERIC) {
            data.trace_length += data.enter_trace.fraction * data.trace_length_remaining;
            data.current_damage *= powf(weaponData->m_flRangeModifier, data.trace_length * 0.002f);
            
            C_CSPlayer* player = (C_CSPlayer*)data.enter_trace.m_pEntityHit;
            if (player->GetTeamNum() == pLocal->GetTeamNum()) {
                return false;
            }
            
            ScaleDamage(data.enter_trace.hitgroup, player, weaponData->m_flArmorRatio, data.current_damage);
            
            return true;
        }
        
        if (!HandleBulletPenetration(weaponData, data)) {
            return false;
        }
    }
    
    return false;
}

float CAutoWalls::GetDamage(C_CSPlayer* LocalPlayer, C_CSPlayer* pEntity, int HitboxIndex) {
    Vector vMin, vMax;
    Vector dst = pEntity->GetPredictedPosition(HitboxIndex, vMin, vMax);
    
    return GetDamage(LocalPlayer, dst);
}

float CAutoWalls::GetDamage(C_CSPlayer* LocalPlayer, Vector HitboxPosition) {
    if (!LocalPlayer) {
        return 0.0f;
    }
    
    float damage = 0.0f;
    
    FireBulletData data;
    data.src = LocalPlayer->GetEyePos();
    data.filter.pSkip = LocalPlayer;
    
    QAngle angles = Math::CalcAngle(data.src, HitboxPosition);
    Math::AngleVectors(angles, data.direction);
    
    data.direction.NormalizeInPlace();
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return -1.0f;
    }
    
    if (SimulateFireBullet(LocalPlayer, ActiveWeapon, data)) {
        damage = data.current_damage;
    }
    
    return damage;
}

float CAutoWalls::GetDamageByAngle(C_CSPlayer* LocalPlayer, QAngle AimAngles) {
    if (!LocalPlayer) {
        return 0.0f;
    }
    
    float damage = 0.0f;
    
    FireBulletData data;
    data.src = LocalPlayer->GetEyePos();
    data.filter.pSkip = LocalPlayer;
    
    data.direction = AimAngles;
    data.direction.NormalizeInPlace();
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return -1.0f;
    }
    
    if (SimulateFireBullet(LocalPlayer, ActiveWeapon, data)) {
        damage = data.current_damage;
    }
    
    return damage;
}

bool CAutoWalls::CanWallbang(C_CSPlayer* LocalPlayer, float &dmg) {
    if (!LocalPlayer && !LocalPlayer->IsValidLivePlayer()) {
        return false;
    }
    
    C_BaseCombatWeapon* weapon = LocalPlayer->GetActiveWeapon();
    if (!weapon) {
        return false;
    }
    
    if (!WeaponManager::IsValidWeapon(weapon->EntityId())) {
        return false;
    }
    
    WeaponCSInfo_t* weaponData = weapon->GetCSWpnData();
    if (!weaponData) {
        return false;
    }
    
    FireBulletData data;
    data.src = LocalPlayer->GetEyePos();
    data.filter.pSkip = LocalPlayer;
    
    Vector EyeAng;
    Engine->GetViewAngles(EyeAng);
    
    Vector dst, forward;
    
    Math::AngleVectors(EyeAng, &forward);
    dst = data.src + (forward * 8196.f);
    
    QAngle angles = Math::CalcAngle(data.src, dst);
    Math::AngleVectors(angles, data.direction);
    
    data.direction.NormalizeInPlace();
    data.penetrate_count = 2;
    data.trace_length = 0.0f;
    data.current_damage = (float)weaponData->m_iDamage;
    data.trace_length_remaining = weaponData->m_flRange - data.trace_length;
    
    Vector end = data.src + data.direction * data.trace_length_remaining;
    TraceLine(data.src, end, MASK_SHOT | CONTENTS_GRATE, LocalPlayer, &data.enter_trace);
    
    if (data.enter_trace.fraction == 1.0f) {
        return false;
    }
    
    if (HandleBulletPenetration(weaponData, data)) {
        dmg = data.current_damage;
        
        return true;
    }
    
    return false;
}

std::shared_ptr<CAutoWalls> AutoWalls = std::make_unique<CAutoWalls>();
