/******************************************************/
/**                                                  **/
/**      Features/BunnyHop.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_BunnyHop_h
#define Features_BunnyHop_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Features/KeyBind.h"

namespace Features {
    class CBunnyHop : public KeyBind {
    public:
        CBunnyHop();
        void CreateMove(CUserCmd* pCmd);
        void BhopLegit(CUserCmd* pCmd);
        void BhopDefault(CUserCmd* pCmd);
        bool bLastJumped = false;
        bool bShouldFake = false;
        int bActualHop = 0;
        int minJumps = 3;
        int maxJumps = 7;
    private:
        CUserCmd* cmd;
        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CBunnyHop> BunnyHop;

#endif /** !Features_BunnyHop_h */
