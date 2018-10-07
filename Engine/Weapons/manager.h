/******************************************************/
/**                                                  **/
/**      Weapons/manager.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Weapons_manager_h
#define Weapons_manager_h

#include "Engine/common.h"
#include "Engine/Fonts/cstrike_icons.h"
#include "Engine/Fonts/fontawesome_icons.h"

namespace WeaponManager {
    extern bool IsKnife(int weaponID);
    extern bool IsDefaultKnife(int weaponID);
    extern bool IsCustomKnife(int weaponID);
    extern bool IsGrenade(int weaponID);
    extern bool IsC4(int weaponID);
    extern bool IsPistol(int weaponID);
    extern bool IsShotgun(int weaponID);
    extern bool IsSniper(int weaponID);
    extern bool IsValidWeapon(int weaponID);
    extern bool IsScopeWeapon(int weaponID);
    extern bool IsGlove(int weaponID);
    extern bool IsDelayedWeapon(int weaponID);
    extern bool IsWeaponConfigWeapon(int weaponID);
    extern bool IsTerrorWeapon(int weaponID);
    extern bool IsCounterTerrorWeapon(int weaponID);
    extern bool IsForAll(int weaponID);
    extern bool IsForAll(std::string weaponName);
    extern std::string GetWeaponIcon(int weaponID);
};

#endif /** !Weapons_manager_h */
