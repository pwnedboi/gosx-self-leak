/******************************************************/
/**                                                  **/
/**      Features/GloveChanger.mm                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "GloveChanger.h"

#ifdef GOSX_GLOVE_CHANGER
void Features::CGloveChanger::FrameStageNotify() {
    if (!Options::Improvements::glove_changer) {
        return;
    }
    
    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        return;
    }
    
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    if (LastTeamNum != LocalPlayer->GetTeamNum()) {
        LastTeamNum = LocalPlayer->GetTeamNum();
        CurrentGlove = Item_t("", "", "", "");
    }
    
    if (std::string(CurrentGlove.display_name) == "") {
        EItemDefinitionIndex teamGlove = (LastTeamNum == EntityTeam::TEAM_CT ? EItemDefinitionIndex::glove_ct : EItemDefinitionIndex::glove_t);
        if (ItemDefinitionIndex.find(teamGlove) != ItemDefinitionIndex.end()) {
            CurrentGlove = ItemDefinitionIndex.at(teamGlove);
        } else {
            return;
        }
    }
    
    if (!Glob::SkinsConfig->HasSkinConfiguration(std::string(CurrentGlove.entity_name), LastTeamNum)) {
        return;
    }
    
    if (!LocalPlayer->IsAlive()) {
        C_BaseAttributableItem* glove = (C_BaseAttributableItem*)EntList->GetClientEntityFromHandle(CBaseHandle(LocalPlayer->GetWearables()[0]));
        if (glove) {
            glove->SetDestroyedOnRecreateEntities();
            glove->Release();
        }
        
        return;
    }

    this->Tick();
}

void Features::CGloveChanger::Tick() {
    static SetAbsOriginFn SetAbsOrigin = reinterpret_cast<SetAbsOriginFn>(
        PatternScanner->GetProcedure("client_panorama.dylib", "50 49 89 F6 48 89 FB E8") - 0x9
    );
    
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        return;
    }
    
    player_info_t LocalPlayerInfo;
    if (!Engine->GetPlayerInfo(Engine->GetLocalPlayer(), &LocalPlayerInfo)) {
        return;
    }
    
    int* weapons = LocalPlayer->GetWeapons();
    if (!weapons) {
        return;
    }
    
    EconomyItem_t gloveSettings = Glob::SkinsConfig->GetSkinConfiguration(std::string(CurrentGlove.entity_name), LocalPlayer->GetTeamNum());
    if (ItemDefinitionIndex.find(gloveSettings.item_definition_index) != ItemDefinitionIndex.end()) {
        if (gloveSettings.item_definition_index == EItemDefinitionIndex::glove_ct || gloveSettings.item_definition_index == EItemDefinitionIndex::glove_t) {
            return;
        }
        
        Item_t updatedGlove = ItemDefinitionIndex.at(gloveSettings.item_definition_index);
        
        int* wearables = LocalPlayer->GetWearables();
        if (!EntList->GetClientEntityFromHandle((CBaseHandle)wearables[0])) {
            for (ClientClass *pClass = Client->GetAllClasses(); pClass; pClass = pClass->m_pNext) {
                if (pClass->m_ClassID != EClassIds::CEconWearable) {
                    continue;
                }
                
                int entry = EntList->GetHighestEntityIndex() + 1;
                int serial = Utils::RandomInt(0x0, 0xFFF);
                
                if (pClass->m_pCreateFn(entry, serial)) {
                    wearables[0] = entry | (serial << 16);
                    glovesUpdated = true;
                    
                    break;
                }
            }
        }
        
        if (!wearables[0]) {
            glovesUpdated = false;
            
            return;
        }
        
        C_BaseAttributableItem* glove = (C_BaseAttributableItem*)EntList->GetClientEntityFromHandle((CBaseHandle)wearables[0]);
        if (!glove) {
            glovesUpdated = false;
            
            return;
        }
        
        if (*glove->GetItemDefinitionIndex() != gloveSettings.item_definition_index) {
            *glove->GetItemDefinitionIndex() = gloveSettings.item_definition_index;
            glove->SetModelIndex(ModelInfo->GetModelIndex(updatedGlove.model));
        }
        
        if (gloveSettings.fallback_paint_kit != -1) {
            *glove->GetFallbackPaintKit() = gloveSettings.fallback_paint_kit;
        }
        
        if (gloveSettings.fallback_wear != -1) {
            *glove->GetFallbackWear() = gloveSettings.fallback_wear;
        }
        
        if (gloveSettings.fallback_seed != -1) {
            *glove->GetFallbackSeed() = gloveSettings.fallback_seed;
        }
        
        SetAbsOrigin(glove, Vector(10000.0f, 10000.0f, 10000.0f));
        
        *glove->GetFallbackStatTrak() = -1;
        *glove->GetEntityQuality() = 4;
        *glove->GetItemIDHigh() = -1;
        *glove->GetItemIDLow() = 0;
        *glove->GetAccountID() = LocalPlayerInfo.xuid_low;
        *glove->IsInitialized() = true;
        
        if (glovesUpdated) {
            glove->GetClientNetworkable()->PreDataUpdate(DATA_UPDATE_CREATED);
            glovesUpdated = false;
        }
    }
}

std::shared_ptr<Features::CGloveChanger> GloveChanger = std::make_unique<Features::CGloveChanger>();
#endif
