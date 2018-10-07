/******************************************************/
/**                                                  **/
/**      SDK/ItemDefinitionIndex.h                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-02-23                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_ItemDefinitionIndex_h
#define SDK_ItemDefinitionIndex_h

#include "SDK/Definitions.h"
#include "SDK/EconomyItem.h"

extern std::unordered_map<int, Item_t> ItemDefinitionIndex;

struct EntityWear_t {
    const char* label;
    float minValue;
    float maxValue;
};

struct SkinRarity_t {
    std::string origin_name = "";
    std::string ingame_name = "";
    Color display_color = Color(0, 0, 0, 0);
};

#ifdef GOSX_SKINCHANGER_RARITY
enum class EntityRarityType : int {
    rarity_default = 0,
    rarity_common = 1,
    rarity_uncommon = 2,
    rarity_rare = 3,
    rarity_mythical = 4,
    rarity_legendary = 5,
    rarity_ancient = 6,
    rarity_immortal = 7,
    rarity_unusual = 99
};
#endif

extern std::unordered_map<size_t, EntityWear_t> EntityWear;

#ifdef GOSX_SKINCHANGER_RARITY
extern std::unordered_map<int, SkinRarity_t> ItemDefinitionRarity;
#endif

#endif /** !SDK_ItemDefinitionIndex_h */
