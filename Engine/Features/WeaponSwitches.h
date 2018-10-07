/******************************************************/
/**                                                  **/
/**      Features/WeaponSwitches.h                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_WeaponSwitches_h
#define Features_WeaponSwitches_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Weapons/manager.h"

namespace Features {
    class CWeaponSwitches {
    public:
        void CreateMove(CUserCmd* pCmd);
    protected:
        void AutoPistolSwitch(CUserCmd* pCmd);
        void AutoKnifeSwitch(CUserCmd* pCmd);
        
        C_CSPlayer* LocalPlayer = nullptr;
        C_BaseCombatWeapon* ActiveWeapon = nullptr;
    private:
        void SendKey(const char* key);
    };
}

extern std::shared_ptr<Features::CWeaponSwitches> WeaponSwitch;

#endif /** !Features_WeaponSwitches_h */
