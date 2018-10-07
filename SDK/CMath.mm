/******************************************************/
/**                                                  **/
/**      SDK/CMath.cpp                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CMath.h"

void Math::SinCos(float radians, float *sine, float *cosine) {
     double __cosr, __sinr;
    __asm ("fsincos" : "=t" (__cosr), "=u" (__sinr) : "0" (radians));

    *sine = __sinr;
    *cosine = __cosr;
}

void Math::AngleVectors(const QAngle &angles, Vector *forward) {
    float sr, sp, sy, cr, cp, cy;
    
    SinCos(DEG2RAD(angles[YAW]), &sy, &cy);
    SinCos(DEG2RAD(angles[PITCH]), &sp, &cp);
    SinCos(DEG2RAD(angles[ROLL]), &sr, &cr);
    
    if (forward) {
        forward->x = cp * cy;
        forward->y = cp * sy;
        forward->z = -sp;
    }
}

void Math::AngleVectors(const Vector &angles, Vector *forward, Vector *right, Vector *up) {
    float sr, sp, sy, cr, cp, cy;
    
    SinCos(DEG2RAD(angles[YAW]), &sy, &cy);
    SinCos(DEG2RAD(angles[PITCH]), &sp, &cp);
    SinCos(DEG2RAD(angles[ROLL]), &sr, &cr);
    
    if (forward) {
        forward->x = cp * cy;
        forward->y = cp * sy;
        forward->z = -sp;
    }
    
    if (right) {
        right->x = (-1 * sr * sp * cy + -1 * cr * -sy);
        right->y = (-1 * sr * sp * sy + -1 * cr * cy);
        right->z = -1 * sr * cp;
    }
    
    if (up) {
        up->x = (cr * sp * cy + -sr * -sy);
        up->y = (cr * sp * sy + -sr * cy);
        up->z = cr * cp;
    }
}

void Math::AngleVectors(const QAngle &angles, Vector& forward) {
    float	sp, sy, cp, cy;

    sy = sin(DEG2RAD(angles[YAW]));
    cy = cos(DEG2RAD(angles[YAW]));

    sp = sin(DEG2RAD(angles[PITCH]));
    cp = cos(DEG2RAD(angles[PITCH]));

    forward.x = cp * cy;
    forward.y = cp * sy;
    forward.z = -sp;
}

float Math::DotProduct(Vector &v1, float* v2) {
    return v1.x * v2[PITCH] + v1.y * v2[YAW] + v1.z * v2[ROLL];
}

float Math::Dot(const Vector &v1, Vector &v2) {
    return v1[PITCH] * v2[PITCH] + v1[YAW] * v2[YAW] + v1[ROLL] * v2[ROLL];
}

void Math::VectorTransform(Vector &in1, matrix3x4_t &in2, Vector &out) {
    out.x = Math::DotProduct(in1, in2.m_flMatVal[0]) + in2.m_flMatVal[0][3];
    out.y = Math::DotProduct(in1, in2.m_flMatVal[1]) + in2.m_flMatVal[1][3];
    out.z = Math::DotProduct(in1, in2.m_flMatVal[2]) + in2.m_flMatVal[2][3];
}

float Math::VecLength(Vector& vec) {
    return sqrt((vec.x * vec.x) + (vec.y * vec.y) + (vec.z * vec.z));
}

float Math::VecDist(const Vector& fVec1, Vector fVec2) {
    return sqrt(pow(fVec1.x - fVec2.x, 2) + pow(fVec1.y - fVec2.y, 2) + pow(fVec1.z - fVec2.z, 2));
}

float Math::GetFov(QAngle viewAngle, Vector playerHeadPosition, Vector entityHeadPosition) {
    Vector ang, aim;

    AngleVectors(viewAngle, &aim);
    QAngle newAngles = CalcAngle(playerHeadPosition, entityHeadPosition);
    AngleVectors(newAngles, &ang);

    return RAD2DEG(acos(aim.Dot(ang) / aim.LengthSqr()));
}

float Math::GetFov(const QAngle& viewAngle, const QAngle& aimAngle) {
    QAngle delta = aimAngle - viewAngle;
    NormalizeAngles(delta);

    return sqrtf(powf(delta.x, 2.0f) + powf(delta.y, 2.0f));
}

float Math::GetDistanceFov(QAngle viewAngle, Vector playerHeadPosition, Vector entityHeadPosition) {
    float distance = VecDist(playerHeadPosition, entityHeadPosition);
    Vector aimingAt;
    AngleVectors(viewAngle, &aimingAt);
    aimingAt *= distance;

    QAngle newAngles = CalcAngle(playerHeadPosition, entityHeadPosition);
    Vector aimAt;
    AngleVectors(newAngles, &aimAt);
    aimAt *= distance;

    return VecDist(aimAt, aimingAt);
}

QAngle Math::CalcAngle(Vector PlayerPos, Vector EnemyPos) {
    QAngle AimAngles;
    Vector delta = PlayerPos - EnemyPos;
    float hyp = sqrt((delta.x * delta.x) + (delta.y * delta.y));
    AimAngles.x = atanf(delta.z / hyp) * M_RADPI;
    AimAngles.y = atanf(delta.y / delta.x) * M_RADPI;
    if (delta.x >= 0.0) {
        AimAngles.y += 180.0f;
    }
    
    AimAngles.z = 0.f;
    return AimAngles;
}

void Math::VectorAngles( const Vector& dir, QAngle &angles ) {
    float hyp = sqrt((dir.x * dir.x) + (dir.y * dir.y) );
    angles.x = atanf(dir.z / hyp) * M_RADPI;
    angles.y = atanf(dir.y / dir.x) * M_RADPI;
    if (dir.x >= 0.0) {
        angles.y += 180.0f;
    }

    angles.z = 0.f;
}

void Math::VectorNormalize( Vector& v ) {
    float l = VecLength(v);
    if (l != 0.0f) {
        v /= l;
    } else {
        v.x = v.y = 0.0f; v.z = 1.0f;
    }
}

void Math::SmoothAngle(const QAngle& ViewAngle, QAngle& DestAngles, float smooth) {
    QAngle vecDelta = ViewAngle - DestAngles;
    ClampAngle(vecDelta);
    DestAngles = ViewAngle - vecDelta / 100.0f * smooth; // 50.0f is ur smooth value
}

void Math::MakeVector(Vector angle, Vector& vector) {
    float pitch = float(angle[PITCH] * M_PI / 180);
    float yaw = float(angle[YAW] * M_PI / 180 );
    float tmp = float(cos(pitch));
    vector[PITCH] = float(-tmp * -cos(yaw));
    vector[YAW] = float(sin(yaw) * tmp);
    vector[ROLL] = float(-sin(pitch));
}

Vector Math::AngleToDirection(QAngle angle) {
    angle.x = (float)DEG2RAD(angle.x);
    angle.y = (float)DEG2RAD(angle.y);
    angle.z = 0.f;
    
    float sinYaw = sin(angle.y);
    float cosYaw = cos(angle.y);
    
    float sinPitch = sin(angle.x);
    float cosPitch = cos(angle.x);
    
    Vector direction;
    direction.x = cosPitch * cosYaw;
    direction.y = cosPitch * sinYaw;
    direction.z = -sinPitch;
    
    return direction;
}

void Math::VectorITransform(Vector& in1, const matrix3x4_t& in2, Vector& out) {
    float in1t[3];
    
    in1t[0] = in1.x - in2.m_flMatVal[0][3];
    in1t[1] = in1.y - in2.m_flMatVal[1][3];
    in1t[2] = in1.z - in2.m_flMatVal[2][3];
    
    out.x = in1t[0] * in2.m_flMatVal[0][0] + in1t[1] * in2.m_flMatVal[1][0] + in1t[2] * in2.m_flMatVal[2][0];
    out.y = in1t[0] * in2.m_flMatVal[0][1] + in1t[1] * in2.m_flMatVal[1][1] + in1t[2] * in2.m_flMatVal[2][1];
    out.z = in1t[0] * in2.m_flMatVal[0][2] + in1t[1] * in2.m_flMatVal[1][2] + in1t[2] * in2.m_flMatVal[2][2];
}

void Math::VectorIRotate( Vector& in1, const matrix3x4_t& in2, Vector& out ) {
    out.x = in1.x*in2.m_flMatVal[0][0] + in1.y*in2.m_flMatVal[1][0] + in1.z*in2.m_flMatVal[2][0];
    out.y = in1.x*in2.m_flMatVal[0][1] + in1.y*in2.m_flMatVal[1][1] + in1.z*in2.m_flMatVal[2][1];
    out.z = in1.x*in2.m_flMatVal[0][2] + in1.y*in2.m_flMatVal[1][2] + in1.z*in2.m_flMatVal[2][2];
}

Vector Math::ExtrapolateTick(Vector position, Vector velocity) {
    position.x += velocity.x * (*GlobalVars)->interval_per_tick;
    position.y += velocity.y * (*GlobalVars)->interval_per_tick;

    return position;
}

void Math::ClampAngle( QAngle& angles ) {
    if (angles.x < -89.0f) {
        angles.x = -89.0f;
    }

    if (angles.x >  89.0f) {
        angles.x = 89.0f;
    }

    while (angles.y < -180.0f) {
        angles.y += 360.0f;
    }

    while (angles.y >  180.0f) {
        angles.y -= 360.0f;
    }

    angles.z = 0.0f;
}

void Math::NormalizeAngles(QAngle& angle) {
    while (angle.x > 89.0f) {
        angle.x -= 180.f;
    }

    while (angle.x < -89.0f) {
        angle.x += 180.f;
    }

    while (angle.y > 180.f) {
        angle.y -= 360.f;
    }

    while (angle.y < -180.f) {
        angle.y += 360.f;
    }
}

void Math::CorrectMovement(QAngle vOldAngles, CUserCmd* pCmd, float fOldForward, float fOldSidemove) {
    float deltaView;
    float f1;
    float f2;

    if (vOldAngles.y < 0.f) {
        f1 = 360.0f + vOldAngles.y;
    } else {
        f1 = vOldAngles.y;
    }

    if (pCmd->viewangles.y < 0.0f) {
        f2 = 360.0f + pCmd->viewangles.y;
    } else {
        f2 = pCmd->viewangles.y;
    }

    if (f2 < f1) {
        deltaView = std::abs(f2 - f1);
    } else {
        deltaView = 360.0f - std::abs(f1 - f2);
    }

    deltaView = 360.0f - deltaView;

    pCmd->forwardmove = cos(DEG2RAD(deltaView)) * fOldForward + cos(DEG2RAD(deltaView + 90.f)) * fOldSidemove;
    pCmd->sidemove = sin(DEG2RAD(deltaView)) * fOldForward + sin(DEG2RAD(deltaView + 90.f)) * fOldSidemove;
}

float Math::ClampYaw (float val) {
    while (val < 0) val += 360.0f;
    while (val > 360.0f) val -= 360.0f;
    return val;
}

void Math::AngleVectors2(const Vector &angles, Vector *forward, Vector *right, Vector *up) {
    float sr, sp, sy, cr, cp, cy;
    
    sp = static_cast<float>(sin(double(angles.x) * M_PIRAD));
    cp = static_cast<float>(cos(double(angles.x) * M_PIRAD));
    sy = static_cast<float>(sin(double(angles.y) * M_PIRAD));
    cy = static_cast<float>(cos(double(angles.y) * M_PIRAD));
    sr = static_cast<float>(sin(double(angles.z) * M_PIRAD));
    cr = static_cast<float>(cos(double(angles.z) * M_PIRAD));
    
    if (forward) {
        forward->x = cp * cy;
        forward->y = cp * sy;
        forward->z = -sp;
    }
    
    if (right) {
        right->x = (-1 * sr * sp * cy + -1 * cr * -sy);
        right->y = (-1 * sr * sp * sy + -1 * cr * cy);
        right->z = -1 * sr * cp;
    }
    
    if (up) {
        up->x = (cr * sp * cy + -sr * -sy);
        up->y = (cr * sp * sy + -sr * cy);
        up->z = cr * cp;
    }
}

float Math::DistancePointToLine(Vector Point, Vector LineOrigin, Vector Dir) {
    auto PointDir = Point - LineOrigin;

    auto TempOffset = PointDir.Dot(Dir) / (Dir.x*Dir.x + Dir.y*Dir.y + Dir.z*Dir.z);
    if (TempOffset < 0.000001f) {
        return FLT_MAX;
    }

    auto PerpendicularPoint = LineOrigin + (Dir * TempOffset);

    return (Point - PerpendicularPoint).Length();
}

Vector Math::AngleVector(Vector meme) {
    auto sy = sin(meme.y / 180.f * static_cast<float>(M_PI));
    auto cy = cos(meme.y / 180.f * static_cast<float>(M_PI));

    auto sp = sin(meme.x / 180.f * static_cast<float>(M_PI));
    auto cp = cos(meme.x / 180.f* static_cast<float>(M_PI));

    return Vector(cp*cy, cp*sy, -sp);
}

QAngle Math::Lerp(const QAngle& a, const QAngle& b, const float t) {
    QAngle result;
    
    QAngle delta = a - b;
    NormalizeAngles(delta);
    
    result.x = a.x + (delta.x) * t;
    result.y = a.y + (delta.y) * t;
    
    return result;
}

QAngle Math::CubicBezier(const QAngle& a, const QAngle& b, const QAngle& c, const QAngle& d, const float t) {
    QAngle ab, bc, cd, abbc, bccd;
    QAngle result;
    
    ab = Lerp(a, b, t);
    bc = Lerp(b, c, t);
    cd = Lerp(c, d, t);
    abbc = Lerp(ab, bc, t);
    bccd = Lerp(bc, cd, t);
    
    result = Lerp(abbc, bccd, t);
    
    return result;
}
