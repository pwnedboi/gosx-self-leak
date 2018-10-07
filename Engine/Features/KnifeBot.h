/******************************************************/
/**                                                  **/
/**      Features/KnifeBot.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_KnifeBot_h
#define Features_KnifeBot_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Weapons/manager.h"
namespace Features {
    class CKnifeBot {
    public:
        void CreateMove(CUserCmd* pCmd);
    protected:
        bool IsPlayerBehind(C_CSPlayer* localplayer, C_CSPlayer* player);
        int GetLeftKnifeDamageDone(C_CSPlayer* localplayer, C_CSPlayer* player);
        int GetRightKnifeDamageDone(C_CSPlayer* localplayer, C_CSPlayer* player);
    };
}

extern std::shared_ptr<Features::CKnifeBot> KnifeBot;

#endif /** !Features_KnifeBot_h */
