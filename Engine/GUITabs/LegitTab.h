/******************************************************/
/**                                                  **/
/**      GUITabs/LegitTab.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef GUITabs_LegitTab_h
#define GUITabs_LegitTab_h

#include "Engine/common.h"
#include "SDK/CCSWpnInfo.h"

namespace GUI {
    namespace LegitTab {
        struct WeaponTypeItem_t {
            std::string typeName = "";
            std::string icon = "";
        };
        
        extern void Setup();
        extern void Render();
        
        extern void RenderAccuracyTab(ImGuiWindow* window);
        extern void RenderMiscTab(ImGuiWindow* window);
        extern void RenderTriggerbotTab(ImGuiWindow* window);
        extern void RenderAnticheatTab(ImGuiWindow* window);
        
        extern std::map<int, std::string> cachedWeaponList;
        
        extern std::vector<const char*> SelectionModes;
        extern std::vector<const char*> HitboxBones;
        extern std::vector<const char*> TargetingModes;
        extern std::map<CSWeaponType, WeaponTypeItem_t> WeaponTypes;
        
        extern int SelectedTab;
        extern int SelectedWeaponIndex;
        extern int SelectedWeaponCat;
        extern int SelectedWeaponBasedType;
    }
}

#endif /** !GUITabs_LegitTab_h */
