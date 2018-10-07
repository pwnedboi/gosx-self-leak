/******************************************************/
/**                                                  **/
/**      GUITabs/DrawingTab.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef GUITabs_DrawingTab_h
#define GUITabs_DrawingTab_h

#include "Engine/common.h"
#include "Engine/Weapons/manager.h"

namespace GUI {
    namespace DrawingTab {
        extern void Render();
        
        extern void RenderESPTab(ImGuiWindow* window);
        extern void RenderGrenadehelperTab(ImGuiWindow* window);
        extern void RenderCrosshairTab(ImGuiWindow* window, ImDrawList* draw);
        extern void RenderSpectatorTab(ImGuiWindow* window);
        extern void RenderRadarTab(ImGuiWindow* window);
        
        extern void CrosshairPreview(ImDrawList* draw, ImVec2 middlePoint);
        extern void ESPPreview(ImDrawList* draw, ImVec2 position, ImVec2 size);
        
        extern int SelectedTab;
        
        extern std::vector<const char*> BombTimerModes;
        extern std::vector<const char*> HitmarkerStyles;
        extern std::vector<const char*> RecoilCrosshairTypes;
        extern std::vector<const char*> RadarStyles;
    }
    
    namespace GrenadeHelperDev {
        namespace GInfo {
            extern int throwType;
        }
        
        extern bool DevWindowVisible;
        extern std::vector<const char*> ThrowTypes;
        extern std::string locationInputString;
        
        extern void Setup();
        extern void RunWindow();
        extern void DrawOutofgameNotice();
    }
}

#endif /** !GUITabs_DrawingTab_h */
