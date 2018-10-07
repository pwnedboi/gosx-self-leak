/******************************************************/
/**                                                  **/
/**      Hooks/manager.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_manager_h
#define Hooks_manager_h

#include "Engine/common.h"
#include "SDK/Thirdparty/DynSkin.h"

#include "PaintTraverse.h"
#include "CreateMove.h"
#include "FrameStageNotify.h"
#include "Events.h"
#include "OverrideConfig.h"
#include "OverrideView.h"
#include "SequenceProxy.h"
#include "DoPostScreenSpaceEffects.h"
#include "BeginFrame.h"

#include "Engine/Netvars/manager.h"

extern DrawModelExecuteFn oDrawModelExecute;

namespace HookManager {
    void InitializeHooks();
    void InitializeVMTs();
    void InitializeInterfaces();
    bool InitializeConfigs();
    void Initialize();

    typedef void(*PaintTraverseFn)              (void*, VPANEL, bool, bool);
    typedef void(*FrameStageNotifyFn)           (void*, ClientFrameStage_t);
    typedef bool(*CreateMoveFn)                 (void*, float, CUserCmd*);
    typedef void(*OverrideViewFn)               (void*, CViewSetup*);
    typedef  int(*KeyEventFn)                   (void*, int, int, const char*);
    typedef void(*OnScreenSizeChangedFn)        (void*, int, int);
    // typedef void(*SceneEndFn)                   (void*);
    typedef bool(*OverrideConfigFn)             (void*, MaterialSystem_Config_t*, bool);
    typedef void(*SetKeyCodeStateFn)            (void*, ButtonCode_t, bool);
    typedef void(*SetMouseCodeStateFn)          (void*, ButtonCode_t, MouseCodeState_t);
    typedef  int(*PumpWindowMessageLoopFn)      (void*);
#ifdef GOSX_OVERWATCH_REVEAL
    typedef void*(*ReadPacketFn)                (void*);
    typedef void(*HudUpdateFn)                  (void*, bool);
#endif
    typedef void(*SDLSwapWindowFn)              (SDL_Window*);
    typedef void(*SDLPollEventFn)               (SDL_Event*);
    typedef void(*LockCursorFn)                 (void*);
    typedef void(*PlaySoundFn)                  (void*, const char*);
#ifdef GOSX_STREAM_PROOF
    typedef CGLError(*FlushDrawableFn)          (CGLContextObj);
#endif
#ifdef GOSX_AUTO_ACCEPT
    typedef void(*EmitSoundFn)                  (void*, IRecipientFilter&, int, int, const char*, unsigned int, const char*, float, int, soundlevel_t, int, int, const Vector*, const Vector*, void*, bool, float, int, void*);
#endif
#ifdef GOSX_RAGE_MODE
    typedef void(*BeginFrameFn)                 (void*, float);
#endif
    typedef bool(*DoPostScreenSpaceEffectsFn)   (void*, CViewSetup*);

    void HOOKED_PaintTraverse(void* thisptr, VPANEL vguiPanel, bool forceRepaint, bool allowForce);
    void HOOKED_FrameStageNotify(void* thisptr, ClientFrameStage_t curStage);
    void HOOKED_DrawModelExecute(void* thisptr, IMatRenderContext* context, const DrawModelState_t &state, const ModelRenderInfo_t &pInfo, matrix3x4_t *pCustomBoneToWorld);
    bool HOOKED_CreateMove(void* thisptr, float sample_input_frametime, CUserCmd* pCmd);
    void HOOKED_OverrideView(void* thisptr, CViewSetup* pSetup);
     int HOOKED_INKeyEvent(void* thisptr, int eventcode, int keynum, const char* currentbinding);
    void HOOKED_SequenceProxyFn(const CRecvProxyData *pData, void *pStruct, void *pOut);
    bool HOOKED_OverrideConfig(void* thisptr, MaterialSystem_Config_t* config, bool forceUpdate);
    void HOOKED_SetKeyCodeState(void* thisptr, ButtonCode_t code, bool bPressed);
    void HOOKED_SetMouseCodeState(void* thisptr, ButtonCode_t code, MouseCodeState_t state);
    void HOOKED_PumpWindowMessageLoop(void* thisptr);
    void HOOKED_SDLSwapWindow(SDL_Window* window);
    void HOOKED_SDLPollEvent(SDL_Event* event);
 // void HOOKED_SceneEnd(void* thisptr);
#ifdef GOSX_AUTO_ACCEPT
    void HOOKED_EmitSound(void* thisptr, IRecipientFilter& filter, int iEntIndex, int iChannel, const char* pSoundEntry, unsigned int nSoundEntryHash, const char *pSample, float flVolume, int nSeed, soundlevel_t iSoundLevel, int iFlags, int iPitch, const Vector* pOrigin, const Vector* pDirection, void* pUtlVecOrigins, bool bUpdatePositions, float soundtime, int speakerentity, void* unknown);
#endif
    bool HOOKED_DoPostScreenSpaceEffects(void* thisptr, CViewSetup* pSetup);
    void HOOKED_LockCursor(void* thisptr);
#ifdef GOSX_RAGE_MODE
    void HOOKED_BeginFrame(void* thisptr, float frameTime);
#endif
#ifdef GOSX_OVERWATCH_REVEAL
    void* HOOKED_ReadPacket(void* thisptr);
    void HOOKED_HudUpdate(void* thisptr, bool active);
#endif
#ifdef GOSX_STREAM_PROOF
    CGLError HOOKED_FlushDrawable(CGLContextObj ctx);
#endif

    bool HOOKED_Plat_IsInDebugSession();
    void Unhook();
    void UnhookVmt();
    void InitGlobalVars();
};

#endif /** !Hooks_manager_h */
