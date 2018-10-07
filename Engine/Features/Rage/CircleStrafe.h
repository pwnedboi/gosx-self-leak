/******************************************************/
/**                                                  **/
/**      Rage/CircleStrafe.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_CircleStrafe_h
#define Rage_CircleStrafe_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"

#ifdef GOSX_RAGE_MODE

namespace Features {
    class CCircleStrafe {
    public:
        void CreateMove(CUserCmd* pCmd);
    };
}

extern std::shared_ptr<Features::CCircleStrafe> CircleStrafe;

#endif

#endif /** !Rage_CircleStrafe_h */
