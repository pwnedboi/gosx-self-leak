/******************************************************/
/**                                                  **/
/**      Features/SkinChanger.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_SkinChanger_h
#define Features_SkinChanger_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/ItemDefinitionIndex.h"

#ifdef GOSX_STICKER_CHANGER
enum class EStickerAttributeType {
    Index,
    Wear,
    Scale,
    Rotation
};
#endif

namespace Features {
#ifdef GOSX_STICKER_CHANGER
    typedef float(*GetStickerAttributeBySlotIndexFloatFn)(void*, int, EStickerAttributeType, float);
    typedef unsigned int(*GetStickerAttributeBySlotIndexIntFn)(void*, int, EStickerAttributeType, unsigned);

    class StickerChanger {
    public:
        static float GetStickerAttributeBySlotIndexFloat(void* thisptr, int slot, EStickerAttributeType attribute, float unknown);
        static unsigned int GetStickerAttributeBySlotIndexInt(void* thisptr, int slot, EStickerAttributeType attribute, unsigned unknown);
    };
#endif
    
    class CSkinChanger {
    public:
        void FrameStageNotify();
        void FireEvent(IGameEvent* event);
#ifdef GOSX_STICKER_CHANGER
        void ApplyStickerHooks(C_BaseAttributableItem* item);
#endif
    protected:
        bool PreTick();
        void Tick();
    private:
        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CSkinChanger> SkinChanger;

#endif /** !Features_SkinChanger_h */
