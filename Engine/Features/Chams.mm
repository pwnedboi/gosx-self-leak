/******************************************************/
/**                                                  **/
/**      Features/Chams.cpp                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Chams.h"

IMaterial* Features::CChams::CreateMaterial(std::string filename, std::string texture, bool ignorez, bool flat, bool gluelook, bool wireframed) {
    std::string materialType = flat ? "UnlitGeneric" : "VertexLitGeneric";

    std::stringstream ss;
    ss << "\"" + materialType + "\"" << std::endl;
    ss << "{" << std::endl;
    ss << "\t\"$basetexture\" \"" + texture + "\"" << std::endl;
    if (gluelook) {
        ss << "\t\"$envmap\" \"env_cubemap\"" << std::endl;
        ss << "\t\"$normalmapalphaenvmapmask\" 1" << std::endl;
        ss << "\t\"$envmapcontrast\" 1" << std::endl;
    } else {
        ss << "\t\"$envmap\" \"\"" << std::endl;
    }
    ss << "\t\"$model\" \"1\"" << std::endl;
    ss << "\t\"$nocull\" \"0\"" << std::endl;
    ss << "\t\"$ambientocclusion\" \"1\"" << std::endl;
    ss << "\t\"$selfillum\" \"1\"" << std::endl;
    ss << "\t\"$halflambert\" \"1\"" << std::endl;
    ss << "\t\"$nofog\" \"1\"" << std::endl;
    ss << "\t\"$phong\" \"1\"" << std::endl;
    ss << "\t\"$phongboost\" \"1\"" << std::endl;
    ss << "\t\"$reflectivity\" \"[1 1 1]\"" << std::endl;
    ss << "\t\"$ignorez\" \"" + std::to_string(ignorez) + "\"" << std::endl;
    ss << "\t\"$znearer\" \"0\"" << std::endl;
    ss << "\t\"$wireframe\" \"" + std::to_string(wireframed) + "\"" << std::endl;
    ss << "}" << std::endl;
    
    std::string materialName = filename + "_" + std::to_string(Utils::RandomInt(10, 100000));
    KeyValues* keyValues = new KeyValues(materialName.c_str());
    
    Utils::InitKeyValues(keyValues, materialType.c_str());
    Utils::LoadFromBuffer(keyValues, materialName.c_str(), ss.str().c_str(), nullptr, NULL, nullptr);
    
    return MaterialSystem->CreateMaterial(materialName.c_str(), keyValues);
}

bool Features::CChams::CanApply(const ModelRenderInfo_t &oriPInfo) {
    if (!Options::Main::enabled || !Options::Chams::enabled) {
        return false;
    }
    
    if (!oriPInfo.pModel) {
        return false;
    }
    
    this->LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!this->LocalPlayer) {
        return false;
    }
    
    return true;
}

void Features::CChams::ApplyPlayerChams(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld) {
    if (!this->CanApply(oriPInfo)) {
        return;
    }
    
    if (!Options::Chams::players) {
        return;
    }
    
    C_CSPlayer* pModelPlayer = (C_CSPlayer*)EntList->GetClientEntity(oriPInfo.entity_index);
    if (!pModelPlayer) {
        return;
    }
    
    bool IsAlive = pModelPlayer->IsAlive();
    
    if (
        (Options::Chams::allies && pModelPlayer->GetTeamNum() == LocalPlayer->GetTeamNum()) ||
        (Options::Chams::enemies && pModelPlayer->GetTeamNum() != LocalPlayer->GetTeamNum())
    ) {
        
        Color ChamsVisibleColor = Color(0, 0, 0, 0);
        Color ChamsColor = Color(0, 0, 0, 0);
        
        if (pModelPlayer->GetTeamNum() == EntityTeam::TEAM_T) {
            ChamsColor = Options::Colors::color_t;
            ChamsVisibleColor = Options::Colors::color_t_visible;
        } else if (pModelPlayer->GetTeamNum() == EntityTeam::TEAM_CT) {
            ChamsColor = Options::Colors::color_ct;
            ChamsVisibleColor = Options::Colors::color_ct_visible;
        }
        
        if (!IsAlive && Options::Chams::show_dead_chams) {
            ChamsColor = Options::Colors::color_player_dead;
            ChamsVisibleColor = Options::Colors::color_player_dead;
        }
        
        bool IsImmune = IsAlive && pModelPlayer->IsImmune();
        if (
            IsAlive ||
            (Options::Chams::show_dead_chams && !IsAlive)
        ) {
            ChamMaterialType_t MaterialType = (ChamMaterialType_t)(Options::Chams::show_dead_chams && !IsAlive ? Options::Chams::deadchams_type : Options::Chams::chams_type);
            this->ApplyMaterial(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld, MaterialType, ChamsColor, ChamsVisibleColor, IsImmune);
        }
    }
}

void Features::CChams::ApplyWeaponChams(void* thisptr, IMatRenderContext *oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld) {
    if (!this->CanApply(oriPInfo)) {
        return;
    }
    
    if (!Options::Chams::weapons) {
        return;
    }
    
    C_BaseCombatWeapon* pModelEntity = (C_BaseCombatWeapon*)EntList->GetClientEntity(oriPInfo.entity_index);
    if (!pModelEntity) {
        return;
    }
    
    if (this->LocalPlayer->GetActiveWeapon() == pModelEntity) {
        if (
            WeaponManager::IsScopeWeapon(pModelEntity->EntityId()) &&
            !WeaponManager::IsSniper(pModelEntity->EntityId())
        ) {
            if (this->LocalPlayer->IsScoped()) {
                return;
            }
        }
    }
    
    this->ApplyMaterial(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld, (ChamMaterialType_t)Options::Chams::weapon_type, Options::Colors::color_weapon, Options::Colors::color_weapon_visible, false);
}

void Features::CChams::ApplyArmChams(void* thisptr, IMatRenderContext *oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld) {
    if (!this->CanApply(oriPInfo)) {
        return;
    }
    
    if (!Options::Chams::arms) {
        return;
    }
    
    this->ApplyMaterial(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld, (ChamMaterialType_t)Options::Chams::arms_type, Options::Colors::color_arms_visible, Options::Colors::color_arms_visible, false);
}

/*void CChams::ApplyWorldChams(IMatRenderContext *oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld) {
 if (!CanApply(oriPInfo)) {
 return;
 }
 
 if (!Options::Chams::players) {
 return;
 }
 
 if (Options::Chams::wallhack) {
 ForceMaterial(visible_tex, Options::Colors::color_player_dead);
 ModelRender->DrawModelExecute(oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
 }
 
 ForceMaterial(hidden_tex, Options::Colors::color_player_dead);
 ModelRender->DrawModelExecute(oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
 }*/

void Features::CChams::DrawModelExecute(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld) {
    if (!this->CanApply(oriPInfo)) {
        return;
    }
    
    std::string szModelName = ModelInfo->GetModelName(oriPInfo.pModel);
    if (szModelName.find("models/player/") != std::string::npos) {
        this->ApplyPlayerChams(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
    }
    
    if (szModelName.find("models/weapons/") != std::string::npos && szModelName.find("arms") == std::string::npos) {
        this->ApplyWeaponChams(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
    }
    
    if (szModelName.find("models/weapons/v_models/arms/") != std::string::npos) {
        this->ApplyArmChams(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
    }
    
    /*if (
     szModelName.find("models/weapons/w_defuser") != std::string::npos ||
     szModelName.find("models/weapons/w_knife") != std::string::npos
     ) {
     ApplyWorldChams(oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
     }*/
}

void Features::CChams::ForceMaterial(IMaterial* material, Color color, bool immune) {
    if (!material) {
        return;
    }
    
    float alpha = 1.f;
    if (immune) {
        alpha = 0.5f;
    }
    
    material->AlphaModulate(alpha);
    material->ColorModulate((float)color.r() / 255.0f, (float)color.g() / 255.0f, (float)color.b() / 255.0f);
    
    ModelRender->ForcedMaterialOverride(material);
}

IMaterial* Features::CChams::GetMaterial(ChamMaterialType_t type) {
    switch (type) {
        case ChamMaterialType_t::CMAT_TYPE_HID_TEX:
            if (!this->hidden_tex) {
                this->hidden_tex = this->CreateMaterial(
                    "chamsmat_hid_tex",
                    "VGUI/white_additive",
                    /* ignorez */ false,
                    /* flat */ false,
                    /* gluelook */ false,
                    /* wireframed */ false
                );
            }
            
            return this->hidden_tex;
            break;
        case ChamMaterialType_t::CMAT_TYPE_VIS_TEX:
            if (!this->visible_tex) {
                this->visible_tex = this->CreateMaterial(
                    "chamsmat_vis_tex",
                    "VGUI/white_additive",
                    /* ignorez */ true,
                    /* flat */ false,
                    /* gluelook */ false,
                    /* wireframed */ false
                );
            }
            
            return this->visible_tex;
            break;
        case ChamMaterialType_t::CMAT_TYPE_HID_FLAT:
            if (!this->hidden_flat) {
                this->hidden_flat = this->CreateMaterial(
                    "chamsmat_hid_flat",
                    "VGUI/white_additive",
                    /* ignorez */ false,
                    /* flat */ true,
                    /* gluelook */ false,
                    /* wireframed */ false
                );
            }
            
            return this->hidden_flat;
            break;
        case ChamMaterialType_t::CMAT_TYPE_VIS_FLAT:
            if (!this->visible_flat) {
                this->visible_flat = this->CreateMaterial(
                    "chamsmat_vis_flat",
                    "VGUI/white_additive",
                    /* ignorez */ true,
                    /* flat */ true,
                    /* gluelook */ false,
                    /* wireframed */ false
                );
            }
            
            return this->visible_flat;
            break;
        case ChamMaterialType_t::CMAT_TYPE_HID_TEX_WIRE:
            if (!this->hidden_tex_wire) {
                this->hidden_tex_wire = this->CreateMaterial(
                    "chamsmat_hid_tex_wire",
                    "VGUI/white_additive",
                    /* ignorez */ false,
                    /* flat */ false,
                    /* gluelook */ false,
                    /* wireframed */ true
                );
            }
        
            return this->hidden_tex_wire;
            break;
        case ChamMaterialType_t::CMAT_TYPE_VIS_TEX_WIRE:
            if (!this->visible_tex_wire) {
                this->visible_tex_wire = this->CreateMaterial(
                    "chamsmat_vis_tex_wire",
                    "VGUI/white_additive",
                    /* ignorez */ true,
                    /* flat */ false,
                    /* gluelook */ false,
                    /* wireframed */ true
                );
            }
            
            return this->visible_tex_wire;
            break;
        case ChamMaterialType_t::CMAT_TYPE_HID_FLAT_WIRE:
            if (!hidden_flat_wire) {
                hidden_flat_wire = this->CreateMaterial(
                    "chamsmat_hid_flat_wire",
                    "VGUI/white_additive",
                    /* ignorez */ false,
                    /* flat */ true,
                    /* gluelook */ false,
                    /* wireframed */ true
                );
            }
            
            return this->hidden_flat_wire;
            break;
        case ChamMaterialType_t::CMAT_TYPE_VIS_FLAT_WIRE:
            if (!this->visible_flat_wire) {
                this->visible_flat_wire = this->CreateMaterial(
                    "chamsmat_vis_flat_wire",
                    "VGUI/white_additive",
                    /* ignorez */ true,
                    /* flat */ true,
                    /* gluelook */ false,
                    /* wireframed */ true
                );
            }
            
            return this->visible_flat_wire;
            break;
            
        default:
            return nullptr;
            break;
    }
}

bool Features::CChams::IsWallhackMaterial(ChamMaterialType_t type) {
    switch (type) {
        case ChamMaterialType_t::CMAT_TYPE_VIS_TEX:
        case ChamMaterialType_t::CMAT_TYPE_VIS_FLAT:
        case ChamMaterialType_t::CMAT_TYPE_VIS_TEX_WIRE:
        case ChamMaterialType_t::CMAT_TYPE_VIS_FLAT_WIRE:
            return true;
            break;
        default:
            return false;
            break;
    }
}

void Features::CChams::ApplyMaterial(
    void* thisptr,
    IMatRenderContext* oriContext,
    const DrawModelState_t &oriState,
    const ModelRenderInfo_t &oriPInfo,
    matrix3x4_t *oriPCustomBoneToWorld,
    ChamMaterialType_t type,
    Color ChamsColor,
    Color ChamsVisibleColor,
    bool IsImmune
) {
    bool HasWallhack = this->IsWallhackMaterial(type);
    if (HasWallhack) {
        IMaterial* whMat = this->GetMaterial(type);
        if (whMat != nullptr) {
            this->ForceMaterial(whMat, ChamsColor, IsImmune);
            oDrawModelExecute(thisptr, oriContext, oriState, oriPInfo, oriPCustomBoneToWorld);
        }
    }
    
    IMaterial* visMat = this->GetMaterial((ChamMaterialType_t)((int)type - (HasWallhack ? 1 : 0)));
    if (visMat != nullptr) {
        this->ForceMaterial(visMat, ChamsVisibleColor, IsImmune);
    }
}

std::shared_ptr<Features::CChams> Chams = std::make_unique<Features::CChams>();
