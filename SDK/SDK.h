/******************************************************/
/**                                                  **/
/**      SDK/SDK.h                                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_SDK_h
#define SDK_SDK_h

#include "Engine/common.h"
#include "Definitions.h"
#include "Vector.h"
#include "Vector2D.h"
#include "Vector4D.h"
#include "QAngle.h"
#include "CHandle.h"
#include "CGlobalVarsBase.h"
#include "ClientClass.h"
#include "Color.h"
#include "CSDLMgr.h"
#include "IBaseClientDll.h"
#include "IClientEntity.h"
#include "IClientEntityList.h"
#include "Interfaces.h"
#include "IMaterial.h"
#include "VMatrix.h"
#include "CBaseEntity.h"
#include "IVModelInfo.h"
#include "IVModelRender.h"
#include "IPanel.h"
#include "IPhysicsSurfaceProps.h"
#include "ISurface.h"
#include "IVEngineClient.h"
#ifdef GOSX_UNUSED
#include "IVDebugOverlay.h"
#endif
#include "IEngineTrace.h"
#include "PlayerInfo.h"
#include "Recv.h"
#include "IClientMode.h"
#include "CUserCmd.h"
#include "ICvar.h"
#include "CMath.h"
#include "CInput.h"
#include "CUtlMemory.h"
#include "CUtlVector.h"
#include "CGlowObjectManager.h"
#include "CPlayerResource.h"
#include "IGameMovement.h"
#include "IMoveHelper.h"
#include "IPrediction.h"
#include "IInputSystem.h"
#include "IGameEvent.h"
#ifdef GOSX_UNSUSED
#include "IVRenderView.h"
#include "CommandLine.h"
#endif
#include "Thirdparty/ConsoleLogger.h"

#ifdef GOSX_OVERWATCH_REVEAL
#include "IDemoPlayer.h"
#endif

#ifdef GOSX_UNSUSED
#include "ILocalize.h"
#endif
#include "IGameEventManager.h"
#include "CBaseClientState.h"
#include "CCSGameRules.h"
#ifdef GOSX_UNSUSED
#include "CGameUI.h"
#endif
#ifdef GOSX_AUTO_ACCEPT
#include "IEngineSound.h"
#endif
#include "Engine/Patterns/manager.h"

typedef IClientMode* (*GetClientModeFn) (void);

namespace Interfaces {
    extern void InitSurface();
    extern void InitPanel();
    extern void InitCvar();
    extern void InitClient();
    extern void InitEngine();
    extern void InitEntityList();
    extern void InitEngineTrace();
    extern void InitModelInfo();
    extern void InitModelRender();
    extern void InitMaterialSystem();
    extern void InitClientMode();
    extern void InitGlobalVars();
    extern void InitGlowObjectManager();
    extern void InitInputSystem();
    extern void InitPlayerResource();
    extern void InitGameEventManager();
    extern void InitClientState();
    extern void InitGameRules();
#ifdef GOSX_UNUSED
    extern void InitGameUI();
#endif
    extern void InitSDLMgr();
    extern void InitInputInternal();
#ifdef GOSX_UNUSED
    extern void InitDebugOverlay();
#endif
    extern void InitPhysics();
#ifdef GOSX_AUTO_ACCEPT
    extern void InitEngineSound();
#endif
    extern void InitPrediction();
    extern void InitGameMovement();
    extern void InitMoveHelper();
#ifdef GOSX_UNUSED
    extern void InitCommandline();
#endif
    extern void InitRenderView();
#ifdef GOSX_THIRDPERSON
    extern void InitInput();
#endif
#ifdef GOSX_OVERWATCH_REVEAL
    extern void InitDemoPlayer();
#endif
#ifdef GOSX_UNUSED
    extern void InitLocalize();
#endif
#ifdef GOSX_RAGE_MODE
    extern void InitSendpacket();
#endif
};

#endif /** !SDK_SDK_h */
