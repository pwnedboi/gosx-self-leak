/******************************************************/
/**                                                  **/
/**      Features/FlashReducer.cpp                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "FlashReducer.h"

void Features::CFlashReducer::FrameStageNotify() {
    if (!Options::Improvements::no_flash) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    float maxFlashAlpha = (Options::Improvements::maxflashalpha * 255.0f);
#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        maxFlashAlpha = 255.0f;
    }
#endif
    if (*LocalPlayer->GetMaxFlashAlpha() == maxFlashAlpha) {
        return;
    }

    *LocalPlayer->GetMaxFlashAlpha() = maxFlashAlpha;
}

std::shared_ptr<Features::CFlashReducer> FlashReducer = std::make_unique<Features::CFlashReducer>();
