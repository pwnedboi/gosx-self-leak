/******************************************************/
/**                                                  **/
/**      Rage/FakeWalk.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_FakeWalk_h
#define Rage_FakeWalk_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"

#ifdef GOSX_RAGE_MODE

namespace Features {
    class CFakeWalk {
    public:
        void CreateMove(CUserCmd* pCmd);
    };
}

extern std::shared_ptr<Features::CFakeWalk> FakeWalk;

#endif

#endif /** !Rage_FakeWalk_h */
