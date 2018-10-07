/******************************************************/
/**                                                  **/
/**      Features/GrenadeHelper.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-22                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_GrenadeHelper_h
#define Features_GrenadeHelper_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"
#include "Engine/Drawing/manager.h"

namespace Features {
    enum GrenadeType : int {
        FLASH,
        SMOKE,
        MOLOTOV,
        HEGRENADE
    };
    
    enum ThrowType {
        NORMAL,
        RUN,
        JUMP,
        WALK,
        RUNJUMP,
        THRMAX
    };
    
    class GrenadeInfo {
    public:
        GrenadeInfo(GrenadeType gType, Vector pos, QAngle angle,ThrowType tType, const char* name);
        GrenadeType gType;
        Vector pos = {0.f, 0.f, 0.f};
        QAngle angle = {0.f, 0.f, 0.f};
        ThrowType tType;
        const char* name;
    };


    class CGrenadeHelper {
    public:
        void UpdateSettings();
        GrenadeType getGrenadeType(C_BaseCombatWeapon* wpn);
        void DrawGrenadeInfo(std::shared_ptr<GrenadeInfo> info);
        void DrawAimHelp(std::shared_ptr<GrenadeInfo> info);
        void AimAssist(CUserCmd* cmd);
        Color getColor(GrenadeType type);
        void CheckForUpdate();
        void CreateMove(CUserCmd* cmd);
        void PaintTraverse();
        void SavePosition(std::string Name, QAngle ViewAngle, Vector PlayerPosition, GrenadeType GrenadeType, int throwType, std::string mapName = "");
        std::shared_ptr<GrenadeInfo> PrepareGrenadeInfo(std::shared_ptr<CSettingsManager> config, CSimpleIniA::Entry section);
        std::string GetCurrentMapConfigName();
    protected:
        bool shotLastTick = false;
        Vector lastPosition = Vector(0.f, 0.f, 0.f);
        QAngle lastViewAngle = QAngle(0.f, 0.f, 0.f);
        int positionCounter = 0;
        std::string mapName;
        C_CSPlayer* LocalPlayer = nullptr;
        C_BaseCombatWeapon* ActiveWeapon = nullptr;
    };
}

extern std::shared_ptr<Features::CGrenadeHelper> GrenadeHelper;

#endif /** !Features_GrenadeHelper_h */
