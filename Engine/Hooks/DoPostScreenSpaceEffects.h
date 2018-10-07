/******************************************************/
/**                                                  **/
/**      Hooks/DoPostScreenSpaceEffects.h            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_DoPostScreenSpaceEffects_h
#define Hooks_DoPostScreenSpaceEffects_h

#include "Engine/Hooks/manager.h"
#include "Engine/Features/GlowEsp.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace FeatureManager {
    class DoPostScreenSpaceEffectsFeature {
    public:
        static void DoPostScreenSpaceEffects(CViewSetup* viewSetup);
    };
}

#endif /** !Hooks_DoPostScreenSpaceEffects_h */
