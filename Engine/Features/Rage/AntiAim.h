/******************************************************/
/**                                                  **/
/**      Rage/AntiAim.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_AntiAim_h
#define Rage_AntiAim_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"

#ifdef GOSX_RAGE_MODE
/*
 Pitch => X
 Yaw => Y
 */
enum EAntiAimPitch {
    Emotion = 0,
    Up = 1,
    Down = 2,
    CustomPitch = 3,
    Dance = 4,
    StaticUpFake = 5,
    StaticDownFake = 6,
    LispDown = 7,
    AngelDown = 8,
    AngelUp = 9,
    RandomPitch = 10
};

enum EAntiAimYaw {
    Backwards = 0,
    Left = 1,
    Right = 2,
    CustomYaw = 3,
    SpinFast = 4,
    SpinSlow = 5,
    Jitter = 6,
    BackJitter = 7,
    Side = 8,
    StaticAA = 9,
    StaticJitter = 10,
    StaticSmallJitter = 11,
    Lisp = 12,
    LispSide = 13,
    LispJitter = 14,
    AngelBackwards = 15,
    AngelInverse = 16,
    AngelSpin = 17,
    RandomYaw = 18
};

namespace Features {
    class CAntiAim {
    public:
        void SetAtTargets(Vector targetAngle);
        void AAPitch(QAngle& angle, bool bFlip, bool& clamp);
        void AAYaw(QAngle& angle, bool bFlip, bool& clamp);
        bool AAEdge(C_CSPlayer* LocalPlayer, CUserCmd* cmd, float flWall, float flCornor);
        void CreateMove(CUserCmd* pCmd);
        static void Unload();
    private:
        Vector atTargets;
    };
}

extern std::shared_ptr<Features::CAntiAim> AntiAim;

#endif

#endif /** !Rage_AntiAim_h */

