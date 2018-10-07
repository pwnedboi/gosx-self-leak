/******************************************************/
/**                                                  **/
/**      Features/Radar.cpp                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Radar.h"

void Features::CRadar::PaintTraverse() {
    if (!Options::Radar::enabled || !Engine->IsInGame()) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || LocalPlayer->IsDormant() || !LocalPlayer->IsAlive()) {
        return;
    }

#ifdef GOSX_STREAM_PROOF
    if (Options::Radar::style == 0 && !StreamProof->Active()) {
        InGameRadar();
        
        return;
    }
#else
    if (Options::Radar::style == 0) {
        InGameRadar();
        
        return;
    }
#endif
    
    QAngle Angle;
    Engine->GetViewAngles(Angle);

    DrawGuiRadar();
    for (int i = 1; i <= Engine->GetMaxClients(); i++) {
        C_CSPlayer* PlayerEntity = (C_CSPlayer*)EntList->GetClientEntity(i);
        if (!PlayerEntity || PlayerEntity->IsDormant() || !PlayerEntity->IsAlive()) {
            continue;
        }

        if (PlayerEntity == LocalPlayer) {
            continue;
        }

        DrawRadarPlayer(PlayerEntity, Angle, (*PlayerResource)->HasC4(i));
    }
    DrawRadarBombsites(Angle);

    C_WeaponC4* c4 = C_WeaponC4::GetBomb();
    if (c4 && (*GameRules)->IsBombDropped()) {
        Vector2D BombPosition = WorldToRadar(*c4->GetOrigin(), *LocalPlayer->GetOrigin(), Angle, Options::Radar::size, Options::Radar::zoom);
        DrawManager->DrawRect((int)((BombPosition.x) - 3), (int)((BombPosition.y) - 3), 6, 6, Options::Glow::color_planted_bomb);
    }
}

void Features::CRadar::DrawGuiRadar() {
    if (!Options::Radar::enabled || !Engine->IsInGame()) {
        return;
    }

    radar_x = Options::Radar::pos_x;
    radar_y = Options::Radar::pos_y;

    if (Options::Radar::enabled && bRadarHide) {
        bRadarHide = false;
    } else if (!Options::Radar::enabled && !bRadarHide) {
        bRadarHide = true;
    }

    DrawManager->DrawRect(radar_x, radar_y, Options::Radar::size, Options::Radar::size, Color(0, 0, 0, 100));
    DrawManager->DrawRect(radar_x, Options::Radar::size / 2 + radar_y, Options::Radar::size, 1 , Color(255, 255, 255, 45));
    DrawManager->DrawRect(Options::Radar::size / 2 + radar_x, radar_y, 1, Options::Radar::size, Color(255, 255, 255, 45));

    if ((*PlayerResource)->HasC4(Engine->GetLocalPlayer())) {
        DrawManager->DrawString(GUI::Fonts::CstrikeIconsBig, radar_x + 10, radar_y + Options::Radar::size + 10, FONTFLAG_NONE, Color(255, 255, 255), ICON_CSGO_C4, false);
    }
}

void Features::CRadar::DrawRadarPlayer(C_CSPlayer* PlayerEntity, QAngle ViewAngle, bool HasBomb) {
    if (!Options::Radar::enabled || !Engine->IsInGame()) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    Color RadarPlayerColor = Color(0, 0, 0);

    int IndicatorSizeW = 6, IndicatorSizeH = 4;
    TriangleDirections dir = TriangleDirections::TRI_DOWN;
    if (PlayerEntity->GetTeamNum() == TEAM_T) {
        RadarPlayerColor = Options::Colors::color_t;
        dir = TriangleDirections::TRI_UP;
        if (HasBomb) {
            RadarPlayerColor = Color(210, 0, 0);
            IndicatorSizeW = 8;
            IndicatorSizeH = 6;
        }
    } else if (PlayerEntity->GetTeamNum() == TEAM_CT) {
        RadarPlayerColor = Options::Colors::color_ct;
    } else {
        return;
    }

    if (PlayerEntity->IsImmune()) {
        RadarPlayerColor.SetA(100);
    }

    Vector2D RadarPoint = WorldToRadar(*PlayerEntity->GetOrigin(), *LocalPlayer->GetOrigin(), ViewAngle, Options::Radar::size, Options::Radar::zoom);
    if (RadarPoint.x < 1 || RadarPoint.y < 1) {
        return;
    }

    DrawManager->DrawTriangle(IndicatorSizeW, IndicatorSizeH, RadarPlayerColor, (int)RadarPoint.x, (int)RadarPoint.y, dir, true);
}

void Features::CRadar::DrawRadarBombsites(QAngle ViewAngle) {
    if (!Options::Radar::enabled || !Engine->IsInGame()) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    if (!(*GameRules)->IsBombDefuseMap()) {
        return;
    }

    Vector BombsiteA = (*PlayerResource)->GetBombsiteCenterA();
    Vector BombsiteB = (*PlayerResource)->GetBombsiteCenterB();

    Vector2D RadarPointA = WorldToRadar(BombsiteA, *LocalPlayer->GetOrigin(), ViewAngle, Options::Radar::size, Options::Radar::zoom);
    if (RadarPointA.x > 0 && RadarPointA.y > 0) {
        DrawManager->DrawString(GUI::Fonts::Section, (int)RadarPointA.x, (int)RadarPointA.y, FONTFLAG_NONE, Options::Glow::color_planted_bomb, true, "A");
    }

    Vector2D RadarPointB = WorldToRadar(BombsiteB, *LocalPlayer->GetOrigin(), ViewAngle, Options::Radar::size, Options::Radar::zoom);
    if (RadarPointB.x > 0 && RadarPointB.y > 0) {
        DrawManager->DrawString(GUI::Fonts::Section, (int)RadarPointB.x, (int)RadarPointB.y, FONTFLAG_NONE, Options::Glow::color_planted_bomb, true, "B");
    }
}

Vector2D Features::CRadar::WorldToRadar(const Vector location, const Vector origin, const QAngle angles, int width, float scale) {
    float x_diff = location.x - origin.x;
    float y_diff = location.y - origin.y;

    int iRadarRadius = width;

    float flOffset = atanf(y_diff / x_diff);
    flOffset *= 180;
    flOffset /= M_PI;

    if ((x_diff < 0) && (y_diff >= 0)) {
        flOffset = 180 + flOffset;
    } else if ((x_diff < 0) && (y_diff < 0)) {
        flOffset = 180 + flOffset;
    } else if ((x_diff >= 0) && (y_diff < 0)) {
        flOffset = 360 + flOffset;
    }

    y_diff = -1 * (sqrtf((x_diff * x_diff) + (y_diff * y_diff)));
    x_diff = 0;

    flOffset = angles.y - flOffset;

    flOffset *= M_PI;
    flOffset /= 180;

    float xnew_diff = x_diff * cosf(flOffset) - y_diff * sinf(flOffset);
    float ynew_diff = x_diff * sinf(flOffset) + y_diff * cosf(flOffset);

    xnew_diff /= scale;
    ynew_diff /= scale;

    xnew_diff = (iRadarRadius / 2) + (int)xnew_diff;
    ynew_diff = (iRadarRadius / 2) + (int)ynew_diff;

    if (xnew_diff > iRadarRadius) {
        xnew_diff = iRadarRadius - 4;
    } else if (xnew_diff < 4) {
        xnew_diff = 4;
    }

    if (ynew_diff> iRadarRadius) {
        ynew_diff = iRadarRadius;
    } else if (ynew_diff < 4) {
        ynew_diff = 0;
    }

    return Vector2D(Options::Radar::pos_x + xnew_diff, Options::Radar::pos_y + ynew_diff);
}

void Features::CRadar::InGameRadar() {
    for (int i = 1; i <= Engine->GetMaxClients(); i++) {
        C_CSPlayer* PlayerEntity = (C_CSPlayer*)EntList->GetClientEntity(i);
        if (!PlayerEntity || PlayerEntity->IsDormant() || !PlayerEntity->IsAlive()) {
            continue;
        }
        
        if (PlayerEntity == LocalPlayer) {
            continue;
        }
        
        if (!(*PlayerEntity->Spotted())) {
            *PlayerEntity->Spotted() = true;
        }
    }
}

std::shared_ptr<Features::CRadar> Radar = std::make_unique<Features::CRadar>();
