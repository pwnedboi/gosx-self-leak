/******************************************************/
/**                                                  **/
/**      SDK/DynSkin.h                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_DynSkin_h
#define SDK_DynSkin_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "SDK/ItemDefinitionIndex.h"
#include "SDK/VDFParser.h"

class CSkinData;

class CSkinWeapon {
public:
    CSkinWeapon(std::string entityName);
    std::string GetEntityName();
    void AddSkin(nlohmann::json skinJson);
    std::vector<std::shared_ptr<CSkinData>> _skinData;
protected:
    std::string _entityName;
};

#ifdef GOSX_STICKER_CHANGER
class CSkinSticker {
public:
    CSkinSticker(int stickerId, std::string stickerName, int rarity = 0);
    std::string GetName();
    int GetID();
#ifdef GOSX_SKINCHANGER_RARITY
    int GetRarity();
#endif
protected:
    int _stickerId = -1;
    std::string _stickerName = "";
#ifdef GOSX_SKINCHANGER_RARITY
    int _rarity = (int)EntityRarityType::rarity_default;
#endif
};
#endif

class CSkinData {
public:
    CSkinData() {
        _skinId = 0;
        _realName = "";
        _phase = "";
#ifdef GOSX_SKINCHANGER_RARITY
        _rarity = (int)EntityRarityType::rarity_default;
#endif
    }

#ifdef GOSX_SKINCHANGER_RARITY
    CSkinData(int skinId, std::string skinName, std::string realName, std::string phase, EntityRarityType rarity) {
#else
    CSkinData(int skinId, std::string skinName, std::string realName, std::string phase) {
#endif
        _skinId = skinId;
        _realName = realName;
        _phase = phase;
#ifdef GOSX_SKINCHANGER_RARITY
        _rarity = (int)rarity;
#endif
    }

    int GetSkinId() {
        return _skinId;
    }

    std::string GetRealName() {
        return _realName;
    }

    std::string GetPhase() {
        return _phase;
    }
#ifdef GOSX_SKINCHANGER_RARITY
    EntityRarityType GetRarity() {
        return (EntityRarityType)_rarity;
    }
#endif

    int _skinId;
    std::string _realName;
    std::string _phase;
#ifdef GOSX_SKINCHANGER_RARITY
    int _rarity;
#endif
};

class CSkinList {
public:
    void DumpList(nlohmann::json skinsJson);
#ifdef GOSX_STICKER_CHANGER
    void DumpStickers(nlohmann::json stickerJson);
#ifdef GOSX_UNUSED
    void DumpStickers();
#endif
#endif
    std::shared_ptr<CSkinWeapon> GetWeaponSkinsPtr(std::string entityName);
    CSkinWeapon GetWeaponSkins(std::string entityName);
    bool HasSkins(std::string entityName);
#ifdef GOSX_STICKER_CHANGER
    std::vector<std::shared_ptr<CSkinSticker>> GetStickerList();
#endif
protected:
    nlohmann::json _skinsJson = {};
    std::vector<std::shared_ptr<CSkinWeapon>> _weaponList;
#ifdef GOSX_STICKER_CHANGER
    std::vector<std::shared_ptr<CSkinSticker>> _stickerList;
#endif
};

#endif /** !SDK_DynSkin_h */
