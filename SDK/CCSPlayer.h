/******************************************************/
/**                                                  **/
/**      SDK/CCSPlayer.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CCSPlayer_h
#define SDK_CCSPlayer_h

#include "SDK.h"
#include "Engine/Netvars/manager.h"
#include "CCSWpnInfo.h"

#include "Engine/Fonts/cstrike_icons.h"

class C_CSPlayer;
class C_BaseWorldModel;

class C_BaseCombatWeapon : public C_BaseEntity {
public:
    C_CSPlayer* GetOwner();
    float NextPrimaryAttack();
    short EntityId();
    int GetAmmo();
    int* GetViewModelIndex();
    C_BaseWorldModel* GetWorldModel();
    WeaponCSInfo_t* GetCSWpnData();
    float GetSpread();
    float GetInaccuracy();
    C_BaseCombatWeapon* UpdateAccuracyPenalty();
    bool CanShoot();
    float GetPostponeFireReadyTime();
    std::string GetGunIcon();
};

class C_BaseAttributableItem : public C_BaseCombatWeapon {
public:
    int* GetAccountID();
    short* GetItemDefinitionIndex();
    int* GetItemIDHigh();
    int* GetItemIDLow();
    int* GetEntityQuality();
    char* GetCustomName();
    int* GetFallbackPaintKit();
    int* GetFallbackSeed();
    float* GetFallbackWear();
    int* GetFallbackStatTrak();
    bool* IsInitialized();
    int* GetIndex();
};

class C_BaseViewModel;
class C_CSPlayer : public C_BaseEntity {
public:
    static C_CSPlayer* GetLocalPlayer();
    static C_CSPlayer* GetEntity(int index);
    bool IsValidLivePlayer();
    C_BaseCombatWeapon* GetActiveWeapon();
    int* GetWearables();
    int* GetWeapons();
    CBaseHandle GetViewModelHandle();
    int GetHealth();
    int GetArmor();
    bool HasHelmet();
    bool HasDefuser();
    bool IsAlive();
    int GetTeamNum();
    int* GetFlags();
    bool IsScoped();
    float GetFlashDuration();
    bool IsFlashed();
    Vector GetViewOffset();
    Vector GetEyePos(bool predict = true);
    QAngle* GetEyeAngles();
    Vector GetViewAngle();
    Vector ViewPunch();
    Vector AimPunch();
    Vector* PtrViewPunch();
    Vector* PtrAimPunch();
    Vector GetVelocity();
    Vector GetPredictedPosition(int Hitbox, Vector &vMin, Vector &vMax);
    Vector GetPredictedPosition(Vector HitboxPosition);
    int GetShotsFired();
    int GetGlowIndex();
    bool IsImmune();
    MoveType_t GetMoveType();
    float* GetMaxFlashAlpha();
    unsigned int GetTickBase();
    bool IsDefusingBomb();
    Vector GetHitboxPosition(int Hitbox, Vector &vMin, Vector &vMax);
    Vector GetBonePosition(int BoneID);
    bool IsOnGround();
    C_CSPlayer* GetObserverTarget();
    int* GetObserverMode();
    C_CSPlayer* PVSFix();
    float* GetLowerBodyYawTarget();
    bool IsMoving();
    bool HasHeavyArmor();
    Vector WorldSpaceCenter();
    
#ifdef GOSX_THIRDPERSON
    QAngle* ThirdpersonAngle();
#endif
    
    float GetSimulationTime();
    bool* Spotted();
    const char* GetClan();
};

class C_PlantedC4 : public C_BaseEntity {
public:
    static C_PlantedC4* GetPlantedBomb();
    C_CSPlayer* GetBombDefuser();
    bool IsBombTicking();
    float GetC4Blow();
    bool IsBombDefused();
    float GetTimerLength();
};

class C_WeaponC4 : public C_BaseEntity {
public:
    static C_WeaponC4* GetBomb();
};

class C_BaseViewModel : public C_BaseEntity {
public:
    CBaseHandle GetOwner();
    int GetWeapon();
};

class C_BaseWorldModel : public C_BaseCombatWeapon {};

#endif /** !SDK_CCSPlayer_h */
