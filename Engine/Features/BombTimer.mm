/******************************************************/
/**                                                  **/
/**      Features/BombTimer.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-22                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "BombTimer.h"

void Features::CBombTimer::PaintTraverse() {
    if ((BombDisplayType)Options::Drawing::bomb_timer == DISPLAY_NONE) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }

    C_PlantedC4* bomb = C_PlantedC4::GetPlantedBomb();
    if (!bomb || !bomb->IsBombTicking()) {
        return;
    }

    BombTimerTime = bomb->GetC4Blow() - ((*GlobalVars)->interval_per_tick * LocalPlayer->GetTickBase());
    switch ((BombDisplayType)Options::Drawing::bomb_timer) {
        case DISPLAY_BOTH:
            DrawOnScreenTimer(bomb);
            DrawWorldModelTimer(bomb);
        break;
        case DISPLAY_ONSCREEN:
            DrawOnScreenTimer(bomb);
        break;
        case DISPLAY_INWORLD:
            DrawWorldModelTimer(bomb);
        break;
        default:
        break;
    }
}

void Features::CBombTimer::DrawOnScreenTimer(C_PlantedC4 *bomb) {
    if (!bomb || !bomb->IsBombTicking()) {
        return;
    }

    float TimerLength = bomb->GetTimerLength();
    float BombTimer = bomb->GetC4Blow() - ((*GlobalVars)->interval_per_tick * LocalPlayer->GetTickBase());

    float TimerPercent = BombTimer / TimerLength * 100.0f;
    float BombOnScreenSize = *Glob::SDLResW / 100 * TimerPercent;

    float HalfScreenWidth = *Glob::SDLResW / 2;
    float HalfBombOnScreenSize = BombOnScreenSize / 2;
    float OnScreenLeftPadding = HalfScreenWidth - HalfBombOnScreenSize;

    DrawManager->DrawRect((int)OnScreenLeftPadding, 0, (int)BombOnScreenSize, 6, GetBombColor(bomb));
}

void Features::CBombTimer::DrawWorldModelTimer(C_PlantedC4 *bomb) {
    if (!bomb || !bomb->IsBombTicking()) {
        return;
    }

    Vector BombPosition, BombMins, BombMaxs;
    BombPosition = *bomb->GetOrigin();
    BombPosition.y -= 3.0f;

    Vector BombScreenPosition;
    if (!Utils::WorldToScreen(BombPosition, BombScreenPosition)) {
        return;
    }

    if (BombTimerTime > 0.01f && !bomb->IsBombDefused()) {
        char buffer[64];
        sprintf(buffer, "Bomb: %.1f", BombTimerTime);
        DrawManager->DrawString(GUI::Fonts::Section, (int)BombScreenPosition.x, (int)BombScreenPosition.y, FONTFLAG_NONE, GetBombColor(bomb), buffer, true);
    }
}

Color Features::CBombTimer::GetBombColor(C_PlantedC4* bomb) {
    bool IsBombDefusing = false;
    C_CSPlayer* BombDefuser = bomb->GetBombDefuser();
    if (BombDefuser && BombDefuser->IsDefusingBomb()) {
        IsBombDefusing = true;
    }
    Color BombColor = Color(200, 0, 0);
    if (LocalPlayer->GetTeamNum() == TEAM_CT) {
        bool WithDefuseKit = LocalPlayer->HasDefuser();
        if (BombTimerTime >= 5.5f && WithDefuseKit) {
            BombColor = Color(0, 200, 0);
        } else if (BombTimerTime >= 10.5f  && !WithDefuseKit) {
            BombColor = Color(0, 200, 0);
        }
    } else if (LocalPlayer->GetTeamNum() == TEAM_T) {
        BombColor = Color(0, 200, 0);
    }

    if (IsBombDefusing) {
        BombColor = Color(0, 200, 0);
    }

    return BombColor;
}

std::shared_ptr<Features::CBombTimer> BombTimer = std::make_unique<Features::CBombTimer>();
