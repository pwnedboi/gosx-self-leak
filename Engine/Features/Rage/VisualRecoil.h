/******************************************************/
/**                                                  **/
/**      Rage/VisualRecoil.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_VisualRecoil_h
#define Rage_VisualRecoil_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"

#ifdef GOSX_RAGE_MODE

namespace Features {
    class CVisualRecoil {
    public:
        void PreFrameStageNotify(ClientFrameStage_t stage);
        void PostFrameStageNotify(ClientFrameStage_t stage);
    protected:
        Vector* ViewPunchPtr = nullptr;
        Vector* AimPunchPtr = nullptr;
        Vector AimPunch;
        Vector ViewPunch;
    };
}

extern std::shared_ptr<Features::CVisualRecoil> VisualRecoil;

#endif

#endif /** !Rage_VisualRecoil_h */
