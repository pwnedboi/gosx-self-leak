/******************************************************/
/**                                                  **/
/**      Rage/RageBot.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_RageBot_h
#define Rage_RageBot_h

#include "Engine/Features/AimHelper.h"

#ifdef GOSX_RAGE_MODE
#include "Resolver.h"
#include "Engine/Features/AutoWalls.h"

#define XM_2PI 6.283185307f

namespace Features {
    class CRageBot : public CAimHelper {
    public:
        void CreateMove(CUserCmd* pCmd);
        void AimTarget(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity);
        C_CSPlayer* FindTarget(C_CSPlayer* LocalPlayer);
        void AutoCrouch(C_CSPlayer* LocalPlayer);
        void AutoStop(C_CSPlayer* LocalPlayer);
        void AutoShoot(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetPlayer, C_BaseCombatWeapon* activeWeapon);
        bool CanHitEntity(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity, Vector EndPosition);
        bool HitChance(QAngle AimAngle, C_CSPlayer* LocalPlayer, C_CSPlayer* TargetPlayer, C_BaseCombatWeapon* activeWeapon);
        bool DelayedShot(C_CSPlayer* LocalPlayer, C_CSPlayer* TargetEntity, C_BaseCombatWeapon* weapon, QAngle AimAngles);
    private:
        CUserCmd* userCommand = nullptr;
    };
}

extern std::shared_ptr<Features::CRageBot> RageBot;

#endif

#endif /** !Rage_RageBot_h */
