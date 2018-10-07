/******************************************************/
/**                                                  **/
/**      Hooks/OverrideConfig.cpp                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "OverrideConfig.h"

void FeatureManager::OverrideConfigFeature::OverrideConfig(MaterialSystem_Config_t* config) {
    if (
        !Options::Main::enabled
#ifdef GOSX_STREAM_PROOF
        || StreamProof->Active()
#endif
    ) {
        return;
    }

    if (!Options::Improvements::gray_walls) {
        return;
    }

    config->m_bDrawGray = Options::Improvements::gray_walls;
}

bool HookManager::HOOKED_OverrideConfig(void *thisptr, MaterialSystem_Config_t* config, bool forceUpdate) {
    static OverrideConfigFn oOverrideConfig = vmtMaterialSystem->orig<OverrideConfigFn>(INDEX_OVERRIDECONFIG);
    
    FeatureManager::OverrideConfigFeature::OverrideConfig(config);
    
    return oOverrideConfig(thisptr, config, forceUpdate);
}
