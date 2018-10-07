/******************************************************/
/**                                                  **/
/**      SDK/EconomyItem.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_EconomyItem_h
#define SDK_EconomyItem_h

class EconomyItem_t {
public:
    void Reset() {
        this->entity_quality = -1;
        this->fallback_seed = -1;
        this->fallback_paint_kit = -1;
        this->fallback_stattrak = -1;
        this->fallback_wear = (float)0.000001f;
        this->item_definition_index = -1;
        this->custom_name.clear();
#ifdef GOSX_STICKER_CHANGER
        this->sticker_slot1 = -1;
        this->sticker_slot2 = -1;
        this->sticker_slot3 = -1;
        this->sticker_slot4 = -1;
#endif
    }

    bool is_valid = false;
    int entity_quality = -1;
    int fallback_seed = -1;
    int fallback_paint_kit = -1;
    int fallback_stattrak = -1;
    float fallback_wear = 0.000001f;
    int item_definition_index = -1;
    std::string custom_name = "";
    int teamNum = 0;
#ifdef GOSX_STICKER_CHANGER
    int sticker_slot1 = -1;
    int sticker_slot2 = -1;
    int sticker_slot3 = -1;
    int sticker_slot4 = -1;
#endif
};

#endif /** !SDK_EconomyItem_h */
