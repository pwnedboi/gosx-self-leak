/******************************************************/
/**                                                  **/
/**      SDK/SDK.cpp                                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SDK.h"
#include "Utils.h"

ISurface*               Surface           = nullptr;
IPanel*                 Panel             = nullptr;
ICvar*                  Cvar              = nullptr;
IBaseClientDLL*         Client            = nullptr;
IVEngineClient*         Engine            = nullptr;
IClientEntityList*      EntList           = nullptr;
IEngineTrace*           Trace             = nullptr;
IVModelInfo*            ModelInfo         = nullptr;
IVModelRender*          ModelRender       = nullptr;
IMaterialSystem*        MaterialSystem    = nullptr;
IClientMode*            ClientMode        = nullptr;
CGlobalVarsBase**       GlobalVars        = nullptr;
CGlowObjectManager*     GlowObjectManager = nullptr;
IInputSystem*           InputSystem       = nullptr;
C_CSPlayerResource**    PlayerResource    = nullptr;
IGameEventManager*      GameEventManager  = nullptr;
GetLocalClientFn        GetLocalClient    = nullptr;
CClientState*           ClientState       = nullptr;
C_CSGameRules**         GameRules         = nullptr;
#ifdef GOSX_UNSUSED
CGameUI*                GameUI            = nullptr;
#endif
CSDLMgr*                SDLMgr            = nullptr;
IInputInternal*         InputInternal     = nullptr;
#ifdef GOSX_UNUSED
IVDebugOverlay*         DebugOverlay      = nullptr;
#endif
IPhysicsSurfaceProps*   Physics           = nullptr;
IPrediction*            Prediction        = nullptr;
IGameMovement*          GameMovement      = nullptr;
IMoveHelper*            MoveHelper        = nullptr;
#ifdef GOSX_AUTO_ACCEPT
IEngineSound*           Sound             = nullptr;
#endif
IDemoPlayer*            DemoPlayer        = nullptr;
#ifdef GOSX_UNSUSED
ILocalize*              Localize          = nullptr;
CCommandLine*           CommandLine       = nullptr;
#endif
// IVRenderView*           RenderView        = nullptr;
#ifdef GOSX_THIRDPERSON
CInput*                 Input             = nullptr;
#endif

#ifdef GOSX_RAGE_MODE
bool* Glob::SendPacket = nullptr;
#endif

typedef IClientMode* (*GetClientModeFn) (void);

void Interfaces::InitSurface() {
    if (!Surface) {
        Surface = Interfaces::Get<ISurface>("./bin/osx64/vguimatsurface.dylib", "VGUI_Surface031", true);
    }
}

void Interfaces::InitPanel() {
    if (!Panel) {
        Panel = Interfaces::Get<IPanel>("./bin/osx64/vgui2.dylib", "VGUI_Panel");
    }
}

void Interfaces::InitCvar() {
    if (!Cvar) {
        Cvar = Interfaces::Get<ICvar>("./bin/osx64/materialsystem.dylib", "VEngineCvar");
    }
}

void Interfaces::InitGlobalVars() {
    if (!GlobalVars) {
        GlobalVars = reinterpret_cast<CGlobalVarsBase**>(
            PatternScanner->GetPointer("client_panorama.dylib", "48 8D 05 ? ? ? ? 48 8B 00 F3 0F 10 ? ? F3 0F 11 83", 0x3) + 0x4
        );
    }
}

void Interfaces::InitInputSystem() {
    if (!InputSystem) {
        InputSystem = Interfaces::Get<IInputSystem>("./bin/osx64/inputsystem.dylib", "InputSystemVersion");
    }
}

void Interfaces::InitGlowObjectManager() {
    if (!GlowObjectManager) {
        GlowObjectManager = reinterpret_cast<CGlowObjectManager*>(
            PatternScanner->GetPointer("client_panorama.dylib", "84 ? ? ? ? 48 C7 05 ? ? ? ? 00 00 00 00 48 8D", 0x8) - 0x10
        );
    }
}

void Interfaces::InitClient() {
    if (!Client) {
        Client = Interfaces::Get<IBaseClientDLL>("./csgo/bin/osx64/client_panorama.dylib", "VClient");
    }
}

void Interfaces::InitClientMode() {
    if (!ClientMode) {
        uintptr_t HudProcessInputPtr = reinterpret_cast<uintptr_t>(Interfaces::Table(Client)[INDEX_HUDPROCESSINPUT]);
        
        typedef IClientMode* (*GetClientModeFn) (void);
        ClientMode = reinterpret_cast<GetClientModeFn>(
            PatternScanner->GetAbsoluteAddress(HudProcessInputPtr + 0x8, 0x1, 0x5)
        )();
    }
}

void Interfaces::InitEngine() {
    if (!Engine) {
        Engine = Interfaces::Get<IVEngineClient>("./bin/osx64/engine.dylib", "VEngineClient");
    }
}

void Interfaces::InitEntityList() {
    if (!EntList) {
        EntList = Interfaces::Get<IClientEntityList>("./csgo/bin/osx64/client_panorama.dylib", "VClientEntityList");
    }
}

void Interfaces::InitEngineTrace() {
    if (!Trace) {
        Trace = Interfaces::Get<IEngineTrace>("./bin/osx64/engine.dylib", "EngineTraceClient");
    }
}

void Interfaces::InitModelInfo() {
    if (!ModelInfo) {
        ModelInfo = Interfaces::Get<IVModelInfo>("./bin/osx64/engine.dylib", "VModelInfoClient");
    }
}

void Interfaces::InitModelRender() {
    if (!ModelRender) {
        ModelRender = Interfaces::Get<IVModelRender>("./bin/osx64/engine.dylib", "VEngineModel");
    }
}

void Interfaces::InitMaterialSystem() {
    if (!MaterialSystem) {
        MaterialSystem = Interfaces::Get<IMaterialSystem>("./bin/osx64/materialsystem.dylib", "VMaterialSystem");
    }
}

void Interfaces::InitPlayerResource() {
    if (!PlayerResource) {
        PlayerResource = reinterpret_cast<C_CSPlayerResource**>(
            PatternScanner->GetPointer("client_panorama.dylib", "48 8D 05 ? ? ? ? 48 8B 38 48 85 FF 74 74", 0x3) + 0x4
        );
    }
}

void Interfaces::InitGameEventManager() {
    if (!GameEventManager) {
        GameEventManager = Interfaces::Get<IGameEventManager>("./bin/osx64/engine.dylib", "GAMEEVENTSMANAGER002", true);
    }
}

void Interfaces::InitClientState() {
    if (!GetLocalClient) {
        uintptr_t GetLocalPlayerFnPtr = reinterpret_cast<uintptr_t>(Interfaces::Table(Engine)[INDEX_GETLOCALPLAYER]);
        
        GetLocalClient = reinterpret_cast<GetLocalClientFn>(
            PatternScanner->GetAbsoluteAddress(GetLocalPlayerFnPtr + 0x9, 0x1, 0x5)
        );
    }
    
    if (!ClientState) {
        ClientState = GetLocalClient(-1);
    }
}

void Interfaces::InitGameRules() {
    if (!GameRules) {
        GameRules = reinterpret_cast<C_CSGameRules**>(
            PatternScanner->GetPointer("client_panorama.dylib", "49 89 FE 48 8D 05 ? ? ? ? 48 8B 38 48 8B 07", 0x6) + 0x4
        );
    }
}

#ifdef GOSX_UNSUSED
void Interfaces::InitGameUI() {
    if (!GameUI) {
        GameUI = Interfaces::Get<CGameUI>("./csgo/bin/osx64/client_panorama.dylib", "GameUI");
    }
}
#endif

void Interfaces::InitSDLMgr() {
    if (!SDLMgr) {
        typedef CSDLMgr*(*SDLMgrCreateFn)(void);
        static SDLMgrCreateFn createFn = reinterpret_cast<SDLMgrCreateFn>(
            PatternScanner->GetProcedure("launcher.dylib", "53 48 8B 1D ? ? ? ? 48 85 DB 75 1C") - 0x6
        );
        SDLMgr = (CSDLMgr*)createFn();
        
        return;
    }
}

void Interfaces::InitInputInternal() {
    if (!InputInternal) {
        InputInternal = Interfaces::Get<IInputInternal>("./bin/osx64/vgui2.dylib", "VGUI_InputInternal001", true);
    }
}

#ifdef GOSX_UNUSED
void Interfaces::InitDebugOverlay() {
    if (!DebugOverlay) {
        DebugOverlay = Interfaces::Get<IVDebugOverlay>("./bin/osx64/engine.dylib", "VDebugOverlay004", true);
    }
}
#endif

void Interfaces::InitPhysics() {
    if (!Physics) {
        Physics = Interfaces::Get<IPhysicsSurfaceProps>("./bin/osx64/vphysics.dylib", "VPhysicsSurfaceProps");
    }
}

#ifdef GOSX_AUTO_ACCEPT
void Interfaces::InitEngineSound() {
    if (!Sound) {
        Sound = Interfaces::Get<IEngineSound>("./bin/osx64/engine.dylib", IENGINESOUND_CLIENT_INTERFACE_VERSION, true);
    }
}
#endif

void Interfaces::InitGameMovement() {
    if (!GameMovement) {
        GameMovement = Interfaces::Get<IGameMovement>("./csgo/bin/osx64/client_panorama.dylib", "GameMovement");
    }
}

void Interfaces::InitMoveHelper() {
    if (!MoveHelper) {
        MoveHelper = reinterpret_cast<IMoveHelper*>(
            PatternScanner->GetPointer(
                "client_panorama.dylib",
                "48 8D 05 ? ? ? ? 48 89 05 ? ? ? ? 48 8D 35 ? ? ? ? C7 05 ? ? ? ? 00 00 00 00",
                0xA
            ) + 0x4
        );
    }
}

void Interfaces::InitPrediction() {
    if (!Prediction) {
        Prediction = Interfaces::Get<IPrediction>("./csgo/bin/osx64/client_panorama.dylib", "VClientPrediction");
    }
}

#ifdef GOSX_UNSUSED
typedef void*(*GetCommandLineFn)();
void Interfaces::InitCommandline() {
    if (!CommandLine) {
        GetCommandLineFn GetCommandLine = reinterpret_cast<GetCommandLineFn>(dlsym(RTLD_DEFAULT, XorStr("CommandLine")));
        
        CommandLine = reinterpret_cast<CCommandLine*>((uintptr_t)GetCommandLine());
    }
}
#endif

#ifdef GOSX_OVERWATCH_REVEAL
void Interfaces::InitDemoPlayer() {
    if (!DemoPlayer) {
        DemoPlayer = *reinterpret_cast<IDemoPlayer**>(PatternScanner->GetPointer(
            "engine.dylib",
            "44 0F 4F E0 C6 03 ? 48 8B 3D",
            0xA
        ) + 0x4);
    }
}
#endif

#ifdef GOSX_UNSUSED
void Interfaces::InitLocalize() {
    if (!Localize) {
        Localize = Interfaces::Get<ILocalize>("./bin/osx64/localize.dylib", "Localize_001", true);
    }
}
#endif

#ifdef GOSX_UNUSED
void Interfaces::InitRenderView() {
    if (!RenderView) {
        RenderView = Internal::GetInterface<IVRenderView>("./bin/osx64/engine.dylib", "VEngineRenderView014", true);
    }
}
#endif

#ifdef GOSX_THIRDPERSON
void Interfaces::InitInput() {
    if (!Input) {
        uintptr_t IN_ActivateMousePtr = reinterpret_cast<uintptr_t>(Interfaces::Table(Client)[INDEX_IN_ACTIVATEMOUSE]);
        Input = *reinterpret_cast<CInput**>(
            PatternScanner->GetAbsoluteAddress(IN_ActivateMousePtr + 0x4, 0x3, 0x7)
        );
    }
}
#endif

#ifdef GOSX_RAGE_MODE
void Interfaces::InitSendpacket() {
    if (!Glob::SendPacket) {
        Glob::SendPacket = reinterpret_cast<bool*>(
            PatternScanner->GetProcedure("engine.dylib", "41 B5 ? 84 C0 74 11") + 0x2
        );
        
        vm_protect(current_task(), (vm_address_t)Glob::SendPacket, sizeof(bool), 0, VM_PROT_ALL);
    }
}
#endif
