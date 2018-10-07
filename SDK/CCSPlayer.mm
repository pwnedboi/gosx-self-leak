/******************************************************/
/**                                                  **/
/**      SDK/CCSPlayer.mm                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CCSPlayer.h"

////////////////////////////////////////////
// C_BaseCombatWeapon                     //
////////////////////////////////////////////

C_CSPlayer* C_BaseCombatWeapon::GetOwner() {
    return (C_CSPlayer*)EntList->GetClientEntityFromHandle(
        GetFieldValue<CHandle<C_CSPlayer>>(Offsets::DT_BaseCombatWeapon::m_hOwner)
    );
}

float C_BaseCombatWeapon::NextPrimaryAttack() {
    return GetFieldValue<float>(Offsets::DT_BaseCombatWeapon::m_flNextPrimaryAttack);
}

short C_BaseCombatWeapon::EntityId() {
    return GetFieldValue<short>(Offsets::DT_BaseAttributableItem::m_iItemDefinitionIndex);
}

int C_BaseCombatWeapon::GetAmmo() {
    return GetFieldValue<int>(Offsets::DT_BaseCombatWeapon::m_iClip1);
}

int* C_BaseCombatWeapon::GetViewModelIndex() {
    return GetFieldPointer<int>(Offsets::DT_BaseCombatWeapon::m_iViewModelIndex);
}

C_BaseWorldModel* C_BaseCombatWeapon::GetWorldModel() {
    return (C_BaseWorldModel*)EntList->GetClientEntityFromHandle(
        GetFieldValue<CHandle<IClientEntity>>(Offsets::DT_BaseCombatWeapon::m_hWeaponWorldModel)
    );
}

WeaponCSInfo_t* C_BaseCombatWeapon::GetCSWpnData() {
    typedef WeaponCSInfo_t* (*oGetCSWpnData)(void*);
    return Interfaces::Function<oGetCSWpnData>(this, 512)(this);
}

float C_BaseCombatWeapon::GetSpread() {
    typedef float(*oGetSpread)(void*);
    return Interfaces::Function<oGetSpread>(this, 504)(this);
}

float C_BaseCombatWeapon::GetInaccuracy() {
    typedef float(*oGetInaccuracy)(void*);
    return Interfaces::Function<oGetInaccuracy>(this, 535)(this);
}

C_BaseCombatWeapon* C_BaseCombatWeapon::UpdateAccuracyPenalty() {
    typedef void(*oUpdateAccuracyPenalty)(void*);
    Interfaces::Function<oUpdateAccuracyPenalty>(this, 536)(this);
    
    return this;
}

bool C_BaseCombatWeapon::CanShoot() {
    return GetAmmo() > 0;
}

float C_BaseCombatWeapon::GetPostponeFireReadyTime() {
    return GetFieldValue<float>(Offsets::DT_WeaponCSBase::m_flPostponeFireReadyTime);
}

std::string C_BaseCombatWeapon::GetGunIcon() {
    return WeaponManager::GetWeaponIcon(EntityId());
}

////////////////////////////////////////////
// C_BaseAttributableItem                 //
////////////////////////////////////////////

int* C_BaseAttributableItem::GetAccountID() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_iAccountID);
}

short* C_BaseAttributableItem::GetItemDefinitionIndex() {
    return GetFieldPointer<short>(Offsets::DT_BaseAttributableItem::m_iItemDefinitionIndex);
}

int* C_BaseAttributableItem::GetItemIDHigh() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_iItemIDHigh);
}

int* C_BaseAttributableItem::GetItemIDLow() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_iItemIDLow);
}

int* C_BaseAttributableItem::GetEntityQuality() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_iEntityQuality);
}

char* C_BaseAttributableItem::GetCustomName() {
    return GetFieldPointer<char>(Offsets::DT_BaseAttributableItem::m_szCustomName);
}

int* C_BaseAttributableItem::GetFallbackPaintKit() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_nFallbackPaintKit);
}

int* C_BaseAttributableItem::GetFallbackSeed() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_nFallbackSeed);
}

float* C_BaseAttributableItem::GetFallbackWear() {
    return GetFieldPointer<float>(Offsets::DT_BaseAttributableItem::m_flFallbackWear);
}

int* C_BaseAttributableItem::GetFallbackStatTrak() {
    return GetFieldPointer<int>(Offsets::DT_BaseAttributableItem::m_nFallbackStatTrak);
}

bool* C_BaseAttributableItem::IsInitialized() {
    return GetFieldPointer<bool>(Offsets::DT_BaseAttributableItem::m_bInitialized);
}

int* C_BaseAttributableItem::GetIndex() {
    return GetFieldPointer<int>(Offsets::DT_BaseEntity::m_bIsAutoaimTarget + 0x4);
}

////////////////////////////////////////////
// C_CSPlayer                             //
////////////////////////////////////////////

C_CSPlayer* C_CSPlayer::GetLocalPlayer() {
    return (C_CSPlayer*)EntList->GetClientEntity(Engine->GetLocalPlayer());
}

C_CSPlayer* C_CSPlayer::GetEntity(int index) {
    return (C_CSPlayer*)EntList->GetClientEntity(index);
}

bool C_CSPlayer::IsValidLivePlayer() {
    return !IsDormant() && IsAlive();
}

C_BaseCombatWeapon* C_CSPlayer::GetActiveWeapon() {
    return (C_BaseCombatWeapon*)EntList->GetClientEntityFromHandle(
        GetFieldValue<CHandle<IClientEntity>>(Offsets::DT_BaseCombatCharacter::m_hActiveWeapon)
    );
}

int* C_CSPlayer::GetWearables() {
    return GetFieldPointer<int>(Offsets::DT_BaseCombatCharacter::m_hMyWearables);
}

int* C_CSPlayer::GetWeapons() {
    return GetFieldPointer<int>(Offsets::DT_BaseCombatCharacter::m_hMyWeapons);
}

CBaseHandle C_CSPlayer::GetViewModelHandle() {
    return GetFieldValue<CBaseHandle>(Offsets::DT_BasePlayer::m_hViewModel);
}

int C_CSPlayer::GetHealth() {
    return GetFieldValue<int>(Offsets::DT_BasePlayer::m_iHealth);
}

int C_CSPlayer::GetArmor() {
    return GetFieldValue<int>(Offsets::DT_CSPlayer::m_ArmorValue);
}

bool C_CSPlayer::HasHelmet() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bHasHelmet);
}

bool C_CSPlayer::HasDefuser() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bHasDefuser);
}

bool C_CSPlayer::IsAlive() {
    return GetFieldValue<int>(Offsets::DT_BasePlayer::m_lifeState) == (int)LifeState::LIFE_ALIVE;
}

int C_CSPlayer::GetTeamNum() {
    return GetFieldValue<int>(Offsets::DT_BaseEntity::m_iTeamNum);
}

int* C_CSPlayer::GetFlags() {
    return GetFieldPointer<int>(Offsets::DT_BasePlayer::m_fFlags);
}

bool C_CSPlayer::IsScoped() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bIsScoped);
}

float C_CSPlayer::GetFlashDuration() {
    return GetFieldValue<float>(Offsets::DT_CSPlayer::m_flFlashDuration);
}

bool C_CSPlayer::IsFlashed() {
    return GetFlashDuration() > 0 ? true : false;
}

Vector C_CSPlayer::GetViewOffset() {
    return GetFieldValue<Vector>(Offsets::DT_BasePlayer::m_vecViewOffset);
}

Vector C_CSPlayer::GetEyePos(bool predict) {
    if (!predict) {
        return GetViewOffset() + *GetOrigin();
    }
    return GetPredictedPosition(GetViewOffset() + *GetOrigin());
}

QAngle* C_CSPlayer::GetEyeAngles() {
    return GetFieldPointer<QAngle>(Offsets::DT_CSPlayer::m_angEyeAngles);
}

Vector C_CSPlayer::GetViewAngle() {
    return GetFieldValue<Vector>(Offsets::DT_BaseEntity::m_angRotation);
}

Vector C_CSPlayer::ViewPunch() {
    return GetFieldValue<Vector>(Offsets::DT_BasePlayer::m_viewPunchAngle);
}

Vector C_CSPlayer::AimPunch() {
    return GetFieldValue<Vector>(Offsets::DT_BasePlayer::m_aimPunchAngle);
}

Vector* C_CSPlayer::PtrViewPunch() {
    return GetFieldPointer<Vector>(Offsets::DT_BasePlayer::m_viewPunchAngle);
}

Vector* C_CSPlayer::PtrAimPunch() {
    return GetFieldPointer<Vector>(Offsets::DT_BasePlayer::m_aimPunchAngle);
}

Vector C_CSPlayer::GetVelocity() {
    return GetFieldValue<Vector>(Offsets::DT_BasePlayer::m_vecVelocity);
}

Vector C_CSPlayer::GetPredictedPosition(int Hitbox, Vector &vMin, Vector &vMax) {
    return Math::ExtrapolateTick(this->GetHitboxPosition(Hitbox, vMin, vMax), this->GetVelocity());
}

Vector C_CSPlayer::GetPredictedPosition(Vector HitboxPosition) {
    return Math::ExtrapolateTick(HitboxPosition, this->GetVelocity());
}

int C_CSPlayer::GetShotsFired() {
    return GetFieldValue<int>(Offsets::DT_CSPlayer::m_iShotsFired);
}

int C_CSPlayer::GetGlowIndex() {
    return GetFieldValue<int>(Offsets::DT_CSPlayer::m_flFlashDuration + 0x18);
}

bool C_CSPlayer::IsImmune() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bGunGameImmunity);
}

MoveType_t C_CSPlayer::GetMoveType() {
    return GetFieldValue<MoveType_t>(Offsets::DT_BaseEntity::m_nRenderMode + 0x1);
}

float* C_CSPlayer::GetMaxFlashAlpha() {
    return GetFieldPointer<float>(Offsets::DT_CSPlayer::m_flFlashMaxAlpha);
}

unsigned int C_CSPlayer::GetTickBase() {
    return GetFieldValue<unsigned int>(Offsets::DT_BasePlayer::m_nTickBase);
}

bool C_CSPlayer::IsDefusingBomb() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bIsDefusing);
}

Vector C_CSPlayer::GetHitboxPosition(int Hitbox, Vector &vMin, Vector &vMax) {
    static matrix3x4_t matrix[MAX_STUDIO_BONES];
    if (!this->SetupBones(matrix, MAX_STUDIO_BONES, BONE_USED_BY_HITBOX, this->GetSimulationTime())) {
        return Vector(0, 0, 0);
    }
    
    studiohdr_t* hdr = ModelInfo->GetStudioModel(this->GetModel());
    mstudiohitboxset_t* set = hdr->pHitboxSet(0);
    mstudiobbox_t* hitbox = set->pHitbox(Hitbox);
    if (!hitbox) {
        return Vector(0, 0, 0);
    }
    
    Vector vCenter;
    Math::VectorTransform(hitbox->bbmin, matrix[hitbox->bone], vMin);
    Math::VectorTransform(hitbox->bbmax, matrix[hitbox->bone], vMax);
    
    vCenter = (vMin + vMax) * 0.50f;

    return vCenter;
}

Vector C_CSPlayer::GetBonePosition(int BoneID) {
    static matrix3x4_t matrix[MAX_STUDIO_BONES];
    if (!this->SetupBones(matrix, MAX_STUDIO_BONES, BONE_USED_BY_HITBOX, this->GetSimulationTime())) {
        return Vector(0, 0, 0);
    }
    
    return {matrix[BoneID].m_flMatVal[0][3], matrix[BoneID].m_flMatVal[1][3], matrix[BoneID].m_flMatVal[2][3]};
}

bool C_CSPlayer::IsOnGround() {
    return *GetFlags() & (int)EntityFlags::FL_ONGROUND;
}

C_CSPlayer* C_CSPlayer::GetObserverTarget() {
    return (C_CSPlayer*)EntList->GetClientEntityFromHandle(
        GetFieldValue<CHandle<IClientEntity>>(
            Offsets::DT_BasePlayer::m_hObserverTarget
        )
    );
}

int* C_CSPlayer::GetObserverMode() {
    return GetFieldPointer<int>(
        Offsets::DT_BasePlayer::m_iObserverMode
    );
}

C_CSPlayer* C_CSPlayer::PVSFix() {
    *GetFieldPointer<int>(0xFEC) = (*GlobalVars)->framecount;
    *GetFieldPointer<int>(0xFE4) = 0;
    
    return this;
}

float* C_CSPlayer::GetLowerBodyYawTarget() {
    return GetFieldPointer<float>(Offsets::DT_CSPlayer::m_flLowerBodyYawTarget);
}

bool C_CSPlayer::IsMoving() {
    return GetFieldValue<bool>(0x110);
}

bool C_CSPlayer::HasHeavyArmor() {
    return GetFieldValue<bool>(Offsets::DT_CSPlayer::m_bHasHeavyArmor);
}

Vector C_CSPlayer::WorldSpaceCenter() {
    Vector Max = this->GetCollideable()->OBBMins() + *this->GetOrigin();
    Vector Min = this->GetCollideable()->OBBMins() + *this->GetOrigin();
    Vector Size = Max - Min;
    Size /= 2;
    Size += Min;
    return Size;
}

#ifdef GOSX_THIRDPERSON
QAngle* C_CSPlayer::ThirdpersonAngle() {
    return GetFieldPointer<QAngle>(Offsets::DT_BasePlayer::deadflag + 0x4);
}
#endif

float C_CSPlayer::GetSimulationTime() {
    return GetFieldValue<float>(Offsets::DT_BaseEntity::m_flSimulationTime);
}

bool* C_CSPlayer::Spotted() {
    return GetFieldPointer<bool>(Offsets::DT_BaseEntity::m_bSpotted);
}

const char* C_CSPlayer::GetClan() {
    return (*PlayerResource)->GetClan(this->EntIndex());
}

////////////////////////////////////////////
// C_PlantedC4                            //
////////////////////////////////////////////

C_PlantedC4* C_PlantedC4::GetPlantedBomb() {
    for (int i = Engine->GetMaxClients(); i < EntList->GetHighestEntityIndex(); i++) {
        C_BaseEntity* entity = (C_BaseEntity*)EntList->GetClientEntity(i);
        if (!entity || entity->IsDormant()) {
            continue;
        }
        
        if (entity->GetClientClass()->m_ClassID == EClassIds::CPlantedC4) {
            return (C_PlantedC4*)entity;
        }
    }
    
    return nullptr;
}

C_CSPlayer* C_PlantedC4::GetBombDefuser() {
    return (C_CSPlayer*)EntList->GetClientEntityFromHandle(
        GetFieldValue<CHandle<IClientEntity>>(Offsets::DT_PlantedC4::m_hBombDefuser)
    );
}

bool C_PlantedC4::IsBombTicking() {
    return GetFieldValue<bool>(Offsets::DT_PlantedC4::m_bBombTicking);
}

float C_PlantedC4::GetC4Blow() {
    return GetFieldValue<float>(Offsets::DT_PlantedC4::m_flC4Blow);
}

bool C_PlantedC4::IsBombDefused() {
    return GetFieldValue<bool>(Offsets::DT_PlantedC4::m_bBombDefused);
}

float C_PlantedC4::GetTimerLength() {
    return GetFieldValue<float>(Offsets::DT_PlantedC4::m_flTimerLength);
}

////////////////////////////////////////////
// C_WeaponC4                             //
////////////////////////////////////////////

C_WeaponC4* C_WeaponC4::GetBomb() {
    for (int i = Engine->GetMaxClients(); i < EntList->GetHighestEntityIndex(); i++) {
        C_BaseEntity* entity = (C_BaseEntity*)EntList->GetClientEntity(i);
        if (!entity || entity->IsDormant()) {
            continue;
        }
        
        if (entity->GetClientClass()->m_ClassID == EClassIds::CC4) {
            return (C_WeaponC4*)entity;
        }
    }
    
    return nullptr;
}

////////////////////////////////////////////
// C_BaseViewModel                        //
////////////////////////////////////////////

CBaseHandle C_BaseViewModel::GetOwner() {
    return GetFieldValue<CBaseHandle>(Offsets::DT_BaseViewModel::m_hOwner);
}

int C_BaseViewModel::GetWeapon() {
    return GetFieldValue<int>(Offsets::DT_BaseViewModel::m_hWeapon);
}
