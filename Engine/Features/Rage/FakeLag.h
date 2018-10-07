/******************************************************/
/**                                                  **/
/**      Rage/FakeLag.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_FakeLag_h
#define Rage_FakeLag_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"

#ifdef GOSX_RAGE_MODE

namespace Features {
    class CFakeLag {
    public:
        void CreateMove(CUserCmd* pCmd);
    };
}

extern std::shared_ptr<Features::CFakeLag> FakeLag;

#endif

#endif /** !Rage_FakeLag_h */
