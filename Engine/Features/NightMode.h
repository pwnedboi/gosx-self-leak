/******************************************************/
/**                                                  **/
/**      Features/NightMode.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_NightMode_h
#define Features_NightMode_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    class CNightMode {
    public:
        void Render();
        bool IsDone();
        void SetIsDone(bool value);
        void TurnOn();
        void TurnOff();
        void WalkMaterialList(bool state = true);
    protected:
        ConVar* sv_skyname = nullptr;
        ConVar* r_DrawSpecificStaticProp = nullptr;
        int r_DrawSpecificStaticProp_backup = -1;
        std::string sv_skyname_backup = "";
        bool done = false;
    };
}

extern std::shared_ptr<Features::CNightMode> NightMode;

#endif /** !Features_NightMode_h */
