/******************************************************/
/**                                                  **/
/**      SDK/DynSkin.cpp                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "DynSkin.h"

CSkinWeapon::CSkinWeapon(std::string entityName) {
    this->_entityName = entityName;
}

std::string CSkinWeapon::GetEntityName() {
    return _entityName;
}

void CSkinWeapon::AddSkin(nlohmann::json skinJson) {
    std::shared_ptr<CSkinData> skinInfo = std::make_unique<CSkinData>();

    skinInfo->_skinId = Functions::GetJsonData<int>(skinJson, "skin_id");
    skinInfo->_realName = Functions::GetJsonData<std::string>(skinJson, "skin_real_name");
    skinInfo->_phase = Functions::GetJsonData<std::string>(skinJson, "skin_phase");
#ifdef GOSX_SKINCHANGER_RARITY
    skinInfo->_rarity = Functions::GetJsonData<int>(skinJson, "skin_rarity");
#endif

    this->_skinData.push_back(skinInfo);
}

#ifdef GOSX_STICKER_CHANGER
CSkinSticker::CSkinSticker(int stickerId, std::string stickerName, int rarity) {
    this->_stickerId = stickerId;
    this->_stickerName = stickerName;
#ifdef GOSX_SKINCHANGER_RARITY
    this->_rarity = rarity;
#endif
}

std::string CSkinSticker::GetName() {
    return this->_stickerName;
}

int CSkinSticker::GetID() {
    return this->_stickerId;
}
#ifdef GOSX_SKINCHANGER_RARITY
int CSkinSticker::GetRarity() {
    return this->_rarity;
}
#endif
#endif

void CSkinList::DumpList(nlohmann::json skinsJson) {
    for (int index = (int)EItemDefinitionIndex::weapon_none; index < (int)EItemDefinitionIndex::glove_max; index++) {
        if (ItemDefinitionIndex.find(index) != ItemDefinitionIndex.end()) {
            Item_t currWeaponEntity = ItemDefinitionIndex.at(index);
            std::shared_ptr<CSkinWeapon> skinWeapon = std::make_unique<CSkinWeapon>(std::string(currWeaponEntity.entity_name));
            this->_weaponList.push_back(skinWeapon);
            if (skinsJson.find(currWeaponEntity.entity_name) != skinsJson.end()) {
                nlohmann::json SkinsData = skinsJson.at(currWeaponEntity.entity_name);
                for (nlohmann::json skin : SkinsData) {
                    skinWeapon->AddSkin(skin);
                }
            }
        }
    }
}

#ifdef GOSX_STICKER_CHANGER
void CSkinList::DumpStickers(nlohmann::json stickerJson) {
    for (nlohmann::json sticker : stickerJson) {
        if (sticker.at("id").is_number_integer() && sticker.at("name").is_string() && sticker.at("rarity").is_number_integer()) {
            this->_stickerList.emplace_back(
                std::make_unique<CSkinSticker>(
                    sticker.at("id").get<int>(),
                    sticker.at("name").get<std::string>(),
                    sticker.at("rarity").get<int>()
                )
            );
        }
    }
}

#ifdef GOSX_UNUSED
void CSkinList::DumpStickers() {
    char ItemsGameRealpath[PATH_MAX];
    realpath(Functions::GetWorkingPath().append("csgo/scripts/items").c_str(), ItemsGameRealpath);
    
    std::shared_ptr<Valve::Parser> ItemsGameParser = std::make_unique<Valve::Parser>();
    std::unique_ptr<Valve::Node> ItemsGame = ItemsGameParser->Parse(std::string(ItemsGameRealpath).append("/items_game.txt").c_str(), Valve::Parser::EFileEncoding::ENC_UTF8);
    Valve::Node StickerKits = ItemsGame->GetChild("sticker_kits");
    for (Valve::Node Sticker : StickerKits.GetChildren()) {
        int stickerID = std::stoi(Sticker.Name());
        if (stickerID == 0) {
            continue;
        }
        std::string itemName = Sticker.GetProperty("item_name").Value();
        const wchar_t* LocalizedWideChar = Localize->FindSafe(itemName.c_str());
        std::string realName = Utils::WstringToString(std::wstring(LocalizedWideChar));
        
        if (realName.find("#FIXME") != std::string::npos) {
            realName = std::string("** ").append(itemName);
        }
        
        this->_stickerList.emplace_back(std::make_unique<CSkinSticker>(stickerID, realName));
    }
}
#endif
#endif

std::shared_ptr<CSkinWeapon> CSkinList::GetWeaponSkinsPtr(std::string entityName) {
    for (std::shared_ptr<CSkinWeapon> wep : this->_weaponList) {
        if (wep->GetEntityName() == entityName) {
            return wep;
        }
    }

    return nullptr;
}

CSkinWeapon CSkinList::GetWeaponSkins(std::string entityName) {
    return *this->GetWeaponSkinsPtr(entityName);
}

bool CSkinList::HasSkins(std::string entityName) {
    for (std::shared_ptr<CSkinWeapon> wep : this->_weaponList) {
        if (wep->GetEntityName() == entityName) {
            return true;
        }
    }

    return false;
}

#ifdef GOSX_STICKER_CHANGER
std::vector<std::shared_ptr<CSkinSticker>> CSkinList::GetStickerList() {
    return this->_stickerList;
}
#endif

std::shared_ptr<CSkinList> Glob::SkinList = std::make_unique<CSkinList>();
