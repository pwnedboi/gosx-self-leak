/******************************************************/
/**                                                  **/
/**      SDK/IVModelRender.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IVModelRender_h
#define SDK_IVModelRender_h

#include "IMaterial.h"

typedef unsigned short ModelInstanceHandle_t;
struct model_t {
    char name[255];
};

enum OverrideType_t {
    OVERRIDE_NORMAL = 0,
    OVERRIDE_BUILD_SHADOWS,
    OVERRIDE_DEPTH_WRITE,
    OVERRIDE_SSAO_DEPTH_WRITE,
};

struct ModelRenderInfo_t {
    Vector origin;
    QAngle angles;
    char pad[0x4];
    void *pRenderable;
    const model_t *pModel;
    const matrix3x4_t* pModelToWorld;
    const matrix3x4_t* pLightingOffset;
    const Vector *pLightingOrigin;
    int flags;
    int entity_index;
    int skin;
    int body;
    int hitboxset;
    ModelInstanceHandle_t instance;
    ModelRenderInfo_t() {
        pModelToWorld = NULL;
        pLightingOffset = NULL;
        pLightingOrigin = NULL;
    }
};

class IMatRenderContext;
struct DrawModelState_t;

typedef void(* ForcedMaterialOverrideFn)(void*, IMaterial*, OverrideType_t, int);
typedef bool(* IsForcedMaterialOverrideFn)(void);
typedef void(* DrawModelExecuteFn)(void*, IMatRenderContext*, const DrawModelState_t&, const ModelRenderInfo_t&, matrix3x4_t*);

class IVModelRender {
    public:
    void ForcedMaterialOverride(IMaterial* newMaterial, OverrideType_t nOverrideType = OVERRIDE_NORMAL, int unk = 0) {
        Interfaces::Function<ForcedMaterialOverrideFn>(this, 1)(this, newMaterial, nOverrideType, unk);
    }
    
    bool IsForcedMaterialOverride() {
        return Interfaces::Function<IsForcedMaterialOverrideFn>(this, 2)();
    }

    void DrawModelExecute(IMatRenderContext* matctx, const DrawModelState_t &state, const ModelRenderInfo_t &pInfo, matrix3x4_t* pCustomBoneToWorld) {
        Interfaces::Function<DrawModelExecuteFn>(this, 21)(this, matctx, state, pInfo, pCustomBoneToWorld);
    }
};

extern IVModelRender* ModelRender;

#endif /** !SDK_IVModelRender_h */
