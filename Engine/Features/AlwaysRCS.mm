/******************************************************/
/**                                                  **/
/**      Features/AlwaysRCS.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "AlwaysRCS.h"

void Features::CAlwaysRCS::CreateMove(CUserCmd *pCmd) {
    if (!Options::Improvements::always_rcs || *Glob::AimbotIsAiming) {
        CAlwaysRCS::lastRCSPunch = {0.0000f, 0.0000f, 0.0000f};
        return;
    }

    if (!(pCmd->buttons & IN_ATTACK)) {
        CAlwaysRCS::lastRCSPunch = {0.0000f, 0.0000f, 0.0000f};
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        CAlwaysRCS::lastRCSPunch = {0.0000f, 0.0000f, 0.0000f};
        return;
    }

    C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
    if (!activeWeapon) {
        CAlwaysRCS::lastRCSPunch = {0.0000f, 0.0000f, 0.0000f};
        return;
    }

    QAngle ViewAngle;
    Engine->GetViewAngles(ViewAngle);

    QAngle CurrentAimPunch = LocalPlayer->AimPunch();
    if (LocalPlayer->GetShotsFired() <= 0) {
        return;
    }

    QAngle NewPunch = {
        CurrentAimPunch.x - CAlwaysRCS::lastRCSPunch.x,
        CurrentAimPunch.y - CAlwaysRCS::lastRCSPunch.y,
        0
    };

    if (NewPunch.Length() > 0.0f || NewPunch.Length() < 150.0f) {
        ViewAngle.x -= NewPunch.x * Options::Aimbot::recoil_level_x;
        ViewAngle.y -= NewPunch.y * Options::Aimbot::recoil_level_y;

        CLegitBot::SmoothAngle(ViewAngle, pCmd->viewangles, pCmd, true);

        Math::NormalizeAngles(ViewAngle);
        Math::ClampAngle(ViewAngle);

        if (Options::AntiCheat::mouse_event_aim || Options::AntiCheat::faceit_safe) {
            Vector Pixels = Vector();
            float m_flSensitivity, m_flYaw, m_flPitch;
            if (Aim->GetMouseData(m_flSensitivity, m_flYaw, m_flPitch)) {
                Pixels = Aim->GetDeltaPixels(pCmd->viewangles, ViewAngle, m_flSensitivity, m_flPitch, m_flYaw);
            }
            
            if (Pixels.IsValid()) {
                NSPoint MousePointer = [NSEvent mouseLocation];
                
                float MouseMoveX, MouseMoveY;
                MouseMoveX = MousePointer.x + Pixels.x;
                MouseMoveY = MousePointer.y + Pixels.y;
                
                CGEventRef mouseMove = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(MouseMoveX, MouseMoveY), kCGMouseButtonLeft);
                CGEventPost(kCGHIDEventTap, mouseMove);
                CFRelease(mouseMove);
            }
        } else {
            Engine->SetViewAngles(ViewAngle);
        }
    }

    CAlwaysRCS::lastRCSPunch = CurrentAimPunch;
}

std::shared_ptr<Features::CAlwaysRCS> AlwaysRCS = std::make_unique<Features::CAlwaysRCS>();
