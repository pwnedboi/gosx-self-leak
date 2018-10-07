/******************************************************/
/**                                                  **/
/**      Hooks/OverrideView.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "OverrideView.h"

void FeatureManager::OverrideViewFeature::OverrideView(CViewSetup *view) {
    if (!Options::Main::enabled) {
        return;
    }
    
    GrenadePrediction->OverrideView(view);
#ifdef GOSX_THIRDPERSON
    ThirdPerson->OverrideView(view);
#endif

    if (
        !Options::Improvements::fov_changer
#ifdef GOSX_STREAM_PROOF
        || StreamProof->Active()
#endif
    ) {
        return;
    }

    if (*Glob::ZoomedFov != view->fov) {
        *Glob::ZoomedFov = view->fov;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    if (LocalPlayer->IsScoped()) {
        return;
    }
    
    view->fov = Options::Improvements::fov;
}

void HookManager::HOOKED_OverrideView(void* thisptr, CViewSetup* view) {
    static OverrideViewFn oOverrideView = vmtClientMode->orig<OverrideViewFn>(INDEX_OVERRIDEVIEW);
    
    FeatureManager::OverrideViewFeature::OverrideView(view);
    
    oOverrideView(thisptr, view);
}
