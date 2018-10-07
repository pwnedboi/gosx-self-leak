/******************************************************/
/**                                                  **/
/**      Rage/FakeWalk.mm                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "FakeWalk.h"

#ifdef GOSX_RAGE_MODE

void Features::CFakeWalk::CreateMove(CUserCmd *pCmd) {
    if (!Engine->IsInGame() && !Engine->IsConnected()) {
        return;
    }
    
    if (!Options::RageMisc::fake_walk) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    if (!InputSystem->IsButtonDown((ButtonCode_t)Options::RageMisc::fake_walk_key)) {
        return;
    }
    
    static int iChoked = 0;
    
    iChoked = iChoked > 5 ? 0 : iChoked + 1;
    pCmd->forwardmove = iChoked < 3 || iChoked > 3 ? 0 : pCmd->forwardmove;
    pCmd->sidemove = iChoked < 4 || iChoked > 4 ? 0 : pCmd->sidemove;
    
    *CreateMove::SendPacket = iChoked < 1;
}

std::shared_ptr<Features::CFakeWalk> FakeWalk = std::make_unique<Features::CFakeWalk>();

#endif
