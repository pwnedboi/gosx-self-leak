/******************************************************/
/**                                                  **/
/**      Hooks/DoPostScreenSpaceEffects.mm           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "DoPostScreenSpaceEffects.h"

void FeatureManager::DoPostScreenSpaceEffectsFeature::DoPostScreenSpaceEffects(CViewSetup *viewSetup) {
    if (!Options::Main::enabled || !Engine->IsConnected() || !Engine->IsInGame()) {
        return;
    }
    
#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        return;
    }
#endif
    
    Glow->DoPostScreenSpaceEffects();
}

bool HookManager::HOOKED_DoPostScreenSpaceEffects(void* thisptr, CViewSetup* pSetup) {
    static DoPostScreenSpaceEffectsFn oDoPostScreenSpaceEffects = vmtClientMode->orig<DoPostScreenSpaceEffectsFn>(INDEX_DOPOSTSCREENSPACEEFFECTS);
    
    FeatureManager::DoPostScreenSpaceEffectsFeature::DoPostScreenSpaceEffects(pSetup);
    
    return oDoPostScreenSpaceEffects(thisptr, pSetup);
}
