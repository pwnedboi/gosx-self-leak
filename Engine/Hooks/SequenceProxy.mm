/******************************************************/
/**                                                  **/
/**      Hooks/SequenceProxy.cpp                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SequenceProxy.h"

SequenceProxy_t FeatureManager::SequenceProxy(RecvVarProxyFn squence, SequenceProxy_t squenceData) {
    CRecvProxyData* pData = const_cast<CRecvProxyData*>(squenceData.pDataConst);
    if (!Options::Improvements::skin_changer) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }
    
    if (!Engine->IsInGame() && !Engine->IsConnected()) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }
    
    C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
    if (!activeWeapon) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }

#ifdef GOSX_MP7TOMP5_FIX
    if (activeWeapon->EntityId() == EItemDefinitionIndex::weapon_mp5sd) {
        Item_t mp7item = ItemDefinitionIndex.at(EItemDefinitionIndex::weapon_mp7);
        if (Glob::SkinsConfig->HasSkinConfiguration(mp7item.entity_name, LocalPlayer->GetTeamNum())) {
            EconomyItem_t skinConfig = Glob::SkinsConfig->GetSkinConfiguration(mp7item.entity_name, LocalPlayer->GetTeamNum());
            if (skinConfig.item_definition_index == EItemDefinitionIndex::weapon_mp5sd) {
                long SequenceNum = pData->m_Value.m_Int;
                if (MP5Sequence(&SequenceNum)) {
                    pData->m_Value.m_Int = SequenceNum;
                }
            }
        }
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }
#endif
    
    if (!WeaponManager::IsKnife(activeWeapon->EntityId())) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }
    
    int OriginalWeaponItem = weapon_knife;
    if (LocalPlayer->GetTeamNum() == TEAM_T) {
        OriginalWeaponItem = weapon_knife_t;
    }
    Item_t WeaponKnifeItem = ItemDefinitionIndex.at(OriginalWeaponItem);
    
    int itemdefindex = activeWeapon->EntityId();
    if (!Glob::SkinsConfig->HasSkinConfiguration(WeaponKnifeItem.entity_name, LocalPlayer->GetTeamNum())) {
        return {squenceData.pDataConst, squenceData.pStruct, squenceData.pOut};
    }

    long m_nSequence = pData->m_Value.m_Int;

    bool SequenceChanged = false;
    switch (itemdefindex) {
        case weapon_knife_butterfly:
            SequenceChanged = ButterflySequence(&m_nSequence);
            break;
        case weapon_knife_falchion:
            SequenceChanged = FalchionSequence(&m_nSequence);
            break;
        case weapon_knife_push:
            SequenceChanged = ShadowdaggersSequence(&m_nSequence);
            break;
        case weapon_knife_survival_bowie:
            SequenceChanged = BowieSequence(&m_nSequence);
            break;
        case weapon_knife_ursus:
            SequenceChanged = UrsusSequence(&m_nSequence);
            break;
        case weapon_knife_stiletto:
            SequenceChanged = StilettoSequence(&m_nSequence);
            break;
        case weapon_knife_widowmaker:
            SequenceChanged = WidowmakerSequence(&m_nSequence);
            break;
        default:
            break;
    }

    if (SequenceChanged) {
        pData->m_Value.m_Int = m_nSequence;
    }

    return {pData, squenceData.pStruct, squenceData.pOut};
}

bool FeatureManager::ButterflySequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_DRAW:
            *m_nSequence = Utils::RandomInt(0, 1);
            
            return true;
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence = Utils::RandomInt(13, 15);
            
            return true;
        default:
            *m_nSequence = *m_nSequence + 1;
            
            return true;
    }
    
    return false;
}

bool FeatureManager::BowieSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_DRAW:
        case SEQUENCE_DEFAULT_IDLE1:
            break;
        case SEQUENCE_DEFAULT_IDLE2:
            *m_nSequence = SEQUENCE_BOWIE_IDLE1;
            
            return true;
        default:
            *m_nSequence = *m_nSequence - 1;
            
            return true;
    }
    
    return false;
}

bool FeatureManager::ShadowdaggersSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_IDLE2:
            *m_nSequence = SEQUENCE_DAGGERS_IDLE1;
            
            return true;
        case SEQUENCE_DEFAULT_LIGHT_MISS1:
        case SEQUENCE_DEFAULT_LIGHT_MISS2:
            *m_nSequence = Utils::RandomInt(SEQUENCE_DAGGERS_LIGHT_MISS1, SEQUENCE_DAGGERS_LIGHT_MISS5);
            
            return true;
        case SEQUENCE_DEFAULT_HEAVY_MISS1:
            *m_nSequence = Utils::RandomInt(SEQUENCE_DAGGERS_HEAVY_MISS2, SEQUENCE_DAGGERS_HEAVY_MISS1);
            
            return true;
        case SEQUENCE_DEFAULT_HEAVY_HIT1:
        case SEQUENCE_DEFAULT_HEAVY_BACKSTAB:
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence += 3;
            
            return true;
        case SEQUENCE_DEFAULT_DRAW:
        case SEQUENCE_DEFAULT_IDLE1:
            break;
        default:
            *m_nSequence += 2;
            
            return true;
    }
    
    return false;
}

bool FeatureManager::FalchionSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_IDLE2:
            *m_nSequence = SEQUENCE_FALCHION_IDLE1;
            
            return true;
        case SEQUENCE_DEFAULT_HEAVY_MISS1:
            *m_nSequence = Utils::RandomInt(SEQUENCE_FALCHION_HEAVY_MISS1, SEQUENCE_FALCHION_HEAVY_MISS1_NOFLIP);
            
            return true;
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence = Utils::RandomInt(SEQUENCE_FALCHION_LOOKAT01, SEQUENCE_FALCHION_LOOKAT02);
            
            return true;
        case SEQUENCE_DEFAULT_DRAW:
        case SEQUENCE_DEFAULT_IDLE1:
            break;
        default:
            *m_nSequence = *m_nSequence - 1;
            
            return true;
    }
    
    return false;
}

bool FeatureManager::UrsusSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_DRAW:
            *m_nSequence = Utils::RandomInt(SEQUENCE_BUTTERFLY_DRAW, SEQUENCE_BUTTERFLY_DRAW2);
            
            return true;
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence = Utils::RandomInt(SEQUENCE_BUTTERFLY_LOOKAT01, SEQUENCE_BUTTERFLY_LOOKAT02);
            
            return true;
        default:
            *m_nSequence = *m_nSequence + 1;
            
            return true;
    }
    
    return false;
}

bool FeatureManager::StilettoSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence = Utils::RandomInt(SEQUENCE_FALCHION_LOOKAT01, SEQUENCE_FALCHION_LOOKAT02);
            return true;
    }
    
    return false;
}

bool FeatureManager::WidowmakerSequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_DEFAULT_LOOKAT01:
            *m_nSequence = Utils::RandomInt(SEQUENCE_BUTTERFLY_LOOKAT02, SEQUENCE_BUTTERFLY_LOOKAT03);
            
            return true;
        case SEQUENCE_DEFAULT_HEAVY_BACKSTAB:
            *m_nSequence = *m_nSequence - 1;
            
            return true;
    }
    
    return false;
}

#ifdef GOSX_MP7TOMP5_FIX
bool FeatureManager::MP5Sequence(long* m_nSequence) {
    switch (*m_nSequence) {
        case SEQUENCE_MP7_LOOKAT:
            *m_nSequence = SEQUENCE_MP5SD_LOOKAT;
            
            return true;
        case SEQUENCE_MP7_SHOOT:
            *m_nSequence = SEQUENCE_MP5SD_SHOOT;
            
            return true;
        case SEQUENCE_MP7_DRAW:
            *m_nSequence = Utils::RandomInt(SEQUENCE_MP5SD_DRAW01, SEQUENCE_MP5SD_DRAW02);
            
            return true;
    }
    
    return false;
}
#endif

void HookManager::HOOKED_SequenceProxyFn(const CRecvProxyData *pDataConst, void *pStruct, void *pOut) {
    SequenceProxy_t proxyData = FeatureManager::SequenceProxy(vmtSequence, {pDataConst, pStruct, pOut});
    
    return vmtSequence(proxyData.pDataConst, proxyData.pStruct, proxyData.pOut);
}
