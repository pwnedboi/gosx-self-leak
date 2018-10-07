/******************************************************/
/**                                                  **/
/**      SDK/CMath.h                                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CMath_h
#define SDK_CMath_h

#include "Engine/common.h"
#include "SDK.h"

#define M_RADPI 57.295779513082f
#define M_PIRAD 0.01745329251f
#define M_PI_F  ((float)(M_PI))
#define M_PHI	1.61803398874989484820
// #define FLT_MAX 3.402823e+38

#define SQUARE(a) a * a

#ifndef RAD2DEG
#define RAD2DEG( x )  ((float)(x) * (float)(180.f / M_PI_F))
#endif

#ifndef DEG2RAD
#define DEG2RAD( x )  ((float)(x) * (float)(M_PI_F / 180.f))
#endif

enum {
    PITCH = 0,	// up / down
    YAW,		// left / right
    ROLL		// fall over
};

namespace Math {
    extern void inline SinCos(float radians, float *sine, float *cosine);
    extern void AngleVectors(const QAngle &angles, Vector *forward);
    extern void AngleVectors(const Vector &angles, Vector *forward, Vector *right, Vector *up);
    extern void AngleVectors(const QAngle &angles, Vector& forward);
    extern void AngleVectors2(const Vector &angles, Vector *forward, Vector *right, Vector *up);
    extern float DotProduct(Vector &v1, float* v2);
    extern float Dot(const Vector &v1, Vector &v2);
    extern void VectorTransform(Vector &in1, matrix3x4_t& in2, Vector &out);
    extern float VecLength(Vector& vec);
    extern float VecDist(const Vector& fVec1, Vector fVec2);
    extern float GetFov(QAngle viewAngle, Vector playerHeadPosition, Vector entityHeadPosition);
    extern float GetFov(const QAngle& viewAngle, const QAngle& aimAngle);
    extern float GetDistanceFov(QAngle viewAngle, Vector playerHeadPosition, Vector entityHeadPosition);
    extern QAngle CalcAngle(Vector PlayerPos, Vector EnemyPos);
    extern void VectorAngles( const Vector& dir, QAngle &angles );
    extern void ClampAngle( QAngle& angles);
    extern void NormalizeAngles(QAngle& angle);
    extern void VectorNormalize( Vector& v);
    extern void SmoothAngle(const QAngle& ViewAngle, QAngle& DestAngles, float smooth);
    extern void MakeVector(Vector angle, Vector& vector);
    extern Vector AngleToDirection( QAngle angle);
    extern void VectorITransform( Vector& in1, const matrix3x4_t& in2, Vector& out);
    extern void VectorIRotate( Vector& in1, const matrix3x4_t& in2, Vector& out);
    extern Vector ExtrapolateTick(Vector p0, Vector v0);
    extern void CorrectMovement(QAngle vOldAngles, CUserCmd* pCmd, float fOldForward, float fOldSidemove);
    extern float ClampYaw(float val);
    extern float DistancePointToLine(Vector Point, Vector LineOrigin, Vector Dir);
    extern Vector AngleVector(Vector meme);
    extern QAngle Lerp(const QAngle& a, const QAngle& b, const float t);
    extern QAngle CubicBezier(const QAngle& a, const QAngle& b, const QAngle& c, const QAngle& d, const float t);
};

#endif /** !SDK_CMath_h */
