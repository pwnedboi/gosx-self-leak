/******************************************************/
/**                                                  **/
/**      Features/Radar.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_Radar_h
#define Features_Radar_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Drawing/manager.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    class CRadar {
    public:
        void PaintTraverse();
        void DrawGuiRadar();
        void DrawRadarPlayer(C_CSPlayer* entity, QAngle ViewAngle, bool HasBomb);
        void DrawRadarBombsites(QAngle ViewAngle);
        void InGameRadar();
        Vector2D WorldToRadar(const Vector location, const Vector origin, const QAngle angles, int width, float scale = 16.f);
    protected:
        bool bRadarHide;
        int radar_x;
        int radar_y;
        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CRadar> Radar;

#endif /** !Features_Radar_h */
