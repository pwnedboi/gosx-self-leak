/******************************************************/
/**                                                  **/
/**      Rage/VisualRecoil.mm                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "VisualRecoil.h"

#ifdef GOSX_RAGE_MODE

void Features::CVisualRecoil::PreFrameStageNotify(ClientFrameStage_t stage) {
    if (!Options::Main::enabled || !Options::RageMisc::no_visual_recoil) {
        return;
    }
    
    if (!Engine->IsInGame() && !Engine->IsConnected()) {
        return;
    }
    
    if (stage != ClientFrameStage_t::FRAME_RENDER_START) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }

    ViewPunchPtr = LocalPlayer->PtrViewPunch();
    AimPunchPtr = LocalPlayer->PtrAimPunch();
    
    if (!ViewPunchPtr || !AimPunchPtr) {
        return;
    }
    
    ViewPunch = *ViewPunchPtr;
    AimPunch = *AimPunchPtr;
    
    ViewPunchPtr->Init();
    AimPunchPtr->Init();
}

void Features::CVisualRecoil::PostFrameStageNotify(ClientFrameStage_t stage) {
    if (!Options::Main::enabled || !Options::RageMisc::no_visual_recoil) {
        return;
    }
    
    if (!Engine->IsInGame() && !Engine->IsConnected()) {
        return;
    }
    
    if (stage != ClientFrameStage_t::FRAME_RENDER_START) {
        return;
    }
    
    if (!ViewPunchPtr || !AimPunchPtr) {
        return;
    }
    
    *ViewPunchPtr = ViewPunch;
    *AimPunchPtr = AimPunch;
}

std::shared_ptr<Features::CVisualRecoil> VisualRecoil = std::make_unique<Features::CVisualRecoil>();

#endif
