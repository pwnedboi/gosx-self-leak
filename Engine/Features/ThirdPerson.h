/******************************************************/
/**                                                  **/
/**      Features/ThirdPerson.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_ThirdPerson_h
#define Features_ThirdPerson_h

#include "SDK/SDK.h"

#ifdef GOSX_THIRDPERSON
#include "SDK/CCSPlayer.h"
#include "Engine/Features/StreamProof.h"
#include "Engine/Features/KeyBind.h"

namespace Features {
    class CThirdPerson : public KeyBind {
    public:
        CThirdPerson();
        void OverrideView(CViewSetup* view);
        void PreFrameStageNotify(ClientFrameStage_t stage);
    protected:
        float GetDistance(C_CSPlayer* LocalPlayer, float SettingsDistance = 100.0f);
        void ResetInput();
        
        bool WasEnabled = false;
    };
}

extern std::shared_ptr<Features::CThirdPerson> ThirdPerson;

#endif

#endif /** !Features_ThirdPerson_h */
