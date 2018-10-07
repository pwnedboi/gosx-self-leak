/******************************************************/
/**                                                  **/
/**      Features/GrenadePrediction.h                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_GrenadePrediction_h
#define Features_GrenadePrediction_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"

namespace Features {
    enum ACT {
        ACT_NONE,
        ACT_THROW,
        ACT_LOB,
        ACT_DROP,
    };

    class CGrenadePrediction {
    public:
        void CreateMove(CUserCmd* pCmd);
        void OverrideView(CViewSetup* setup);
        void PaintTraverse();
    private:
        std::vector<Vector> path;
        
        int type = 0;
        int act = 0;
        QAngle viewAngle = QAngle(0.0f, 0.0f, 0.0f);
        
        void Setup(Vector& vecSrc, Vector& vecThrow, Vector viewangles);
        void Simulate(CViewSetup* setup);
        
        int  Step(Vector& vecSrc, Vector& vecThrow, int tick, float interval);
        bool CheckDetonate(const Vector& vecThrow, const trace_t& tr, int tick, float interval);
        
        void TraceHull(Vector& src, Vector& end, trace_t& tr);
        void AddGravityMove(Vector& move, Vector& vel, float frametime, bool onground);
        void PushEntity(Vector& src, const Vector& move, trace_t& tr);
        void ResolveFlyCollisionCustom(trace_t& tr, Vector& vecVelocity, float interval);
        int  PhysicsClipVelocity(const Vector& in, const Vector& normal, Vector& out, float overbounce);
    };
}

extern std::shared_ptr<Features::CGrenadePrediction> GrenadePrediction;

#endif /** !Features_GrenadePrediction_h */
