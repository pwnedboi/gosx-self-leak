/******************************************************/
/**                                                  **/
/**      SDK/VMatrix.h                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_VMatrix_h
#define SDK_VMatrix_h

#include "QAngle.h"

struct cplane_t {
    Vector          normal;
    float           dist;
    unsigned char	type;			// for fast side tests
    unsigned char	signbits;		// signx + (signy<<1) + (signz<<1)
    unsigned char	pad[2];

};

class matrix3x4_t {
public:
    matrix3x4_t() {}
    matrix3x4_t(
        float m00, float m01, float m02, float m03,
        float m10, float m11, float m12, float m13,
        float m20, float m21, float m22, float m23
    ) {
        m_flMatVal[0][0] = m00;	m_flMatVal[0][1] = m01; m_flMatVal[0][2] = m02; m_flMatVal[0][3] = m03;
        m_flMatVal[1][0] = m10;	m_flMatVal[1][1] = m11; m_flMatVal[1][2] = m12; m_flMatVal[1][3] = m13;
        m_flMatVal[2][0] = m20;	m_flMatVal[2][1] = m21; m_flMatVal[2][2] = m22; m_flMatVal[2][3] = m23;
    }
    void Init(const Vector& xAxis, const Vector& yAxis, const Vector& zAxis, const Vector &vecOrigin) {
        m_flMatVal[0][0] = xAxis.x; m_flMatVal[0][1] = yAxis.x; m_flMatVal[0][2] = zAxis.x; m_flMatVal[0][3] = vecOrigin.x;
        m_flMatVal[1][0] = xAxis.y; m_flMatVal[1][1] = yAxis.y; m_flMatVal[1][2] = zAxis.y; m_flMatVal[1][3] = vecOrigin.y;
        m_flMatVal[2][0] = xAxis.z; m_flMatVal[2][1] = yAxis.z; m_flMatVal[2][2] = zAxis.z; m_flMatVal[2][3] = vecOrigin.z;
    }

    matrix3x4_t(const Vector& xAxis, const Vector& yAxis, const Vector& zAxis, const Vector &vecOrigin) {
        Init(xAxis, yAxis, zAxis, vecOrigin);
    }

    inline void SetOrigin(Vector const & p) {
        m_flMatVal[0][3] = p.x;
        m_flMatVal[1][3] = p.y;
        m_flMatVal[2][3] = p.z;
    }

    inline void Invalidate(void) {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                m_flMatVal[i][j] = std::numeric_limits<float>::infinity();;
            }
        }
    }

    float *operator[](int i) { return m_flMatVal[i]; }
    const float *operator[](int i) const { return m_flMatVal[i]; }
    float *Base() { return &m_flMatVal[0][0]; }
    const float *Base() const { return &m_flMatVal[0][0]; }

    float m_flMatVal[3][4];
};

class VMatrix {
public:
    VMatrix();
    VMatrix(
        vec_t m00, vec_t m01, vec_t m02, vec_t m03,
        vec_t m10, vec_t m11, vec_t m12, vec_t m13,
        vec_t m20, vec_t m21, vec_t m22, vec_t m23,
        vec_t m30, vec_t m31, vec_t m32, vec_t m33
    );
    VMatrix(const Vector& forward, const Vector& left, const Vector& up);
    VMatrix(const matrix3x4_t& matrix3x4);
    void Init(
        vec_t m00, vec_t m01, vec_t m02, vec_t m03,
        vec_t m10, vec_t m11, vec_t m12, vec_t m13,
        vec_t m20, vec_t m21, vec_t m22, vec_t m23,
        vec_t m30, vec_t m31, vec_t m32, vec_t m33
    );

    void Init(const matrix3x4_t& matrix3x4);
    inline float* operator[](int i) {
        return m[i];
    }

    inline const float* operator[](int i) const {
        return m[i];
    }

    inline float *Base() {
        return &m[0][0];
    }

    inline const float *Base() const {
        return &m[0][0];
    }

    void		SetLeft(const Vector &vLeft);
    void		SetUp(const Vector &vUp);
    void		SetForward(const Vector &vForward);
    void		GetBasisVectors(Vector &vForward, Vector &vLeft, Vector &vUp) const;
    void		SetBasisVectors(const Vector &vForward, const Vector &vLeft, const Vector &vUp);
    Vector &	GetTranslation(Vector &vTrans) const;
    void		SetTranslation(const Vector &vTrans);
    void		PreTranslate(const Vector &vTrans);
    void		PostTranslate(const Vector &vTrans);

    matrix3x4_t& As3x4();
    const matrix3x4_t& As3x4() const;
    void		CopyFrom3x4(const matrix3x4_t &m3x4);
    void		Set3x4(matrix3x4_t& matrix3x4) const;

    bool		operator==(const VMatrix& src) const;
    bool		operator!=(const VMatrix& src) const { return !(*this == src); }
    Vector		GetLeft() const;
    Vector		GetUp() const;
    Vector		GetForward() const;
    Vector		GetTranslation() const;
public:
    void		V3Mul(const Vector &vIn, Vector &vOut) const;
    //void		V4Mul( const Vector4D &vIn, Vector4D &vOut ) const;
    Vector		ApplyRotation(const Vector &vVec) const;
    Vector		operator*(const Vector &vVec) const;
    Vector		VMul3x3(const Vector &vVec) const;
    Vector		VMul3x3Transpose(const Vector &vVec) const;
    Vector		VMul4x3(const Vector &vVec) const;
    Vector		VMul4x3Transpose(const Vector &vVec) const;
public:
    VMatrix&	operator=(const VMatrix &mOther);
    void		MatrixMul(const VMatrix &vm, VMatrix &out) const;
    const VMatrix& operator+=(const VMatrix &other);
    VMatrix		operator*(const VMatrix &mOther) const;
    VMatrix		operator+(const VMatrix &other) const;
    VMatrix		operator-(const VMatrix &other) const;
    VMatrix		operator-() const;
    VMatrix		operator~() const;
public:
    void		Identity();
    bool		IsIdentity() const;
    void		SetupMatrixOrgAngles(const Vector &origin, const QAngle &vAngles);
    bool		InverseGeneral(VMatrix &vInverse) const;
    void		InverseTR(VMatrix &mRet) const;
    bool		IsRotationMatrix() const;
    VMatrix		InverseTR() const;
    Vector		GetScale() const;
    VMatrix		Scale(const Vector &vScale);
    VMatrix		NormalizeBasisVectors() const;
    VMatrix		Transpose() const;
    VMatrix		Transpose3x3() const;
public:
    vec_t		m[4][4];
};

#endif /** !SDK_VMatrix_h */
