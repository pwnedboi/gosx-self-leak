/******************************************************/
/**                                                  **/
/**      SDK/CPlayerResource.mm                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CPlayerResource.h"

const char* C_CSPlayerResource::GetPlayerName(int index) {
    typedef const char* (* oGetPlayerName)(void*, int);
    return Interfaces::Function<oGetPlayerName>(this, 251)(this, index);
}

int C_CSPlayerResource::GetPing(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iPing + (index * 0x4));
}

int C_CSPlayerResource::GetKills(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iKills + (index * 0x4));
}

int C_CSPlayerResource::GetAssists(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iAssists + (index * 0x4));
}

int C_CSPlayerResource::GetDeaths(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iDeaths + (index * 0x4));
}

bool C_CSPlayerResource::GetConnected(int index) {
    return GetFieldValue<bool>(Offsets::DT_PlayerResource::m_bConnected + index);
}

EntityTeam C_CSPlayerResource::GetTeam(int index) {
    return GetFieldValue<EntityTeam>(Offsets::DT_PlayerResource::m_iTeam + (index * 0x4));
}

int C_CSPlayerResource::GetPendingTeam(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iPendingTeam + (index * 0x4));
}

bool C_CSPlayerResource::GetAlive(int index) {
    return GetFieldValue<bool>(Offsets::DT_PlayerResource::m_bAlive + index);
}

int C_CSPlayerResource::GetHealth(int index) {
    return GetFieldValue<int>(Offsets::DT_PlayerResource::m_iHealth + (index * 0x4));
}

int C_CSPlayerResource::GetPlayerC4() {
    return GetFieldValue<int>(Offsets::DT_CSPlayerResource::m_iPlayerC4);
}

bool C_CSPlayerResource::HasC4(int index) {
    return GetFieldValue<int>(Offsets::DT_CSPlayerResource::m_iPlayerC4) == index;
}

int C_CSPlayerResource::GetMVPs(int index) {
    return GetFieldValue<int>(Offsets::DT_CSPlayerResource::m_iMVPs + (index * 0x4));
}

int C_CSPlayerResource::GetArmor(int index) {
    return GetFieldValue<int>(Offsets::DT_CSPlayerResource::m_iArmor + (index * 0x4));
}

int C_CSPlayerResource::GetScore(int index) {
    return GetFieldValue<int>(Offsets::DT_CSPlayerResource::m_iScore + (index * 0x4));
}

int* C_CSPlayerResource::GetCompetitiveRanking(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_iCompetitiveRanking + (index * 0x4));
}

int* C_CSPlayerResource::GetCompetitiveWins(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_iCompetitiveWins + (index * 0x4));
}

Color C_CSPlayerResource::GetCompTeammateColor(int index) {
    ColorRGBA temporaryColor = GetFieldValue<ColorRGBA>(Offsets::DT_CSPlayerResource::m_iCompTeammateColor + (index * 0x4));
    return Color(
        (int)((float)temporaryColor.RGBA[0] * 255.0f),
        (int)((float)temporaryColor.RGBA[1] * 255.0f),
        (int)((float)temporaryColor.RGBA[2] * 255.0f),
        (int)((float)temporaryColor.RGBA[3] * 255.0f)
    );
}

const char* C_CSPlayerResource::GetClan(int index) {
    return GetFieldValue<const char*>(Offsets::DT_CSPlayerResource::m_szClan + (index * 0x10));
}

int* C_CSPlayerResource::GetActiveCoinRank(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_nActiveCoinRank + (index * 0x4));
}

int* C_CSPlayerResource::GetMusicID(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_nMusicID + (index * 0x4));
}

int* C_CSPlayerResource::GetPersonaDataPublicCommendsLeader(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsLeader + (index * 0x4));
}

int* C_CSPlayerResource::GetPersonaDataPublicCommendsTeacher(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsTeacher + (index * 0x4));
}

int* C_CSPlayerResource::GetPersonaDataPublicCommendsFriendly(int index) {
    return GetFieldPointer<int>(Offsets::DT_CSPlayerResource::m_nPersonaDataPublicCommendsFriendly + (index * 0x4));
}

Vector C_CSPlayerResource::GetBombsiteCenterA() {
    return GetFieldValue<Vector>(Offsets::DT_CSPlayerResource::m_bombsiteCenterA);
}

Vector C_CSPlayerResource::GetBombsiteCenterB() {
    return GetFieldValue<Vector>(Offsets::DT_CSPlayerResource::m_bombsiteCenterB);
}
