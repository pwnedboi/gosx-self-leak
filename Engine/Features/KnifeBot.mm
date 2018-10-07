/******************************************************/
/**                                                  **/
/**      Features/KnifeBot.cpp                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "KnifeBot.h"

void Features::CKnifeBot::CreateMove(CUserCmd *pCmd) {
    if (!Options::Extras::knifebot) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
    if (!activeWeapon) {
        return;
    }

    int weaponID = activeWeapon->EntityId();
    if (!WeaponManager::IsKnife(weaponID) && activeWeapon->GetClientClass()->m_ClassID != EClassIds::CKnifeGG) {
        return;
    }

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

    Vector localPlayerOrigin = *LocalPlayer->GetOrigin();
    float playerDistance = localPlayerOrigin.DistTo(*player->GetOrigin());
    if (activeWeapon->NextPrimaryAttack() < (*GlobalVars)->curtime) {
        if (playerDistance <= 65.f && GetRightKnifeDamageDone(LocalPlayer, player) >= player->GetHealth()) {
            pCmd->buttons |= IN_ATTACK2;
        } else if (IsPlayerBehind(LocalPlayer, player) && playerDistance <= 65.f) {
            pCmd->buttons |= IN_ATTACK2;
        } else if (playerDistance <= 78.f) {
            if (IsPlayerBehind(LocalPlayer, player)) {
                return;
            }
                
            if (playerDistance <= 65.f &&
                (2 * GetLeftKnifeDamageDone(LocalPlayer, player)) + (GetRightKnifeDamageDone(LocalPlayer, player) - 13) < player->GetHealth()
            ) {
                pCmd->buttons |= IN_ATTACK2;
            } else {
                pCmd->buttons |= IN_ATTACK;
            }
        }
    }
}

bool Features::CKnifeBot::IsPlayerBehind(C_CSPlayer* localplayer, C_CSPlayer* player) {
    Vector toTarget = (*localplayer->GetOrigin() - *player->GetOrigin());
    Vector playerViewAngles;
    Math::AngleVectors(*player->GetEyeAngles(), playerViewAngles);
    if (toTarget.Normalized().Dot(playerViewAngles) > -0.5f) {
        return false;
    } else {
        return true;
    }
}

int Features::CKnifeBot::GetLeftKnifeDamageDone(C_CSPlayer* localplayer, C_CSPlayer* player) {
    bool backstab = IsPlayerBehind(localplayer, player);
    int armor = player->GetArmor();
    if (!backstab) {
        if (armor > 0) {
            return 33; // 21
        } else {
            return 39; // 25
        }
    } else {
        if (armor > 0) {
            return 76; // 76
        } else {
            return 90; // 90
        }
    }
}

int Features::CKnifeBot::GetRightKnifeDamageDone(C_CSPlayer* localplayer, C_CSPlayer* player) {
    bool backstab = IsPlayerBehind(localplayer, player);
    int armor = player->GetArmor();
    if (!backstab) {
        if (armor > 0) {
            return 33; // 21
        } else {
            return 39; // 25
        }
    } else {
        return 100;
    }
}

std::shared_ptr<Features::CKnifeBot> KnifeBot = std::make_unique<Features::CKnifeBot>();
