/******************************************************/
/**                                                  **/
/**      Weapons/manager.cpp                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"
#include "SDK/Definitions.h"
#include "SDK/ItemDefinitionIndex.h"

bool WeaponManager::IsKnife(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_knife ||
           weaponID == EItemDefinitionIndex::weapon_knife_t ||
           (
                weaponID >= EItemDefinitionIndex::weapon_knife_bayonet &&
                weaponID < EItemDefinitionIndex::weapon_max
           );
}

bool WeaponManager::IsDefaultKnife(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_knife ||
           weaponID == EItemDefinitionIndex::weapon_knife_t;
}

bool WeaponManager::IsCustomKnife(int weaponID) {
    return weaponID >= EItemDefinitionIndex::weapon_knife_bayonet &&
           weaponID < EItemDefinitionIndex::weapon_max;
}

bool WeaponManager::IsGlove(int weaponID) {
    return weaponID >= EItemDefinitionIndex::studded_bloodhound_gloves &&
           weaponID < EItemDefinitionIndex::glove_max;
}

bool WeaponManager::IsWeaponConfigWeapon(int weaponID) {
    return !IsGrenade(weaponID) &&
           !IsKnife(weaponID) &&
           !IsC4(weaponID) &&
           !(EItemDefinitionIndex::weapon_taser == weaponID);
}

bool WeaponManager::IsValidWeapon(int weaponID) {
    return !IsGrenade(weaponID) &&
           !IsKnife(weaponID) &&
           !IsC4(weaponID) &&
           !IsGlove(weaponID);
}

bool WeaponManager::IsGrenade(int weaponID) {
    return weaponID >= EItemDefinitionIndex::weapon_flashbang &&
           weaponID <= EItemDefinitionIndex::weapon_incgrenade;
}

bool WeaponManager::IsC4(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_c4;
}

bool WeaponManager::IsPistol(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_deagle ||
           weaponID == EItemDefinitionIndex::weapon_elite ||
           weaponID == EItemDefinitionIndex::weapon_fiveseven ||
           weaponID == EItemDefinitionIndex::weapon_glock ||
           weaponID == EItemDefinitionIndex::weapon_tec9 ||
           weaponID == EItemDefinitionIndex::weapon_taser ||
           weaponID == EItemDefinitionIndex::weapon_hkp2000 ||
           weaponID == EItemDefinitionIndex::weapon_p250 ||
           weaponID == EItemDefinitionIndex::weapon_usp_silencer ||
           weaponID == EItemDefinitionIndex::weapon_cz75a ||
           weaponID == EItemDefinitionIndex::weapon_revolver;
}

bool WeaponManager::IsShotgun(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_xm1014 ||
           weaponID == EItemDefinitionIndex::weapon_mag7 ||
           weaponID == EItemDefinitionIndex::weapon_mag7 ||
           weaponID == EItemDefinitionIndex::weapon_nova ||
           weaponID == EItemDefinitionIndex::weapon_sawedoff;
}


bool WeaponManager::IsSniper(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_g3sg1 ||
           weaponID == EItemDefinitionIndex::weapon_scar20 ||
           weaponID == EItemDefinitionIndex::weapon_ssg08 ||
           weaponID == EItemDefinitionIndex::weapon_awp;
}

bool WeaponManager::IsDelayedWeapon(int weaponID) {
    return IsPistol(weaponID) ||
           IsShotgun(weaponID) ||
           weaponID == EItemDefinitionIndex::weapon_ssg08 ||
           weaponID == EItemDefinitionIndex::weapon_awp;
}

bool WeaponManager::IsScopeWeapon(int weaponID) {
    return weaponID == EItemDefinitionIndex::weapon_aug ||
           weaponID == EItemDefinitionIndex::weapon_ssg08 ||
           weaponID == EItemDefinitionIndex::weapon_sg556 ||
           weaponID == EItemDefinitionIndex::weapon_g3sg1 ||
           weaponID == EItemDefinitionIndex::weapon_scar20 ||
           weaponID == EItemDefinitionIndex::weapon_awp;
}

bool WeaponManager::IsTerrorWeapon(int weaponID) {
    return weaponID == weapon_deagle ||
           weaponID == weapon_elite ||
           weaponID == weapon_glock ||
           weaponID == weapon_ak47 ||
           weaponID == weapon_awp ||
           weaponID == weapon_g3sg1 ||
           weaponID == weapon_galilar ||
           weaponID == weapon_m249 ||
           weaponID == weapon_mac10 ||
           weaponID == weapon_p90 ||
           weaponID == weapon_mp5sd ||
           weaponID == weapon_ump45 ||
           weaponID == weapon_xm1014 ||
           weaponID == weapon_bizon ||
           weaponID == weapon_negev ||
           weaponID == weapon_sawedoff ||
           weaponID == weapon_tec9 ||
           weaponID == weapon_mp7 ||
           weaponID == weapon_nova ||
           weaponID == weapon_p250 ||
           weaponID == weapon_sg556 ||
           weaponID == weapon_ssg08 ||
           weaponID == weapon_knife_t ||
           weaponID == weapon_cz75a ||
           weaponID == weapon_revolver ||
           weaponID == weapon_flashbang ||
           weaponID == weapon_hegrenade ||
           weaponID == weapon_smokegrenade ||
           weaponID == weapon_molotov ||
           weaponID == weapon_decoy ||
           weaponID == weapon_incgrenade ||
           weaponID == weapon_knife_bayonet ||
           weaponID == weapon_knife_flip ||
           weaponID == weapon_knife_gut ||
           weaponID == weapon_knife_karambit ||
           weaponID == weapon_knife_m9_bayonet ||
           weaponID == weapon_knife_tactical ||
           weaponID == weapon_knife_falchion ||
           weaponID == weapon_knife_survival_bowie ||
           weaponID == weapon_knife_butterfly ||
           weaponID == weapon_knife_push ||
           weaponID == weapon_knife_ursus ||
           weaponID == weapon_knife_gypsy_jackknife ||
           weaponID == weapon_knife_stiletto ||
           weaponID == weapon_knife_widowmaker ||
           weaponID == glove_t ||
           weaponID == slick_gloves ||
           weaponID == sporty_gloves ||
           weaponID == specialist_gloves ||
           weaponID == motorcycle_gloves ||
           weaponID == studded_hydra_gloves ||
           weaponID == studded_bloodhound_gloves ||
           weaponID == leather_handwraps;
}

bool WeaponManager::IsCounterTerrorWeapon(int weaponID) {
    return weaponID == weapon_deagle ||
           weaponID == weapon_elite ||
           weaponID == weapon_fiveseven ||
           weaponID == weapon_aug ||
           weaponID == weapon_awp ||
           weaponID == weapon_famas ||
           weaponID == weapon_m249 ||
           weaponID == weapon_mag7 ||
           weaponID == weapon_m4a1 ||
           weaponID == weapon_p90 ||
           weaponID == weapon_mp5sd ||
           weaponID == weapon_ump45 ||
           weaponID == weapon_xm1014 ||
           weaponID == weapon_bizon ||
           weaponID == weapon_negev ||
           weaponID == weapon_hkp2000 ||
           weaponID == weapon_mp7 ||
           weaponID == weapon_mp9 ||
           weaponID == weapon_nova ||
           weaponID == weapon_p250 ||
           weaponID == weapon_scar20 ||
           weaponID == weapon_ssg08 ||
           weaponID == weapon_knife ||
           weaponID == weapon_m4a1_silencer ||
           weaponID == weapon_usp_silencer ||
           weaponID == weapon_cz75a ||
           weaponID == weapon_revolver ||
           weaponID == weapon_flashbang ||
           weaponID == weapon_hegrenade ||
           weaponID == weapon_smokegrenade ||
           weaponID == weapon_molotov ||
           weaponID == weapon_decoy ||
           weaponID == weapon_incgrenade ||
           weaponID == weapon_knife_bayonet ||
           weaponID == weapon_knife_flip ||
           weaponID == weapon_knife_gut ||
           weaponID == weapon_knife_karambit ||
           weaponID == weapon_knife_m9_bayonet ||
           weaponID == weapon_knife_tactical ||
           weaponID == weapon_knife_falchion ||
           weaponID == weapon_knife_survival_bowie ||
           weaponID == weapon_knife_butterfly ||
           weaponID == weapon_knife_push ||
           weaponID == weapon_knife_ursus ||
           weaponID == weapon_knife_gypsy_jackknife ||
           weaponID == weapon_knife_stiletto ||
           weaponID == weapon_knife_widowmaker ||
           weaponID == glove_ct ||
           weaponID == slick_gloves ||
           weaponID == sporty_gloves ||
           weaponID == specialist_gloves ||
           weaponID == motorcycle_gloves ||
           weaponID == studded_hydra_gloves ||
           weaponID == studded_bloodhound_gloves ||
           weaponID == leather_handwraps;
}

bool WeaponManager::IsForAll(int weaponID) {
    return weaponID == weapon_deagle ||
           weaponID == weapon_elite ||
           weaponID == weapon_awp ||
           weaponID == weapon_m249 ||
           weaponID == weapon_p90 ||
           weaponID == weapon_mp5sd ||
           weaponID == weapon_ump45 ||
           weaponID == weapon_xm1014 ||
           weaponID == weapon_bizon ||
           weaponID == weapon_negev ||
           weaponID == weapon_mp7 ||
           weaponID == weapon_nova ||
           weaponID == weapon_p250 ||
           weaponID == weapon_ssg08 ||
           weaponID == weapon_cz75a ||
           weaponID == weapon_revolver ||
           weaponID == weapon_flashbang ||
           weaponID == weapon_hegrenade ||
           weaponID == weapon_smokegrenade ||
           weaponID == weapon_molotov ||
           weaponID == weapon_decoy ||
           weaponID == weapon_incgrenade ||
           weaponID == weapon_knife_bayonet ||
           weaponID == weapon_knife_flip ||
           weaponID == weapon_knife_gut ||
           weaponID == weapon_knife_karambit ||
           weaponID == weapon_knife_m9_bayonet ||
           weaponID == weapon_knife_tactical ||
           weaponID == weapon_knife_falchion ||
           weaponID == weapon_knife_survival_bowie ||
           weaponID == weapon_knife_butterfly ||
           weaponID == weapon_knife_push ||
           weaponID == weapon_knife_ursus ||
           weaponID == weapon_knife_gypsy_jackknife ||
           weaponID == weapon_knife_stiletto ||
           weaponID == weapon_knife_widowmaker ||
           weaponID == slick_gloves ||
           weaponID == sporty_gloves ||
           weaponID == specialist_gloves ||
           weaponID == motorcycle_gloves ||
           weaponID == studded_hydra_gloves ||
           weaponID == studded_bloodhound_gloves ||
           weaponID == leather_handwraps;
}

bool WeaponManager::IsForAll(std::string weaponName) {
    for (auto item : ItemDefinitionIndex) {
        if (std::string(item.second.entity_name) == weaponName) {
            return IsForAll(item.first);
        }
    }
    
    return false;
}

std::string WeaponManager::GetWeaponIcon(int weaponID) {
    switch (weaponID) {
        case weapon_knife_bayonet:
            return ICON_CSGO_KNIFE_BAYONET;
        case weapon_knife_survival_bowie:
            return ICON_CSGO_KNIFE_BOWIE;
        case weapon_knife_butterfly:
            return ICON_CSGO_KNIFE_BUTTERFLY;
        case weapon_knife_ursus:
            return ICON_CSGO_KNIFE_URSUS;
        case weapon_knife_gypsy_jackknife:
            return ICON_CSGO_KNIFE_NAVAJA;
        case weapon_knife_stiletto:
            return ICON_CSGO_KNIFE_STILETTO;
        case weapon_knife_widowmaker:
            return ICON_CSGO_KNIFE_TALON;
        case weapon_knife:
            return ICON_CSGO_KNIFE_CT;
        case weapon_knife_falchion:
            return ICON_CSGO_KNIFE_FALCHION;
        case weapon_knife_flip:
            return ICON_CSGO_KNIFE_FLIP;
        case weapon_knife_gut:
            return ICON_CSGO_KNIFE_GUT;
        case weapon_knife_karambit:
            return ICON_CSGO_KNIFE_KARAMBIT;
        case weapon_knife_m9_bayonet:
            return ICON_CSGO_KNIFE_M9BAYONET;
        case weapon_knife_t:
            return ICON_CSGO_KNIFE_T;
        case weapon_knife_tactical:
            return ICON_CSGO_KNIFE_HUNTSMAN;
        case weapon_knife_push:
            return ICON_CSGO_KNIFE_SHADOWDAGGERS;
        case weapon_deagle:
            return ICON_CSGO_DEAGLE;
        case weapon_elite:
            return ICON_CSGO_ELITE;
        case weapon_fiveseven:
            return ICON_CSGO_FIVESEVEN;
        case weapon_glock:
            return ICON_CSGO_GLOCK;
        case weapon_hkp2000:
            return ICON_CSGO_P2000;
        case weapon_mp5sd:
            return ICON_CSGO_MP5SD;
        case weapon_p250:
            return ICON_CSGO_P250;
        case weapon_usp_silencer:
            return ICON_CSGO_USPS;
        case weapon_tec9:
            return ICON_CSGO_TEC9;
        case weapon_revolver:
            return ICON_CSGO_REVOLVER;
        case weapon_mac10:
            return ICON_CSGO_MAC10;
        case weapon_ump45:
            return ICON_CSGO_UMP45;
        case weapon_bizon:
            return ICON_CSGO_PPBIZON;
        case weapon_mp7:
            return ICON_CSGO_MP7;
        case weapon_mp9:
            return ICON_CSGO_MP9;
        case weapon_p90:
            return ICON_CSGO_P90;
        case weapon_galilar:
            return ICON_CSGO_GALIL;
        case weapon_famas:
            return ICON_CSGO_FAMAS;
        case weapon_m4a1_silencer:
            return ICON_CSGO_M4A1S;
        case weapon_m4a1:
            return ICON_CSGO_M4A4;
        case weapon_aug:
            return ICON_CSGO_AUG;
        case weapon_sg556:
            return ICON_CSGO_SG558;
        case weapon_ak47:
            return ICON_CSGO_AK47;
        case weapon_g3sg1:
            return ICON_CSGO_G3SG1;
        case weapon_scar20:
            return ICON_CSGO_SCAR20;
        case weapon_awp:
            return ICON_CSGO_AWP;
        case weapon_ssg08:
            return ICON_CSGO_SSG08;
        case weapon_xm1014:
            return ICON_CSGO_XM1014;
        case weapon_sawedoff:
            return ICON_CSGO_SAWEDOFF;
        case weapon_mag7:
            return ICON_CSGO_MAG7;
        case weapon_nova:
            return ICON_CSGO_NOVA;
        case weapon_negev:
            return ICON_CSGO_NEGEV;
        case weapon_m249:
            return ICON_CSGO_M249;
        case weapon_taser:
            return ICON_CSGO_ZEUS;
        case weapon_flashbang:
            return ICON_CSGO_FLASH;
        case weapon_hegrenade:
            return ICON_CSGO_HE;
        case weapon_smokegrenade:
            return ICON_CSGO_SMOKE;
        case weapon_molotov:
            return ICON_CSGO_MOLOTOV;
        case weapon_decoy:
            return ICON_CSGO_DECOY;
        case weapon_incgrenade:
            return ICON_CSGO_INC;
        case weapon_c4:
            return ICON_CSGO_C4;
        case weapon_cz75a:
            return ICON_CSGO_CZ75A;
        default:
            return " ";
    }
}
