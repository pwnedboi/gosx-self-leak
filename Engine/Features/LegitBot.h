/******************************************************/
/**                                                  **/
/**      Features/LegitBot.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_LegitBot_h
#define Features_LegitBot_h

#include "AimHelper.h"
#include "Engine/Features/EnginePrediction.h"
#include "Engine/Features/KeyBind.h"

namespace Features {
    class CLegitBot : public CAimHelper, KeyBind {
    public:
        CLegitBot();
        int GetBestBone(C_CSPlayer* TargetEntity, CUserCmd* pCmd);
        C_CSPlayer* FindTarget(CUserCmd* pCmd);
        void AimTarget(CUserCmd* pCmd);
        void CreateMove(CUserCmd* pCmd);
        static void Salt(float& smooth);
        static void SmoothAngle(QAngle& angle, QAngle CurrentAngle, CUserCmd* pCmd, bool forceConstantSpeed = false);
        void DelayedShot(C_BaseCombatWeapon* weapon, CUserCmd* pCmd);
        bool IsLowFovSilentAim();
        QAngle GetDeltaPixels(QAngle viewAngle, QAngle &AimAngle, const float m_flSensitivity, const float m_flYaw, const float m_flPitch);
    private:
        C_BaseCombatWeapon* currentWeapon = nullptr;
        C_CSPlayer* PreviousTarget = nullptr;
    };
}

extern std::shared_ptr<Features::CLegitBot> Aim;


#endif /** !Features_LegitBot_h */
