/******************************************************/
/**                                                  **/
/**      Features/TriggerBot.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_TriggerBot_h
#define Features_TriggerBot_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Weapons/manager.h"

namespace Features {
    class CTriggerBot {
    public:
        void CreateMove(CUserCmd* pCmd);
    protected:
        void Reset();
        long triggerTime = 0;
        C_CSPlayer* triggerTarget = nullptr;
    };
}

extern std::shared_ptr<Features::CTriggerBot> TriggerBot;

#endif /** !Features_TriggerBot_h */
