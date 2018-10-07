/******************************************************/
/**                                                  **/
/**      Hooks/PaintTraverse.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_PaintTraverse_h
#define Hooks_PaintTraverse_h

#include "SDK/SDK.h"

#include "Engine/Hooks/manager.h"

#include "Engine/Drawing/manager.h"
#include "Engine/Features/Esp.h"
#include "Engine/Features/GrenadeHelper.h"
#include "Engine/Features/SpectatorList.h"
#include "Engine/Features/HitMarker.h"
#include "Engine/Features/BombTimer.h"
#include "Engine/Features/Radar.h"

#ifdef GOSX_BACKTRACKING
#include "Engine/Features/BackTracking.h"
#endif

#include "Engine/Features/GrenadePrediction.h"

#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace FeatureManager {
    class PaintTraverseFeature {
    public:
        static std::string Watermark;
        static std::string VersionString;
        static Vector2D VersionTextSize;
        static int VersionPosX;
        static int VersionPosY;
        
        static bool PrePaintTraverse(VPANEL vguiPanel);
        static void ImPaintTraverse();
        static void PaintTraverse(VPANEL vguiPanel);
        static void Release();
    };
}

#endif /** !Hooks_PaintTraverse_h */
