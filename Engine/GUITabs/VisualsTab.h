/******************************************************/
/**                                                  **/
/**      GUITabs/VisualsTab.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef GUITabs_VisualsTab_h
#define GUITabs_VisualsTab_h

#include "Engine/common.h"

namespace GUI {
    namespace VisualsTab {
        extern void Render();
        
        extern void RenderChamsTab(ImGuiWindow* window);
        extern void RenderGlowTab(ImGuiWindow* window);
        extern void RenderGrenadePredictionTab(ImGuiWindow* window);
        extern void RenderColorsTab(ImGuiWindow* window);
#ifdef GOSX_THIRDPERSON
        extern void RenderThirdpersonTab(ImGuiWindow* window);
#endif
        
        extern int SelectedTab;
        
        extern std::vector<const char*> ChamTypes;
        
        extern std::vector<const char*> PlayerChamTypes;
        extern std::vector<const char*> ArmsChamTypes;
    }
}

#endif /** !GUITabs_VisualsTab_h */
