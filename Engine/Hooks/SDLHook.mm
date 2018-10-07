/******************************************************/
/**                                                  **/
/**      Hooks/SDLHook.cpp                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-31                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"
#include "Engine/Features/NightMode.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

ConVar* mat_queue_mode = nullptr;
int old_mat_queue_mode = -1;

void HookManager::HOOKED_PumpWindowMessageLoop(void* thisptr) {
    static PumpWindowMessageLoopFn original_PumpWindowMessageLoop = vmtSDLMgr
        ->orig<PumpWindowMessageLoopFn>(INDEX_PUMPWINDOWSMESSAGELOOP);
    
    if (!mat_queue_mode) {
        mat_queue_mode = Cvar->FindVar("mat_queue_mode");
    }
    
    if (old_mat_queue_mode == -1) {
        old_mat_queue_mode = mat_queue_mode->GetInt();
    }
    
    if (
        GUI::IsVisible &&
        !SetKeyCodeState::shouldListen
    ) {
        if (old_mat_queue_mode != 0 && mat_queue_mode->GetInt() != 0) {
            mat_queue_mode->SetValue(0);
        }
        
        return;
    }
    
    if (mat_queue_mode->GetInt() != old_mat_queue_mode) {
        mat_queue_mode->SetValue(old_mat_queue_mode);
    }
    
    original_PumpWindowMessageLoop(thisptr);
}

SDL_GLContext gosxContext = nullptr;
SDL_GLContext gameContext = nullptr;
SDL_Window* lastWindow = nullptr;

void HookManager::HOOKED_SDLSwapWindow(SDL_Window* window) {
    static SDLSwapWindowFn original_SGL_GL_SwapWindow = reinterpret_cast<SDLSwapWindowFn>(swapwindow_original);

    lastWindow = window;
    
    gameContext = SDL_GL_GetCurrentContext();
    
    if (*FirstRun) {
        GUI::IsVisible = true;
    }
    
    static bool SetStylesNow = false;
    if (!gosxContext) {
        gosxContext = SDL_GL_CreateContext(window);
        
        ImGui::CreateContext();
        ImGuiIO& io = ImGui::GetIO(); (void)io;
        
        ImGui_ImplSDL2_InitForOpenGL(window, gosxContext);
        ImGui_ImplOpenGL2_Init();
        
        GUI::LoadFontsTexture();
        
        SetStylesNow = true;
    }

#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        StreamProof->ToogleCaptureBuffer(true);
    } else {
        StreamProof->ToogleCaptureBuffer(false);
    }
#endif
    
    SDL_GL_MakeCurrent(window, gosxContext);
    
    static int SizeW, SizeH;
    SDL_GetWindowSize(window, &SizeW, &SizeH);
    
    *Glob::SDLResH = SizeH;
    *Glob::SDLResW = SizeW;
    
    if (GUI::IsVisible && !SetKeyCodeState::shouldListen) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            ImGui_ImplSDL2_ProcessEvent(&event);
            if (event.type == SDL_QUIT) {
                return;
            }
        }
    }
    
    ImGui_ImplOpenGL2_NewFrame();
    ImGui_ImplSDL2_NewFrame(window);
    ImGui::NewFrame();
    
    NightMode->Render();
    
    GUI::RenderStart(window);
    FeatureManager::PaintTraverseFeature::ImPaintTraverse();
    GUI::RenderEnd();
    
    ImGuiIO& io = ImGui::GetIO();
    
    io.MouseDrawCursor = GUI::IsVisible;
    io.WantCaptureKeyboard = GUI::IsVisible;
    io.WantCaptureMouse = GUI::IsVisible;
    
    if (SetStylesNow) {
        GUI::SetStyles();
        
        SetStylesNow = false;
    }
    
    GUI::MessagePopup::Tick();
    GUI::SetupMenu(window);
    GUI::SetupGUI();
    
#ifdef GOSX_STREAM_PROOF
    if (!StreamProof->Active()) {
#endif
        ImGui::Render();
        ImGui_ImplOpenGL2_RenderDrawData(ImGui::GetDrawData());
#ifdef GOSX_STREAM_PROOF
    }
#endif

    original_SGL_GL_SwapWindow(window);
    
    SDL_GL_MakeCurrent(window, gameContext);
    glFlush();
}

void HookManager::HOOKED_SDLPollEvent(SDL_Event* event) {
    static SDLPollEventFn original_SDL_PollEvent = reinterpret_cast<SDLPollEventFn>(pollevent_original);

    if (event->type == SDL_KEYUP) {
        if (((event->key.keysym.mod & KMOD_ALT && event->key.keysym.sym == SDLK_BACKSPACE) || event->key.keysym.sym == SDLK_DELETE)) {
            GUI::IsVisible = !GUI::IsVisible;
            
            if (!GUI::IsVisible) {
                Options::synced = false;
                Glob::SkinsConfig->ReloadSettings();
                
                *Glob::IsWeaponSwitched = true;
                Glob::LastActiveWeapon = nullptr;
                
                if (*FirstRun) {
                    *FirstRun = false;
                }
            }
        }
    }
    
    original_SDL_PollEvent(event);
}

void HookManager::HOOKED_LockCursor(void* thisptr) {
    static LockCursorFn oLockCursor = vmtSurface->orig<LockCursorFn>(INDEX_LOCKCURSOR);
    
    if (GUI::IsVisible) {
        Surface->UnlockCursor();
        
        return;
    }
    
    oLockCursor(thisptr);
}
