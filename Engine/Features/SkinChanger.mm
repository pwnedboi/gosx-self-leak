/******************************************************/
/**                                                  **/
/**      Features/SkinChanger.cpp                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SkinChanger.h"
#include "SDK/Utils.h"

#ifdef GOSX_STICKER_CHANGER
static uintptr_t s_iwoff = 0x0;
static void* oFloatFunc;
static void* oUintFunc;
#endif

void Features::CSkinChanger::FrameStageNotify() {
    if (!Options::Improvements::skin_changer) {
        return;
    }

    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }

    if (this->PreTick()) {
        return;
    }
    
    if (!LocalPlayer->IsAlive()) {
        return;
    }
    
#ifdef GOSX_STICKER_CHANGER
    if (!s_iwoff) {
        s_iwoff = Offsets::DT_EconEntity::m_Item + 0x18;
    }
#endif

    this->Tick();
}

bool Features::CSkinChanger::PreTick() {
    return false;
}

void Features::CSkinChanger::Tick() {
    if (!Options::Improvements::skin_changer) {
        return;
    }
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }

    int* pWeapons = LocalPlayer->GetWeapons();
    if (!pWeapons) {
        return;
    }
    
    player_info_t LocalPlayerInfo;
    if (!Engine->GetPlayerInfo(Engine->GetLocalPlayer(), &LocalPlayerInfo)) {
        return;
    }

    for (int i = 0; pWeapons[i]; i++) {
        C_BaseAttributableItem* weapon = (C_BaseAttributableItem*)EntList->GetClientEntityFromHandle(pWeapons[i]);
        if (!weapon) {
            continue;
        }

        short* item_definition_index = weapon->GetItemDefinitionIndex();
        if (*item_definition_index == 0) {
            continue;
        }
        
#ifdef GOSX_STICKER_CHANGER
        if (WeaponManager::IsValidWeapon(*item_definition_index) && ActiveWeapon == weapon) {
            this->ApplyStickerHooks(weapon);
        }
#endif

        const char* weaponConfigName = ItemDefinitionIndex.at(*item_definition_index).entity_name;
        if (!Glob::SkinsConfig->HasSkinConfiguration(std::string(weaponConfigName), LocalPlayer->GetTeamNum())) {
            continue;
        }

        const EconomyItem_t& weapon_config = Glob::SkinsConfig->GetSkinConfiguration(weaponConfigName, LocalPlayer->GetTeamNum());
        *weapon->GetItemIDHigh() = -1;
        *weapon->GetAccountID() = LocalPlayerInfo.xuid_low;

        if (weapon_config.item_definition_index != -1) {
            if (ItemDefinitionIndex.find(weapon_config.item_definition_index) != ItemDefinitionIndex.end()) {
                Item_t econItem = ItemDefinitionIndex.at(weapon_config.item_definition_index);
                
                *weapon->GetModelIndex() = ModelInfo->GetModelIndex(econItem.model);
                if (ItemDefinitionIndex.find(*item_definition_index) != ItemDefinitionIndex.end()) {
                    *item_definition_index = weapon_config.item_definition_index;
                }
                
                /*C_BaseWorldModel* WorldModel = weapon->GetWorldModel();
                if (WorldModel && strlen(econItem.world_model) > 0) {
                    *WorldModel->GetModelIndex() = ModelInfo->GetModelIndex(econItem.world_model);
                }*/
            }
        }

        if (weapon_config.entity_quality != -1) {
            *weapon->GetEntityQuality() = weapon_config.entity_quality;
        }
        if (weapon_config.fallback_paint_kit != -1) {
            *weapon->GetFallbackPaintKit() = weapon_config.fallback_paint_kit;
        }
        if (weapon_config.fallback_seed != -1) {
            *weapon->GetFallbackSeed() = weapon_config.fallback_seed;
        }
        if (weapon_config.fallback_wear != -1) {
            *weapon->GetFallbackWear() = weapon_config.fallback_wear;
        }
        if (weapon_config.fallback_stattrak != -1) {
            *weapon->GetFallbackStatTrak() = weapon_config.fallback_stattrak;
        }
        if (weapon_config.custom_name != "") {
            std::snprintf(weapon->GetCustomName(), 32, "%s", weapon_config.custom_name.c_str());
        }
    }

    C_BaseViewModel* ViewModel = LocalPlayer->GetViewModel();
    if (!ViewModel) {
        return;
    }

    CBaseHandle ViewmodelWeaponHandle = ViewModel->GetWeapon();
    if (ViewmodelWeaponHandle == INVALID_EHANDLE_INDEX) {
        return;
    }

    C_BaseAttributableItem* ViewmodelWeapon = (C_BaseAttributableItem*)EntList->GetClientEntityFromHandle(ViewmodelWeaponHandle);
    if (!ViewmodelWeapon) {
        return;
    }

    if (ItemDefinitionIndex.find(*ViewmodelWeapon->GetItemDefinitionIndex()) != ItemDefinitionIndex.end()) {
        const Item_t& OverrideWeapon = ItemDefinitionIndex.at(*ViewmodelWeapon->GetItemDefinitionIndex());
        *ViewModel->GetModelIndex() = ModelInfo->GetModelIndex(OverrideWeapon.model);
    }
}

void Features::CSkinChanger::FireEvent(IGameEvent *event) {
    std::string eventName = std::string(event->GetName());
    if (eventName != "player_death") {
        return;
    }

    if (!Options::Improvements::skin_changer) {
        return;
    }

    int attacker_id = event->GetInt("attacker");
    int victim_id = event->GetInt("userid");

    if (Engine->GetPlayerForUserID(attacker_id) != Engine->GetLocalPlayer()) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }

    std::string weaponConfigName = "weapon_";
    weaponConfigName.append(event->GetString("weapon"));
    if (!Glob::SkinsConfig->HasSkinConfiguration(weaponConfigName, LocalPlayer->GetTeamNum())) {
        return;
    }

    C_CSPlayer* victim = (C_CSPlayer*)EntList->GetClientEntity(Engine->GetPlayerForUserID(victim_id));
    if (!victim) {
        return;
    }
    
    player_info_t VictimPlayerInfo;
    if (!Engine->GetPlayerInfo(victim->EntIndex(), &VictimPlayerInfo)) {
        return;
    }
    
    if (std::string(VictimPlayerInfo.guid) == "") {
        return;
    }

    EconomyItem_t currentConfig = Glob::SkinsConfig->GetSkinConfiguration(weaponConfigName, LocalPlayer->GetTeamNum());
    if (currentConfig.fallback_stattrak == -1) {
        return;
    }

    bool valueHasChanged = false;
    if (LocalPlayer->GetTeamNum() != victim->GetTeamNum()) {
        if (currentConfig.fallback_stattrak < 999999) {
            currentConfig.fallback_stattrak++;
            valueHasChanged = true;
        }
    } else if (LocalPlayer->GetTeamNum() == victim->GetTeamNum()) {
        if (!(currentConfig.fallback_stattrak <= 0)) {
            currentConfig.fallback_stattrak--;
            valueHasChanged = true;
        }
    }
    
    if (valueHasChanged) {
        Glob::SkinsConfig->SetIsInit(true);
        Glob::SkinsConfig->SetSkinConfiguration(weaponConfigName, currentConfig, LocalPlayer->GetTeamNum());
        Glob::SkinsConfig->SetIsInit(false);
    }
}

#ifdef GOSX_STICKER_CHANGER
void Features::CSkinChanger::ApplyStickerHooks(C_BaseAttributableItem* item) {
    if (!LocalPlayer || LocalPlayer->IsDormant() || !LocalPlayer->IsAlive()) {
        return;
    }
    
    if (!item) {
        return;
    }
    
    void**& iw_vt = *reinterpret_cast<void***>(uintptr_t(item) + s_iwoff);
    
    static void** iw_hook_vt = nullptr;
    
    if (!iw_hook_vt) {
        size_t len = 0;
        
        while (iw_vt[len]) {
            ++len;
        }
        
        iw_hook_vt = new void*[len];
        memcpy(iw_hook_vt, iw_vt, len * sizeof(void*));
        oFloatFunc = iw_hook_vt[5];
        iw_hook_vt[5] = (void*)StickerChanger::GetStickerAttributeBySlotIndexFloat;
        oUintFunc = iw_hook_vt[6];
        iw_hook_vt[6] = (void*)StickerChanger::GetStickerAttributeBySlotIndexInt;
    }
    
    iw_vt = iw_hook_vt;
}

float Features::StickerChanger::GetStickerAttributeBySlotIndexFloat(void* thisptr, int slot, EStickerAttributeType attribute, float unknown) {
    static GetStickerAttributeBySlotIndexFloatFn oFunc = reinterpret_cast<GetStickerAttributeBySlotIndexFloatFn>(oFloatFunc);
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (LocalPlayer) {
        C_BaseAttributableItem* ActiveEconWeapon = reinterpret_cast<C_BaseAttributableItem*>(uintptr_t(thisptr) - s_iwoff);
        if (ActiveEconWeapon) {
            switch (attribute) {
                case EStickerAttributeType::Wear:
                    return FLT_MIN;
                case EStickerAttributeType::Scale:
                    return 1.f;
                case EStickerAttributeType::Rotation:
                    return 0.f;
                default:
                    break;
            }
        }
    }
    
    return oFunc(thisptr, slot, attribute, unknown);
}

unsigned int Features::StickerChanger::GetStickerAttributeBySlotIndexInt(void* thisptr, int slot, EStickerAttributeType attribute, unsigned unknown) {
    static GetStickerAttributeBySlotIndexIntFn oFunc = reinterpret_cast<GetStickerAttributeBySlotIndexIntFn>(oUintFunc);
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (LocalPlayer) {
        C_BaseAttributableItem* ActiveEconWeapon = reinterpret_cast<C_BaseAttributableItem*>(uintptr_t(thisptr) - s_iwoff);
        if (ActiveEconWeapon) {
            if (ItemDefinitionIndex.find(*ActiveEconWeapon->GetItemDefinitionIndex()) == ItemDefinitionIndex.end()) {
                return oFunc(thisptr, slot, attribute, unknown);
            }
            
            Item_t currentConfigWeapon = ItemDefinitionIndex.at(*ActiveEconWeapon->GetItemDefinitionIndex());
            
            if (!Glob::SkinsConfig->HasSkinConfiguration(currentConfigWeapon.entity_name, LocalPlayer->GetTeamNum())) {
                return oFunc(thisptr, slot, attribute, unknown);
            }
            
            EconomyItem_t skinConfig = Glob::SkinsConfig->GetSkinConfiguration(currentConfigWeapon.entity_name, LocalPlayer->GetTeamNum());
            int selectedStickerID = -1;
            switch (slot) {
                case 0:
                    selectedStickerID = skinConfig.sticker_slot1;
                    break;
                case 1:
                    selectedStickerID = skinConfig.sticker_slot2;
                    break;
                case 2:
                    selectedStickerID = skinConfig.sticker_slot3;
                    break;
                case 3:
                    selectedStickerID = skinConfig.sticker_slot4;
                    break;
            }
            
            if (selectedStickerID == -1) {
                return oFunc(thisptr, slot, attribute, unknown);
            }
            
            switch (attribute) {
                case EStickerAttributeType::Index:
                    return selectedStickerID;
                default:
                    break;
            }
        }
    }
    
    return oFunc(thisptr, slot, attribute, unknown);
}
#endif

std::shared_ptr<Features::CSkinChanger> SkinChanger = std::make_unique<Features::CSkinChanger>();
