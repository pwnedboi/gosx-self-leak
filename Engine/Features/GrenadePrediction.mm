/******************************************************/
/**                                                  **/
/**      Features/GrenadePrediction.cpp              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "GrenadePrediction.h"

void Features::CGrenadePrediction::CreateMove(CUserCmd* pCmd) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    try {
        bool InAttack = pCmd->buttons & IN_ATTACK;
        bool InAttack2 = pCmd->buttons & IN_ATTACK2;
        
        act = (InAttack && InAttack2) ? ACT_LOB : (InAttack2) ? ACT_DROP : (InAttack) ? ACT_THROW : ACT_NONE;
        viewAngle = pCmd->viewangles;
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::CreateMove()");
    }
}

void Features::CGrenadePrediction::OverrideView(CViewSetup* setup) {
    try {
        if (!Options::GrenadePrediction::enabled) {
            return;
        }
        
        C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
        if (!LocalPlayer || !LocalPlayer->IsAlive()) {
            return;
        }
        
        C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
        if (!activeWeapon || !WeaponManager::IsGrenade(activeWeapon->EntityId()) || act == ACT_NONE) {
            type = 0;
            
            return;
        }
        
        type = activeWeapon->EntityId();
        Simulate(setup);
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::View()");
    }
}

void Features::CGrenadePrediction::PaintTraverse() {
    try {
        if (!Options::GrenadePrediction::enabled) {
            return;
        }
        
        if (!Options::GrenadePrediction::last_path_stays && (!type || path.size() < 1)) {
            return;
        }
        
        Vector nadeStart, nadeEnd;

        if (path.begin() == path.end()) {
            return;
        }
        
        Vector prev = path[0];
        for (auto it = path.begin(), end = path.end(); it != end; ++it)  {
            if (Utils::WorldToScreen(prev, nadeStart) && Utils::WorldToScreen(*it, nadeEnd)) {
                DrawManager->DrawLine((int)nadeStart.x, (int)nadeStart.y, (int)nadeEnd.x, (int)nadeEnd.y, Options::GrenadePrediction::path_color, Options::GrenadePrediction::path_width);
            }
            prev = *it;
        }
        
        if (Utils::WorldToScreen(prev, nadeEnd)) {
            DrawManager->Circle(Vector2D(nadeEnd.x, nadeEnd.y), ((float)Options::GrenadePrediction::hit_size * 1.5f), (float)Options::GrenadePrediction::hit_size, Options::GrenadePrediction::hit_color, Options::GrenadePrediction::path_width);
        }
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::Paint()");
    }
}

void Features::CGrenadePrediction::Setup(Vector& vecSrc, Vector& vecThrow, Vector viewangles) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    try {
        C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
        if (!LocalPlayer || !LocalPlayer->IsAlive()) {
            return;
        }
        
        Vector angThrow = viewangles;
        float pitch = angThrow.x;
        
        if (pitch <= 90.0f) {
            if (pitch < -90.0f) {
                pitch += 360.0f;
            }
        } else {
            pitch -= 360.0f;
        }
        
        float a = pitch - (90.0f - fabs(pitch)) * 10.0f / 90.0f;
        angThrow.x = a;

        float flVel = 750.0f * 0.9f;

        static const float power[] = { 1.0f, 1.0f, 0.5f, 0.0f };
        float b = power[act];

        b = b * 0.7f;
        b = b + 0.3f;
        flVel *= b;
        
        Vector vForward, vRight, vUp;
        Math::AngleVectors2(angThrow, &vForward, &vRight, &vUp);
        
        vecSrc = LocalPlayer->GetEyePos();
        float off = (power[act] * 12.0f) - 12.0f;
        vecSrc.z += off;
        
        trace_t tr;
        Vector vecDest = vecSrc;
        vecDest += vForward * 22.0f;
        
        TraceHull(vecSrc, vecDest, tr);
        Vector vecBack = vForward; vecBack *= 6.0f;
        vecSrc = tr.endpos;
        vecSrc -= vecBack;
        
        vecThrow = LocalPlayer->GetVelocity();
        vecThrow *= 1.25f;
        vecThrow += vForward * flVel;
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::Setup()");
    }
}

void Features::CGrenadePrediction::Simulate(CViewSetup* setup) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    try {
        Vector vecSrc, vecThrow;
        
        Setup(vecSrc, vecThrow, viewAngle);
        
        float interval = (*GlobalVars)->interval_per_tick;
        int logstep = static_cast<int>(0.05f / interval);
        int logtimer = 0;
        
        path.clear();
        for (unsigned int i = 0; i < path.max_size() - 1; ++i) {
            if (!logtimer) {
                path.emplace_back(vecSrc);
            }
            
            int s = Step(vecSrc, vecThrow, i, interval);
            if ((s & 1)) {
                break;
            }
            
            if ((s & 2) || logtimer >= logstep) {
                logtimer = 0;
            } else {
                ++logtimer;
            }
        }
        path.emplace_back(vecSrc);
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::Simulate()");
    }
}

int Features::CGrenadePrediction::Step(Vector& vecSrc, Vector& vecThrow, int tick, float interval) {
    try {
        Vector move;
        AddGravityMove(move, vecThrow, interval, false);

        trace_t tr;
        PushEntity(vecSrc, move, tr);
        
        int result = 0;
        if (CheckDetonate(vecThrow, tr, tick, interval)) {
            result |= 1;
        }

        if (tr.fraction != 1.0f) {
            result |= 2;
            ResolveFlyCollisionCustom(tr, vecThrow, interval);
        }

        vecSrc = tr.endpos;
        
        return result;
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::Step()");
    }
}


bool Features::CGrenadePrediction::CheckDetonate(const Vector& vecThrow, const trace_t& tr, int tick, float interval) {
    try {
        switch (type) {
            case weapon_smokegrenade:
            case weapon_decoy:
                if (vecThrow.Length2D()<0.1f) {
                    int det_tick_mod = static_cast<int>(0.2f / interval);
                    return !(tick%det_tick_mod);
                }
                return false;
            case weapon_molotov:
            case weapon_incgrenade:
                if (tr.fraction != 1.0f && tr.plane.normal.z > 0.7f) {
                    return true;
                }
            case weapon_flashbang:
            case weapon_hegrenade:
                return static_cast<float>(tick) * interval > 1.5f && !(tick % static_cast<int>(0.2f / interval));
            default:
                return false;
        }
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::CheckDetonate()");
    }
}

void Features::CGrenadePrediction::TraceHull(Vector& src, Vector& end, trace_t& tr) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    try {
        Ray_t ray;
        ray.Init(src, end, Vector(-2.0f, -2.0f, -2.0f), Vector(2.0f, 2.0f, 2.0f));
        
        CTraceFilterWorldAndPropsOnly filter;
        
        Trace->TraceRay(ray, 0x200400B, &filter, &tr);
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::TraceHull()");
    }
}

void Features::CGrenadePrediction::AddGravityMove(Vector& move, Vector& vel, float frametime, bool onground) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    try {
        Vector basevel(0.0f, 0.0f, 0.0f);
        
        move.x = (vel.x + basevel.x) * frametime;
        move.y = (vel.y + basevel.y) * frametime;
        
        if (onground) {
            move.z = (vel.z + basevel.z) * frametime;
        } else {
            float gravity = 800.0f * 0.4f;
            
            float newZ = vel.z - (gravity * frametime);
            move.z = ((vel.z + newZ) / 2.0f + basevel.z) * frametime;
            
            vel.z = newZ;
        }
    } catch (...) {
        throw std::invalid_argument("Crash in CGrenadePrediction::AddGravityMove()");
    }
}

void Features::CGrenadePrediction::PushEntity(Vector& src, const Vector& move, trace_t& tr) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }
    
    Vector vecAbsEnd = src;
    vecAbsEnd += move;
        
    TraceHull(src, vecAbsEnd, tr);
}

void Features::CGrenadePrediction::ResolveFlyCollisionCustom(trace_t& tr, Vector& vecVelocity, float interval) {
    if (!Options::GrenadePrediction::enabled) {
        return;
    }

    float flSurfaceElasticity = 1.0;
    float flGrenadeElasticity = 0.45f;
    float flTotalElasticity = flGrenadeElasticity * flSurfaceElasticity;
    if (flTotalElasticity>0.9f) {
        flTotalElasticity = 0.9f;
    }
    if (flTotalElasticity<0.0f) {
        flTotalElasticity = 0.0f;
    }

    Vector vecAbsVelocity;
    PhysicsClipVelocity(vecVelocity, tr.plane.normal, vecAbsVelocity, 2.0f);
    vecAbsVelocity *= flTotalElasticity;
    
    float flSpeedSqr = vecAbsVelocity.LengthSqr();
    static const float flMinSpeedSqr = 20.0f * 20.0f;
    if (flSpeedSqr < flMinSpeedSqr) {
        vecAbsVelocity.x = 0.0f;
        vecAbsVelocity.y = 0.0f;
        vecAbsVelocity.z = 0.0f;
    }

    if (tr.plane.normal.z > 0.7f) {
        vecVelocity = vecAbsVelocity;
        vecAbsVelocity *= ((1.0f - tr.fraction) * interval);
        PushEntity(tr.endpos, vecAbsVelocity, tr);
    } else {
        vecVelocity = vecAbsVelocity;
    }
}

int Features::CGrenadePrediction::PhysicsClipVelocity(const Vector& in, const Vector& normal, Vector& out, float overbounce) {
    static const float STOP_EPSILON = 0.1f;
    
    float    backoff;
    float    change;
    float    angle;
    int      i, blocked;
    
    blocked = 0;
    
    angle = normal[2];
    
    if (angle > 0) {
        blocked |= 1;
    }
    if (!angle) {
        blocked |= 2;
    }
    
    backoff = in.Dot(normal) * overbounce;
    
    for (i = 0; i < 3; i++) {
        change = normal[i] * backoff;
        out[i] = in[i] - change;
        if (out[i] > -STOP_EPSILON && out[i] < STOP_EPSILON) {
            out[i] = 0;
        }
    }
    
    return blocked;
}

std::shared_ptr<Features::CGrenadePrediction> GrenadePrediction = std::make_unique<Features::CGrenadePrediction>();
