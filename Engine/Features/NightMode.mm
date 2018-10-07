/******************************************************/
/**                                                  **/
/**      Features/NightMode.mm                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Features/NightMode.h"

bool Features::CNightMode::IsDone() {
    return done;
}

void Features::CNightMode::SetIsDone(bool value) {
    done = value;
}

void Features::CNightMode::Render() {
    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        return;
    }
    
    if (!this->sv_skyname) {
        this->sv_skyname = Cvar->FindVar("sv_skyname");
        this->sv_skyname_backup = std::string(this->sv_skyname->strString);
    }
    
    if (std::string(this->sv_skyname->strString) != this->sv_skyname_backup && std::string(this->sv_skyname->strString) != "sky_csgo_night02") {
        this->sv_skyname_backup = std::string(this->sv_skyname->strString);
    }
    
    if (!this->r_DrawSpecificStaticProp) {
        this->r_DrawSpecificStaticProp = Cvar->FindVar("r_DrawSpecificStaticProp");
        this->r_DrawSpecificStaticProp_backup = this->r_DrawSpecificStaticProp->nValue;
    }

    if (Options::Improvements::night_mode
#ifdef GOSX_STREAM_PROOF
        && !StreamProof->Active()
#endif
    ) {
        if (!this->IsDone()) {
            this->TurnOn();
        }
    } else {
#ifdef GOSX_STREAM_PROOF
        if (StreamProof->Active()) {
            this->SetIsDone(true);
        }
#endif
        
        if (this->IsDone()) {
            this->TurnOff();
        }
    }
}

void Features::CNightMode::TurnOn() {
    this->r_DrawSpecificStaticProp->SetValue(1);
    Utils::SetSkybox("sky_csgo_night02");
    
    this->WalkMaterialList(true);
    
    this->SetIsDone(true);
}

void Features::CNightMode::TurnOff() {
    this->r_DrawSpecificStaticProp->SetValue(r_DrawSpecificStaticProp_backup);
    Utils::SetSkybox(sv_skyname_backup);
    
    this->WalkMaterialList(false);
    
    this->SetIsDone(false);
}

void Features::CNightMode::WalkMaterialList(bool state) {
    for (
         MaterialHandle_t i = MaterialSystem->FirstMaterial();
         i != MaterialSystem->InvalidMaterial();
         i = MaterialSystem->NextMaterial(i)
    ) {
        IMaterial *material = MaterialSystem->GetMaterial(i);
        
        if (!material) {
            continue;
        }
        
        const char* group = material->GetTextureGroupName();
        const char* name = material->GetName();
        
        bool isInWorldTextureGroup = strstr(group, "World textures");
        if (isInWorldTextureGroup || strstr(group, "StaticProp") || strstr(name, "models/props/de_dust/palace_pillars")) {
            float value = 1.0f;
            if (state) {
                value = 0.30f;
                if (isInWorldTextureGroup) {
                    value = 0.10f;
                }
            }
            
            material->ColorModulate(value, value, value);
        }
        
        if (strstr(name, "models/props/de_dust/palace_bigdome") || strstr(group, "Particle textures")) {
            material->SetMaterialVarFlag(MATERIAL_VAR_NO_DRAW, !state);
        }
    }
}

std::shared_ptr<Features::CNightMode> NightMode = std::make_unique<Features::CNightMode>();
