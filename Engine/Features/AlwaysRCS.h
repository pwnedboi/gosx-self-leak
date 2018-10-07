/******************************************************/
/**                                                  **/
/**      Features/AlwaysRCS.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_AlwaysRCS_h
#define Features_AlwaysRCS_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Weapons/manager.h"
#include "Engine/Features/LegitBot.h"

namespace Features {
    class CAlwaysRCS {
    public:
        void CreateMove(CUserCmd* pCmd);
        void Smooth(QAngle& angle);
    protected:
        QAngle lastRCSPunch = {0.0000f, 0.0000f, 0.0000f};
        CLegitBot* aimLegitInstance = nullptr;
    };
}

extern std::shared_ptr<Features::CAlwaysRCS> AlwaysRCS;

#endif /** !Features_AlwaysRCS_h */
