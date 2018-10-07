/******************************************************/
/**                                                  **/
/**      Features/BunnyHop.cpp                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "BunnyHop.h"

Features::CBunnyHop::CBunnyHop() {
    this->RegisterKeyBind(
        "hop_enabled",
        &Options::Improvements::bhop_toggle_key,
        &Options::Improvements::bunnyhop,
        "Improvements",
        "bunnyhop"
    );
}

void Features::CBunnyHop::CreateMove(CUserCmd* pCmd) {
    this->KeybindTick();
    
    if (!Options::Improvements::bunnyhop) {
        return;
    }

    this->LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!this->LocalPlayer || !this->LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    if (this->LocalPlayer->GetMoveType() == MoveType_t::MOVETYPE_LADDER || this->LocalPlayer->GetMoveType() == MoveType_t::MOVETYPE_NOCLIP) {
        return;
    }

    this->BhopLegit(pCmd);
    this->BhopDefault(pCmd);
}

void Features::CBunnyHop::BhopLegit(CUserCmd *pCmd) {
    if (!Options::Improvements::bhop_legit) {
        return;
    }

    if (!this->bLastJumped && this->bShouldFake) {
        this->bShouldFake = false;
        pCmd->buttons |= IN_JUMP;
    } else if (pCmd->buttons & IN_JUMP) {
        if (this->LocalPlayer->IsOnGround()) {
            this->bActualHop++;
            this->bLastJumped = true;
            this->bShouldFake = true;
        } else {
            if (
                (this->bActualHop > Options::Improvements::bhop_minhops) &&
                (rand()%100 > 75)
            ) {
                return;
            }

            if (this->bActualHop > Options::Improvements::bhop_maxhops) {
                return;
            }

            pCmd->buttons &= ~IN_JUMP;
            this->bLastJumped = false;
        }
    } else {
        this->bActualHop = 0;
        this->bLastJumped = false;
        this->bShouldFake = false;
    }
}

void Features::CBunnyHop::BhopDefault(CUserCmd *pCmd) {
    if (Options::Improvements::bhop_legit) {
        return;
    }

    if (pCmd->buttons & IN_JUMP && !this->LocalPlayer->IsOnGround()) {
        pCmd->buttons &= ~IN_JUMP;
    }
}

std::shared_ptr<Features::CBunnyHop> BunnyHop = std::make_unique<Features::CBunnyHop>();
