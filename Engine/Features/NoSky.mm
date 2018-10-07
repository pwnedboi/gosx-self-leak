/******************************************************/
/**                                                  **/
/**      Features/NoSky.cpp                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "NoSky.h"

void Features::CNoSky::FrameStageNotify(ClientFrameStage_t stage) {
    if (!Engine->IsInGame() && skyboxMaterials.size() > 0) {
        for (const auto& it: skyboxMaterials) {
            IMaterial* mat = MaterialSystem->GetMaterial(it.first);

            if (!mat) {
                continue;
            }

            mat->GetColorModulation(&r1, &g1, &b1);
            a1 = mat->GetAlphaModulation();

            mat->ColorModulate(r1, g1, b1);
            mat->AlphaModulate(a1);
        }
        
        skyboxMaterials.clear();
        skyboxMaterials2.clear();
    }

    if (stage != ClientFrameStage_t::FRAME_NET_UPDATE_POSTDATAUPDATE_END) {
        return;
    }
    
    for (
        MaterialHandle_t i = MaterialSystem->FirstMaterial();
        i != MaterialSystem->InvalidMaterial();
        i = MaterialSystem->NextMaterial(i)
    ) {
        IMaterial* mat = MaterialSystem->GetMaterial(i);

        if (!mat || strcmp(mat->GetTextureGroupName(), TEXTURE_GROUP_SKYBOX) != 0) {
            continue;
        }

        if (skyboxMaterials.find(i) == skyboxMaterials.end()) {
            mat->GetColorModulation(&r1, &g1, &b1);
            a1 = mat->GetAlphaModulation();
            skyboxMaterials.emplace(i, Color((int)(r1 * 255), (int)(g1 * 255), (int)(b1 * 255), (int)(a1 * 255)));
            skyboxMaterials2.emplace(i, Color((int)(r1 * 255), (int)(g1 * 255), (int)(b1 * 255), (int)(a1 * 255)));
        }

        bool NoSkyActive = Options::Improvements::no_sky;
        Color color = NoSkyActive ? Options::Colors::nosky_color : skyboxMaterials2.find(i)->second;

        if (skyboxMaterials.at(i) != color) {
            mat->ColorModulate(((float)color.r() / 255.0f), ((float)color.g() / 255.0f), ((float)color.b() / 255.0f));
            skyboxMaterials.at(i) = color;
        }
    }
}

std::shared_ptr<Features::CNoSky> NoSky = std::make_unique<Features::CNoSky>();
