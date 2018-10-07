/******************************************************/
/**                                                  **/
/**      Rage/AntiAim.mm                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "AutoStrafe.h"

#ifdef GOSX_RAGE_MODE

void Features::CAutoStrafe::CreateMove(CUserCmd* pCmd) {
    if (!Options::Main::enabled || !Options::AutoStrafe::enabled) {
        return;
    }
    
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    if (!LocalPlayer->IsAlive()) {
        return;
    }
    
    if (LocalPlayer->GetMoveType() == MOVETYPE_LADDER || LocalPlayer->GetMoveType() == MOVETYPE_NOCLIP) {
        return;
    }
    
    switch ((AutostrafeType)Options::AutoStrafe::strafe_type) {
        case AutostrafeType::AS_FORWARDS:
        case AutostrafeType::AS_BACKWARDS:
        case AutostrafeType::AS_LEFTSIDEWAYS:
        case AutostrafeType::AS_RIGHTSIDEWAYS:
            this->LegitStrafe(pCmd);
        break;
        case AutostrafeType::AS_RAGE:
            this->RageStrafe(pCmd);
        break;
    }
}

void Features::CAutoStrafe::LegitStrafe(CUserCmd* pCmd) {
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }
    
    if (LocalPlayer->IsOnGround()) {
        return;
    }
    
    if (
        pCmd->buttons & IN_FORWARD ||
        pCmd->buttons & IN_BACK ||
        pCmd->buttons & IN_MOVELEFT ||
        pCmd->buttons & IN_MOVERIGHT
    ) {
        return;
    }
    
    if (pCmd->mousedx <= 1 && pCmd->mousedx >= -1) {
        return;
    }
    
    switch ((AutostrafeType)Options::AutoStrafe::strafe_type) {
        case AutostrafeType::AS_FORWARDS:
            pCmd->sidemove = pCmd->mousedx < 0.f ? -250.f : 250.f;
            break;
        case AutostrafeType::AS_BACKWARDS:
            pCmd->sidemove = pCmd->mousedx < 0.f ? 250.f : -250.f;
            break;
        case AutostrafeType::AS_LEFTSIDEWAYS:
            pCmd->forwardmove = pCmd->mousedx < 0.f ? -250.f : 250.f;
            break;
        case AutostrafeType::AS_RIGHTSIDEWAYS:
            pCmd->forwardmove = pCmd->mousedx < 0.f ? 250.f : -250.f;
            break;
        default:
            break;
    }
}

void Features::CAutoStrafe::RageStrafe(CUserCmd* pCmd) {
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }
    
    static bool leftRight;
    bool inMove = pCmd->buttons & IN_FORWARD ||
                  pCmd->buttons & IN_BACK ||
                  pCmd->buttons & IN_MOVELEFT ||
                  pCmd->buttons & IN_MOVERIGHT;
    
    if (pCmd->buttons & IN_FORWARD && LocalPlayer->GetVelocity().Length() <= 50.0f) {
        pCmd->forwardmove = 250.0f;
    }
    
    float yaw_change = 0.0f;
    if (LocalPlayer->GetVelocity().Length() > 50.f) {
        yaw_change = 30.0f * fabsf(30.0f / LocalPlayer->GetVelocity().Length());
    }
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (ActiveWeapon && !(ActiveWeapon->GetAmmo() == 0) && pCmd->buttons & IN_ATTACK) {
        yaw_change = 0.0f;
    }
    
    QAngle viewAngles;
    Engine->GetViewAngles(viewAngles);
    
    if (!LocalPlayer->IsOnGround() && !inMove) {
        if (leftRight || pCmd->mousedx > 1) {
            viewAngles.y += yaw_change;
            pCmd->sidemove = 250.0f;
        } else if (!leftRight || pCmd->mousedx < 1) {
            viewAngles.y -= yaw_change;
            pCmd->sidemove = -250.0f;
        }
        
        leftRight = !leftRight;
    }
    
    Math::NormalizeAngles(viewAngles);
    Math::ClampAngle(viewAngles);
    
    Math::CorrectMovement(viewAngles, pCmd, pCmd->forwardmove, pCmd->sidemove);
    
    if (!Options::AutoStrafe::silent) {
        pCmd->viewangles = viewAngles;
    }
}

std::shared_ptr<Features::CAutoStrafe> AutoStrafe = std::make_unique<Features::CAutoStrafe>();

#endif
