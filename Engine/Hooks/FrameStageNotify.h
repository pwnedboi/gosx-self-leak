/******************************************************/
/**                                                  **/
/**      Hooks/FrameStageNotify.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_FrameStageNotify_h
#define Hooks_FrameStageNotify_h

#include "SDK/SDK.h"

#include "Engine/Hooks/manager.h"

#include "Engine/Features/FlashReducer.h"
#include "Engine/Features/SkinChanger.h"
#ifdef GOSX_THIRDPERSON
#include "Engine/Features/ThirdPerson.h"
#endif

#ifdef GOSX_RAGE_MODE
#include "Engine/Features/Rage/Resolver.h"
#include "Engine/Features/Rage/VisualRecoil.h"
#endif

#ifdef GOSX_GLOVE_CHANGER
#include "Engine/Features/GloveChanger.h"
#endif

#include "Engine/Features/NoSky.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif
#include "SDK/CCSPlayer.h"

namespace FeatureManager {
    class FrameStageNotifyFeature {
    public:
        static void PreFrameStageNotify(ClientFrameStage_t stage);
        static void PostFrameStageNotify(ClientFrameStage_t stage);
    };
}

#endif /** !Hooks_FrameStageNotify_h */
