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

#include "AntiAim.h"

#ifdef GOSX_RAGE_MODE

void Features::CAntiAim::AAPitch(QAngle& angle, bool bFlip, bool& clamp) {
    EAntiAimPitch AntiaimTypePitch = (EAntiAimPitch)Options::Rage::antiaim_pitch;

    static float pDance = 0.0f;

    switch (AntiaimTypePitch) {
        case EAntiAimPitch::Emotion:
            angle.x = 82.0f;
            break;
        case EAntiAimPitch::Down:
            angle.x = 89.0f;
            break;
        case EAntiAimPitch::Up:
            angle.x = -89.0f;
            break;
        case EAntiAimPitch::CustomPitch:
            angle.x -= 89.f - Options::Rage::antiaim_custom_pitch;
            break;
        case EAntiAimPitch::Dance:
            pDance += 45.0f;
            if (pDance > 100) {
                pDance = 0.0f;
            } else if (pDance > 75.f) {
                angle.x = -89.f;
            } else if (pDance < 75.f) {
                angle.x = 89.f;
            }
            break;
        case EAntiAimPitch::StaticUpFake:
            angle.x = bFlip ? 89.0f : -89.0f;
            break;
        case EAntiAimPitch::StaticDownFake:
            angle.x = bFlip ? -89.0f : 89.0f;
            break;
        case EAntiAimPitch::LispDown:
            clamp = false;
            angle.x = 1800089.0f;
            break;
        case EAntiAimPitch::AngelDown:
            clamp = false;
            angle.x = 36000088.0f;
            break;
        case EAntiAimPitch::AngelUp:
            clamp = false;
            angle.x = 35999912.0f;
            break;
        default:
            float AAAngle = Utils::RandomFloat(-89.0f, 89.0f);
            float factor = AAAngle / M_PHI;
            angle.x = fmodf((*GlobalVars)->curtime * factor, AAAngle);
            break;
    }
}

void Features::CAntiAim::AAYaw(QAngle& angle, bool bFlip, bool& clamp) {
    EAntiAimYaw AntiaimTypeYaw = (EAntiAimYaw)Options::Rage::antiaim_yaw;

    static bool yFlip;
    float temp;
    double factor;
    static float trigger;
    QAngle temp_qangle;
    int random;
    int maxJitter;

    yFlip = bFlip != yFlip;

    switch (AntiaimTypeYaw) {
        case EAntiAimYaw::Backwards:
            angle.y -= 180.0f;
            break;
        case EAntiAimYaw::Left:
            angle.y += 90.0f;
            break;
        case EAntiAimYaw::Right:
            angle.y -= 90.0f;
            break;
        case EAntiAimYaw::CustomYaw:
            angle.y -= 180.f - Options::Rage::antiaim_custom_yaw;
            break;
        case EAntiAimYaw::SpinFast:
            factor =  360.0 / M_PHI;
            factor *= 25;
            angle.y = fmodf((*GlobalVars)->curtime * factor, 360.0);
            break;
        case EAntiAimYaw::SpinSlow:
            factor =  360.0 / M_PHI;
            angle.y = fmodf((*GlobalVars)->curtime * factor, 360.0);
            break;
        case EAntiAimYaw::Jitter:
            yFlip ? angle.y -= 90.0f : angle.y -= 270.0f;
            break;
        case EAntiAimYaw::BackJitter:
            angle.y -= 180;
            random = rand() % 100;
            maxJitter = rand() % (85 - 70 + 1) + 70;
            temp = maxJitter - (rand() % maxJitter);
            if (random < 35 + (rand() % 15)) {
                angle.y -= temp;
            } else if (random < 85 + (rand() % 15 )) {
                angle.y += temp;
            }
            break;
        case EAntiAimYaw::Side:
            yFlip ? angle.y += 90.f : angle.y -= 90.0f;
            break;
        case EAntiAimYaw::StaticAA:
            angle.y = 0.0f;
            break;
        case EAntiAimYaw::StaticJitter:
            trigger += 15.0f;
            angle.y = trigger > 50.0f ? 150.0f : -150.0f;

            if (trigger > 100.0f) {
                trigger = 0.0f;
            }
            break;
        case EAntiAimYaw::StaticSmallJitter:
            trigger += 15.0f;
            angle.y = trigger > 50.0f ? -30.0f : 30.0f;

            if (trigger > 100.0f) {
                trigger = 0.0f;
            }
            break;
        case EAntiAimYaw::Lisp:
            clamp = false;
            yFlip ? angle.y += 323210000.0f : angle.y -= 323210000.0f;
            break;
        case EAntiAimYaw::LispSide:
            clamp = false;
            temp = angle.y + 90.0f;
            temp_qangle = QAngle(0.0f, temp, 0.0f);
            Math::NormalizeAngles(temp_qangle);
            temp = temp_qangle.y;

            if (temp > -45.0f) {
                temp < 0.0f ? temp = -90.0f : temp < 45.0f ? temp = 90.0f : temp = temp;
            }

            temp += 1800000.0f;
            angle.y = temp;
            break;
        case EAntiAimYaw::LispJitter:
            clamp = false;
            static int jittertimer = -1;
            temp = angle.y - 155.0f;

            if (jittertimer == 1) {
                temp = angle.y + 58.0f;
                temp += 1800000.0f;
            }

            if (*Glob::SendPacket) {
                if (jittertimer >= 1) {
                    jittertimer = -1;
                }
                jittertimer++;
            }
            angle.y = temp;
            break;
        case EAntiAimYaw::AngelBackwards:
            clamp = false;
            angle.y += 36000180.0f;
            break;
        case EAntiAimYaw::AngelInverse:
            clamp = false;
            angle.y = 36000180.0f;
            break;
        case EAntiAimYaw::AngelSpin:
            clamp = false;
            factor = ((*GlobalVars)->curtime * 5000.0f);
            angle.y = factor + 36000000.0f;
            break;
        default:
            float AAAngle = Utils::RandomFloat(-179.999999f, 179.999999f);
            factor = AAAngle / M_PHI;
            angle.y = fmodf((*GlobalVars)->curtime * factor, AAAngle);
            break;
    }
}

bool Features::CAntiAim::AAEdge(C_CSPlayer* LocalPlayer, CUserCmd* pCmd, float flWall, float flCornor) {
    Ray_t ray;
    trace_t tr;
    
    CTraceFilter traceFilter;
    traceFilter.pSkip = LocalPlayer;
    
    auto bRetVal = false;
    auto vecCurPos = LocalPlayer->GetEyePos();
    
    for (float i = 0; i < 360; i++) {
        Vector vecDummy(10.f, pCmd->viewangles.y, 0.f);
        vecDummy.y += i;
        
        NormalizeVector(vecDummy);
        
        Vector vecForward;
        Math::AngleVectors(vecDummy, vecForward);
        
        auto flLength = ((16.f + 3.f) + ((16.f + 3.f) * sin(DEG2RAD(10.f)))) + 7.f;
        vecForward *= flLength;
        
        ray.Init(vecCurPos, (vecCurPos + vecForward));
        Trace->TraceRay(ray, MASK_SHOT, &traceFilter, &tr);
        
        if (tr.fraction != 1.0f) {
            Vector qAngles;
            auto vecNegate = tr.plane.normal;
            
            vecNegate *= -1.f;
            Math::AngleVectors(vecNegate, qAngles);
            
            vecDummy.y = qAngles.y;
            
            NormalizeVector(vecDummy);
            trace_t leftTrace, rightTrace;
            
            Vector vecLeft;
            Math::AngleVectors(vecDummy + Vector(0.f, 30.f, 0.f), vecLeft);
            
            Vector vecRight;
            Math::AngleVectors(vecDummy - Vector(0.f, 30.f, 0.f), vecRight);
            
            vecLeft *= (flLength + (flLength * sin(DEG2RAD(30.f))));
            vecRight *= (flLength + (flLength * sin(DEG2RAD(30.f))));
            
            ray.Init(vecCurPos, (vecCurPos + vecLeft));
            Trace->TraceRay(ray, MASK_SHOT, (CTraceFilter*)&traceFilter, &leftTrace);
            
            ray.Init(vecCurPos, (vecCurPos + vecRight));
            Trace->TraceRay(ray, MASK_SHOT, (CTraceFilter*)&traceFilter, &rightTrace);
            
            if ((leftTrace.fraction == 1.f) && (rightTrace.fraction != 1.f)) {
                vecDummy.y -= flCornor; // left
            } else if ((leftTrace.fraction != 1.f) && (rightTrace.fraction == 1.f)) {
                vecDummy.y += flCornor; // right
            }
            
            pCmd->viewangles.y = vecDummy.y;
            pCmd->viewangles.y -= flWall;
            pCmd->viewangles.x = 89.0f;
            bRetVal = true;
        }
    }
    return bRetVal;
}

void Features::CAntiAim::CreateMove(CUserCmd* pCmd) {
    if (!Options::Rage::anti_aim) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }

    C_BaseCombatWeapon* pWeapon = LocalPlayer->GetActiveWeapon();
    if (!pWeapon) {
        return;
    }

    QAngle oldAngle = pCmd->viewangles;
    float oldForward = pCmd->forwardmove;
    float oldSideMove = pCmd->sidemove;

    QAngle angle = pCmd->viewangles;

    if (
        pCmd->buttons & IN_USE ||
        pCmd->buttons & IN_ATTACK ||
        (pCmd->buttons & IN_ATTACK2 && pWeapon->EntityId() == EItemDefinitionIndex::weapon_revolver)
    ) {
        return;
    }

    if (LocalPlayer->GetMoveType() == MOVETYPE_LADDER || LocalPlayer->GetMoveType() == MOVETYPE_NOCLIP) {
        return;
    }

    if (LocalPlayer->IsAlive() && pWeapon->GetCSWpnData()->m_WeaponType == CSWeaponType::WEAPONTYPE_KNIFE) {
        return;
    }

    if (LocalPlayer->IsAlive() && pWeapon->GetCSWpnData()->m_WeaponType == CSWeaponType::WEAPONTYPE_GRENADE) {
        return;
    }

    if (
        Options::Improvements::triggerbot &&
        InputSystem->IsButtonDown(
            (ButtonCode_t)Options::Improvements::trigger_key
        )
    ) {
        return;
    }
    
    if (Options::Rage::edge_aa && AAEdge(LocalPlayer, pCmd, 360.f, 89.f)) {
        return;
    }

    static bool bFlip;

    bFlip = !bFlip;

    bool ShouldClamp = true;

    AAYaw(angle, bFlip, ShouldClamp);
    Math::NormalizeAngles(angle);

    if (!Options::RageMisc::fakelag) {
        *CreateMove::SendPacket = bFlip;
    }

    AAPitch(angle, bFlip, ShouldClamp);

    if (ShouldClamp || Options::Rage::anti_untrusted) {
        Math::NormalizeAngles(angle);
        Math::ClampAngle(angle);
    }

    pCmd->viewangles = angle;

    Math::CorrectMovement(oldAngle, pCmd, oldForward, oldSideMove);
}

std::shared_ptr<Features::CAntiAim> AntiAim = std::make_unique<Features::CAntiAim>();

#endif
