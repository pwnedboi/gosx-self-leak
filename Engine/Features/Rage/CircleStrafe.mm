/******************************************************/
/**                                                  **/
/**      Rage/CircleStrafe.mm                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CircleStrafe.h"

#ifdef GOSX_RAGE_MODE

void Features::CCircleStrafe::CreateMove(CUserCmd* pCmd) {
    if (!Options::Main::enabled || !Options::RageMisc::circle_strafe) {
        return;
    }
    
    static int Angle = 0;
    
    if (!Engine->IsInGame() && !Engine->IsConnected()) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }
    
    if (pCmd->viewangles.y - Angle > 360) {
        Angle -= 360;
    }
    
    static bool shouldspin = false;
    static bool enabled = false;
    
    if (!InputSystem->IsButtonDown((ButtonCode_t)Options::RageMisc::circle_strafe_key)) {
        return;
    }

    shouldspin = true;
    pCmd->buttons |= IN_JUMP;
    pCmd->buttons |= IN_DUCK;
    
    if (!shouldspin) {
        Angle = pCmd->viewangles.y;
        
        return;
    }
    
    Vector Dir;
    Math::AngleVectors(Vector(0, Angle, 0), &Dir);
    Dir *= 8218;
    
    Ray_t ray;
    CTraceFilterWorldAndPropsOnly filter;
    trace_t trace;
    
    ray.Init(LocalPlayer->GetEyePos(), *LocalPlayer->GetOrigin() + Dir);
    Trace->TraceRay(ray, MASK_SHOT, &filter, &trace);
    auto temp = 3.4f / ((trace.endpos - *LocalPlayer->GetOrigin()).Length() / 100.f);
    
    if (temp < 3.4f) {
        temp = 3.4f;
    }
    
    if (enabled) {
        Angle += temp;
        pCmd->sidemove = -450;
    } else {
        if (pCmd->viewangles.y - Angle < temp) {
            Angle = pCmd->viewangles.y;
            shouldspin = false;
        } else {
            Angle += temp;
        }
    }
    pCmd->viewangles.y = Angle;
}

std::shared_ptr<Features::CCircleStrafe> CircleStrafe = std::make_unique<Features::CCircleStrafe>();

#endif
