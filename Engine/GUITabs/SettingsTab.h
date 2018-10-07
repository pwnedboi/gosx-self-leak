/******************************************************/
/**                                                  **/
/**      GUITabs/SettingsTab.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef GUITabs_SettingsTab_h
#define GUITabs_SettingsTab_h

#include "Engine/common.h"

namespace GUI {
    namespace SettingsTab {
        extern void Render();
        
        extern void RenderImprovementsTab(ImGuiWindow* window);
        extern void RenderBunnyhopTab(ImGuiWindow* window);
#ifdef GOSX_BACKTRACKING
        extern void RenderBacktrackingTab(ImGuiWindow* window);
#endif
        
        extern std::vector<const char*> HitboxBones;
        extern std::vector<const char*> BacktrackVisualType;
        
        extern int SelectedTab;
        extern std::vector<std::string> Tabs;
    }
}

#endif /** !GUITabs_SettingsTab_h */
