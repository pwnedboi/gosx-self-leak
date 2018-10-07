/******************************************************/
/**                                                  **/
/**      SDK/CGlowObjectManager.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CGlowObjectManager_h
#define SDK_CGlowObjectManager_h

#include "SDK.h"

#define END_OF_FREE_LIST -1
#define ENTRY_IN_USE -2

struct GlowObjectDefinition_t {
    C_BaseEntity* m_pEntity;
    Vector m_flGlowColor;
    float m_flGlowAlpha;
    char unknown[4];
    float flUnk;
    float m_flBloomAmount;
    float localplayeriszeropoint3;
    bool m_bRenderWhenOccluded;
    bool m_bRenderWhenUnoccluded;
    bool m_bFullBloomRender;
    char unknown1[1];
    int m_nFullBloomStencilTestValue;
    int iUnk;
    int m_nSplitScreenSlot;
    int m_nNextFreeSlot;
    
    bool IsUnused() const {
        return m_nNextFreeSlot != ENTRY_IN_USE;
    }
};

class CGlowObjectManager {
public:
    int RegisterGlowObject(C_BaseEntity* entity);
    void UnregisterGlowObject(int index);
    bool HasGlowEffect(C_BaseEntity* entity);
    
public:
    CUtlVector<GlowObjectDefinition_t> m_entries;
    int m_nFirstFreeSlot;
};

extern CGlowObjectManager* GlowObjectManager;

#endif /** !SDK_CGlowObjectManager_h */
