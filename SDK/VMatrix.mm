/******************************************************/
/**                                                  **/
/**      SDK/VMatrix.cpp                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "VMatrix.h"

VMatrix::VMatrix() {
}

VMatrix::VMatrix(
    vec_t m00, vec_t m01, vec_t m02, vec_t m03,
    vec_t m10, vec_t m11, vec_t m12, vec_t m13,
    vec_t m20, vec_t m21, vec_t m22, vec_t m23,
    vec_t m30, vec_t m31, vec_t m32, vec_t m33
) {
    Init(
        m00, m01, m02, m03,
        m10, m11, m12, m13,
        m20, m21, m22, m23,
        m30, m31, m32, m33
    );
}

VMatrix::VMatrix(const matrix3x4_t& matrix3x4) {
    Init(matrix3x4);
}

VMatrix::VMatrix(const Vector& xAxis, const Vector& yAxis, const Vector& zAxis) {
    Init(
        xAxis.x, yAxis.x, zAxis.x, 0.0f,
        xAxis.y, yAxis.y, zAxis.y, 0.0f,
        xAxis.z, yAxis.z, zAxis.z, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    );
}


void VMatrix::Init(
    vec_t m00, vec_t m01, vec_t m02, vec_t m03,
    vec_t m10, vec_t m11, vec_t m12, vec_t m13,
    vec_t m20, vec_t m21, vec_t m22, vec_t m23,
    vec_t m30, vec_t m31, vec_t m32, vec_t m33
) {
    m[0][0] = m00;
    m[0][1] = m01;
    m[0][2] = m02;
    m[0][3] = m03;

    m[1][0] = m10;
    m[1][1] = m11;
    m[1][2] = m12;
    m[1][3] = m13;

    m[2][0] = m20;
    m[2][1] = m21;
    m[2][2] = m22;
    m[2][3] = m23;

    m[3][0] = m30;
    m[3][1] = m31;
    m[3][2] = m32;
    m[3][3] = m33;
}

void VMatrix::Init(const matrix3x4_t& matrix3x4) {
    memcpy(m, matrix3x4.Base(), sizeof(matrix3x4_t));

    m[3][0] = 0.0f;
    m[3][1] = 0.0f;
    m[3][2] = 0.0f;
    m[3][3] = 1.0f;
}

void Vector3DMultiplyPosition(const VMatrix& src1, const Vector& src2, Vector& dst) {
    dst[0] = src1[0][0] * src2.x + src1[0][1] * src2.y + src1[0][2] * src2.z + src1[0][3];
    dst[1] = src1[1][0] * src2.x + src1[1][1] * src2.y + src1[1][2] * src2.z + src1[1][3];
    dst[2] = src1[2][0] * src2.x + src1[2][1] * src2.y + src1[2][2] * src2.z + src1[2][3];
}

Vector VMatrix::GetForward() const {
    return Vector(m[0][0], m[1][0], m[2][0]);
}

Vector VMatrix::GetLeft() const {
    return Vector(m[0][1], m[1][1], m[2][1]);
}

Vector VMatrix::GetUp() const {
    return Vector(m[0][2], m[1][2], m[2][2]);
}

void VMatrix::SetForward(const Vector &vForward) {
    m[0][0] = vForward.x;
    m[1][0] = vForward.y;
    m[2][0] = vForward.z;
}

void VMatrix::SetLeft(const Vector &vLeft) {
    m[0][1] = vLeft.x;
    m[1][1] = vLeft.y;
    m[2][1] = vLeft.z;
}

void VMatrix::SetUp(const Vector &vUp) {
    m[0][2] = vUp.x;
    m[1][2] = vUp.y;
    m[2][2] = vUp.z;
}

void VMatrix::GetBasisVectors(Vector &vForward, Vector &vLeft, Vector &vUp) const {
    vForward.Init(m[0][0], m[1][0], m[2][0]);
    vLeft.Init(m[0][1], m[1][1], m[2][1]);
    vUp.Init(m[0][2], m[1][2], m[2][2]);
}

void VMatrix::SetBasisVectors(const Vector &vForward, const Vector &vLeft, const Vector &vUp) {
    SetForward(vForward);
    SetLeft(vLeft);
    SetUp(vUp);
}

Vector VMatrix::GetTranslation() const {
    return Vector(m[0][3], m[1][3], m[2][3]);
}

Vector& VMatrix::GetTranslation(Vector &vTrans) const {
    vTrans.x = m[0][3];
    vTrans.y = m[1][3];
    vTrans.z = m[2][3];
    return vTrans;
}

void VMatrix::SetTranslation(const Vector &vTrans) {
    m[0][3] = vTrans.x;
    m[1][3] = vTrans.y;
    m[2][3] = vTrans.z;
}

void VMatrix::PreTranslate(const Vector &vTrans) {
    Vector tmp;
    Vector3DMultiplyPosition(*this, vTrans, tmp);
    m[0][3] = tmp.x;
    m[1][3] = tmp.y;
    m[2][3] = tmp.z;
}

void VMatrix::PostTranslate(const Vector &vTrans) {
    m[0][3] += vTrans.x;
    m[1][3] += vTrans.y;
    m[2][3] += vTrans.z;
}

const matrix3x4_t& VMatrix::As3x4() const {
    return *((const matrix3x4_t*)this);
}

matrix3x4_t& VMatrix::As3x4() {
    return *((matrix3x4_t*)this);
}

void VMatrix::CopyFrom3x4(const matrix3x4_t &m3x4) {
    memcpy(m, m3x4.Base(), sizeof(matrix3x4_t));
    m[3][0] = m[3][1] = m[3][2] = 0;
    m[3][3] = 1;
}

void VMatrix::Set3x4(matrix3x4_t& matrix3x4) const {
    memcpy(matrix3x4.Base(), m, sizeof(matrix3x4_t));
}

const VMatrix& VMatrix::operator+=(const VMatrix &other) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            m[i][j] += other.m[i][j];
        }
    }

    return *this;
}

VMatrix VMatrix::operator+(const VMatrix &other) const {
    VMatrix ret;
    for (int i = 0; i < 16; i++) {
        ((float*)ret.m)[i] = ((float*)m)[i] + ((float*)other.m)[i];
    }
    return ret;
}

VMatrix VMatrix::operator-(const VMatrix &other) const {
    VMatrix ret;

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            ret.m[i][j] = m[i][j] - other.m[i][j];
        }
    }

    return ret;
}

VMatrix VMatrix::operator-() const {
    VMatrix ret;
    for (int i = 0; i < 16; i++) {
        ((float*)ret.m)[i] = -((float*)m)[i];
    }
    return ret;
}

Vector VMatrix::operator*(const Vector &vVec) const {
    Vector vRet;
    vRet.x = m[0][0] * vVec.x + m[0][1] * vVec.y + m[0][2] * vVec.z + m[0][3];
    vRet.y = m[1][0] * vVec.x + m[1][1] * vVec.y + m[1][2] * vVec.z + m[1][3];
    vRet.z = m[2][0] * vVec.x + m[2][1] * vVec.y + m[2][2] * vVec.z + m[2][3];

    return vRet;
}

Vector VMatrix::VMul4x3(const Vector &vVec) const {
    Vector vResult;
    Vector3DMultiplyPosition(*this, vVec, vResult);
    return vResult;
}


Vector VMatrix::VMul4x3Transpose(const Vector &vVec) const {
    Vector tmp = vVec;
    tmp.x -= m[0][3];
    tmp.y -= m[1][3];
    tmp.z -= m[2][3];

    return Vector(
        m[0][0] * tmp.x + m[1][0] * tmp.y + m[2][0] * tmp.z,
        m[0][1] * tmp.x + m[1][1] * tmp.y + m[2][1] * tmp.z,
        m[0][2] * tmp.x + m[1][2] * tmp.y + m[2][2] * tmp.z
    );
}

Vector VMatrix::VMul3x3(const Vector &vVec) const {
    return Vector(
        m[0][0] * vVec.x + m[0][1] * vVec.y + m[0][2] * vVec.z,
        m[1][0] * vVec.x + m[1][1] * vVec.y + m[1][2] * vVec.z,
        m[2][0] * vVec.x + m[2][1] * vVec.y + m[2][2] * vVec.z
    );
}

Vector VMatrix::VMul3x3Transpose(const Vector &vVec) const {
    return Vector(
        m[0][0] * vVec.x + m[1][0] * vVec.y + m[2][0] * vVec.z,
        m[0][1] * vVec.x + m[1][1] * vVec.y + m[2][1] * vVec.z,
        m[0][2] * vVec.x + m[1][2] * vVec.y + m[2][2] * vVec.z
    );
}


void VMatrix::V3Mul(const Vector &vIn, Vector &vOut) const {
    vec_t rw;

    rw = 1.0f / (m[3][0] * vIn.x + m[3][1] * vIn.y + m[3][2] * vIn.z + m[3][3]);
    vOut.x = (m[0][0] * vIn.x + m[0][1] * vIn.y + m[0][2] * vIn.z + m[0][3]) * rw;
    vOut.y = (m[1][0] * vIn.x + m[1][1] * vIn.y + m[1][2] * vIn.z + m[1][3]) * rw;
    vOut.z = (m[2][0] * vIn.x + m[2][1] * vIn.y + m[2][2] * vIn.z + m[2][3]) * rw;
}

void VMatrix::Identity() {
    m[0][0] = 1.0f; m[0][1] = 0.0f; m[0][2] = 0.0f; m[0][3] = 0.0f;
    m[1][0] = 0.0f; m[1][1] = 1.0f; m[1][2] = 0.0f; m[1][3] = 0.0f;
    m[2][0] = 0.0f; m[2][1] = 0.0f; m[2][2] = 1.0f; m[2][3] = 0.0f;
    m[3][0] = 0.0f; m[3][1] = 0.0f; m[3][2] = 0.0f; m[3][3] = 1.0f;
}

bool VMatrix::IsIdentity() const {
    return
        m[0][0] == 1.0f && m[0][1] == 0.0f && m[0][2] == 0.0f && m[0][3] == 0.0f &&
        m[1][0] == 0.0f && m[1][1] == 1.0f && m[1][2] == 0.0f && m[1][3] == 0.0f &&
        m[2][0] == 0.0f && m[2][1] == 0.0f && m[2][2] == 1.0f && m[2][3] == 0.0f &&
        m[3][0] == 0.0f && m[3][1] == 0.0f && m[3][2] == 0.0f && m[3][3] == 1.0f;
}

Vector VMatrix::ApplyRotation(const Vector &vVec) const {
    return VMul3x3(vVec);
}

/*VMatrix VMatrix::operator~() const {
    VMatrix mRet;
    InverseGeneral(mRet);
    return mRet;
}*/
