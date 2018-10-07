/******************************************************/
/**                                                  **/
/**      Features/AimHelper.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "AimHelper.h"

bool* Glob::AimbotIsAiming = nullptr;

int CAimHelper::MakeHitscan(C_CSPlayer* pEntity) {
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        return Hitboxes::HITBOX_HEAD;
    }
    
    float mostDamageDone = 0.f;
    int bestHitbox = Hitboxes::HITBOX_HEAD;
    for (int hit = 0; hit < HITBOX_RIGHT_THIGH; hit++) {
        float flDmg = AutoWalls->GetDamage(LocalPlayer, pEntity, hit);
        if (flDmg > mostDamageDone) {
            mostDamageDone = flDmg;
            bestHitbox = hit;
        }
    }
    
    return (int)bestHitbox;
}

void CAimHelper::RecoilControl(QAngle& angle, C_CSPlayer* LocalPlayer) {
    // Check if recoil control is active
    if (!Options::Aimbot::recoil_control) {
        return;
    }

    // Check if LocalPlayer has been assigned
    if (!LocalPlayer) {
        LocalPlayer = C_CSPlayer::GetLocalPlayer();
    }
    
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }
    
    // Did the player shoot once?
    if (LocalPlayer->GetShotsFired() <= 0) {
        return;
    }
    
    // Assign the recoil level from the config
    angle -= this->GetPunchAngle(LocalPlayer);
}

bool CAimHelper::NeedsReset() {
    if (m_lockedBone != Hitboxes::HITBOX_NONE) {
        return true;
    }
    
    if (m_lockedEntity != nullptr) {
        return true;
    }
    
    if (*Glob::AimbotIsAiming != false) {
        return true;
    }
    
    return false;
}

void CAimHelper::Reset() {
    if (!NeedsReset()) {
        return;
    }
    
    // This resets all data assigned to the class instance
    m_lockedBone = Hitboxes::HITBOX_NONE;
    m_lockedEntity = nullptr;
    *Glob::AimbotIsAiming = false;
}

bool CAimHelper::HasTarget() {
    // Has the class instance a target?
    return m_lockedBone != Hitboxes::HITBOX_NONE &&
           m_lockedEntity != nullptr;
}

bool CAimHelper::CanHitTarget(C_CSPlayer *TargetEntity, C_BaseCombatWeapon *weapon, CUserCmd *pCmd) {
    // Check if we have a valid LocalPlayer instance
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return false;
    }

    // Check if we have a valid TargetEntity instance
    if (!TargetEntity || !TargetEntity->IsValidLivePlayer() || TargetEntity->IsImmune()) {
        return false;
    }

    // Check if we have a valid weapon entity
    if (!weapon || weapon->GetAmmo() == 0 || !WeaponManager::IsValidWeapon(weapon->EntityId())) {
        return false;
    }

    // Initialize TraceRay
    Vector traceStart, traceEnd;

    // Get the current viewAngle and substract the aim punch
    QAngle viewAngles = pCmd->viewangles;
    QAngle viewAnglesRCS = viewAngles - GetPunchAngle();

    // Do some stuff with TraceRay
    Math::AngleVectors(viewAnglesRCS, traceEnd);

    traceStart = LocalPlayer->GetEyePos();
    traceEnd = traceStart + (traceEnd * weapon->GetCSWpnData()->m_flRange);

    trace_t trace;
    Ray_t ray;
    ray.Init(traceStart, traceEnd);
    CTraceFilter filter;
    filter.pSkip = LocalPlayer;

    Trace->TraceRay(ray, MASK_SHOT, &filter, &trace);

    if (trace.startsolid || trace.allsolid) {
        return false;
    }
    
    // If the trace hits the desired entity return true
    if (trace.m_pEntityHit && trace.m_pEntityHit == TargetEntity) {
        return true;
    }

    return false;
}

void CAimHelper::AutoCockRevolver(CUserCmd* pCmd) {
    if (pCmd->buttons & IN_RELOAD) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || LocalPlayer->IsDormant() || !LocalPlayer->IsAlive()) {
        return;
    }

    C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
    if (!activeWeapon || activeWeapon->EntityId() != EItemDefinitionIndex::weapon_revolver) {
        return;
    }

    pCmd->buttons |= IN_ATTACK;
    float postponeFireReady = activeWeapon->GetPostponeFireReadyTime();
    if (pCmd->buttons & IN_ATTACK2) {
        pCmd->buttons |= IN_ATTACK;
    } else if (postponeFireReady > 0 && postponeFireReady < (*GlobalVars)->curtime) {
        pCmd->buttons &= ~IN_ATTACK;
    }
}

QAngle CAimHelper::GetPunchAngle(C_CSPlayer* LocalPlayer) {
    if (!Options::Aimbot::recoil_control) {
        return QAngle(0.0f, 0.0f, 0.0f);
    }

    if (!LocalPlayer) {
        LocalPlayer = C_CSPlayer::GetLocalPlayer();
    }
    
    if (!LocalPlayer || LocalPlayer->IsDormant() || !LocalPlayer->IsAlive()) {
        return QAngle(0.0f, 0.0f, 0.0f);
    }

    QAngle CurrentPunch = LocalPlayer->AimPunch();
    if (CurrentPunch.x == 0.0f && CurrentPunch.y == 0.0f) {
        return QAngle(0.0f, 0.0f, 0.0f);
    }

    return QAngle(
        CurrentPunch.x * Options::Aimbot::recoil_level_x,
        CurrentPunch.y * Options::Aimbot::recoil_level_y,
        0.0f
    );
}

bool CAimHelper::GetMouseData(float &m_flSensitivity, float &m_flYaw, float &m_flPitch) {
    if (!sensitivity) {
        sensitivity = Cvar->FindVar("sensitivity");
    }
    
    if (!m_yaw) {
        m_yaw = Cvar->FindVar("m_yaw");
    }
    
    if (!m_pitch) {
        m_pitch = Cvar->FindVar("m_pitch");
    }
    
    if (!sensitivity || !m_yaw || !m_pitch) {
        return false;
    }
    
    m_flSensitivity = sensitivity->GetFloat();
    m_flYaw = m_yaw->GetFloat();
    m_flPitch = m_pitch->GetFloat();
    
    return true;
}

QAngle CAimHelper::AnglesToPixels(QAngle viewAngle, QAngle aimAngle, float sensitivity, float mpitch, float myaw) {
    QAngle deltaAngle = viewAngle - aimAngle;
    Math::NormalizeAngles(deltaAngle);
    
    float moveAngleX = ( -deltaAngle.x ) / (myaw * sensitivity * 1);
    float moveAngleY = (  deltaAngle.y ) / (mpitch * sensitivity * 1);
    
    return QAngle(moveAngleX, moveAngleY, 0.0f);
}

QAngle CAimHelper::PixelsDeltaToAnglesDelta(Vector PixelsDelta, float sens, float mpitch, float myaw) {
    float xMove = (-PixelsDelta.x) * (myaw * sens * 1);
    float yMove = ( PixelsDelta.y) * (mpitch * sens * 1);
    
    return QAngle(yMove, xMove, 0.0f);
}

bool CAimHelper::CanAttack() {
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() ) {
        return false;
    }
    
    C_BaseCombatWeapon* weapon = LocalPlayer->GetActiveWeapon();
    if (!weapon) {
        return false;
    }
    
    if (weapon->GetAmmo() < 1 && !WeaponManager::IsValidWeapon(weapon->EntityId())) {
        return false;
    }
    
    float curtime = LocalPlayer->GetTickBase() * (*GlobalVars)->interval_per_tick;
    float nextAttack = weapon->NextPrimaryAttack();
    return !(nextAttack > curtime);
}

QAngle CAimHelper::GetAimAngles(C_CSPlayer* LocalPlayer) {
    QAngle AimPunch = this->GetPunchAngle(LocalPlayer);
    this->CurrentRawAngle -= (AimPunch - OldPunch);
    
    OldPunch = AimPunch;
    
    return CurrentRawAngle;
}
