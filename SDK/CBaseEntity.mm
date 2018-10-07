/******************************************************/
/**                                                  **/
/**      SDK/CBaseEntity.mm                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CBaseEntity.h"

int* C_BaseEntity::GetModelIndex() {
    return GetFieldPointer<int>(Offsets::DT_BaseEntity::m_nModelIndex);
}

void C_BaseEntity::SetModelIndex(int index) {
    typedef void (* oSetModelIndex)(void*, int);
    return Interfaces::Function<oSetModelIndex>(this, 111)(this, index);
}

bool C_BaseEntity::IsPlayer() {
    return (GetClientClass()->m_ClassID == EClassIds::CCSPlayer);
}

bool C_BaseEntity::IsChicken() {
    return (GetClientClass()->m_ClassID == EClassIds::CChicken);
}

bool C_BaseEntity::IsDefuseKit() {
    return (GetClientClass()->m_ClassID == EClassIds::CEconEntity);
}

bool C_BaseEntity::IsWeapon() {
    switch (GetClientClass()->m_ClassID) {
        case EClassIds::CAK47:
        case EClassIds::CDEagle:
        case EClassIds::CKnife:
        case EClassIds::CKnifeGG:
        case EClassIds::CSCAR17:
        case EClassIds::CWeaponAug:
        case EClassIds::CWeaponAWP:
        case EClassIds::CWeaponBizon:
        case EClassIds::CWeaponElite:
        case EClassIds::CWeaponFamas:
        case EClassIds::CWeaponFiveSeven:
        case EClassIds::CWeaponG3SG1:
        case EClassIds::CWeaponGalil:
        case EClassIds::CWeaponGalilAR:
        case EClassIds::CWeaponGlock:
        case EClassIds::CWeaponHKP2000:
        case EClassIds::CWeaponM249:
        case EClassIds::CWeaponM3:
        case EClassIds::CWeaponM4A1:
        case EClassIds::CWeaponMAC10:
        case EClassIds::CWeaponMag7:
        case EClassIds::CWeaponMP5Navy:
        case EClassIds::CWeaponMP7:
        case EClassIds::CWeaponMP9:
        case EClassIds::CWeaponNegev:
        case EClassIds::CWeaponNOVA:
        case EClassIds::CWeaponP228:
        case EClassIds::CWeaponP250:
        case EClassIds::CWeaponP90:
        case EClassIds::CWeaponSawedoff:
        case EClassIds::CWeaponSCAR20:
        case EClassIds::CWeaponScout:
        case EClassIds::CWeaponSG550:
        case EClassIds::CWeaponSG552:
        case EClassIds::CWeaponSG556:
        case EClassIds::CWeaponSSG08:
        case EClassIds::CWeaponTaser:
        case EClassIds::CWeaponTec9:
        case EClassIds::CWeaponTMP:
        case EClassIds::CWeaponUMP45:
        case EClassIds::CWeaponUSP:
        case EClassIds::CWeaponXM1014:
            return true;
            break;
        default:
            return false;
            break;
    }
}

bool C_BaseEntity::IsBomb() {
    return (GetClientClass()->m_ClassID == EClassIds::CC4);
}

bool C_BaseEntity::IsPlantedBomb() {
    return (GetClientClass()->m_ClassID == EClassIds::CPlantedC4);
}

bool C_BaseEntity::IsGrenade() {
    EClassIds ClassID = (EClassIds)GetClientClass()->m_ClassID;
    switch (ClassID) {
        case EClassIds::CDecoyGrenade:
        case EClassIds::CFlashbang:
        case EClassIds::CHEGrenade:
        case EClassIds::CMolotovGrenade:
        case EClassIds::CIncendiaryGrenade:
        case EClassIds::CSmokeGrenade:
        case EClassIds::CBaseCSGrenadeProjectile:
        case EClassIds::CBaseCSGrenade:
            return true;
            break;
        default:
            return false;
            break;
    }
}

bool C_BaseEntity::IsHostage() {
    return (GetClientClass()->m_ClassID == EClassIds::CHostage);
}

bool C_BaseEntity::IsGlowEntity() {
    return (
            IsPlantedBomb()
    );
}

ICollideable* C_BaseEntity::Collideable() {
    return GetFieldPointer<ICollideable>(Offsets::DT_BaseEntity::m_Collision);
}

Vector* C_BaseEntity::GetOrigin() {
    return GetFieldPointer<Vector>(Offsets::DT_BaseEntity::m_vecOrigin);
}

Vector C_BaseEntity::GetVecMins() {
    return GetFieldValue<Vector>(Offsets::DT_BaseEntity::m_vecMins);
}

Vector C_BaseEntity::GetVecMaxs() {
    return GetFieldValue<Vector>(Offsets::DT_BaseEntity::m_vecMaxs);
}

matrix3x4_t C_BaseEntity::GetRgflCoordinateFrame() {
    return GetFieldValue<matrix3x4_t>(Offsets::DT_BaseEntity::m_CollisionGroup - 0x30);
}

bool* C_BaseEntity::ShouldGlow() {
    return GetFieldPointer<bool>(Offsets::DT_DynamicProp::m_bShouldGlow);
}

C_BaseViewModel* C_BaseEntity::GetViewModel() {
    return (C_BaseViewModel*)EntList->GetClientEntityFromHandle(this->GetFieldValue<CBaseHandle>(Offsets::DT_BasePlayer::m_hViewModel));
}
