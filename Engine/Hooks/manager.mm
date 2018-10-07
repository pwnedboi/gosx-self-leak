/******************************************************/
/**                                                  **/
/**      Hooks/manager.cpp                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"

std::shared_ptr<VMT> vmtPanel            = nullptr;
std::shared_ptr<VMT> vmtClient           = nullptr;
std::shared_ptr<VMT> vmtModelRender      = nullptr;
std::shared_ptr<VMT> vmtClientMode       = nullptr;
std::shared_ptr<VMT> vmtInputSystem      = nullptr;
std::shared_ptr<VMT> vmtInputInternal    = nullptr;
std::shared_ptr<VMT> vmtMaterialSystem   = nullptr;
std::shared_ptr<VMT> vmtSDLMgr           = nullptr;
std::shared_ptr<VMT> vmtSurface          = nullptr;
#ifdef GOSX_UNUSED
std::shared_ptr<VMT> vmtRenderView       = nullptr;
#endif
#ifdef GOSX_OVERWATCH_REVEAL
std::shared_ptr<VMT> vmtDemoPlayer       = nullptr;
#endif
#ifdef GOSX_AUTO_ACCEPT
std::shared_ptr<VMT> vmtSound            = nullptr;
#endif
RecvVarProxyFn       vmtSequence         = nullptr;

RecvProp* HookedRecvProp = 0;
RecvVarProxyFn OriginalRecvProp = 0;

std::shared_ptr<CSettingsManager> Glob::SkinsConfig = nullptr;
std::string currentConfigName = "";

json Glob::AuthData = NULL;
int* Glob::SDLResW = nullptr;
int* Glob::SDLResH = nullptr;

bool*(*OriginalDebugSession)(void);

float* Glob::ZoomedFov = nullptr;

#ifdef GOSX_STREAM_PROOF
uintptr_t* flushdrawable_ptr = nullptr;
uintptr_t flushdrawable_original = NULL;
#endif

uintptr_t* swapwindow_ptr = nullptr;
uintptr_t swapwindow_original = NULL;

uintptr_t* pollevent_ptr = nullptr;
uintptr_t pollevent_original = NULL;

std::shared_ptr<CEventListener> EventListener = nullptr;

void HookManager::InitializeHooks() {
#ifdef GOSX_STREAM_PROOF
    uintptr_t cglflushdrawableFn = reinterpret_cast<uintptr_t>(dlsym(RTLD_DEFAULT, "CGLFlushDrawable"));
    flushdrawable_ptr = reinterpret_cast<uintptr_t*>(
        PatternScanner->GetAbsoluteAddress(
            PatternScanner->GetAbsoluteAddress(cglflushdrawableFn + 0x1C, 0x1, 0x5)
        , 0x2, 0x6)
    );
    flushdrawable_original = *flushdrawable_ptr;
    *flushdrawable_ptr = reinterpret_cast<uintptr_t>(&HOOKED_FlushDrawable);
#endif
    
    uintptr_t swapwindowFn = reinterpret_cast<uintptr_t>(dlsym(RTLD_DEFAULT, "SDL_GL_SwapWindow"));
    swapwindow_ptr = reinterpret_cast<uintptr_t*>(PatternScanner->GetAbsoluteAddress(swapwindowFn + 0xC, 0x3, 0x7));
    swapwindow_original = *swapwindow_ptr;
    *swapwindow_ptr = reinterpret_cast<uintptr_t>(&HOOKED_SDLSwapWindow);
    
    uintptr_t polleventFn = reinterpret_cast<uintptr_t>(dlsym(RTLD_DEFAULT, "SDL_PollEvent"));
    pollevent_ptr = reinterpret_cast<uintptr_t*>(PatternScanner->GetAbsoluteAddress(polleventFn + 0xC, 0x3, 0x7));
    pollevent_original = *pollevent_ptr;
    *pollevent_ptr = reinterpret_cast<uintptr_t>(&HOOKED_SDLPollEvent);
    
    plugin(
        dlsym(RTLD_DEFAULT, "Plat_IsInDebugSession"),
        (void*)&HookManager::HOOKED_Plat_IsInDebugSession,
        (void **)&OriginalDebugSession
    );
    
    vmtClient->hook((void*)HOOKED_FrameStageNotify, INDEX_FRAMESTAGENOTIFY);
    vmtClient->hook((void*)HOOKED_INKeyEvent, INDEX_INKEYEVENT);
#ifdef GOSX_OVERWATCH_REVEAL
    vmtClient->hook((void*)HOOKED_HudUpdate, INDEX_HUDUPDATE);
#endif
    vmtClient->apply();

    vmtPanel->hook((void*)HOOKED_PaintTraverse, INDEX_PAINTTRAVERSE);
    vmtPanel->apply();

    vmtModelRender->hook((void*)HOOKED_DrawModelExecute, INDEX_DRAWMODELEXECUTE);
    vmtModelRender->apply();

    vmtClientMode->hook((void*)HOOKED_OverrideView, INDEX_OVERRIDEVIEW);
    vmtClientMode->hook((void*)HOOKED_CreateMove, INDEX_CREATEMOVE);
    vmtClientMode->hook((void*)HOOKED_DoPostScreenSpaceEffects, INDEX_DOPOSTSCREENSPACEEFFECTS);
    vmtClientMode->apply();

    vmtMaterialSystem->hook((void*)HOOKED_OverrideConfig, INDEX_OVERRIDECONFIG);
#ifdef GOSX_RAGE_MODE
    vmtMaterialSystem->hook((void*)HOOKED_BeginFrame, INDEX_BEGINFRAME);
#endif
    vmtMaterialSystem->apply();
    
    vmtInputInternal->hook((void*)HOOKED_SetKeyCodeState, INDEX_SETKEYCODESTATE);
    vmtInputInternal->hook((void*)HOOKED_SetMouseCodeState, INDEX_SETMOUSECODESTATE);
    vmtInputInternal->apply();
    
    vmtSDLMgr->hook((void*)HOOKED_PumpWindowMessageLoop, INDEX_PUMPWINDOWSMESSAGELOOP);
    vmtSDLMgr->apply();
    
    vmtSurface->hook((void*)HOOKED_LockCursor, INDEX_LOCKCURSOR);
    vmtSurface->apply();
    
#ifdef GOSX_AUTO_ACCEPT
    vmtSound->hook((void*)HOOKED_EmitSound, INDEX_EMITSOUND);
    if (!Engine->IsInGame() && !Engine->IsConnected() && !Glob::IsEmitSoundHooked) {
        vmtSound->apply();
        Glob::IsEmitSoundHooked = true;
    }
#endif
    
#ifdef GOSX_UNUSED
    vmtRenderView->hook((void*)HOOKED_SceneEnd, INDEX_SCENEEND);
    vmtRenderView->apply();
#endif
    
#ifdef GOSX_OVERWATCH_REVEAL
    vmtDemoPlayer->hook((void*)HOOKED_ReadPacket, INDEX_READPACKET);
    vmtDemoPlayer->apply();
#endif
    
    EventListener = std::make_unique<CEventListener>();

    vmtSequence = (RecvVarProxyFn)NetvarManager::HookProp("DT_BaseViewModel", "m_nSequence", HOOKED_SequenceProxyFn);
}

void HookManager::InitializeVMTs() {
    vmtClient           = std::make_unique<VMT>(Client);
    vmtPanel            = std::make_unique<VMT>(Panel);
    vmtModelRender      = std::make_unique<VMT>(ModelRender);
    vmtClientMode       = std::make_unique<VMT>(ClientMode);
    vmtInputSystem      = std::make_unique<VMT>(InputSystem);
    vmtMaterialSystem   = std::make_unique<VMT>(MaterialSystem);
    vmtSDLMgr           = std::make_unique<VMT>(SDLMgr);
    vmtSurface          = std::make_unique<VMT>(Surface);
    vmtInputInternal    = std::make_unique<VMT>(InputInternal);
#ifdef GOSX_UNUSED
    vmtRenderView       = std::make_unique<VMT>(RenderView);
#endif
#ifdef GOSX_OVERWATCH_REVEAL
    vmtDemoPlayer       = std::make_unique<VMT>(DemoPlayer);
#endif
#ifdef GOSX_AUTO_ACCEPT
    vmtSound            = std::make_unique<VMT>(Sound);
#endif
}

bool HookManager::InitializeConfigs() {
    if (!CSettingsManager::Install()) {
        return false;
    }
    currentConfigName = "configs/default.ini";
    
    if (*FirstRun) {
        CSettingsManager::SaveAll(currentConfigName, true, true);
    }
    
    Glob::SkinsConfig = CSettingsManager::Instance("skins.ini");

    std::string tempSettings = std::string(CSettingsManager::Instance("menu.ini")->GetStringSetting("Main", "settings_file"));
    if (tempSettings != "" && tempSettings != currentConfigName) {
        currentConfigName = tempSettings;
    }
    
    Options::synced = false;
    CSettingsManager::SyncSettings();
    
    return true;
}

void HookManager::InitializeInterfaces() {
    while (!Client) { Interfaces::InitClient(); if (!Client) { usleep(50000); } }
    Interfaces::InitEntityList();
#ifdef GOSX_UNUSED
    Interfaces::InitGameUI();
#endif
    Interfaces::InitGameMovement();
    Interfaces::InitPrediction();
    Interfaces::InitMoveHelper();
    Interfaces::InitClientMode();
#ifdef GOSX_THIRDPERSON
    Interfaces::InitInput();
#endif
    
    while (!Engine) { Interfaces::InitEngine(); if (!Engine) { usleep(50000); } }
    Interfaces::InitEngineTrace();
    Interfaces::InitModelInfo();
    Interfaces::InitModelRender();
    Interfaces::InitGameEventManager();
#ifdef GOSX_UNUSED
    Interfaces::InitDebugOverlay();
#endif
    Interfaces::InitClientState();
#ifdef GOSX_UNUSED
    Interfaces::InitRenderView();
#endif
#ifdef GOSX_OVERWATCH_REVEAL
    Interfaces::InitDemoPlayer();
#endif
#ifdef GOSX_AUTO_ACCEPT
    Interfaces::InitEngineSound();
#endif
    
    while (!Panel) { Interfaces::InitPanel(); if (!Panel) { usleep(50000); } }
    Interfaces::InitInputInternal();
    
    while (!Cvar) { Interfaces::InitCvar(); if (!Cvar) { usleep(50000); } }
    Interfaces::InitMaterialSystem();
    
    while (!InputSystem) { Interfaces::InitInputSystem(); if (!InputSystem) { usleep(50000); } }
    while (!Surface) { Interfaces::InitSurface(); if (!Surface) { usleep(50000); } }
    while (!Physics) { Interfaces::InitPhysics(); if (!Physics) { usleep(50000); } }
#ifdef GOSX_UNUSED
    while (!Localize) { Interfaces::InitLocalize(); if (!Localize) { usleep(50000); } }
#endif

    Interfaces::InitGlobalVars();
    Interfaces::InitGameRules();
    Interfaces::InitGlowObjectManager();
    Interfaces::InitPlayerResource();
    Interfaces::InitSDLMgr();
    Utils::InitPredictionData();
#ifdef GOSX_RAGE_MODE
    Interfaces::InitSendpacket();
#endif
}

void HookManager::Initialize() {
    HookManager::InitGlobalVars();

    HookManager::InitializeInterfaces();
    NetvarManager::SetStaticOffsets();
    if (HookManager::InitializeConfigs()) {
        HookManager::InitializeVMTs();
        HookManager::InitializeHooks();
        
        DrawManager->SetDropShadowAlpha(155);
        
        MessagePopupType InfoType = MESSAGE_TYPE_SUCCESS;

        Tools::ConsoleLogger::Default("Injected", true, true);
        GUI::MessagePopup::AddMessage("GO:SX has been succesfully injected!", InfoType, 10000);
    } else {
        GUI::MessagePopup::AddMessage("Something went wrong when initialising the configs.\n\nPlease check if your system meets the requirements.", MESSAGE_TYPE_ERROR, 10000);
    }
}

#ifdef GOSX_UNUSED
void HookManager::HOOKED_SceneEnd(void *thisptr) {
    static SceneEndFn original_SceneEnd = vmtRenderView->GetOriginalMethod<SceneEndFn>(INDEX_SCENEEND);
    original_SceneEnd(thisptr);
    
    Chams->SceneEnd();
 }
#endif

bool HookManager::HOOKED_Plat_IsInDebugSession() {
    return false;
}

void HookManager::Unhook() {
    *swapwindow_ptr = swapwindow_original;
    *pollevent_ptr = pollevent_original;
#ifdef GOSX_STREAM_PROOF
    *flushdrawable_ptr = flushdrawable_original;
#endif
#ifdef GOSX_RAGE_MODE
    *Glob::SendPacket = true;
#endif
    *m_nPredictionSeed = -1;
    
    
    if (SDL_GL_GetCurrentContext() == gosxContext) {
        SDL_GL_MakeCurrent(lastWindow, gameContext);
        
        SDL_GL_DeleteContext(gosxContext);
    }
    
    HookedRecvProp->m_ProxyFn = OriginalRecvProp;
    
    delete Glob::IsWeaponSwitched;
    delete Glob::AimbotIsAiming;
    delete Glob::ZoomedFov;
    delete Glob::SDLResW;
    delete Glob::SDLResH;
#ifdef GOSX_THIRDPERSON
    delete Glob::ThirdpersonAngles;
#endif
#ifdef GOSX_RAGE_MODE
    delete Glob::SendPacket;
    delete CreateMove::SendPacket;
#endif
}

void HookManager::UnhookVmt() {
    vmtPanel->release();
    vmtClient->release();
    vmtModelRender->release();
    vmtClientMode->release();
    vmtInputSystem->release();
    vmtInputInternal->release();
    vmtMaterialSystem->release();
    vmtSDLMgr->release();
    vmtSurface->release();
#ifdef GOSX_OVERWATCH_REVEAL
    vmtDemoPlayer->release();
#endif
}

void HookManager::InitGlobalVars() {
    if (!Glob::IsWeaponSwitched) {
        Glob::IsWeaponSwitched = new bool();
        *Glob::IsWeaponSwitched = false;
    }
    
    if (!Glob::AimbotIsAiming) {
        Glob::AimbotIsAiming = new bool();
        *Glob::AimbotIsAiming = false;
    }
    
    if (!Glob::ZoomedFov) {
        Glob::ZoomedFov = new float();
        *Glob::ZoomedFov = 0.0f;
    }
    
    if (!Glob::SDLResW) {
        Glob::SDLResW = new int();
        *Glob::SDLResW = 0;
    }
    
    if (!Glob::SDLResH) {
        Glob::SDLResH = new int();
        *Glob::SDLResH = 0;
    }
#ifdef GOSX_THIRDPERSON
    if (!Glob::ThirdpersonAngles) {
        Glob::ThirdpersonAngles = new Vector();
    }
#endif
#ifdef GOSX_RAGE_MODE
    if (!Glob::SendPacket) {
        Glob::SendPacket = new bool();
        *Glob::SendPacket = true;
    }
    if (!CreateMove::SendPacket) {
        CreateMove::SendPacket = new bool();
        *CreateMove::SendPacket = true;
    }
#endif
}
