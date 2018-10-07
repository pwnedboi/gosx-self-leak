/******************************************************/
/**                                                  **/
/**      Features/Chams.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_Chams_h
#define Features_Chams_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Hooks/manager.h"

enum ChamMaterialType_t {
    CMAT_TYPE_NONE = 0,
    CMAT_TYPE_HID_TEX = 1,
    CMAT_TYPE_VIS_TEX = 2,
    CMAT_TYPE_HID_FLAT = 3,
    CMAT_TYPE_VIS_FLAT = 4,
    CMAT_TYPE_HID_TEX_WIRE = 5,
    CMAT_TYPE_VIS_TEX_WIRE = 6,
    CMAT_TYPE_HID_FLAT_WIRE = 7,
    CMAT_TYPE_VIS_FLAT_WIRE = 8,
    CMAT_TYPE_ALL_MODEL = 9,
    CMAT_TYPE_MAX = 10
};

namespace Features {
    class CChams {
    public:
        void DrawModelExecute(
            void* thisptr,
            IMatRenderContext* oriContext,
            const DrawModelState_t &oriState,
            const ModelRenderInfo_t &oriPInfo,
            matrix3x4_t *oriPCustomBoneToWorld
        );
        void SceneEnd();
        bool CanApply(const ModelRenderInfo_t &oriPInfo);
        bool CanApply(C_CSPlayer* PlayerEntity);
        void ApplyPlayerChams(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld);
        void ApplyArmChams(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld);
        void ApplyWeaponChams(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld);
        void ApplyWorldChams(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld);
    private:
        void CreateMaterials();
        void ForceMaterial(IMaterial* material, Color color, bool immune = false);
        IMaterial* CreateMaterial(std::string filename, std::string texture, bool ignorez, bool flat, bool gluelook, bool wireframed);
        IMaterial* GetMaterial(ChamMaterialType_t type);
        bool IsWallhackMaterial(ChamMaterialType_t type);
        void ApplyMaterial(void* thisptr, IMatRenderContext* oriContext, const DrawModelState_t &oriState, const ModelRenderInfo_t &oriPInfo, matrix3x4_t *oriPCustomBoneToWorld, ChamMaterialType_t type, Color ChamsColor, Color ChamsVisibleColor, bool IsImmune);
        IMaterial* visible_flat = nullptr;
        IMaterial* visible_tex = nullptr;
        IMaterial* hidden_flat = nullptr;
        IMaterial* hidden_tex = nullptr;
        IMaterial* visible_flat_wire = nullptr;
        IMaterial* visible_tex_wire = nullptr;
        IMaterial* hidden_flat_wire = nullptr;
        IMaterial* hidden_tex_wire = nullptr;

        C_CSPlayer* LocalPlayer = nullptr;
    };
}

extern std::shared_ptr<Features::CChams> Chams;

#endif /** !Features_Chams_h */
