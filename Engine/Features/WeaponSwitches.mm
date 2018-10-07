/******************************************************/
/**                                                  **/
/**      Features/WeaponSwitches.cpp                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "WeaponSwitches.h"

void Features::CWeaponSwitches::CreateMove(CUserCmd* pCmd) {
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }
    
    ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }
    
    AutoPistolSwitch(pCmd);
    AutoKnifeSwitch(pCmd);
}

void Features::CWeaponSwitches::SendKey(const char* key) {
    Engine->ExecuteClientCmd(key);
}

void Features::CWeaponSwitches::AutoPistolSwitch(CUserCmd* pCmd) {
    if (!Options::Extras::autopistol) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    if (!ActiveWeapon) {
        return;
    }

    int activeWeaponID = ActiveWeapon->EntityId();
    if (!WeaponManager::IsValidWeapon(activeWeaponID) || WeaponManager::IsPistol(activeWeaponID)) {
        return;
    }

    int currentAmmo = ActiveWeapon->GetAmmo();
    if (pCmd->buttons & IN_ATTACK && !currentAmmo) {
        if (!InputSystem->IsButtonDown(KEY_2)) {
            SendKey("slot2");
        }
    }
}

void Features::CWeaponSwitches::AutoKnifeSwitch(CUserCmd* pCmd) {
    if (!Options::Extras::autoknife) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }

    if (!WeaponManager::IsPistol(ActiveWeapon->EntityId())) {
        return;
    }

    int currentAmmo = ActiveWeapon->GetAmmo();
    if (pCmd->buttons & IN_ATTACK && !currentAmmo) {
        if (!InputSystem->IsButtonDown(KEY_3)) {
            SendKey("slot3");
        }
    }
}

std::shared_ptr<Features::CWeaponSwitches> WeaponSwitch = std::make_unique<Features::CWeaponSwitches>();
