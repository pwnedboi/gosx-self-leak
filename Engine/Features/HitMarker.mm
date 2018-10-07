/******************************************************/
/**                                                  **/
/**      Features/HitMarker.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "HitMarker.h"

void Features::CHitMarker::ResetDamageData() {
    DamageData.Init(false, 0.0f);
}

void Features::CHitMarker::FireEvent(IGameEvent *event) {
    if (!Options::Drawing::hit_marker) {
        return;
    }

    std::string eventName = std::string(event->GetName());
    if (eventName != "player_hurt") {
        return;
    }

    int attacker_id = event->GetInt("attacker");
    int victim_id = event->GetInt("userid");

    int attackerUid = Engine->GetPlayerForUserID(attacker_id);
    int localplayerUid = Engine->GetLocalPlayer();
    int victimUid = Engine->GetPlayerForUserID(victim_id);

    if (attackerUid != localplayerUid) {
        return;
    }

    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        return;
    }

    C_CSPlayer* VictimEntity = (C_CSPlayer*)EntList->GetClientEntity(victimUid);
    if (!VictimEntity) {
        return;
    }

    if (LocalPlayer->GetTeamNum() == VictimEntity->GetTeamNum()) {
        return;
    }

    DamageData.DidDamage = true;
    DamageData.DamageTime = (*GlobalVars)->curtime;

#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        return;
    }
#endif
    if (Options::Drawing::hit_marker_sound && Options::Drawing::hit_marker_volume > 0.0f) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PlaySound();
        });
    }
}

void Features::CHitMarker::PaintTraverse() {
    if (!Options::Drawing::hit_marker) {
        ResetDamageData();
        return;
    }

    if (!DamageData.DidDamage) {
        ResetDamageData();
        return;
    }

    float DamageDiffTime = (*GlobalVars)->curtime - DamageData.DamageTime;
    if (DamageDiffTime > 0.675f) {
        ResetDamageData();
        return;
    }
    
    static int PositionFromMiddlePoint = Options::Drawing::crosshair_gap;
    int MiddlePointX, MiddlePointY;
    MiddlePointX = *Glob::SDLResW / 2;
    MiddlePointY = *Glob::SDLResH / 2;
    
    if (Options::Drawing::hit_marker_style == 1) {
        static int LineSize = 5;
        DrawManager->DrawLine(
            MiddlePointX - (PositionFromMiddlePoint + LineSize),
            MiddlePointY - (PositionFromMiddlePoint + LineSize),
            MiddlePointX - PositionFromMiddlePoint,
            MiddlePointY - PositionFromMiddlePoint,
            Color(255, 255, 255, 155),
            1.5f
        );
        DrawManager->DrawLine(
            MiddlePointX + (PositionFromMiddlePoint + LineSize),
            MiddlePointY - (PositionFromMiddlePoint + LineSize),
            MiddlePointX + PositionFromMiddlePoint,
            MiddlePointY - PositionFromMiddlePoint,
            Color(255, 255, 255, 155),
            1.5f
        );
        DrawManager->DrawLine(
            MiddlePointX + (PositionFromMiddlePoint + LineSize),
            MiddlePointY + (PositionFromMiddlePoint + LineSize),
            MiddlePointX + PositionFromMiddlePoint,
            MiddlePointY + PositionFromMiddlePoint,
            Color(255, 255, 255, 155),
            1.5f
        );
        DrawManager->DrawLine(
            MiddlePointX - (PositionFromMiddlePoint + LineSize),
            MiddlePointY + (PositionFromMiddlePoint + LineSize),
            MiddlePointX - PositionFromMiddlePoint,
            MiddlePointY + PositionFromMiddlePoint,
            Color(255, 255, 255, 155),
            1.5f
        );
    } else {
        std::vector<Vector2D> positions = {
            Vector2D(
                float(MiddlePointX - PositionFromMiddlePoint),
                float(MiddlePointY - PositionFromMiddlePoint)
            ), // TRI_DOWNRIGHT
            Vector2D(
                float(MiddlePointX + PositionFromMiddlePoint),
                float(MiddlePointY - PositionFromMiddlePoint)
            ), // TRI_DOWNLEFT
            Vector2D(
                float(MiddlePointX + PositionFromMiddlePoint),
                float(MiddlePointY + PositionFromMiddlePoint)
            ), // TRI_UPLEFT
            Vector2D(
                float(MiddlePointX - PositionFromMiddlePoint),
                float(MiddlePointY + PositionFromMiddlePoint)
            )  // TRI_UPRIGHT
        };

        int dir = 4;
        for (Vector2D pos : positions) {
            DrawManager->DrawTriangle(4, 4, Color(255, 255, 255), (int)pos.x, (int)pos.y, (TriangleDirections)dir, true);
            dir++;
        }
    }
}

void Features::CHitMarker::PlaySound() {
    if (!HitmarkerSoundObject) {
        if (!HitmarkerSound) {
            HitmarkerSound = [NSData dataWithBytes:(const void*)hitmarker_mp3 length:(NSUInteger)hitmarker_mp3_len];
        }
        HitmarkerSoundObject = [[NSSound alloc] initWithData:HitmarkerSound];
    }
    
    if ([HitmarkerSoundObject isPlaying]) {
        return;
    }
    
    if ([HitmarkerSoundObject volume] != Options::Drawing::hit_marker_volume) {
        [HitmarkerSoundObject setVolume:Options::Drawing::hit_marker_volume];
    }
    
    [HitmarkerSoundObject play];
}

Features::CHitMarker::~CHitMarker() {
    [HitmarkerSoundObject dealloc];
    [HitmarkerSound dealloc];
}

std::shared_ptr<Features::CHitMarker> HitMarker = std::make_unique<Features::CHitMarker>();
