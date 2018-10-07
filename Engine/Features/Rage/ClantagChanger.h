/******************************************************/
/**                                                  **/
/**      Rage/ClantagChanger.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_ClantagChanger_h
#define Rage_ClantagChanger_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"

#ifdef GOSX_RAGE_MODE
enum TagAnimationType {
    ANIMATE_RTL = 0,
    ANIMATE_LTR,
    ANIMATE_KNIGHTRIDER,
    ANIMATE_LETTER
};

namespace Features {
    class CClantagChanger {
    public:
        void Reset();
        void BeginFrame();
        std::string AnimateClantag(std::string tag);
    protected:
        std::string AnimateLTR(std::string tag, int tagSize, int preparedTagSize);
        std::string AnimateRTL(std::string tag, int tagSize, int preparedTagSize);
    protected:
        std::string LastTagName = "";
        C_CSPlayer* LocalPlayer = nullptr;
        float nextAnimationTick = 0.0f;
        int PositionInTag = -1;
    };
}

extern std::shared_ptr<Features::CClantagChanger> ClantagChanger;
#endif

#endif /** !Rage_ClantagChanger_h */
