/******************************************************/
/**                                                  **/
/**      Hooks/BeginFrame.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_BeginFrame_h
#define Hooks_BeginFrame_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "Engine/Hooks/manager.h"

#ifdef GOSX_RAGE_MODE
#include "Engine/Features/Rage/ClantagChanger.h"

namespace FeatureManager {
    class BeginFrameFeature {
    public:
        static void BeginFrame(float frameTime);
    };
}

#endif

#endif /** !Hooks_BeginFrame_h */
