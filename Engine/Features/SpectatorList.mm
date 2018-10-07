/******************************************************/
/**                                                  **/
/**      Features/SpectatorList.cpp                  **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SpectatorList.h"

void Features::CSpectatorList::PaintTraverse() {
    if (!Options::Drawing::list_enabled) {
        return;
    }

    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }

    int specs = 0;
    int modes = 0;
    spectatorList.clear();
    for (int i = 1; i < Engine->GetMaxClients(); i++) {
        C_CSPlayer* SpectatorEntity = (C_CSPlayer*)EntList->GetClientEntity(i);
        if (
            !SpectatorEntity ||
            SpectatorEntity->GetHealth() > 0 ||
            SpectatorEntity == LocalPlayer ||
            SpectatorEntity->GetObserverTarget() != LocalPlayer
        ) {
            if (spectatorList.find(i) != spectatorList.end()) {
                spectatorList.erase(i);
            }
            
            continue;
        }

        player_info_t pInfo;
        if (!Engine->GetPlayerInfo(SpectatorEntity->EntIndex(), &pInfo)) {
            if (spectatorList.find(i) != spectatorList.end()) {
                spectatorList.erase(i);
            }
            
            continue;
        }

        if (pInfo.ishltv) {
            if (spectatorList.find(i) != spectatorList.end()) {
                spectatorList.erase(i);
            }
            
            continue;
        }

        specs++;

        std::string mode;
        switch (*SpectatorEntity->GetObserverMode()) {
            case OBS_MODE_IN_EYE:
                mode.append("1st Person");
                break;
            case OBS_MODE_CHASE:
                mode.append("3rd Person");
                break;
            case OBS_MODE_ROAMING:
                mode.append("No Clip");
                break;
            case OBS_MODE_DEATHCAM:
                mode.append("Deathcam");
                break;
            case OBS_MODE_FREEZECAM:
                mode.append("Freezecam");
                break;
            case OBS_MODE_FIXED:
                mode.append("Fixed");
                break;
            default:
                break;
        }

        modes++;

        spectatorList[i] = {pInfo.name, mode, SpectatorEntity};
    }

    if (spectatorList.size() <= 0) {
        return;
    }

    int maxNameWidth = 0;
    int maxNameHeight = 0;
    int maxModeWidth = 0;
    for (auto item : spectatorList) {
        Vector2D nameSize = DrawManager->GetTextSize(item.second.name.c_str());
        if (nameSize.x > maxNameWidth) {
            maxNameWidth = (int)nameSize.x;
        }

        if (nameSize.y > maxNameHeight) {
            maxNameHeight = (int)nameSize.y;
        }

        Vector2D modeSize = DrawManager->GetTextSize(item.second.mode.c_str());
        if (modeSize.x > maxModeWidth) {
            maxModeWidth = (int)modeSize.x;
        }
    }

    maxNameWidth += 10;
    maxModeWidth += 10;

    int item_height = maxNameHeight;
    int listLength = (int)spectatorList.size();
    int listContentHeight = 0;
    listContentHeight += ((item_height + 1) * listLength);
    int listX = (int)Options::Drawing::list_x;
    int listY = (int)Options::Drawing::list_y;

    Vector2D headingSize = DrawManager->GetTextSize("Spectators");

    std::string addS = "";
    if (specs == 1) {
        addS.append("s");
    }

    DrawManager->DrawString(nullptr, (int)(listX + 1), (int)(listY + 1), FONTFLAG_NONE, Color(255, 255, 255, 255), false, "%i Spectator%s", specs, addS.c_str());
    listY += (int)headingSize.y + 2;
    DrawManager->DrawRect(listX, listY, (maxNameWidth + 1 + maxModeWidth + 1), listContentHeight, Color(0, 0, 0, 55));

    listY += 1;
    listX += 1;

    for (auto item : spectatorList) {
        DrawManager->DrawRect(listX, listY, maxNameWidth, item_height, Color(0, 0, 0, 55));
        DrawManager->DrawRect((listX + (maxNameWidth + 1)), listY, maxModeWidth, item_height, Color(0, 0, 0, 55));

        DrawManager->DrawString(GUI::Fonts::Label, (int)(listX + 1), (int)(listY + 1), FONTFLAG_NONE, Color(255, 255, 255, 255), false, "%s", item.second.name.c_str());
        DrawManager->DrawString(GUI::Fonts::Label, (int)(listX + (maxNameWidth + 1)), (int)(listY + 1), FONTFLAG_NONE, Color(255, 255, 255, 255), false, "%s", item.second.mode.c_str());

        listY += (item_height + 1);
    }
}

std::shared_ptr<Features::CSpectatorList> SpecList = std::make_unique<Features::CSpectatorList>();
