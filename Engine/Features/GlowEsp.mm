/******************************************************/
/**                                                  **/
/**      Features/GlowEsp.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "GlowEsp.h"
#include "SDK/CCSPlayer.h"

void Features::CGlowESP::DoPostScreenSpaceEffects() {
    if (!Options::Glow::enabled) {
        return;
    }
    
    ConVar* deathcam = Cvar->FindVar("spec_replay_autostart");
    if (deathcam && deathcam->GetInt() == 1) {
        deathcam->SetValue(0);
    }

    if (Options::Glow::glow_extra) {
        this->ApplyExtraGlow();
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }
    
    IMaterial* glowMaterial = MaterialSystem->FindMaterial("dev/glow_color", TEXTURE_GROUP_OTHER, true);
    ModelRender->ForcedMaterialOverride(glowMaterial);

    for (int i = 0; i < GlowObjectManager->m_entries.Count(); i++) {
        GlowObjectDefinition_t& glow_object = GlowObjectManager->m_entries[i];

        if (!glow_object.m_pEntity || glow_object.m_pEntity == LocalPlayer || glow_object.m_pEntity->IsDormant()) {
            continue;
        }
        
        if (glow_object.IsUnused()) {
            continue;
        }
        
        ClientClass* entityClientClass = glow_object.m_pEntity->GetClientClass();
        if (!entityClientClass) {
            continue;
        }

        Color color = Color(0, 0, 0);
        bool should_glow = true;
        bool goOn = false;
        if (Options::Glow::glow_weapon && glow_object.m_pEntity->IsWeapon()) {
            color = Options::Colors::color_weapon_visible;
        } else if (Options::Glow::glow_bomb && glow_object.m_pEntity->IsBomb()) {
            color = _bombColor(entityClientClass->m_ClassID, &goOn);
        } else if (Options::Glow::glow_grenades && glow_object.m_pEntity->IsGrenade()) {
            color = _grenadeColor(glow_object.m_pEntity, &goOn);
            if (goOn) {
                continue;
            }
        } else if (Options::Glow::glow_extra && glow_object.m_pEntity->IsDefuseKit()) {
            if (LocalPlayer->GetTeamNum() == EntityTeam::TEAM_T || LocalPlayer->HasDefuser()) {
                continue;
            }
            
            color = Options::Glow::color_extra;
        } else if (Options::Glow::glow_player && glow_object.m_pEntity->IsPlayer()) {
            C_CSPlayer* EntityPlayer = (C_CSPlayer*)glow_object.m_pEntity;
            if (!EntityPlayer || !EntityPlayer->IsValidLivePlayer()) {
                continue;
            }

            int teamNum = EntityPlayer->GetTeamNum();
            if (!Options::Glow::glow_team && teamNum == LocalPlayer->GetTeamNum()) {
                continue;
            }
            
            if (teamNum != TEAM_T && teamNum != TEAM_CT) {
                continue;
            }

            bool EntityVisible = Utils::IsVisible(LocalPlayer, EntityPlayer, HITBOX_BODY);
            color = teamNum == EntityTeam::TEAM_T ? (!EntityVisible ? Options::Colors::color_t_glow : Options::Colors::color_t_visible_glow) : (!EntityVisible ? Options::Colors::color_ct_glow : Options::Colors::color_ct_visible_glow);
        } else {
              continue;
        }
        
        float alphaValue = color.GetA();
        should_glow = should_glow && alphaValue > 0;

        glow_object.m_flGlowColor.x = (float)((float)color.r() / 255.0f);
        glow_object.m_flGlowColor.y = (float)((float)color.g() / 255.0f);
        glow_object.m_flGlowColor.z = (float)((float)color.b() / 255.0f);
        glow_object.m_flGlowAlpha = should_glow ? (float)((float)color.a() / 255.0f) : 0.0f;
        glow_object.m_flBloomAmount = 1.0f;
        glow_object.m_bRenderWhenOccluded = should_glow;
        glow_object.m_bRenderWhenUnoccluded = !should_glow;
        glow_object.m_bFullBloomRender = false;
    }
}

Color Features::CGlowESP::_grenadeColor(C_BaseEntity *entity, bool* goOn) {
    C_BaseCombatWeapon* pWeapon = (C_BaseCombatWeapon*)entity;
    if (pWeapon) {
        switch (pWeapon->EntityId()) {
            case weapon_hegrenade:
                return Options::GrenadeHelper::color_grenade_he;
                break;
            case weapon_incgrenade:
            case weapon_molotov:
                return Options::GrenadeHelper::color_grenade_inc;
                break;
            case weapon_smokegrenade:
                return Options::GrenadeHelper::color_grenade_smoke;
                break;
            case weapon_flashbang:
            case weapon_decoy:
                return Options::GrenadeHelper::color_grenade_flash;
                break;
            default:
                *goOn = true;
                return Options::Glow::color_grenades;
                break;
        }
    }
    
    return Color();
}

void Features::CGlowESP::ApplyExtraGlow() {
    for (int i = Engine->GetMaxClients(); i < EntList->GetHighestEntityIndex(); i++) {
        C_BaseEntity* entity = (C_BaseEntity*)EntList->GetClientEntity(i);

        if (Engine->IsInGame() && entity && entity->GetClientClass()->m_ClassID == EClassIds::CEconEntity) {
            if (!GlowObjectManager->HasGlowEffect(entity)) {
                int array_index = GlowObjectManager->RegisterGlowObject(entity);

                if (array_index != -1) {
                    custom_glow_entities[i] = array_index;
                }
            }
        } else {
            auto iterator = std::find_if(
                custom_glow_entities.begin(),
                custom_glow_entities.end(),
                [&] (const std::pair<int, int>& p) {
                    return p.first == i;
                }
            );

            if (iterator != custom_glow_entities.end()) {
                GlowObjectManager->UnregisterGlowObject(iterator->second);
                custom_glow_entities.erase(iterator);
            }
        }
    }
}

Color Features::CGlowESP::_bombColor(int classId, bool* goOn) {
    if (classId == EClassIds::CPlantedC4 && (*GameRules)->IsBombPlanted()) {
        return Options::Glow::color_planted_bomb;
    } else {
        return Options::Glow::color_dropped_bomb;
    }
}

std::shared_ptr<Features::CGlowESP> Glow = std::make_unique<Features::CGlowESP>();
