/******************************************************/
/**                                                  **/
/**      Hooks/OverrideConfig.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_OverrideConfig_h
#define Hooks_OverrideConfig_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"

#include "Engine/Hooks/manager.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace FeatureManager {
    class OverrideConfigFeature {
    public:
        static void OverrideConfig(MaterialSystem_Config_t* config);
    };
}

#endif /** !Hooks_OverrideConfig_h */
