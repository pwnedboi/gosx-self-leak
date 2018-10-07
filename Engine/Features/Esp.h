/******************************************************/
/**                                                  **/
/**      Features/Esp.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_Esp_h
#define Features_Esp_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "Engine/Drawing/manager.h"
#include "Engine/Features/AutoWalls.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    class CEsp {
    public:
        void DrawPlayerVisuals();
        void ImDrawPlayerVisuals();
        void DrawESP(C_CSPlayer* PlayerEntity);
        void DrawCrossHair();
        void DrawFOVCircle();
        void DrawTheCircle(float x, float y, bool IsZoomedIn = false);
        void DrawScope();
        void DrawSmokeESP(C_CSPlayer* PlayerEntity);
        void DrawBoneESP(C_CSPlayer* PlayerEntity);
        void DrawWeaponESP(C_BaseEntity* Entity);
        void DrawGrenadeESP(C_BaseEntity *Entity);
        void DrawBombESP(C_BaseEntity* Entity);
        void DrawDefuseESP(C_BaseEntity* Entity);
        void DrawEntityViewLine(C_CSPlayer* Entity);

        ConVar* GetCrosshairCvar() {
            if (!ch) {
                ch = Cvar->FindVar("crosshair");
            }
            
            return ch;
        }
    public:
        bool GetBox(C_BaseEntity* PlayerEntity, float* x, float* y, float* w, float* h);
        void DrawBox(float x, float y, float w, float h, int cx, int cy, Color clrColor, bool outline = false);
        void DrawESPForPlayer(C_CSPlayer* PlayerEntity, Color clrTeam);
        void DrawESPEntity(C_BaseEntity* PlayerEntity, Color clr);
    private:
        ConVar* ch = nullptr;
        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CEsp> ESP;

#endif /** !Features_Esp_h */
