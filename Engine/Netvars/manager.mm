/******************************************************/
/**                                                  **/
/**      Netvars/manager.cpp                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"
#include "SDK/SDK.h"

std::vector<RecvTable*> NetvarManager::GetTables()
{
    std::vector<RecvTable*> tables;
    
    ClientClass* clientClass = Client->GetAllClasses();
    if (!clientClass) {
        return std::vector<RecvTable*>();
    }
    
    while (clientClass) {
        RecvTable* recvTable = clientClass->m_pRecvTable;
        tables.emplace_back(recvTable);
        
        clientClass = clientClass->m_pNext;
    }
    
    return tables;
}

RecvTable* NetvarManager::GetTable(std::vector<RecvTable*> tables, std::string tableName) {
    if (tables.empty()) {
        return NULL;
    }
    
    for (unsigned long i = 0; i < tables.size(); i++) {
        RecvTable* table = tables[i];
        
        if (!table) {
            continue;
        }
        
        if (strcasecmp(table->m_pNetTableName, tableName.c_str()) == 0) {
            return table;
        }
    }
    
    return NULL;
}

int NetvarManager::GetOffset(std::vector<RecvTable*> tables, std::string tableName, std::string propName) {
    int offset = GetProp(tables, tableName, propName);
    if (!offset) {
        return 0;
    }
    return offset;
}


int NetvarManager::GetProp(std::vector<RecvTable*> tables, std::string tableName, std::string propName, RecvProp** prop) {
    RecvTable* recvTable = GetTable(tables, tableName);
    if (!recvTable) {
        return 0;
    }
    
    int offset = GetProp(tables, recvTable, propName, prop);
    if (!offset) {
        return 0;
    }
    
    return offset;
}

int NetvarManager::GetProp(std::vector<RecvTable*> tables, RecvTable* recvTable, std::string propName, RecvProp** prop) {
    int extraOffset = 0;
    
#ifdef DUMP_NETVARS
    std::string dump = DumpTable(recvTable);
    FILE* h = fopen("netvars.txt", "a+");
    fputs(dump.c_str(), h);
    fclose(h);
    Tools::ConsoleLogger::Default(std::string(recvTable->m_pNetTableName) + " dumped to \"netvars.txt\" successfully!");
#endif
    
    for (int i = 0; i < recvTable->m_nProps; ++i) {
        RecvProp* recvProp = &recvTable->m_pProps[i];
        RecvTable* child = recvProp->m_pDataTable;
        
        if (child && (child->m_nProps > 0)) {
            int tmp = GetProp(tables, child, propName, prop);
            if (tmp) {
                extraOffset += (recvProp->m_Offset + tmp);
            }
        }
        
        if (strcasecmp(recvProp->m_pVarName, propName.c_str())) {
            continue;
        }
        
        if (prop) {
            *prop = recvProp;
        }
        
        return (recvProp->m_Offset + extraOffset);
    }
    
    return extraOffset;
}

std::string NetvarManager::DumpTable(RecvTable* table, int depth) {
    std::string pre("");
    std::stringstream ss;
    
    for (int i = 0; i < depth; i++) {
        pre.append("\t");
    }
    
    ss << pre << table->m_pNetTableName << "\n";
    
    for (int i = 0; i < table->m_nProps; i++) {
        RecvProp* prop = &table->m_pProps[i];
        if (!prop) {
            continue;
        }
        
        std::string varName(prop->m_pVarName);
        
        if (varName.find("baseclass") == 0 || varName.find("0") == 0 || varName.find("1") == 0 || varName.find("2") == 0) {
            continue;
        }
        
        ss << pre << "\t" << varName << " [0x" << std::hex << prop->m_Offset << "]\n";
        
        if (prop->m_pDataTable) {
            ss << DumpTable(prop->m_pDataTable, depth + 1);
        }
    }
    
    return ss.str();
}

uintptr_t NetvarManager::HookProp(std::string tableName, std::string propName, RecvVarProxyFn function) {
    NetvarManager::GetProp(NetvarManager::GetTables(), tableName, propName, &HookedRecvProp);
    
    if (!HookedRecvProp) {
        return 0;
    }
    
    OriginalRecvProp = HookedRecvProp->m_ProxyFn;
    HookedRecvProp->m_ProxyFn = function;
    return (uintptr_t)OriginalRecvProp;
}

void NetvarManager::SetStaticOffsets() {
    std::vector<RecvTable*> tables = NetvarManager::GetTables();
    
    Offsets::DT_BaseCombatWeapon::m_flNextPrimaryAttack = GetOffset(tables, "DT_BaseCombatWeapon", "m_flNextPrimaryAttack");
    Offsets::DT_BaseCombatWeapon::m_hOwner = GetOffset(tables, "DT_BaseCombatWeapon", "m_hOwner");
    Offsets::DT_BaseCombatWeapon::m_iClip1 = GetOffset(tables, "DT_BaseCombatWeapon", "m_iClip1");
    Offsets::DT_BaseCombatWeapon::m_iViewModelIndex = GetOffset(tables, "DT_BaseCombatWeapon", "m_iViewModelIndex");
    Offsets::DT_BaseCombatWeapon::m_hWeaponWorldModel = GetOffset(tables, "DT_BaseCombatWeapon", "m_hWeaponWorldModel");
    
    
    Offsets::DT_BaseAttributableItem::m_iItemDefinitionIndex = GetOffset(tables, "DT_BaseAttributableItem", "m_iItemDefinitionIndex");
    Offsets::DT_BaseAttributableItem::m_iAccountID = GetOffset(tables, "DT_BaseAttributableItem", "m_iAccountID");
    Offsets::DT_BaseAttributableItem::m_iItemIDHigh = GetOffset(tables, "DT_BaseAttributableItem", "m_iItemIDHigh");
    Offsets::DT_BaseAttributableItem::m_iItemIDLow = GetOffset(tables, "DT_BaseAttributableItem", "m_iItemIDLow");
    Offsets::DT_BaseAttributableItem::m_iEntityQuality = GetOffset(tables, "DT_BaseAttributableItem", "m_iEntityQuality");
    Offsets::DT_BaseAttributableItem::m_szCustomName = GetOffset(tables, "DT_BaseAttributableItem", "m_szCustomName");
    Offsets::DT_BaseAttributableItem::m_bInitialized = GetOffset(tables, "DT_BaseAttributableItem", "m_bInitialized");
    Offsets::DT_BaseAttributableItem::m_nFallbackPaintKit = GetOffset(tables, "DT_BaseAttributableItem", "m_nFallbackPaintKit");
    Offsets::DT_BaseAttributableItem::m_nFallbackSeed = GetOffset(tables, "DT_BaseAttributableItem", "m_nFallbackSeed");
    Offsets::DT_BaseAttributableItem::m_flFallbackWear = GetOffset(tables, "DT_BaseAttributableItem", "m_flFallbackWear");
    Offsets::DT_BaseAttributableItem::m_nFallbackStatTrak = GetOffset(tables, "DT_BaseAttributableItem", "m_nFallbackStatTrak");
    
    Offsets::DT_EconEntity::m_Item = GetOffset(tables, "DT_EconEntity", "m_Item");
    
    Offsets::DT_WeaponCSBase::m_fAccuracyPenalty = GetOffset(tables, "DT_WeaponCSBase", "m_fAccuracyPenalty");
    Offsets::DT_WeaponCSBase::m_flPostponeFireReadyTime = GetOffset(tables, "DT_WeaponCSBase", "m_flPostponeFireReadyTime");
    
    Offsets::DT_BaseCombatCharacter::m_hActiveWeapon = GetOffset(tables, "DT_BaseCombatCharacter", "m_hActiveWeapon");
    Offsets::DT_BaseCombatCharacter::m_hMyWearables = GetOffset(tables, "DT_BaseCombatCharacter", "m_hMyWearables");
    Offsets::DT_BaseCombatCharacter::m_hMyWeapons = GetOffset(tables, "DT_BaseCombatCharacter", "m_hMyWeapons") / 2;
    
    Offsets::DT_BasePlayer::m_viewPunchAngle = GetOffset(tables, "DT_BasePlayer", "m_viewPunchAngle");
    Offsets::DT_BasePlayer::m_aimPunchAngle = GetOffset(tables, "DT_BasePlayer", "m_aimPunchAngle");
    Offsets::DT_BasePlayer::m_vecViewOffset = GetOffset(tables, "DT_BasePlayer", "m_vecViewOffset[0]");
    Offsets::DT_BasePlayer::m_vecVelocity = GetOffset(tables, "DT_BasePlayer", "m_vecVelocity[0]");
    Offsets::DT_BasePlayer::m_nTickBase = GetOffset(tables, "DT_BasePlayer", "m_nTickBase");
    Offsets::DT_BasePlayer::deadflag = GetOffset(tables, "DT_BasePlayer", "deadflag");
    Offsets::DT_BasePlayer::m_hViewModel = GetOffset(tables, "DT_BasePlayer", "m_hViewModel[0]");
    Offsets::DT_BasePlayer::m_iHealth = GetOffset(tables, "DT_BasePlayer", "m_iHealth");
    Offsets::DT_BasePlayer::m_lifeState = GetOffset(tables, "DT_BasePlayer", "m_lifeState");
    Offsets::DT_BasePlayer::m_fFlags = GetOffset(tables, "DT_BasePlayer", "m_fFlags");
    Offsets::DT_BasePlayer::m_hObserverTarget = GetOffset(tables, "DT_BasePlayer", "m_hObserverTarget");
    Offsets::DT_BasePlayer::m_iObserverMode = GetOffset(tables, "DT_BasePlayer", "m_iObserverMode");
    
    Offsets::DT_CSPlayer::m_iShotsFired = GetOffset(tables, "DT_CSPlayer", "m_iShotsFired");
    Offsets::DT_CSPlayer::m_ArmorValue = GetOffset(tables, "DT_CSPlayer", "m_ArmorValue");
    Offsets::DT_CSPlayer::m_bHasHelmet = GetOffset(tables, "DT_CSPlayer", "m_bHasHelmet");
    Offsets::DT_CSPlayer::m_bHasDefuser = GetOffset(tables, "DT_CSPlayer", "m_bHasDefuser");
    Offsets::DT_CSPlayer::m_bIsScoped = GetOffset(tables, "DT_CSPlayer", "m_bIsScoped");
    Offsets::DT_CSPlayer::m_flFlashDuration = GetOffset(tables, "DT_CSPlayer", "m_flFlashDuration");
    Offsets::DT_CSPlayer::m_angEyeAngles = GetOffset(tables, "DT_CSPlayer", "m_angEyeAngles[0]");
    Offsets::DT_CSPlayer::m_bGunGameImmunity = GetOffset(tables, "DT_CSPlayer", "m_bGunGameImmunity");
    Offsets::DT_CSPlayer::m_flFlashMaxAlpha = GetOffset(tables, "DT_CSPlayer", "m_flFlashMaxAlpha");
    Offsets::DT_CSPlayer::m_bIsDefusing = GetOffset(tables, "DT_CSPlayer", "m_bIsDefusing");
    Offsets::DT_CSPlayer::m_flLowerBodyYawTarget = GetOffset(tables, "DT_CSPlayer", "m_flLowerBodyYawTarget");
    Offsets::DT_CSPlayer::m_bHasHeavyArmor = GetOffset(tables, "DT_CSPlayer", "m_bHasHeavyArmor");
    
    Offsets::DT_BaseEntity::m_vecMins = GetOffset(tables, "DT_BaseEntity", "m_vecMins");
    Offsets::DT_BaseEntity::m_vecMaxs = GetOffset(tables, "DT_BaseEntity", "m_vecMaxs");
    Offsets::DT_BaseEntity::m_iTeamNum = GetOffset(tables, "DT_BaseEntity", "m_iTeamNum");
    Offsets::DT_BaseEntity::m_angRotation = GetOffset(tables, "DT_BaseEntity", "m_angRotation");
    Offsets::DT_BaseEntity::m_nRenderMode = GetOffset(tables, "DT_BaseEntity", "m_nRenderMode");
    Offsets::DT_BaseEntity::m_nModelIndex = GetOffset(tables, "DT_BaseEntity", "m_nModelIndex");
    Offsets::DT_BaseEntity::m_vecOrigin = GetOffset(tables, "DT_BaseEntity", "m_vecOrigin");
    Offsets::DT_BaseEntity::m_CollisionGroup = GetOffset(tables, "DT_BaseEntity", "m_CollisionGroup");
    Offsets::DT_BaseEntity::m_flSimulationTime = GetOffset(tables, "DT_BaseEntity", "m_flSimulationTime");
    Offsets::DT_BaseEntity::m_Collision = GetOffset(tables, "DT_BaseEntity", "m_Collision");
    Offsets::DT_BaseEntity::m_bSpotted = GetOffset(tables, "DT_BaseEntity", "m_bSpotted");
    Offsets::DT_BaseEntity::m_bIsAutoaimTarget = GetOffset(tables, "DT_BaseEntity", "m_bIsAutoaimTarget");
    
    Offsets::DT_PlantedC4::m_hBombDefuser = GetOffset(tables, "DT_PlantedC4", "m_hBombDefuser");
    Offsets::DT_PlantedC4::m_bBombTicking = GetOffset(tables, "DT_PlantedC4", "m_bBombTicking");
    Offsets::DT_PlantedC4::m_flC4Blow = GetOffset(tables, "DT_PlantedC4", "m_flC4Blow");
    Offsets::DT_PlantedC4::m_bBombDefused = GetOffset(tables, "DT_PlantedC4", "m_bBombDefused");
    Offsets::DT_PlantedC4::m_flTimerLength = GetOffset(tables, "DT_PlantedC4", "m_flTimerLength");
    
    Offsets::DT_BaseViewModel::m_hOwner = GetOffset(tables, "DT_BaseViewModel", "m_hOwner");
    Offsets::DT_BaseViewModel::m_hWeapon = GetOffset(tables, "DT_BaseViewModel", "m_hWeapon");
    
    Offsets::DT_CSGameRulesProxy::m_bIsValveDS = GetOffset(tables, "DT_CSGameRulesProxy", "m_bIsValveDS");
    Offsets::DT_CSGameRulesProxy::m_bBombPlanted = GetOffset(tables, "DT_CSGameRulesProxy", "m_bBombPlanted");
    Offsets::DT_CSGameRulesProxy::m_bBombDropped = GetOffset(tables, "DT_CSGameRulesProxy", "m_bBombDropped");
    Offsets::DT_CSGameRulesProxy::m_bMapHasBombTarget = GetOffset(tables, "DT_CSGameRulesProxy", "m_bMapHasBombTarget");
    
    Offsets::DT_DynamicProp::m_bShouldGlow = GetOffset(tables, "DT_DynamicProp", "m_bShouldGlow");
    
    Offsets::DT_PlayerResource::m_iPing = GetOffset(tables, "DT_PlayerResource", "m_iPing");
    Offsets::DT_PlayerResource::m_iKills = GetOffset(tables, "DT_PlayerResource", "m_iKills");
    Offsets::DT_PlayerResource::m_iAssists = GetOffset(tables, "DT_PlayerResource", "m_iAssists");
    Offsets::DT_PlayerResource::m_iDeaths = GetOffset(tables, "DT_PlayerResource", "m_iDeaths");
    Offsets::DT_PlayerResource::m_bConnected = GetOffset(tables, "DT_PlayerResource", "m_bConnected");
    Offsets::DT_PlayerResource::m_iTeam = GetOffset(tables, "DT_PlayerResource", "m_iTeam");
    Offsets::DT_PlayerResource::m_iPendingTeam = GetOffset(tables, "DT_PlayerResource", "m_iPendingTeam");
    Offsets::DT_PlayerResource::m_bAlive = GetOffset(tables, "DT_PlayerResource", "m_bAlive");
    Offsets::DT_PlayerResource::m_iHealth = GetOffset(tables, "DT_PlayerResource", "m_iHealth");
    
    Offsets::DT_CSPlayerResource::m_iPlayerC4 = GetOffset(tables, "DT_CSPlayerResource", "m_iPlayerC4");
    Offsets::DT_CSPlayerResource::m_iMVPs = GetOffset(tables, "DT_CSPlayerResource", "m_iMVPs");
    Offsets::DT_CSPlayerResource::m_iArmor = GetOffset(tables, "DT_CSPlayerResource", "m_iArmor");
    Offsets::DT_CSPlayerResource::m_iScore = GetOffset(tables, "DT_CSPlayerResource", "m_iScore");
    Offsets::DT_CSPlayerResource::m_iCompetitiveRanking = GetOffset(tables, "DT_CSPlayerResource", "m_iCompetitiveRanking");
    Offsets::DT_CSPlayerResource::m_iCompetitiveWins = GetOffset(tables, "DT_CSPlayerResource", "m_iCompetitiveWins");
    Offsets::DT_CSPlayerResource::m_iCompTeammateColor = GetOffset(tables, "DT_CSPlayerResource", "m_iCompTeammateColor");
    Offsets::DT_CSPlayerResource::m_szClan = GetOffset(tables, "DT_CSPlayerResource", "m_szClan");
    Offsets::DT_CSPlayerResource::m_nActiveCoinRank = GetOffset(tables, "DT_CSPlayerResource", "m_nActiveCoinRank");
    Offsets::DT_CSPlayerResource::m_nMusicID = GetOffset(tables, "DT_CSPlayerResource", "m_nMusicID");
    Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsLeader = GetOffset(tables, "DT_CSPlayerResource", "m_nPersonaDataPublicCommendsLeader");
//    Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsTeacher = GetOffset(tables, "DT_CSPlayerResource", "m_nPersonaDataPublicCommendsTeacher");
    Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsFriendly = GetOffset(tables, "DT_CSPlayerResource", "m_nPersonaDataPublicCommendsFriendly");
    Offsets::DT_CSPlayerResource::m_bombsiteCenterA = GetOffset(tables, "DT_CSPlayerResource", "m_bombsiteCenterA");
    Offsets::DT_CSPlayerResource::m_bombsiteCenterB = GetOffset(tables, "DT_CSPlayerResource", "m_bombsiteCenterB");
    
    Offsets::DT_BaseAnimating::m_nBoneMatrix = GetOffset(tables, "DT_BaseAnimating", "m_nForceBone") + 0x2C;
}

