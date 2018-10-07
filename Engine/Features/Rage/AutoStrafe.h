/******************************************************/
/**                                                  **/
/**      Rage/AutoStrafe.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_AutoStrafe_h
#define Rage_AutoStrafe_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"

#ifdef GOSX_RAGE_MODE

namespace Features {
    class CAutoStrafe {
    public:
        void CreateMove(CUserCmd* pCmd);
        void LegitStrafe(CUserCmd* pCmd);
        void RageStrafe(CUserCmd* pCmd);
    protected:
        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CAutoStrafe> AutoStrafe;

#endif

#endif /** !Rage_AutoStrafe_h */
