/******************************************************/
/**                                                  **/
/**      SDK/CPlayerResource.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CPlayerResource_h
#define SDK_CPlayerResource_h

#include "NetworkableReader.h"
#include "Definitions.h"
#include "Interfaces.h"
#include "Engine/Netvars/offsets.h"
#include "SDK/Color.h"
#include "SDK/ICvar.h"
#include "SDK/Vector.h"

class C_CSPlayerResource : public NetworkableReader {
public:
    const char* GetPlayerName(int index);
    int GetPing(int index);
    int GetKills(int index);
    int GetAssists(int index);
    int GetDeaths(int index);
    bool GetConnected(int index);
    EntityTeam GetTeam(int index);
    int GetPendingTeam(int index);
    bool GetAlive(int index);
    int GetHealth(int index);
    int GetPlayerC4();
    bool HasC4(int index);
    int GetMVPs(int index);
    int GetArmor(int index);
    int GetScore(int index);
    int* GetCompetitiveRanking(int index);
    int* GetCompetitiveWins(int index);
    Color GetCompTeammateColor(int index);
    const char* GetClan(int index);
    int* GetActiveCoinRank(int index);
    int* GetMusicID(int index);
    int* GetPersonaDataPublicCommendsLeader(int index);
    int* GetPersonaDataPublicCommendsTeacher(int index);
    int* GetPersonaDataPublicCommendsFriendly(int index);
    Vector GetBombsiteCenterA();
    Vector GetBombsiteCenterB();
};

extern C_CSPlayerResource** PlayerResource;

#endif /** !SDK_CPlayerResource_h */
