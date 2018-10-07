/******************************************************/
/**                                                  **/
/**      Netvars/offsets.cpp                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "offsets.h"

uintptr_t Offsets::DT_BaseCombatWeapon::m_flNextPrimaryAttack                   = 0x0;
uintptr_t Offsets::DT_BaseCombatWeapon::m_hOwner                                = 0x0;
uintptr_t Offsets::DT_BaseCombatWeapon::m_iClip1                                = 0x0;
uintptr_t Offsets::DT_BaseCombatWeapon::m_iViewModelIndex                       = 0x0;
uintptr_t Offsets::DT_BaseCombatWeapon::m_hWeaponWorldModel                      = 0x0;

uintptr_t Offsets::DT_BaseAttributableItem::m_iItemDefinitionIndex              = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_iAccountID                        = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_iItemIDHigh                       = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_iItemIDLow                        = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_iEntityQuality                    = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_szCustomName                      = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_bInitialized                      = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_nFallbackPaintKit                 = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_nFallbackSeed                     = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_flFallbackWear                    = 0x0;
uintptr_t Offsets::DT_BaseAttributableItem::m_nFallbackStatTrak                 = 0x0;

uintptr_t Offsets::DT_EconEntity::m_Item                                        = 0x0;

uintptr_t Offsets::DT_WeaponCSBase::m_fAccuracyPenalty                          = 0x0;
uintptr_t Offsets::DT_WeaponCSBase::m_flPostponeFireReadyTime                   = 0x0;

uintptr_t Offsets::DT_BaseCombatCharacter::m_hActiveWeapon                      = 0x0;
uintptr_t Offsets::DT_BaseCombatCharacter::m_hMyWearables                       = 0x0;
uintptr_t Offsets::DT_BaseCombatCharacter::m_hMyWeapons                         = 0x0;

uintptr_t Offsets::DT_BasePlayer::m_viewPunchAngle                              = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_aimPunchAngle                               = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_vecViewOffset                               = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_vecVelocity                                 = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_nTickBase                                   = 0x0;
uintptr_t Offsets::DT_BasePlayer::deadflag                                      = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_hViewModel                                  = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_iHealth                                     = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_lifeState                                   = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_fFlags                                      = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_hObserverTarget                             = 0x0;
uintptr_t Offsets::DT_BasePlayer::m_iObserverMode                               = 0x0;

uintptr_t Offsets::DT_CSPlayer::m_iShotsFired                                   = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_ArmorValue                                    = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bHasHelmet                                    = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bHasDefuser                                   = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bIsScoped                                     = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_flFlashDuration                               = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_angEyeAngles                                  = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bGunGameImmunity                              = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_flFlashMaxAlpha                               = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bIsDefusing                                   = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_flLowerBodyYawTarget                          = 0x0;
uintptr_t Offsets::DT_CSPlayer::m_bHasHeavyArmor                                = 0x0;

uintptr_t Offsets::DT_BaseEntity::m_vecMins                                     = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_vecMaxs                                     = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_iTeamNum                                    = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_angRotation                                 = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_nRenderMode                                 = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_nModelIndex                                 = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_vecOrigin                                   = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_CollisionGroup                              = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_flSimulationTime                            = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_Collision                                   = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_bSpotted                                    = 0x0;
uintptr_t Offsets::DT_BaseEntity::m_bIsAutoaimTarget                            = 0x0;

uintptr_t Offsets::DT_PlantedC4::m_hBombDefuser                                 = 0x0;
uintptr_t Offsets::DT_PlantedC4::m_bBombTicking                                 = 0x0;
uintptr_t Offsets::DT_PlantedC4::m_flC4Blow                                     = 0x0;
uintptr_t Offsets::DT_PlantedC4::m_bBombDefused                                 = 0x0;
uintptr_t Offsets::DT_PlantedC4::m_flTimerLength                                = 0x0;

uintptr_t Offsets::DT_BaseViewModel::m_hOwner                                   = 0x0;
uintptr_t Offsets::DT_BaseViewModel::m_hWeapon                                  = 0x0;

uintptr_t Offsets::DT_CSGameRulesProxy::m_bIsValveDS                            = 0x0;
uintptr_t Offsets::DT_CSGameRulesProxy::m_bBombPlanted                          = 0x0;
uintptr_t Offsets::DT_CSGameRulesProxy::m_bBombDropped                          = 0x0;
uintptr_t Offsets::DT_CSGameRulesProxy::m_bMapHasBombTarget                     = 0x0;

uintptr_t Offsets::DT_DynamicProp::m_bShouldGlow                                = 0x0;

uintptr_t Offsets::DT_PlayerResource::m_iPing                                   = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iKills                                  = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iAssists                                = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iDeaths                                 = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_bConnected                              = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iTeam                                   = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iPendingTeam                            = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_bAlive                                  = 0x0;
uintptr_t Offsets::DT_PlayerResource::m_iHealth                                 = 0x0;

uintptr_t Offsets::DT_CSPlayerResource::m_iPlayerC4                             = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iMVPs                                 = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iArmor                                = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iScore                                = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iCompetitiveRanking                   = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iCompetitiveWins                      = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_iCompTeammateColor                    = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_szClan                                = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_nActiveCoinRank                       = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_nMusicID                              = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsLeader      = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsTeacher     = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsFriendly    = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_bombsiteCenterA                       = 0x0;
uintptr_t Offsets::DT_CSPlayerResource::m_bombsiteCenterB                       = 0x0;

uintptr_t Offsets::DT_BaseAnimating::m_nBoneMatrix                              = 0x0;

