/******************************************************/
/**                                                  **/
/**      SDK/Vector4D.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Vector4D_h
#define SDK_Vector4D_h

#include "Engine/common.h"

typedef float vec_t;

class Vector4D {
public:
    vec_t x, y, z, w;

    Vector4D(void);
    Vector4D(vec_t X, vec_t Y, vec_t Z, vec_t W);
    Vector4D(vec_t* clr);
    void Init(vec_t ix = 0.0f, vec_t iy = 0.0f, vec_t iz = 0.0f, vec_t iw = 0.0f);
    bool IsValid() const;
    void Invalidate();
    vec_t operator[](int i) const;
    vec_t& operator[](int i);
    vec_t* Base();
    vec_t const* Base() const;
    void Random(vec_t minVal, vec_t maxVal);
    void Zero();
    bool operator==(const Vector4D& v) const;
    bool operator!=(const Vector4D& v) const;
    Vector4D& operator+=(const Vector4D& v) {
        x += v.x; y += v.y; z += v.z; w += v.w;

        return *this;
    }

    Vector4D& operator-=(const Vector4D& v) {
        x -= v.x; y -= v.y; z -= v.z; w -= v.w;

        return *this;
    }

    Vector4D& operator*=(float fl) {
        x *= fl;
        y *= fl;
        z *= fl;
        w *= fl;

        return *this;
    }

    Vector4D& operator*=(const Vector4D& v) {
        x *= v.x;
        y *= v.y;
        z *= v.z;
        w *= v.w;

        return *this;
    }

    Vector4D& operator/=(const Vector4D& v) {
        x /= v.x;
        y /= v.y;
        z /= v.z;
        w /= v.w;

        return *this;
    }

    Vector4D&	operator+=(float fl) {
        x += fl;
        y += fl;
        z += fl;
        w += fl;

        return *this;
    }

    Vector4D&	operator/=(float fl) {
        x /= fl;
        y /= fl;
        z /= fl;
        w /= fl;

        return *this;
    }

    Vector4D&	operator-=(float fl) {
        x -= fl;
        y -= fl;
        z -= fl;
        w -= fl;

        return *this;
    }
    void	Negate();
    vec_t	Length() const;
    vec_t LengthSqr(void) const {
        return (x*x + y*y + z*z);
    }

    bool IsZero(float tolerance = 0.01f) const {
        return (x > -tolerance && x < tolerance &&
            y > -tolerance && y < tolerance &&
            z > -tolerance && z < tolerance &&
            w > -tolerance && w < tolerance
        );
    }

    vec_t	NormalizeInPlace();
    Vector4D	Normalized() const;
    bool	IsLengthGreaterThan(float val) const;
    bool	IsLengthLessThan(float val) const;
    bool WithinAABox(Vector4D const &boxmin, Vector4D const &boxmax);
    vec_t	DistTo(const Vector4D &vOther) const;
    vec_t DistToSqr(const Vector4D &vOther) const {
        Vector4D delta;

        delta.x = x - vOther.x;
        delta.y = y - vOther.y;
        delta.z = z - vOther.z;
        delta.w = w - vOther.w;

        return delta.LengthSqr();
    }
    void	CopyToArray(float* rgfl) const;
    void	MulAdd(const Vector4D& a, const Vector4D& b, float scalar);
    vec_t	Dot(const Vector4D& vOther) const;
    Vector4D& operator=(const Vector4D &vOther);
    vec_t	Length2D(void) const;
    vec_t	Length2DSqr(void) const;
    Vector4D  ProjectOnto(const Vector4D& onto);
    Vector4D	operator-(void) const;
    Vector4D	operator+(const Vector4D& v) const;
    Vector4D	operator-(const Vector4D& v) const;
    Vector4D	operator*(const Vector4D& v) const;
    Vector4D	operator/(const Vector4D& v) const;
    Vector4D	operator*(float fl) const;
    Vector4D	operator/(float fl) const;
    Vector4D	Min(const Vector4D &vOther) const;
    Vector4D	Max(const Vector4D &vOther) const;
};

#endif /** !SDK_Vector4D_h */
