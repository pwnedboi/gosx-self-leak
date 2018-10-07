/******************************************************/
/**                                                  **/
/**      Features/AimHelper.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_AimHelper_h
#define Features_AimHelper_h

#include "SDK/SDK.h"
#include "SDK/Definitions.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"
#include "Engine/Weapons/manager.h"
#include "Engine/Features/AutoWalls.h"

class CAimHelper {
public:
    bool NeedsReset();
    int MakeHitscan(C_CSPlayer* pEntity);
    void RecoilControl(QAngle& angle, C_CSPlayer* LocalPlayer = nullptr);
    bool CanHitTarget(C_CSPlayer* TargetEntity, C_BaseCombatWeapon* weapon, CUserCmd* pCmd);
    bool HitChance(C_CSPlayer* TargetEntity, Vector targetPosition, CUserCmd* pCmd);
    bool HasTarget();
    void Reset();
    void AutoCockRevolver(CUserCmd* pCmd);
    QAngle GetPunchAngle(C_CSPlayer* LocalPlayer = nullptr);
    bool CanAttack();
    QAngle GetAimAngles(C_CSPlayer* LocalPlayer = nullptr);
    
// Faceit / SMAC safe aim
public:
    bool GetMouseData(float &m_flSensitivity, float &m_flYaw, float &m_flPitch);
    QAngle AnglesToPixels(QAngle viewAngle, QAngle aimAngle, float sensitivity, float mpitch, float myaw);
    QAngle PixelsDeltaToAnglesDelta(Vector PixelsDelta, float sensitivity, float mpitch, float myaw);
public:
    C_CSPlayer* LocalPlayer = nullptr;
    C_CSPlayer* m_lockedEntity = nullptr;
    Hitboxes m_lockedBone = Hitboxes::HITBOX_NONE;
    
    QAngle OldPunch = QAngle(0.0f, 0.0f, 0.0f);
    QAngle CurrentAngle = QAngle(-1.0f, -1.0f, -1.0f);
    QAngle CurrentRawAngle = QAngle(-1.0f, -1.0f, -1.0f);
    
    ConVar* sensitivity = nullptr;
    ConVar* m_yaw = nullptr;
    ConVar* m_pitch = nullptr;
};

#endif /** !Features_AimHelper_h */
