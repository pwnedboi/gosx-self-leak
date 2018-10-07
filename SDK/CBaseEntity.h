/******************************************************/
/**                                                  **/
/**      SDK/CBaseEntity.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CBaseEntity_h
#define SDK_CBaseEntity_h

#include "IClientEntity.h"
#include "NetworkableReader.h"

class C_BaseViewModel;

class C_BaseEntity : public IClientEntity, public NetworkableReader {
public:
    int* GetModelIndex();
    void SetModelIndex(int index);
    bool IsPlayer();
    bool IsChicken();
    bool IsDefuseKit();
    bool IsWeapon();
    bool IsBomb();
    bool IsPlantedBomb();
    bool IsGrenade();
    bool IsHostage();
    bool IsGlowEntity();
    ICollideable* Collideable();
    Vector* GetOrigin();
    Vector GetVecMins();
    Vector GetVecMaxs();
    matrix3x4_t GetRgflCoordinateFrame();
    bool* ShouldGlow();
    C_BaseViewModel* GetViewModel();
};

#endif /** !SDK_CBaseEntity_h */
