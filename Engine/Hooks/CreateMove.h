/******************************************************/
/**                                                  **/
/**      Hooks/CreateMove.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_CreateMove_h
#define Hooks_CreateMove_h

#include "Engine/Hooks/manager.h"

#include "Engine/Features/BunnyHop.h"
#include "Engine/Features/LegitBot.h"
#include "Engine/Features/TriggerBot.h"
#include "Engine/Features/KnifeBot.h"
#include "Engine/Features/WeaponSwitches.h"
#include "Engine/Features/AlwaysRCS.h"
#include "Engine/Features/GrenadeHelper.h"
#include "Engine/Features/RankReveal.h"
#ifdef GOSX_RAGE_MODE
#include "Engine/Features/Rage/RageBot.h"
#include "Engine/Features/Rage/AntiAim.h"
#include "Engine/Features/Rage/FakeLag.h"
#include "Engine/Features/Rage/AutoStrafe.h"
#include "Engine/Features/Rage/FakeWalk.h"
#include "Engine/Features/Rage/CircleStrafe.h"
#endif
#ifdef GOSX_BACKTRACKING
#include "Engine/Features/BackTracking.h"
#endif
#include "Engine/Features/GrenadePrediction.h"

namespace FeatureManager {
    class CreateMoveFeature {
    public:
        static void CreateMove(void* thisptr, float sample_input_frametime, CUserCmd* pCmd);
    };
}

#endif /** !Hooks_CreateMove_h */
