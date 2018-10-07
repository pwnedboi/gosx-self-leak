/******************************************************/
/**                                                  **/
/**      Hooks/FrameStageNotify.cpp                  **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "FrameStageNotify.h"

C_BaseCombatWeapon* Glob::LastActiveWeapon = nullptr;

void FeatureManager::FrameStageNotifyFeature::PreFrameStageNotify(ClientFrameStage_t stage) {
#ifdef GOSX_STREAM_PROOF
    StreamProof->FrameStageNotify();
#endif
    
    if (!Options::Main::enabled || !Engine->IsInGame()) {
        return;
    }
    
#ifdef GOSX_THIRDPERSON
    ThirdPerson->PreFrameStageNotify(stage);
#endif
#ifdef GOSX_RAGE_MODE
    Features::CResolver::FrameStageNotify(stage);
    VisualRecoil->PreFrameStageNotify(stage);
#endif

    if (stage == ClientFrameStage_t::FRAME_START) {
        if (Engine->IsInGame() || !Options::synced) {
            CSettingsManager::SyncSettings();
            if (*Glob::IsWeaponSwitched) {
                C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
                if (LocalPlayer && LocalPlayer->IsValidLivePlayer()) {
                    C_BaseCombatWeapon* currentWeapon = LocalPlayer->GetActiveWeapon();
                    if (currentWeapon) {
                        if (currentWeapon != Glob::LastActiveWeapon) {
                            Glob::LastActiveWeapon = currentWeapon;
                            CSettingsManager::UpdateConfigForWeapon(currentWeapon->EntityId(), currentWeapon->GetCSWpnData()->m_WeaponType);
                            *Glob::IsWeaponSwitched = false;
                        }
                    }
                }
            }
        }
        
        FlashReducer->FrameStageNotify();
    }
    
    if (stage == ClientFrameStage_t::FRAME_NET_UPDATE_POSTDATAUPDATE_START) {
#ifdef GOSX_GLOVE_CHANGER
        GloveChanger->FrameStageNotify();
#endif
        SkinChanger->FrameStageNotify();
    }
    
    NoSky->FrameStageNotify(stage);
}

void FeatureManager::FrameStageNotifyFeature::PostFrameStageNotify(ClientFrameStage_t stage) {
#ifdef GOSX_RAGE_MODE
    VisualRecoil->PostFrameStageNotify(stage);
#endif
}

void HookManager::HOOKED_FrameStageNotify(void* thisptr, ClientFrameStage_t stage) {
    static FrameStageNotifyFn oFrameStageNotify = vmtClient->orig<FrameStageNotifyFn>(INDEX_FRAMESTAGENOTIFY);

#ifdef GOSX_AUTO_ACCEPT
    if (!Engine->IsInGame() && !Engine->IsConnected() && !Glob::IsEmitSoundHooked) {
        vmtSound->ApplyVMT();
        Glob::IsEmitSoundHooked = true;
    }
#endif
    
    FeatureManager::FrameStageNotifyFeature::PreFrameStageNotify(stage);
    
    oFrameStageNotify(thisptr, stage);
    
    FeatureManager::FrameStageNotifyFeature::PostFrameStageNotify(stage);
}
