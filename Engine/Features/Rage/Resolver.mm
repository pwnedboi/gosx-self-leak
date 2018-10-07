/******************************************************/
/**                                                  **/
/**      Rage/Resolver.mm                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Resolver.h"

#ifdef GOSX_RAGE_MODE

std::array<Features::CResolveInfo, 32> Features::CResolver::m_arrInfos;
std::vector<int64_t> Features::CResolver::Players;
std::vector<std::pair<C_CSPlayer*, QAngle>> player_data;

std::map<int, const char*> Features::CResolver::GetModeList() {
    std::map<int, const char*> select = {
        {(int)ResolverMode::OFF, "0"},
        {(int)ResolverMode::FORCE, "1"},
        {(int)ResolverMode::DELTA, "2"},
        {(int)ResolverMode::STEADY, "3"},
        {(int)ResolverMode::TICKMODULO, "4"},
        {(int)ResolverMode::POSEPARAM, "5"},
        {(int)ResolverMode::ALL, "6"}
    };

    return select;
}

std::map<int, const char*> Features::CResolver::GetModeValues() {
    std::map<int, const char*> select = {
        {(int)ResolverMode::OFF, "Off"},
        {(int)ResolverMode::FORCE, "Force"},
        {(int)ResolverMode::DELTA, "Delta"},
        {(int)ResolverMode::STEADY, "Steady"},
        {(int)ResolverMode::TICKMODULO, "Modulo"},
        {(int)ResolverMode::POSEPARAM, "Pose Param"},
        {(int)ResolverMode::ALL, "All"}
    };

    return select;
}

void Features::CResolver::Resolve(C_CSPlayer* ent) {
    auto cur = m_arrInfos.at(ent->EntIndex()).m_sRecords;

    ResolverMode mode = (ResolverMode)Options::Rage::resolver_mode;

    switch (mode) {
        case ResolverMode::FORCE: {
            ent->GetEyeAngles()->y = cur.front().m_flLowerBodyYawTarget;
            break;
        }
        case ResolverMode::DELTA: {
            ent->GetEyeAngles()->y = LBYDelta(cur.front());
            break;
        }
        case ResolverMode::STEADY: {
            if (cur.size() <= 1) {
                return;
            }
            float tickdif = static_cast<float>(cur.front().tickcount - cur.at(1).tickcount);
            float lbydif = GetDelta(cur.front().m_flLowerBodyYawTarget, cur.at(1).m_flLowerBodyYawTarget);
            float ntickdif = static_cast<float>((*GlobalVars)->tickcount - cur.front().tickcount);
            ent->GetEyeAngles()->y = (lbydif / tickdif) * ntickdif;
            break;
        }
        case ResolverMode::TICKMODULO: {
            ent->GetEyeAngles()->y = ent->GetEyeAngles()->y - GetDeltaByComparingTicks(cur);
            break;
        }
        case ResolverMode::POSEPARAM: {
            if (ent->IsMoving()) {
                ent->GetEyeAngles()->y = *ent->GetLowerBodyYawTarget();
            }
            break;
        }
        case ResolverMode::ALL: {
            if (ent->IsMoving()) {
                ent->GetEyeAngles()->y = *ent->GetLowerBodyYawTarget();
            } else if (HasStaticRealAngle(cur)) {
                ent->GetEyeAngles()->y = (cur.front().m_flLowerBodyYawTarget) + (Utils::RandomFloat(0.f, 1.f) > 0.5f ? 10 : -10);
            } else if (HasStaticYawDifference(cur)) {
                ent->GetEyeAngles()->y = ent->GetEyeAngles()->y - (cur.front().m_angEyeAngles.y - cur.front().m_flLowerBodyYawTarget);
            } else if (HasSteadyDifference(cur)) {
                float tickdif = static_cast<float>(cur.front().tickcount - cur.at(1).tickcount);
                float lbydif = GetDelta(cur.front().m_flLowerBodyYawTarget, cur.at(1).m_flLowerBodyYawTarget);
                float ntickdif = static_cast<float>((*GlobalVars)->tickcount - cur.front().tickcount);
                ent->GetEyeAngles()->y = (lbydif / tickdif) * ntickdif;
            } else if (DeltaKeepsChanging(cur)) {
                ent->GetEyeAngles()->y = ent->GetEyeAngles()->y - GetDeltaByComparingTicks(cur);
            } else if (LBYKeepsChanging(cur)) {
                ent->GetEyeAngles()->y = GetLBYByComparingTicks(cur);
            } else {
                ent->GetEyeAngles()->y = ent->GetEyeAngles()->y + 180;
            }
            break;
        }

        default: {
            break;
        }
    }
}

void Features::CResolver::FrameStageNotify(ClientFrameStage_t stage) {
    if (!Options::Rage::resolver) {
        return;
    }

    if (!Engine->IsInGame()) {
        return;
    }

    C_CSPlayer* localplayer = (C_CSPlayer*) EntList->GetClientEntity(Engine->GetLocalPlayer());
    if (!localplayer) {
        return;
    }

    if (stage == ClientFrameStage_t::FRAME_NET_UPDATE_POSTDATAUPDATE_START) {
        for (int i = 1; i < Engine->GetMaxClients(); ++i) {
            C_CSPlayer* player = (C_CSPlayer*)EntList->GetClientEntity(i);

            if (!player ||
                player == localplayer ||
                player->IsDormant() ||
                !player->IsAlive() ||
                player->IsImmune() ||
                player->GetTeamNum() == localplayer->GetTeamNum()
            ) {
                continue;
            }


            player_info_t entityInformation;
            Engine->GetPlayerInfo(i, &entityInformation);

            if (!Options::Rage::resolve_all && std::find(CResolver::Players.begin(), CResolver::Players.end(), entityInformation.xuid) == CResolver::Players.end()) {
                continue;
            }

            player_data.push_back(std::pair<C_CSPlayer*, QAngle>(player, *player->GetEyeAngles()));
            Resolve(player);

            player->GetEyeAngles()->y = *player->GetLowerBodyYawTarget();
            static bool bFlip = true;
            float flYaw = *player->GetLowerBodyYawTarget();

            if (player->IsMoving()) {
                float flCurTime = (*GlobalVars)->curtime;
                static float flTimeUpdate = 0.5f;
                static float flNextTimeUpdate = flCurTime + flTimeUpdate;

                if (flCurTime >= flNextTimeUpdate) {
                    bFlip = !bFlip;
                }

                if (flNextTimeUpdate < flCurTime || flNextTimeUpdate - flCurTime > 10.f)
                    flNextTimeUpdate = flCurTime + flTimeUpdate;

                if (bFlip) {
                    flYaw += 35.f;
                }
                else {
                    flYaw -= 35.f;
                }
                player->GetEyeAngles()->y = flYaw;
            }
        }
        return;
    }

    if (stage == ClientFrameStage_t::FRAME_RENDER_END) {
        for (unsigned long i = 0; i < player_data.size(); i++) {
            std::pair<C_CSPlayer*, QAngle> player_aa_data = player_data[i];
            *player_aa_data.first->GetEyeAngles() = player_aa_data.second;
        }

        player_data.clear();

        return;
    }
}

void Features::CResolver::PostFrameStageNotify(ClientFrameStage_t stage) {
}


Features::CTickRecord Features::CResolver::GetShotRecord(C_CSPlayer* ent) {
    for (auto cur : m_arrInfos[ent->EntIndex()].m_sRecords) {
        if (cur.validtick) {
            return CTickRecord(cur);
        }
    }
    return CTickRecord();
}


bool& Features::CResolver::LowerBodyYawChanged(C_CSPlayer* ent) {
    return m_arrInfos.at(ent->EntIndex()).m_bLowerBodyYawChanged;
}

void Features::CResolver::StoreVars(C_CSPlayer* ent) {
    if (m_arrInfos.at(ent->EntIndex()).m_sRecords.size() >= Options::Rage::resolver_ticks) {
        m_arrInfos.at(ent->EntIndex()).m_sRecords.pop_back();
    }
    m_arrInfos.at(ent->EntIndex()).m_sRecords.push_front(CTickRecord(ent));
}

void Features::CResolver::StoreVars(C_CSPlayer* ent, QAngle ang, float lby, float simtime, float tick) {
    if (m_arrInfos.at(ent->EntIndex()).m_sRecords.size() >= Options::Rage::resolver_ticks) {
        m_arrInfos.at(ent->EntIndex()).m_sRecords.pop_back();
    }
    m_arrInfos.at(ent->EntIndex()).m_sRecords.push_front(CTickRecord(ent));
}

bool& Features::CResolver::BacktrackThisTick(C_CSPlayer* ent) {
    return m_arrInfos.at(ent->EntIndex()).m_bBacktrackThisTick;
}


bool Features::CResolver::HasStaticRealAngle(const std::deque<CTickRecord>& l, float tolerance) {
    auto minmax = std::minmax_element(std::begin(l), std::end(l), [](const CTickRecord& t1, const CTickRecord& t2) {
        return t1.m_flLowerBodyYawTarget < t2.m_flLowerBodyYawTarget;
    });
    return (fabs(minmax.first->m_flLowerBodyYawTarget - minmax.second->m_flLowerBodyYawTarget) <= tolerance);
}

bool Features::CResolver::HasStaticRealAngle(int index, float tolerance) {
    return HasStaticRealAngle(m_arrInfos[index].m_sRecords, tolerance);
}

bool Features::CResolver::HasStaticYawDifference(const std::deque<CTickRecord>& l, float tolerance) {
    for (auto i = l.begin(); i < l.end() - 1;) {
        if (GetDelta(LBYDelta(*i), LBYDelta(*++i)) > tolerance) {
            return false;
        }
    }
    return true;
}

bool Features::CResolver::HasSteadyDifference(const std::deque<CTickRecord>& l, float tolerance) {
    size_t misses = 0;
    for (size_t i = 0; i < l.size() - 1; i++) {
        float tickdif = static_cast<float>(l.at(i).m_flSimulationTime - l.at(i + 1).tickcount);
        float lbydif = GetDelta(l.at(i).m_flLowerBodyYawTarget, l.at(i + 1).m_flLowerBodyYawTarget);
        float ntickdif = static_cast<float>((*GlobalVars)->tickcount - l.at(i).tickcount);
        if (((lbydif / tickdif) * ntickdif) > tolerance){
            misses++;
        }
    }
    return (misses <= (l.size() / 3));
}

int Features::CResolver::GetDifferentDeltas(const std::deque<CTickRecord>& l, float tolerance) {
    std::vector<float> vec;
    for (auto var : l) {
        float curdelta = LBYDelta(var);
        bool add = true;
        for (auto fl : vec) {
            if (!IsDifferent(curdelta, fl, tolerance)) {
                add = false;
            }
        }
        if (add) {
            vec.push_back(curdelta);
        }
    }
    return (int)vec.size();
}

int Features::CResolver::GetDifferentLBYs(const std::deque<CTickRecord>& l, float tolerance) {
    std::vector<float> vec;
    for (auto var : l) {
        float curyaw = var.m_flLowerBodyYawTarget;
        bool add = true;
        for (auto fl : vec) {
            if (!IsDifferent(curyaw, fl, tolerance)) {
                add = false;
            }
        }
        if (add) {
            vec.push_back(curyaw);
        }
    }
    return (int)vec.size();
}

bool Features::CResolver::DeltaKeepsChanging(const std::deque<CTickRecord>& cur, float tolerance) {
    return (GetDifferentDeltas(cur) > (int) cur.size() / 2);
}

bool Features::CResolver::LBYKeepsChanging(const std::deque<CTickRecord>& cur, float tolerance) {
    return (GetDifferentLBYs(cur, tolerance) > (int)cur.size() / 2);
}

float Features::CResolver::GetLBYByComparingTicks(const std::deque<CTickRecord>& l) {
    int modulo = Options::Rage::resolver_modulo;
    int difangles = GetDifferentLBYs(l);
    int inc = modulo * difangles;
    for (auto var : l) {
        for (int lasttick = var.tickcount; lasttick < (*GlobalVars)->tickcount; lasttick += inc) {
            if (lasttick == (*GlobalVars)->tickcount) {
                return var.m_flLowerBodyYawTarget;
            }
        }
    }
    return 0.f;
}

float Features::CResolver::GetDeltaByComparingTicks(const std::deque<CTickRecord>& l) {
    int modulo = Options::Rage::resolver_modulo;
    int difangles = GetDifferentDeltas(l);
    int inc = modulo * difangles;
    for (auto var : l) {
        for (int lasttick = var.tickcount; lasttick < (*GlobalVars)->tickcount; lasttick += inc) {
            if (lasttick == (*GlobalVars)->tickcount) {
                return LBYDelta(var);
            }
        }
    }
    return 0.f;
}

void Features::CResolver::FireEvent(IGameEvent* event) {
    if (!event) {
        return;
    }
    
    std::string EventName = std::string(event->GetName());
    if (EventName != "player_connect_full" || EventName != "cs_game_disconnected") {
        return;
    }
    
    int UserID = event->GetInt("userid");
    if (UserID && Engine->GetPlayerForUserID(UserID) != Engine->GetLocalPlayer()) {
        return;
    }
    
    CResolver::Players.clear();
}

#endif
