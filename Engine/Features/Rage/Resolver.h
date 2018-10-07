/******************************************************/
/**                                                  **/
/**      Rage/Resolver.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Rage_Resolver_h
#define Rage_Resolver_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"

#ifdef GOSX_RAGE_MODE

namespace Features {

    struct CTickRecord;

    struct CValidTick {
        explicit operator CTickRecord() const;
        
        explicit operator bool() const noexcept {
            return m_flSimulationTime > 0.f;
        }
        
        float m_flPitch = 0.f;
        float m_flYaw = 0.f;
        float m_flSimulationTime = 0.f;
        C_CSPlayer* m_pEntity = nullptr;
    };

    struct CTickRecord {
        CTickRecord() {}
        CTickRecord(C_CSPlayer* ent) {
            m_flLowerBodyYawTarget = *ent->GetLowerBodyYawTarget();
            m_angEyeAngles = *ent->GetEyeAngles();
            m_flSimulationTime = ent->GetSimulationTime();
            tickcount = 0;
        }
        
        explicit operator bool() const noexcept {
            return m_flSimulationTime > 0.f;
        }
        
        bool operator>(const CTickRecord& others) {
            return (m_flSimulationTime > others.m_flSimulationTime);
        }
        bool operator>=(const CTickRecord& others) {
            return (m_flSimulationTime >= others.m_flSimulationTime);
        }
        bool operator<(const CTickRecord& others) {
            return (m_flSimulationTime < others.m_flSimulationTime);
        }
        bool operator<=(const CTickRecord& others) {
            return (m_flSimulationTime <= others.m_flSimulationTime);
        }
        bool operator==(const CTickRecord& others) {
            return (m_flSimulationTime == others.m_flSimulationTime);
        }
        
        float m_flLowerBodyYawTarget;
        QAngle m_angEyeAngles;
        float m_flSimulationTime;
        CValidTick validtick;
        int tickcount = 0;
    };

    inline CValidTick::operator CTickRecord() const{
        CTickRecord rec(m_pEntity);
        rec.m_angEyeAngles.x = this->m_flPitch;
        rec.m_angEyeAngles.y = this->m_flYaw;
        rec.m_flSimulationTime = this->m_flSimulationTime;
        return rec;
    }

    class CResolveInfo {
    public:
        std::deque<CTickRecord> m_sRecords;
        bool	m_bEnemyShot; //priority
        bool	m_bLowerBodyYawChanged;
        bool	m_bBacktrackThisTick;
    };

    namespace CResolver {
        extern std::vector<int64_t> Players;
        extern std::array<CResolveInfo, 32> m_arrInfos;

        void Resolve(C_CSPlayer* ent);

        extern std::map<int, const char*> GetModeList();
        extern std::map<int, const char*> GetModeValues();
        void FrameStageNotify(ClientFrameStage_t stage);
        void PostFrameStageNotify(ClientFrameStage_t stage);
        void FireEvent(IGameEvent* event);

        CTickRecord GetShotRecord(C_CSPlayer*);

        bool HasStaticRealAngle(int index, float tolerance = 15.f);
        bool HasStaticRealAngle(const std::deque<CTickRecord>& l, float tolerance = 15.f);
        bool HasStaticYawDifference(const std::deque<CTickRecord>& l, float tolerance = 15.f);
        bool HasSteadyDifference(const std::deque<CTickRecord>& l, float tolerance = 15.f);
        int GetDifferentDeltas(const std::deque<CTickRecord>& l, float tolerance = 15.f);
        int GetDifferentLBYs(const std::deque<CTickRecord>& l, float tolerance = 15.f);
        float GetLBYByComparingTicks(const std::deque<CTickRecord>& l);
        float GetDeltaByComparingTicks(const std::deque<CTickRecord>& l);
        bool DeltaKeepsChanging(const std::deque<CTickRecord>& cur, float tolerance = 15.f);
        bool LBYKeepsChanging(const std::deque<CTickRecord>& cur, float tolerance = 15.f);
        bool IsEntityMoving(C_CSPlayer* ent);
        bool& LowerBodyYawChanged(C_CSPlayer* ent);
        void StoreVars(C_CSPlayer* ent);
        void StoreVars(C_CSPlayer* ent, QAngle ang, float lby, float simtime, float tick);
        bool& BacktrackThisTick(C_CSPlayer* ent);
    }

    const inline float GetDelta(float a, float b) {
        return std::abs(Math::ClampYaw(a - b));
    }

    const inline float LBYDelta(const CTickRecord& v) {
        return v.m_angEyeAngles.y - v.m_flLowerBodyYawTarget;
    }

    const inline bool IsDifferent(float a, float b, float tolerance = 10.f) {
        return (GetDelta(a, b) > tolerance);
    }
}
#endif

#endif /** !Rage_Resolver_h */
