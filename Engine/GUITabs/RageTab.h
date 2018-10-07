/******************************************************/
/**                                                  **/
/**      GUITabs/RageTab.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef GUITabs_RageTab_h
#define GUITabs_RageTab_h

#include "Engine/common.h"

#ifdef GOSX_RAGE_MODE

namespace GUI {
    namespace RageTab {
        extern void Render();
        
        extern void RenderAimTab(ImGuiWindow* window);
        extern void RenderAntiaimTab(ImGuiWindow* window);
        extern void RenderResolverTab(ImGuiWindow* window);
        extern void RenderMiscTab(ImGuiWindow* window);
        extern void RenderClantagTab(ImGuiWindow* window);
        extern void RenderMiscTab(ImGuiWindow* window);
        
        extern int SelectedTab;
        
        extern std::vector<const char*> PitchAAList;
        extern std::vector<const char*> YawAAList;
        extern std::vector<const char*> ResolverModes;
        extern std::vector<const char*> ClantagAnimationTypes;
        extern std::vector<const char*> AutostrafeTypes;
    }
}
#endif

#endif /** !GUITabs_RageTab_h */
