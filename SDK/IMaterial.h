/******************************************************/
/**                                                  **/
/**      SDK/IMaterial.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-16                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IMaterial_h
#define SDK_IMaterial_h

#include "IMaterialSystem.h"

class IMaterialVar;
class ITexture;
class IMaterialProxy;
class Vector;

enum MaterialPropertyTypes_t {
    MATERIAL_PROPERTY_NEEDS_LIGHTMAP = 0,					// bool
    MATERIAL_PROPERTY_OPACITY,								// int (enum MaterialPropertyOpacityTypes_t)
    MATERIAL_PROPERTY_REFLECTIVITY,							// vec3_t
    MATERIAL_PROPERTY_NEEDS_BUMPED_LIGHTMAPS				// bool
};

enum ImageFormat {
    IMAGE_FORMAT_UNKNOWN = -1,
    IMAGE_FORMAT_RGBA8888 = 0,
    IMAGE_FORMAT_ABGR8888,
    IMAGE_FORMAT_RGB888,
    IMAGE_FORMAT_BGR888,
    IMAGE_FORMAT_RGB565,
    IMAGE_FORMAT_I8,
    IMAGE_FORMAT_IA88,
    IMAGE_FORMAT_P8,
    IMAGE_FORMAT_A8,
    IMAGE_FORMAT_RGB888_BLUESCREEN,
    IMAGE_FORMAT_BGR888_BLUESCREEN,
    IMAGE_FORMAT_ARGB8888,
    IMAGE_FORMAT_BGRA8888,
    IMAGE_FORMAT_DXT1,
    IMAGE_FORMAT_DXT3,
    IMAGE_FORMAT_DXT5,
    IMAGE_FORMAT_BGRX8888,
    IMAGE_FORMAT_BGR565,
    IMAGE_FORMAT_BGRX5551,
    IMAGE_FORMAT_BGRA4444,
    IMAGE_FORMAT_DXT1_ONEBITALPHA,
    IMAGE_FORMAT_BGRA5551,
    IMAGE_FORMAT_UV88,
    IMAGE_FORMAT_UVWQ8888,
    IMAGE_FORMAT_RGBA16161616F,
    IMAGE_FORMAT_RGBA16161616,
    IMAGE_FORMAT_UVLX8888,
    IMAGE_FORMAT_R32F,			// Single-channel 32-bit floating point
    IMAGE_FORMAT_RGB323232F,	// NOTE: D3D9 does not have this format
    IMAGE_FORMAT_RGBA32323232F,
    IMAGE_FORMAT_RG1616F,
    IMAGE_FORMAT_RG3232F,
    IMAGE_FORMAT_RGBX8888,
    IMAGE_FORMAT_NULL,			// Dummy format which takes no video memory
    IMAGE_FORMAT_ATI2N,			// One-surface ATI2N / DXN format
    IMAGE_FORMAT_ATI1N,			// Two-surface ATI1N format
    IMAGE_FORMAT_RGBA1010102,	// 10 bit-per component render targets
    IMAGE_FORMAT_BGRA1010102,
    IMAGE_FORMAT_R16F,			// 16 bit FP format
    IMAGE_FORMAT_D16,
    IMAGE_FORMAT_D15S1,
    IMAGE_FORMAT_D32,
    IMAGE_FORMAT_D24S8,
    IMAGE_FORMAT_LINEAR_D24S8,
    IMAGE_FORMAT_D24X8,
    IMAGE_FORMAT_D24X4S4,
    IMAGE_FORMAT_D24FS8,
    IMAGE_FORMAT_D16_SHADOW,	// Specific formats for shadow mapping
    IMAGE_FORMAT_D24X8_SHADOW,	// Specific formats for shadow mapping
    IMAGE_FORMAT_LINEAR_BGRX8888,
    IMAGE_FORMAT_LINEAR_RGBA8888,
    IMAGE_FORMAT_LINEAR_ABGR8888,
    IMAGE_FORMAT_LINEAR_ARGB8888,
    IMAGE_FORMAT_LINEAR_BGRA8888,
    IMAGE_FORMAT_LINEAR_RGB888,
    IMAGE_FORMAT_LINEAR_BGR888,
    IMAGE_FORMAT_LINEAR_BGRX5551,
    IMAGE_FORMAT_LINEAR_I8,
    IMAGE_FORMAT_LINEAR_RGBA16161616,
    IMAGE_FORMAT_LE_BGRX8888,
    IMAGE_FORMAT_LE_BGRA8888,
    NUM_IMAGE_FORMATS
};

typedef uint64_t VertexFormat_t;

#define MATERIAL_VAR_DEBUG                      0x0001
#define MATERIAL_VAR_NO_DEBUG_OVERRIDE          0x0002
#define MATERIAL_VAR_NO_DRAW                    0x0004
#define MATERIAL_VAR_USE_IN_FILLRATE_MODE       0x0008
#define MATERIAL_VAR_VERTEXCOLOR                0x0010
#define MATERIAL_VAR_VERTEXALPHA                0x0020
#define MATERIAL_VAR_SELFILLUM                  0x0040
#define MATERIAL_VAR_ADDITIVE                   0x0080
#define MATERIAL_VAR_ALPHATEST                  0x0100
#define MATERIAL_VAR_MULTIPASS                  0x0200
#define MATERIAL_VAR_ZNEARER                    0x0400
#define MATERIAL_VAR_MODEL                      0x0800
#define MATERIAL_VAR_FLAT                       0x1000
#define MATERIAL_VAR_NOCULL                     0x2000
#define MATERIAL_VAR_NOFOG                      0x4000
#define MATERIAL_VAR_IGNOREZ                    0x8000
#define MATERIAL_VAR_DECAL                      0x10000
#define MATERIAL_VAR_ENVMAPSPHERE               0x20000
#define MATERIAL_VAR_NOALPHAMOD                 0x40000
#define MATERIAL_VAR_ENVMAPCAMERASPACE          0x80000
#define MATERIAL_VAR_BASEALPHAENVMAPMASK        0x100000
#define MATERIAL_VAR_TRANSLUCENT                0x200000
#define MATERIAL_VAR_NORMALMAPALPHAENVMAPMASK   0x400000
#define MATERIAL_VAR_NEEDS_SOFTWARE_SKINNING    0x800000
#define MATERIAL_VAR_OPAQUETEXTURE              0x1000000
#define MATERIAL_VAR_ENVMAPMODE                 0x2000000
#define MATERIAL_VAR_SUPPRESS_DECALS            0x4000000
#define MATERIAL_VAR_HALFLAMBERT                0x8000000
#define MATERIAL_VAR_WIREFRAME                  0x10000000
#define MATERIAL_VAR_ALLOWALPHATOCOVERAGE       0x20000000
#define MATERIAL_VAR_IGNORE_ALPHA_MODULATION    0x40000000

enum PreviewImageRetVal_t {
    MATERIAL_PREVIEW_IMAGE_BAD = 0,
    MATERIAL_PREVIEW_IMAGE_OK,
    MATERIAL_NO_PREVIEW_IMAGE,
};

class IMaterial {
public:
    virtual const char *	GetName() const = 0;
    virtual const char *	GetTextureGroupName() const = 0;
    virtual PreviewImageRetVal_t GetPreviewImageProperties(int *width, int *height, ImageFormat *imageFormat, bool* isTranslucent) const = 0;
    virtual PreviewImageRetVal_t GetPreviewImage(unsigned char *data, int width, int height, ImageFormat imageFormat) const = 0;
    virtual int				GetMappingWidth() = 0;
    virtual int				GetMappingHeight() = 0;
    virtual int				GetNumAnimationFrames() = 0;
    virtual bool			InMaterialPage(void) = 0;
    virtual	void			GetMaterialOffset(float *pOffset) = 0;
    virtual void			GetMaterialScale(float *pScale) = 0;
    virtual IMaterial		*GetMaterialPage(void) = 0;
    virtual IMaterialVar *	FindVar(const char *varName, bool *found, bool complain = true) = 0;
    virtual void			IncrementReferenceCount(void) = 0;
    virtual void			DecrementReferenceCount(void) = 0;
    inline void AddRef() { IncrementReferenceCount(); }
    inline void Release() { DecrementReferenceCount(); }
    virtual int 			GetEnumerationID(void) const = 0;
    virtual void			GetLowResColorSample(float s, float t, float *color) const = 0;
    virtual void			RecomputeStateSnapshots() = 0;
    virtual bool			IsTranslucent() = 0;
    virtual bool			IsAlphaTested() = 0;
    virtual bool			IsVertexLit() = 0;
    virtual VertexFormat_t	GetVertexFormat() const = 0;
    virtual bool			HasProxy(void) const = 0;
    virtual bool			UsesEnvCubemap(void) = 0;
    virtual bool			NeedsTangentSpace(void) = 0;
    virtual bool			NeedsPowerOfTwoFrameBufferTexture(bool bCheckSpecificToThisFrame = true) = 0;
    virtual bool			NeedsFullFrameBufferTexture(bool bCheckSpecificToThisFrame = true) = 0;
    virtual bool			NeedsSoftwareSkinning(void) = 0;
    virtual void			AlphaModulate(float alpha) = 0;
    virtual void			ColorModulate(float r, float g, float b) = 0;
    virtual void			SetMaterialVarFlag(unsigned int flag, bool on) = 0;
    virtual bool			GetMaterialVarFlag(unsigned int flag) = 0;
    virtual void			GetReflectivity(Vector& reflect) = 0;
    virtual bool			GetPropertyFlag(MaterialPropertyTypes_t type) = 0;
    virtual bool			IsTwoSided() = 0;
    virtual void			SetShader(const char *pShaderName) = 0;
    virtual int				GetNumPasses(void) = 0;
    virtual int				GetTextureMemoryBytes(void) = 0;
    virtual void			Refresh() = 0;
    virtual bool			NeedsLightmapBlendAlpha(void) = 0;
    virtual bool			NeedsSoftwareLighting(void) = 0;
    virtual int				ShaderParamCount() const = 0;
    virtual IMaterialVar	**GetShaderParams(void) = 0;
    virtual bool			IsErrorMaterial() const = 0;
    virtual void			Unused() = 0;
    virtual float			GetAlphaModulation() = 0;
    virtual void			GetColorModulation(float *r, float *g, float *b) = 0;
    virtual bool			IsTranslucentUnderModulation(float fAlphaModulation = 1.0f) const = 0;
    virtual IMaterialVar *	FindVarFast(char const *pVarName, unsigned int *pToken) = 0;
    virtual void			SetShaderAndParams(void *pKeyValues) = 0;
    virtual const char *	GetShaderName() const = 0;
    virtual void			DeleteIfUnreferenced() = 0;
    virtual bool			IsSpriteCard() = 0;
    virtual void			CallBindProxy(void *proxyData) = 0;
    virtual void			RefreshPreservingMaterialVars() = 0;
    virtual bool			WasReloadedFromWhitelist() = 0;
    virtual bool			SetTempExcluded(bool bSet, int nExcludedDimensionLimit) = 0;
    virtual int				GetReferenceCount() const = 0;
};

#endif /** !SDK_IMaterial_h */
