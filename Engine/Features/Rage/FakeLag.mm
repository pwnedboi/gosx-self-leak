/******************************************************/
/**                                                  **/
/**      Rage/FakeLag.mm                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "FakeLag.h"

#ifdef GOSX_RAGE_MODE

static int ticks = 0;
int ticksMax = 16;

void Features::CFakeLag::CreateMove(CUserCmd *pCmd) {
    if (!Options::RageMisc::fakelag) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }
    
    if (LocalPlayer->IsOnGround() && Options::RageMisc::fakelag_adaptive) {
        return;
    }
    
    if (pCmd->buttons & IN_ATTACK) {
        *CreateMove::SendPacket = true;
        return;
    }
    
    if (ticks >= ticksMax) {
        *CreateMove::SendPacket = true;
        ticks = 0;
    } else {
        if (Options::RageMisc::fakelag_adaptive) {
            int packetsToChoke;
            if (LocalPlayer->GetVelocity().Length() > 0.f) {
                packetsToChoke = (int)((64.f / (*GlobalVars)->interval_per_tick) / LocalPlayer->GetVelocity().Length()) + 1;
                if (packetsToChoke >= 15) {
                    packetsToChoke = 14;
                }
                if (packetsToChoke < Options::RageMisc::fakelag_ticks) {
                    packetsToChoke = Options::RageMisc::fakelag_ticks;
                }
            } else {
                packetsToChoke = 0;
            }
            *CreateMove::SendPacket = ticks < 16 - packetsToChoke;
        } else {
            *CreateMove::SendPacket = ticks < 16 - Options::RageMisc::fakelag_ticks;
        }
    }
    ticks++;
}

std::shared_ptr<Features::CFakeLag> FakeLag = std::make_unique<Features::CFakeLag>();

#endif
