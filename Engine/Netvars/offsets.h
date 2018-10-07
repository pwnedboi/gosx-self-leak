/******************************************************/
/**                                                  **/
/**      Netvars/offsets.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Netvars_offsets_h
#define Netvars_offsets_h

#include <memory>

namespace Offsets {
    namespace DT_BaseCombatWeapon {
        extern uintptr_t m_flNextPrimaryAttack;
        extern uintptr_t m_hOwner;
        extern uintptr_t m_iClip1;
        extern uintptr_t m_iViewModelIndex;
        extern uintptr_t m_hWeaponWorldModel;
    };
    
    namespace DT_BaseAttributableItem {
        extern uintptr_t m_iItemDefinitionIndex;
        extern uintptr_t m_iAccountID;
        extern uintptr_t m_iItemIDHigh;
        extern uintptr_t m_iItemIDLow;
        extern uintptr_t m_iEntityQuality;
        extern uintptr_t m_szCustomName;
        extern uintptr_t m_bInitialized;
        extern uintptr_t m_nFallbackPaintKit;
        extern uintptr_t m_nFallbackSeed;
        extern uintptr_t m_flFallbackWear;
        extern uintptr_t m_nFallbackStatTrak;
    };
    
    namespace DT_EconEntity {
        extern uintptr_t m_Item;
    };
    
    namespace DT_WeaponCSBase {
        extern uintptr_t m_fAccuracyPenalty;
        extern uintptr_t m_flPostponeFireReadyTime;
    };
    
    namespace DT_BaseCombatCharacter {
        extern uintptr_t m_hActiveWeapon;
        extern uintptr_t m_hMyWearables;
        extern uintptr_t m_hMyWeapons;
    };
    
    namespace DT_BasePlayer {
        extern uintptr_t m_vecViewOffset;
        extern uintptr_t m_viewPunchAngle;
        extern uintptr_t m_aimPunchAngle;
        extern uintptr_t m_vecVelocity;
        extern uintptr_t m_nTickBase;
        extern uintptr_t deadflag;
        extern uintptr_t m_hViewModel;
        extern uintptr_t m_iHealth;
        extern uintptr_t m_lifeState;
        extern uintptr_t m_fFlags;
        extern uintptr_t m_hObserverTarget;
        extern uintptr_t m_iObserverMode;
    };
    
    namespace DT_CSPlayer {
        extern uintptr_t m_iShotsFired;
        extern uintptr_t m_ArmorValue;
        extern uintptr_t m_bHasHelmet;
        extern uintptr_t m_bHasDefuser;
        extern uintptr_t m_bIsScoped;
        extern uintptr_t m_flFlashDuration;
        extern uintptr_t m_angEyeAngles;
        extern uintptr_t m_bGunGameImmunity;
        extern uintptr_t m_flFlashMaxAlpha;
        extern uintptr_t m_bIsDefusing;
        extern uintptr_t m_flLowerBodyYawTarget;
        extern uintptr_t m_bHasHeavyArmor;
    };
    
    namespace DT_BaseEntity {
        extern uintptr_t m_vecMins;
        extern uintptr_t m_vecMaxs;
        extern uintptr_t m_iTeamNum;
        extern uintptr_t m_angRotation;
        extern uintptr_t m_nRenderMode;
        extern uintptr_t m_nModelIndex;
        extern uintptr_t m_vecOrigin;
        extern uintptr_t m_CollisionGroup;
        extern uintptr_t m_flSimulationTime;
        extern uintptr_t m_Collision;
        extern uintptr_t m_bSpotted;
        extern uintptr_t m_bIsAutoaimTarget;
    };
    
    namespace DT_PlantedC4 {
        extern uintptr_t m_hBombDefuser;
        extern uintptr_t m_bBombTicking;
        extern uintptr_t m_flC4Blow;
        extern uintptr_t m_bBombDefused;
        extern uintptr_t m_flTimerLength;
    };
    
    namespace DT_BaseViewModel {
        extern uintptr_t m_hOwner;
        extern uintptr_t m_hWeapon;
    };
    
    namespace DT_CSGameRulesProxy {
        extern uintptr_t m_bIsValveDS;
        extern uintptr_t m_bBombPlanted;
        extern uintptr_t m_bBombDropped;
        extern uintptr_t m_bMapHasBombTarget;
    };
    
    namespace DT_DynamicProp {
        extern uintptr_t m_bShouldGlow;
    };
    
    namespace DT_PlayerResource {
        extern uintptr_t m_iPing;
        extern uintptr_t m_iKills;
        extern uintptr_t m_iAssists;
        extern uintptr_t m_iDeaths;
        extern uintptr_t m_bConnected;
        extern uintptr_t m_iTeam;
        extern uintptr_t m_iPendingTeam;
        extern uintptr_t m_bAlive;
        extern uintptr_t m_iHealth;
    };
    
    namespace DT_CSPlayerResource {
        extern uintptr_t m_iPlayerC4;
        extern uintptr_t m_iMVPs;
        extern uintptr_t m_iArmor;
        extern uintptr_t m_iScore;
        extern uintptr_t m_iCompetitiveRanking;
        extern uintptr_t m_iCompetitiveWins;
        extern uintptr_t m_iCompTeammateColor;
        extern uintptr_t m_szClan;
        extern uintptr_t m_nActiveCoinRank;
        extern uintptr_t m_nMusicID;
        extern uintptr_t m_nPersonaDataPublicCommendsLeader;
        extern uintptr_t m_nPersonaDataPublicCommendsTeacher;
        extern uintptr_t m_nPersonaDataPublicCommendsFriendly;
        extern uintptr_t m_bombsiteCenterA;
        extern uintptr_t m_bombsiteCenterB;
    };
    
    namespace DT_BaseAnimating {
        extern uintptr_t m_nBoneMatrix;
    }
};

#endif /** !Netvars_offsets_h */

