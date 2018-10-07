/******************************************************/
/**                                                  **/
/**      Engine/common.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Engine_common_h
#define Engine_common_h

#define GOSX_CLIENT_VERSION_MAJOR  2
#define GOSX_CLIENT_VERSION_MINOR  15
#define GOSX_CLIENT_VERSION_BUGFIX 2
#define GOSX_CLIENT_VERSION_NOTICE "steel-serpent"

// #define DUMP_NETVARS true

#define GOSX_STREAM_PROOF true
#define GOSX_OVERWATCH_REVEAL true
#define GOSX_GLOVE_CHANGER true
#define GOSX_BACKTRACKING true
#define GOSX_STICKER_CHANGER true
// #define GOSX_THIRDPERSON true
// #define GOSX_RAGE_MODE true
#define GOSX_MP7TOMP5_FIX true
// #define GOSX_AUTO_ACCEPT true

// #define GOSX_UNSUSED true

#define GOSX_SKINCHANGER_RARITY true
// #define GOSX_MOJAVE_SWITCH true

typedef unsigned long DWORD;
typedef unsigned char BYTE;
typedef BYTE* PBYTE;
typedef unsigned short WORD;
typedef WORD *PWORD;
typedef unsigned long long HFONT;

#include <string>
#include <unordered_map>
#include <unordered_set>
#include <dlfcn.h>
#include <fstream>
#include <libproc.h>
#include <sys/stat.h>
#include <map>
#include <vector>
#include <assert.h>
#include <dirent.h>
#include <algorithm>
#include <codecvt>
#include <deque>
#include <mach-o/dyld_images.h>
#include <curl/curl.h>
#include <memory>
#include <thread>
#include <OpenGL/gl.h>
#include <SDL2/SDL.h>
#include <AppKit/AppKit.h>

#include "SDK/Thirdparty/XorStr.h"
#include "Engine/imgui/keyCodeState.h"

#include "Engine/imgui/imgui.h"
#include "Engine/imgui/imgui_internal.h"
#include "Engine/imgui/imgui_impl_opengl2.h"
#include "Engine/imgui/imgui_impl_sdl.h"

#include "SDK/Thirdparty/plugin.h"
#include "SDK/KeyStroke.h"
#include "SDK/Thirdparty/json.h"
#include "Engine/functions.h"
#include "Engine/Patterns/manager.h"
#include "Engine/Settings/manager.h"
#include "Engine/Hooks/VMT.h"
#include "Engine/Hooks/indexes.h"

#include "GUI.h"

using json = nlohmann::json;

#ifdef GOSX_STREAM_PROOF
extern uintptr_t* flushdrawable_ptr;
extern uintptr_t flushdrawable_original;
#endif

extern uintptr_t* swapwindow_ptr;
extern uintptr_t swapwindow_original;

extern uintptr_t* pollevent_ptr;
extern uintptr_t pollevent_original;

extern std::shared_ptr<VMT> vmtPanel;
extern std::shared_ptr<VMT> vmtClient;
extern std::shared_ptr<VMT> vmtModelRender;
extern std::shared_ptr<VMT> vmtClientMode;
extern std::shared_ptr<VMT> vmtInputSystem;
extern std::shared_ptr<VMT> vmtInputInternal;
extern std::shared_ptr<VMT> vmtMaterialSystem;
extern std::shared_ptr<VMT> vmtSDLMgr;
extern std::shared_ptr<VMT> vmtSurface;
#ifdef GOSX_UNUSED
extern std::shared_ptr<VMT> vmtRenderView;
#endif
#ifdef GOSX_OVERWATCH_REVEAL
extern std::shared_ptr<VMT> vmtDemoPlayer;
#endif
#ifdef GOSX_AUTO_ACCEPT
extern std::shared_ptr<VMT> vmtSound;
#endif

class RecvProp;
extern RecvProp* HookedRecvProp;

struct CRecvProxyData;
typedef void (*RecvVarProxyFn) (const CRecvProxyData *pData, void *pStruct, void *pOut);
extern RecvVarProxyFn OriginalRecvProp;
extern RecvVarProxyFn vmtSequence;

extern SDL_GLContext gosxContext;
extern SDL_GLContext gameContext;
extern SDL_Window* lastWindow;

extern bool* FirstRun;

class C_BaseCombatWeapon;
class CSkinList;
class CSettingsManager;
class VMatrix;
class Vector;

namespace Glob {
    extern C_BaseCombatWeapon*                  LastActiveWeapon;
    extern bool*                                IsWeaponSwitched;
    extern bool*                                AimbotIsAiming;
    extern json                                 AuthData;
    extern std::shared_ptr<CSkinList>           SkinList;
    extern std::shared_ptr<CSettingsManager>    SkinsConfig;
    extern float*                               ZoomedFov;
    extern int*                                 SDLResW;
    extern int*                                 SDLResH;
#ifdef GOSX_THIRDPERSON
    extern Vector*                              ThirdpersonAngles;
#endif
#ifdef GOSX_RAGE_MODE
    extern bool*                                SendPacket;
    extern bool*                                PostProcessing;
#endif
#ifdef GOSX_AUTO_ACCEPT
    extern bool                                 IsEmitSoundHooked;
#endif
};

#ifdef GOSX_RAGE_MODE
namespace CreateMove {
    extern bool* SendPacket;
};
#endif

#endif /** !Engine_common_h */
