/******************************************************/
/**                                                  **/
/**      SDK/Vector.h                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Vector_h
#define SDK_Vector_h

#include "Definitions.h"

typedef float vec_t;
class Vector {
public:
    vec_t x, y, z;
    Vector(void);
    Vector(vec_t X, vec_t Y, vec_t Z);
    Vector(vec_t* clr);
    void Init(vec_t ix = 0.0f, vec_t iy = 0.0f, vec_t iz = 0.0f);
    bool IsValid() const;
    void Invalidate();
    vec_t operator[](int i) const;
    vec_t& operator[](int i);
    vec_t* Base();
    vec_t const* Base() const;
    void Random(vec_t minVal, vec_t maxVal);
    void Zero();
    bool operator==(const Vector& v) const;
    bool operator!=(const Vector& v) const;
    Vector& operator+=(const Vector& v) {
        x += v.x; y += v.y; z += v.z;

        return *this;
    }

    Vector& operator-=(const Vector& v) {
        x -= v.x; y -= v.y; z -= v.z;

        return *this;
    }

    Vector& operator*=(float fl) {
        x *= fl;
        y *= fl;
        z *= fl;

        return *this;
    }

    Vector& operator*=(const Vector& v) {
        x *= v.x;
        y *= v.y;
        z *= v.z;

        return *this;
    }

    Vector& operator/=(const Vector& v) {
        x /= v.x;
        y /= v.y;
        z /= v.z;

        return *this;
    }

    Vector&	operator+=(float fl) {
        x += fl;
        y += fl;
        z += fl;

        return *this;
    }

    Vector&	operator/=(float fl) {
        x /= fl;
        y /= fl;
        z /= fl;

        return *this;
    }

    Vector&	operator-=(float fl) {
        x -= fl;
        y -= fl;
        z -= fl;

        return *this;
    }
    void Negate();
    vec_t	Length() const;

    vec_t LengthSqr(void) const {
        return (x * x + y * y + z * z);
    }

    bool IsZero(float tolerance = 0.01f) const {
        return (x > -tolerance && x < tolerance &&
            y > -tolerance && y < tolerance &&
            z > -tolerance && z < tolerance);
    }

    vec_t	NormalizeInPlace();
    Vector	Normalized() const;
    bool	IsLengthGreaterThan(float val) const;
    bool	IsLengthLessThan(float val) const;
    bool WithinAABox(Vector const &boxmin, Vector const &boxmax);
    vec_t	DistTo(const Vector &vOther) const;
    vec_t DistToSqr(const Vector &vOther) const {
        Vector delta;

        delta.x = x - vOther.x;
        delta.y = y - vOther.y;
        delta.z = z - vOther.z;

        return delta.LengthSqr();
    }
    void	CopyToArray(float* rgfl) const;
    void	MulAdd(const Vector& a, const Vector& b, float scalar);
    vec_t	Dot(const Vector& vOther) const;
    Vector& operator=(const Vector &vOther);
    vec_t	Length2D(void) const {
        return (vec_t)sqrt(x * x + y * y);
    }
    vec_t	Length2DSqr(void) const;
    Vector  ProjectOnto(const Vector& onto);
    Vector	operator-(void) const;
    Vector	operator+(const Vector& v) const;
    Vector	operator-(const Vector& v) const;
    Vector	operator*(const Vector& v) const;
    Vector	operator/(const Vector& v) const;
    Vector	operator*(float fl) const;
    Vector	operator/(float fl) const;
    Vector	Cross(const Vector &vOther) const;
    Vector	Min(const Vector &vOther) const;
    Vector	Max(const Vector &vOther) const;
};

void VectorCopy(const Vector& src, Vector& dst);
float VectorLength(const Vector& v);
void VectorLerp(const Vector& src1, const Vector& src2, vec_t t, Vector& dest);
void VectorCrossProduct(const Vector& a, const Vector& b, Vector& result);
vec_t NormalizeVector(Vector& v);

class TableVector {
public:
    vec_t x, y, z;
    operator Vector &()				{ return *((Vector *)(this)); }
    operator const Vector &() const	{ return *((const Vector *)(this)); }

    inline vec_t& operator[](int i) {
        return ((vec_t*)this)[i];
    }
    
    inline vec_t operator[](int i) const {
        return ((vec_t*)this)[i];
    }
};


class alignas(16) VectorAligned : public Vector {
public:
    inline VectorAligned(void) {};
    inline VectorAligned(float X, float Y, float Z) {
        Init(X, Y, Z);
    }

#ifdef VECTOR_NO_SLOW_OPERATIONS

private:
    // No copy constructors allowed if we're in optimal mode
    VectorAligned(const VectorAligned& vOther);
    VectorAligned(const Vector &vOther);

#else
public:
    explicit VectorAligned(const Vector &vOther) {
        Init(vOther.x, vOther.y, vOther.z);
    }

    VectorAligned& operator=(const Vector &vOther) {
        Init(vOther.x, vOther.y, vOther.z);
        return *this;
    }
    
#endif
    float w;	// this space is used anyway
};

#endif /** !SDK_Vector_h */
