/******************************************************/
/**                                                  **/
/**      Rage/RageBot.mm                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "RageBot.h"

#ifdef GOSX_RAGE_MODE

void Features::CRageBot::CreateMove(CUserCmd* pCmd) {
    userCommand = pCmd;

    C_CSPlayer* LocalPlayer = (C_CSPlayer*)EntList->GetClientEntity(Engine->GetLocalPlayer());
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        Reset();
        
        return;
    }

    C_BaseCombatWeapon* currentWeapon = LocalPlayer->GetActiveWeapon();
    if (!currentWeapon || !currentWeapon->CanShoot()) {
        Reset();
        
        return;
    }

    int currentWeaponID = currentWeapon->EntityId();
    if (
        WeaponManager::IsC4(currentWeaponID) ||
        WeaponManager::IsKnife(currentWeaponID) ||
        WeaponManager::IsGrenade(currentWeaponID)
    ) {
        Reset();
        
        return;
    }

    ButtonCode_t aimKey = (ButtonCode_t)Options::Aimbot::aim_key;
    ButtonCode_t volverKey = MOUSE_RIGHT;
    if (aimKey != ButtonCode_t::KEY_FIRST && aimKey != ButtonCode_t::MOUSE_LEFT) {
        volverKey = aimKey;
    } else {
        aimKey = ButtonCode_t::MOUSE_LEFT;
    }

    bool AutoShoot = Options::Rage::auto_shoot || (
        (InputSystem->IsButtonDown(aimKey) && currentWeaponID != EItemDefinitionIndex::weapon_revolver) ||
        (InputSystem->IsButtonDown(volverKey) && currentWeaponID == EItemDefinitionIndex::weapon_revolver)
    );
    if (!AutoShoot) {
        Reset();

        return;
    }

    C_CSPlayer* TargetEntity = nullptr;
    if (!m_lockedEntity) {
        TargetEntity = FindTarget(LocalPlayer);
        m_lockedEntity = TargetEntity;
    } else {
        TargetEntity = m_lockedEntity;
    }

    if (!TargetEntity || !TargetEntity->IsAlive() || TargetEntity->IsDormant()) {
        Reset();
        
        return;
    }

    AimTarget(LocalPlayer, TargetEntity);
}

void Features::CRageBot::AimTarget(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity) {
    C_BaseCombatWeapon* currentWeapon = LocalPlayer->GetActiveWeapon();
    if (!currentWeapon) {
        return;
    }
    QAngle oldAngle;
    Engine->GetViewAngles(oldAngle);

    QAngle AimAngles;

    Hitboxes aimBone = HITBOX_NONE;
    if (m_lockedBone == Hitboxes::HITBOX_NONE) {
        if (Options::Rage::hit_scan) {
            aimBone = (Hitboxes)MakeHitscan(TargetEntity);
        } else {
            aimBone = (Hitboxes)Options::Aimbot::fixed_bone;
        }
        m_lockedBone = aimBone;
    } else {
        aimBone = m_lockedBone;
    }

    if (aimBone == Hitboxes::HITBOX_NONE) {
        return;
    }
    
    Vector vMin, vMax;
    Vector EnemyPos = TargetEntity->GetPredictedPosition((int)aimBone, vMin, vMax);
    if (!Utils::IsVisible(LocalPlayer, TargetEntity, aimBone, 360.0f, false)) {
        if (Options::Rage::auto_wall) {
            if (AutoWalls->GetDamage(LocalPlayer, TargetEntity, aimBone) < Options::Rage::autowall_min_damage) {
                return;
            }
        } else {
            return;
        }
    }

    Vector dir = LocalPlayer->GetEyePos() - EnemyPos;
    Math::VectorNormalize(dir);
    Math::VectorAngles(dir, AimAngles);

    Vector AimPunch = LocalPlayer->AimPunch();
    if (AimPunch.x != 0.0f && AimPunch.y != 0.0f) {
        AimAngles -= AimPunch * 2.0f;
    }

    Math::NormalizeAngles(AimAngles);
    Math::ClampAngle(AimAngles);

    if (AimAngles == oldAngle || !AimAngles.IsValid()) {
        return;
    }

    *Glob::AimbotIsAiming = true;
    if (Options::Rage::silent_aim) {
        userCommand->viewangles = AimAngles;
    } else {
        Engine->SetViewAngles(AimAngles);
    }
    
    if (!DelayedShot(LocalPlayer, TargetEntity, currentWeapon, AimAngles)) {
        if (
            Options::Rage::auto_scope &&
            WeaponManager::IsScopeWeapon(currentWeapon->EntityId()) &&
            currentWeapon->GetCSWpnData()->m_iZoomLevels > 0 &&
            LocalPlayer->IsScoped()
        ) {
            userCommand->buttons |= IN_ATTACK2;
        }
        
        return;
    }
    
    if (
        Options::Rage::auto_scope &&
        WeaponManager::IsScopeWeapon(currentWeapon->EntityId()) &&
        currentWeapon->GetCSWpnData()->m_iZoomLevels > 0 &&
        !LocalPlayer->IsScoped()
    ) {
        userCommand->buttons |= IN_ATTACK2;
    } else {
        AutoStop(LocalPlayer);
        
        if (Options::Rage::autocrouch) {
            userCommand->buttons |= IN_DUCK;
        }
        
        AutoCockRevolver(userCommand);
    }
}

void Features::CRageBot::AutoCrouch(C_CSPlayer* LocalPlayer) {
    if (!Options::Rage::autocrouch) {
        return;
    }

    if (!HasTarget()) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    userCommand->buttons |= IN_DUCK;
}

void Features::CRageBot::AutoStop(C_CSPlayer* LocalPlayer) {
    if (!Options::Rage::auto_stop) {
        return;
    }

    if (!HasTarget()) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    userCommand->forwardmove = 0.0f;
    userCommand->sidemove = 0.0f;
}

bool Features::CRageBot::CanHitEntity(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity, Vector EndPosition) {
    if (!Utils::IsVisible(LocalPlayer, TargetEntity, EndPosition, 360.0f, false)) {
        if (AutoWalls->GetDamage(LocalPlayer, EndPosition) >= Options::Rage::autowall_min_damage) {
            return true;
        }
    } else {
        trace_t tr;
        Ray_t ray;
        ray.Init(LocalPlayer->GetEyePos(), EndPosition);
        
        Trace->ClipRayToEntity(ray, MASK_SHOT, TargetEntity, &tr);
        
        if (tr.startsolid || tr.allsolid) {
            return false;
        }
        
        C_CSPlayer* entity = (C_CSPlayer*)tr.m_pEntityHit;
        if (!entity) {
            return false;
        }
        
        if (entity->GetTeamNum() == LocalPlayer->GetTeamNum()) {
            return false;
        }
        
        if (entity->IsImmune()) {
            return false;
        }
        
        if (entity != TargetEntity) {
            return false;
        }
        
        return true;
    }

    return false;
}

bool Features::CRageBot::HitChance(QAngle AimAngle, C_CSPlayer* LocalPlayer, C_CSPlayer* TargetPlayer, C_BaseCombatWeapon* activeWeapon) {
    static int MaxTraces = Options::Rage::hitchance_shots;
    int TotalHits = 0;
    
    int NeededHits = MaxTraces * (Options::Rage::hitchance_percent / 100.f);
    
    Vector eyes = LocalPlayer->GetEyePos();
    float flRange = activeWeapon->GetCSWpnData()->m_flRange;
    
    for (int i = 0; i < MaxTraces; i++) {
        activeWeapon->UpdateAccuracyPenalty();
        
        float fRand1 = Utils::RandomFloat(0.0f, M_PI * 2.0f);
        float fRandPi1 = Utils::RandomFloat(0.0f, activeWeapon->GetSpread());
        float fRand2 = Utils::RandomFloat(0.0f, M_PI * 2.0f);
        float fRandPi2 = Utils::RandomFloat(0.0f, activeWeapon->GetInaccuracy());
        
        Vector vSpread = Vector(
            (cos(fRand1) * fRandPi1) + (cos(fRand2) * fRandPi2),
            (sin(fRand1) * fRandPi1) + (sin(fRand2) * fRandPi2),
            0.0f
        );
        
        QAngle qViewAngles = AimAngle + vSpread;
        
        Vector forward;
        Math::AngleVectors(qViewAngles, forward);
        Vector vEnd = eyes + (forward * flRange);
        
        if (!CanHitEntity(LocalPlayer, TargetPlayer, vEnd)) {
            continue;
        }
        
        TotalHits++;
        if (TotalHits >= NeededHits) {
            return true;
        }
        
        if ((MaxTraces - i + TotalHits) < NeededHits) {
            return false;
        }
    }
    
    return false;
}

bool Features::CRageBot::DelayedShot(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity, C_BaseCombatWeapon* weapon, QAngle AimAngles) {
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return false;
    }
    
    if (!TargetEntity || !TargetEntity->IsValidLivePlayer() || TargetEntity->IsImmune()) {
        return false;
    }
    
    if (!weapon) {
        return false;
    }
    
    bool HitChanceHit = !Options::Rage::hitchance || HitChance(AimAngles, LocalPlayer, TargetEntity, weapon);
    
    bool AutoShoot = (HitChanceHit && (
        (userCommand->buttons & IN_ATTACK) ||
        ((userCommand->buttons & IN_ATTACK2) && weapon->EntityId() == EItemDefinitionIndex::weapon_revolver)
    )) || (Options::Rage::auto_shoot && HitChanceHit);

    bool InValidWeapon = weapon->GetAmmo() == 0 || !WeaponManager::IsValidWeapon(weapon->EntityId());
    bool NoDelayedWeapon = !WeaponManager::IsDelayedWeapon(weapon->EntityId());
    if (InValidWeapon || NoDelayedWeapon) {
        if (!InValidWeapon && NoDelayedWeapon && AutoShoot) {
            if (weapon->EntityId() == EItemDefinitionIndex::weapon_revolver) {
                userCommand->buttons |= IN_ATTACK2;
            } else {
                userCommand->buttons |= IN_ATTACK;
            }
        }
        
        if (!InValidWeapon) {
            return true;
        }
        
        return false;
    }
    
    bool WasPrimaryAttacking = (bool)(userCommand->buttons & IN_ATTACK);
    bool WasSecondaryAttacking = (bool)(userCommand->buttons & IN_ATTACK2);
    
    userCommand->buttons &= ~IN_ATTACK;
    userCommand->buttons &= ~IN_ATTACK2;
    
    if (CanHitTarget(TargetEntity, weapon, userCommand)) {
        if (AutoShoot) {
            if (weapon->EntityId() == EItemDefinitionIndex::weapon_revolver) {
                if (WasSecondaryAttacking) {
                    userCommand->buttons |= IN_ATTACK2;
                }
            } else {
                if (WasPrimaryAttacking) {
                    userCommand->buttons |= IN_ATTACK;
                }
            }
            
            return true;
        }
    }
    
    return false;
}

C_CSPlayer* Features::CRageBot::FindTarget(C_CSPlayer* LocalPlayer) {
    C_CSPlayer* m_bestEnt = nullptr;
    C_BaseCombatWeapon* currentWeapon = LocalPlayer->GetActiveWeapon();
    if (!currentWeapon) {
        return nullptr;
    }
    
    float m_bestFov = Options::Aimbot::field_of_view;
    if (Options::Rage::fov_multiplier > 1.0f) {
        m_bestFov *= Options::Rage::fov_multiplier;
    }
    
    EntityTeam localTeam = (EntityTeam)LocalPlayer->GetTeamNum();
    
    for (int index = 1; index < Engine->GetMaxClients(); index++) {
        C_CSPlayer* possibleTargetEntity = (C_CSPlayer*)EntList->GetClientEntity(index);
        if (
            !possibleTargetEntity ||
            !possibleTargetEntity->IsAlive() ||
            possibleTargetEntity->IsDormant() ||
            possibleTargetEntity->IsImmune() ||
            possibleTargetEntity == LocalPlayer
        ) {
            continue;
        }
        
        Features::CResolver::StoreVars(possibleTargetEntity);
        
        if (localTeam == (EntityTeam)possibleTargetEntity->GetTeamNum()) {
            continue;
        }
        
        QAngle viewAngle;
        Engine->GetViewAngles(viewAngle);
        
        Hitboxes aimBone = Hitboxes::HITBOX_NONE;
        if (m_lockedBone == Hitboxes::HITBOX_NONE) {
            if (Options::Rage::hit_scan) {
                aimBone = (Hitboxes)MakeHitscan(possibleTargetEntity);
            } else {
                aimBone = (Hitboxes)Options::Aimbot::fixed_bone;
            }
            m_lockedBone = aimBone;
        } else {
            aimBone = (Hitboxes)m_lockedBone;
        }
        
        if (aimBone == Hitboxes::HITBOX_NONE) {
            continue;
        }
        
        if (!Utils::IsVisible(LocalPlayer, possibleTargetEntity, aimBone, 360.0f, false)) {
            if (Options::Rage::auto_wall) {
                if (AutoWalls->GetDamage(LocalPlayer, possibleTargetEntity, aimBone) < Options::Rage::autowall_min_damage) {
                    continue;
                }
            } else {
                continue;
            }
        }
        
        Vector AimPunch = LocalPlayer->AimPunch();
        if (AimPunch.x != 0.0f && AimPunch.y != 0.0f) {
            viewAngle -= AimPunch * 2.0f;
        }
        
        Vector vMin, vMax;
        float fov = Math::GetFov(
            viewAngle,
            LocalPlayer->GetEyePos(),
            possibleTargetEntity->GetPredictedPosition((int)aimBone, vMin, vMax)
        );
        
        if (fov < m_bestFov) {
            m_bestFov = fov;
            m_bestEnt = possibleTargetEntity;
        }
    }
    
    return m_bestEnt;
}

std::shared_ptr<Features::CRageBot> RageBot = std::make_unique<Features::CRageBot>();

#endif
