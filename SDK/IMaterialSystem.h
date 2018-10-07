/******************************************************/
/**                                                  **/
/**      SDK/IMaterialSystem.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IMaterialSystem_h
#define SDK_IMaterialSystem_h

#include "IAppSystem.h"

#define TEXTURE_GROUP_LIGHTMAP                      "Lightmaps"
#define TEXTURE_GROUP_WORLD                         "World textures"
#define TEXTURE_GROUP_STATICPROP                    "StaticProp textures"
#define TEXTURE_GROUP_MODEL                         "Model textures"
#define TEXTURE_GROUP_VGUI                          "VGUI textures"
#define TEXTURE_GROUP_PARTICLE                      "Particle textures"
#define TEXTURE_GROUP_DECAL                         "Decal textures"
#define TEXTURE_GROUP_SKYBOX                        "SkyBox textures"
#define TEXTURE_GROUP_CLIENT_EFFECTS                "ClientEffect textures"
#define TEXTURE_GROUP_OTHER                         "Other textures"
#define TEXTURE_GROUP_PRECACHED                     "Precached"
#define TEXTURE_GROUP_CUBE_MAP                      "CubeMap textures"
#define TEXTURE_GROUP_RENDER_TARGET                 "RenderTargets"
#define TEXTURE_GROUP_UNACCOUNTED                   "Unaccounted textures"
#define TEXTURE_GROUP_STATIC_INDEX_BUFFER           "Static Indices"
#define TEXTURE_GROUP_STATIC_VERTEX_BUFFER_DISP     "Displacement Verts"
#define TEXTURE_GROUP_STATIC_VERTEX_BUFFER_COLOR    "Lighting Verts"
#define TEXTURE_GROUP_STATIC_VERTEX_BUFFER_WORLD    "World Verts"
#define TEXTURE_GROUP_STATIC_VERTEX_BUFFER_MODELS   "Model Verts"
#define TEXTURE_GROUP_STATIC_VERTEX_BUFFER_OTHER    "Other Verts"
#define TEXTURE_GROUP_DYNAMIC_INDEX_BUFFER          "Dynamic Indices"
#define TEXTURE_GROUP_DYNAMIC_VERTEX_BUFFER         "Dynamic Verts"
#define TEXTURE_GROUP_DEPTH_BUFFER                  "DepthBuffer"
#define TEXTURE_GROUP_VIEW_MODEL                    "ViewModel"
#define TEXTURE_GROUP_PIXEL_SHADERS                 "Pixel Shaders"
#define TEXTURE_GROUP_VERTEX_SHADERS                "Vertex Shaders"
#define TEXTURE_GROUP_RENDER_TARGET_SURFACE         "RenderTarget Surfaces"
#define TEXTURE_GROUP_MORPH_TARGETS                 "Morph Targets"

class IMaterial;

typedef unsigned short MaterialHandle_t;

class KeyValues;

struct MaterialVideoMode_t {
    int m_Width;
    int m_Height;
    int m_Format;
    int m_RefreshRate;
};

struct MaterialSystem_Config_t {
    MaterialVideoMode_t m_VideoMode;    // 0x10 + 0x00 = 0x10
    float m_fMonitorGamma;              // 0x04 + 0x10 = 0x14
    float m_fGammaTVRangeMin;           // 0x04 + 0x14 = 0x18
    float m_fGammaTVRangeMax;           // 0x04 + 0x18 = 0x1C
    float m_fGammaTVExponent;           // 0x04 + 0x1C = 0x20
    bool m_bGammaTVEnabled;             // 0x01 + 0x20 = 0x21
    bool m_bTripleBuffered;             // 0x01 + 0x21 = 0x22
    int m_nAASamples;                   // 0x04 + 0x22 = 0x26
    int m_nForceAnisotropicLevel;       // 0x04 + 0x26 = 0x2A
    int m_nSkipMipLevels;               // 0x04 + 0x2A = 0x2E
    int m_nDxSupportLevel;              // 0x04 + 0x2E = 0x32
    int m_nFlags;                       // 0x04 + 0x32 = 0x36
    bool m_bEditMode;                   // 0x01 + 0x36 = 0x37
    char m_nProxiesTestMode;            // 0x01 + 0x37 = 0x38
    bool m_bCompressedTextures;         // 0x01 + 0x38 = 0x39
    bool m_bFilterLightmaps;            // 0x01 + 0x39 = 0x3A
    bool m_bFilterTextures;             // 0x01 + 0x3A = 0x3B
    bool m_bReverseDepth;               // 0x01 + 0x3B = 0x3C
    bool m_bBufferPrimitives;           // 0x01 + 0x3C = 0x3D
    bool m_bDrawFlat;                   // 0x01 + 0x3D = 0x3E
    bool m_bMeasureFillRate;            // 0x01 + 0x3E = 0x3F
    bool m_bVisualizeFillRate;          // 0x01 + 0x3F = 0x40
    bool m_bNoTransparency;             // 0x01 + 0x40 = 0x41
    bool m_bSoftwareLighting;           // 0x01 + 0x41 = 0x42
    bool m_bAllowCheats;                // 0x01 + 0x42 = 0x43
    char m_nShowMipLevels;              // 0x01 + 0x43 = 0x44
    bool m_bShowLowResImage;            // 0x01 + 0x44 = 0x45
    bool m_bShowNormalMap;              // 0x01 + 0x45 = 0x46
    bool m_bMipMapTextures;             // 0x01 + 0x46 = 0x47
    char m_nFullbright;                 // 0x01 + 0x47 = 0x48
    bool m_bFastNoBump;                 // 0x01 + 0x48 = 0x49
    bool m_bSuppressRendering;          // 0x01 + 0x49 = 0x4A
    bool m_bDrawGray;                   // 0x01 + 0x4A = 0x4B
    bool m_bShowSpecular;               // 0x01 + 0x4B = 0x4C
    bool m_bShowDiffuse;                // 0x01 + 0x4C = 0x4D
    int m_nWindowedSizeLimitWidth;      // 0x04 + 0x4D = 0x51
    int m_nWindowedSizeLimitHeight;     // 0x04 + 0x51 = 0x55
    int m_nAAQuality;                   // 0x04 + 0x55 = 0x59
    bool m_bShadowDepthTexture;         // 0x01 + 0x59 = 0x6A
    bool m_bMotionBlur;                 // 0x01 + 0x6A = 0x6B
    bool m_bSupportFlashlight;          // 0x01 + 0x6B = 0x6C
    bool m_bPaintEnabled;               // 0x01 + 0x6C = 0x6D
    char pad[0xC];                      // 0x0C + 0x6D = 0x78
}; // Length 0x78

typedef IMaterial* (* FindMaterialFn)(void*, const char*, const char*, bool, const char*);
typedef MaterialHandle_t (* FirstMaterialFn)(void*);
typedef MaterialHandle_t (* NextMaterialFn)(void*, MaterialHandle_t);
typedef MaterialHandle_t (* InvalidMaterialFn)(void*);
typedef IMaterial* (* GetMaterialFn)(void*, MaterialHandle_t);
typedef IMaterial* (* CreateMaterialFn)(void*, const char*, KeyValues*);

class CMatRenderContext {
private:
    BYTE    __unknownbytes[0xc];
    void**    __pUnkTypeMaterial;
public:
    IClientRenderable* m_pRenderEntity;
};

class IMaterialSystem : public IAppSystem {
public:
    IMaterial* FindMaterial(const char* pMaterialName, const char* pTextureGroupName = "Model textures", bool complain = true, const char* pComplainPrefix = NULL) {
        return Interfaces::Function<FindMaterialFn>(this, 84)(this, pMaterialName, pTextureGroupName, complain, pComplainPrefix);
    }

    MaterialHandle_t FirstMaterial() {
        return Interfaces::Function<FirstMaterialFn>(this, 86)(this);
    }

    MaterialHandle_t NextMaterial(MaterialHandle_t h) {
        return Interfaces::Function<NextMaterialFn>(this, 87)(this, h);
    }

    MaterialHandle_t InvalidMaterial() {
        return Interfaces::Function<InvalidMaterialFn>(this, 88)(this);
    }

    IMaterial* GetMaterial(MaterialHandle_t h) {
        return Interfaces::Function<GetMaterialFn>(this, 89)(this, h);
    }

    IMaterial* CreateMaterial(const char* pMaterialName, KeyValues* pVMTKeyValues) {
        return Interfaces::Function<CreateMaterialFn>(this, 83)(this, pMaterialName, pVMTKeyValues);
    }
    
    CMatRenderContext* GetRenderContext() {
        typedef CMatRenderContext* (*GetRenderContextFn)(void*);
        return Interfaces::Function<GetRenderContextFn>(this, 115)(this);
    }
    
    C_BaseEntity* GetRenderingEntity() {
        CMatRenderContext* context = GetRenderContext();
        C_BaseEntity* dwEntity = (C_BaseEntity*)context->m_pRenderEntity;
        if (!dwEntity) {
            return nullptr;
        }

        return (C_BaseEntity*)((uintptr_t)dwEntity - 0x4);
    }
};

extern IMaterialSystem* MaterialSystem;

#endif /** !SDK_IMaterialSystem_h */
