/******************************************************/
/**                                                  **/
/**      Features/TriggerBot.cpp                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "TriggerBot.h"

void Features::CTriggerBot::CreateMove(CUserCmd *pCmd) {
    if (!Options::Improvements::triggerbot) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        Reset();
        return;
    }

    C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
    if (!activeWeapon) {
        Reset();
        return;
    }

    if (InputSystem->IsButtonDown((ButtonCode_t)Options::Improvements::trigger_key) || Options::Improvements::trigger_autoactivation) {
        if (!LocalPlayer->IsValidLivePlayer()) {
            return;
        }

        if (activeWeapon->GetAmmo() == 0) {
            Reset();
            return;
        }

        if (!WeaponManager::IsValidWeapon(activeWeapon->EntityId())) {
            Reset();
            return;
        }

        if (!triggerTarget) {
            Vector traceStart, traceEnd;
            trace_t tr;

            QAngle viewAngles = pCmd->viewangles;
            QAngle viewAnglesRcs = viewAngles + LocalPlayer->AimPunch() * 2.0f;

            Math::AngleVectors(viewAnglesRcs, traceEnd);

            traceStart = LocalPlayer->GetEyePos();
            traceEnd = traceStart + (traceEnd * 8192.0f);

            Ray_t ray;
            ray.Init(traceStart, traceEnd);
            CTraceFilter traceFilter;
            traceFilter.pSkip = LocalPlayer;
            Trace->TraceRay(ray, 0x46004003, &traceFilter, &tr);
            
            C_CSPlayer* player = (C_CSPlayer*)tr.m_pEntityHit;
            if (!player) {
                return;
            }

            if (player->GetClientClass()->m_ClassID != EClassIds::CCSPlayer) {
                return;
            }
            
            if (player == LocalPlayer || player->IsDormant() || !player->IsAlive() || player->IsImmune()) {
                return;
            }
            
            if (player->GetTeamNum() == LocalPlayer->GetTeamNum()) {
                return;
            }
            
            bool filter;
            
            switch (tr.hitgroup) {
                case HitGroups::HITGROUP_HEAD:
                    filter = Options::Improvements::trigger_filter_head;
                    break;
                case HitGroups::HITGROUP_CHEST:
                    filter = Options::Improvements::trigger_filter_chest;
                    break;
                case HitGroups::HITGROUP_STOMACH:
                    filter = Options::Improvements::trigger_filter_stomach;
                    break;
                case HitGroups::HITGROUP_LEFTARM:
                case HitGroups::HITGROUP_RIGHTARM:
                    filter = Options::Improvements::trigger_filter_arms;
                    break;
                case HitGroups::HITGROUP_LEFTLEG:
                case HitGroups::HITGROUP_RIGHTLEG:
                    filter = Options::Improvements::trigger_filter_legs;
                    break;
                default:
                    filter = false;
            }
            
            if (!filter) {
                return;
            }
            
            Vector vMin, vMax;
            if (Options::Aimbot::smokecheck && Utils::LineGoesThroughSmoke(traceStart, player->GetPredictedPosition(HITBOX_BODY, vMin, vMax))) {
                return;
            }

            triggerTarget = player;
            return;
        } else {
            bool delayExpired = false;
            if (Options::Improvements::trigger_delay) {
                long currTime = Functions::GetTimeStamp();
                if (triggerTime == 0) {
                    triggerTime = currTime;
                }

                long triggerDelay = (long)Functions::SafeFloatToInt(Options::Improvements::trigger_delay_value);
                long currentDelay = currTime - triggerTime;
                if (currentDelay > triggerDelay) {
                    delayExpired = true;
                    triggerTime = 0;
                }
            } else {
                delayExpired = true;
            }

            if (delayExpired) {
                if (activeWeapon->EntityId() == EItemDefinitionIndex::weapon_revolver) {
                    pCmd->buttons |= IN_ATTACK2;
                } else {
                    pCmd->buttons |= IN_ATTACK;
                }
                Reset();

                return;
            }

            return;
        }
    } else {
        Reset();

        return;
    }
}

void Features::CTriggerBot::Reset() {
    triggerTime = 0;
    triggerTarget = nullptr;
}

std::shared_ptr<Features::CTriggerBot> TriggerBot = std::make_unique<Features::CTriggerBot>();
