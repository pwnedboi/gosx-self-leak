/******************************************************/
/**                                                  **/
/**      Hooks/BeginFrame.mm                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "BeginFrame.h"
#include "Engine/functions.h"

#ifdef GOSX_RAGE_MODE

bool* Glob::PostProcessing = nullptr;

void FeatureManager::BeginFrameFeature::BeginFrame(float frameTime) {
    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        *Glob::SendPacket = true;
        *CreateMove::SendPacket = true;
        
        return;
    }
    
    ClantagChanger->BeginFrame();
    
    if (!Glob::PostProcessing) {
        Glob::PostProcessing = reinterpret_cast<bool*>(PatternScanner->GetPointer(
            "client_panorama.dylib",
            XorStr("31 DB 80 3D ? ? ? ? 00 0F 85 66"),
            0x4
        ) + 0x5);
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        return;
    }
    
    if (*Glob::PostProcessing) {
        *Glob::PostProcessing = false;
    }
}

void HookManager::HOOKED_BeginFrame(void *thisptr, float frameTime) {
    static BeginFrameFn oBeginFrame = vmtMaterialSystem->orig<BeginFrameFn>(INDEX_BEGINFRAME);
    
    FeatureManager::BeginFrameFeature::BeginFrame(frameTime);
    
    oBeginFrame(thisptr, frameTime);
}

#endif
