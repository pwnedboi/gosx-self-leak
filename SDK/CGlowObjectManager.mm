/******************************************************/
/**                                                  **/
/**      SDK/CGlowObjectManager.mm                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CGlowObjectManager.h"

int CGlowObjectManager::RegisterGlowObject(C_BaseEntity* entity) {
    if (m_nFirstFreeSlot == END_OF_FREE_LIST) {
        return -1;
    }
    
    int index = m_nFirstFreeSlot;
    m_nFirstFreeSlot = m_entries[index].m_nNextFreeSlot;
    
    m_entries[index].m_pEntity = entity;
    m_entries[index].flUnk = 0.0f;
    m_entries[index].localplayeriszeropoint3 = 0.0f;
    m_entries[index].m_bFullBloomRender = false;
    m_entries[index].m_nFullBloomStencilTestValue = 0;
    m_entries[index].m_nSplitScreenSlot = -1;
    m_entries[index].m_nNextFreeSlot = ENTRY_IN_USE;
    
    return index;
}

void CGlowObjectManager::UnregisterGlowObject(int index) {
    m_entries[index].m_nNextFreeSlot = m_nFirstFreeSlot;
    m_entries[index].m_pEntity = NULL;
    m_nFirstFreeSlot = index;
}

bool CGlowObjectManager::HasGlowEffect(C_BaseEntity* entity) {
    for (int i = 0; i < m_entries.Count(); ++i) {
        if (m_entries[i].m_pEntity != entity) {
            continue;
        }
        
        if (!m_entries[i].IsUnused()) {
            return true;
        }
    }
    
    return false;
    };
