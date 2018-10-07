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

#ifndef Hooks_OverrideView_h
#define Hooks_OverrideView_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"

#include "Engine/Hooks/manager.h"

#ifdef GOSX_THIRDPERSON
#include "Engine/Features/ThirdPerson.h"
#endif
#include "Engine/Features/GrenadePrediction.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace FeatureManager {
    class OverrideViewFeature {
    public:
        static void OverrideView(CViewSetup* view);
    };
}

#endif /** !Hooks_OverrideView_h */
