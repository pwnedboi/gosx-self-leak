/******************************************************/
/**                                                  **/
/**      Features/GloveChanger.h                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_GloveChanger_h
#define Features_GloveChanger_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "SDK/CCSPlayer.h"
#include "SDK/ItemDefinitionIndex.h"

#ifdef GOSX_GLOVE_CHANGER
typedef void(*SetAbsOriginFn) (void*, const Vector&);

namespace Features {
    class CGloveChanger {
    public:
        void FrameStageNotify();
    protected:
        void Tick();
    private:
        bool glovesUpdated = false;
        C_CSPlayer* LocalPlayer = nullptr;
        int LastTeamNum = TEAM_NONE;
        Item_t CurrentGlove = Item_t("", "", "", "");
    };
}

extern std::shared_ptr<Features::CGloveChanger> GloveChanger;
#endif

#endif /** !Features_GloveChanger_h */
