/******************************************************/
/**                                                  **/
/**      Engine/GUI.h                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Engine_GUI_h
#define Engine_GUI_h

#include "common.h"
#include "SDK/Color.h"
#include "SDK/EconomyItem.h"
// #include "SDK/Color.h"
#define IM_ARRAYSIZE(_ARR)  ((int)(sizeof(_ARR)/sizeof(*_ARR)))

#include "Engine/GUITabs/LegitTab.h"
#include "Engine/GUITabs/DrawingTab.h"
#include "Engine/GUITabs/VisualsTab.h"
#include "Engine/GUITabs/SettingsTab.h"
#ifdef GOSX_RAGE_MODE
#include "Engine/GUITabs/RageTab.h"
#endif
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

struct Item_t;
class ConVar;

struct ElementConfig_t {
    ElementConfig_t(std::string elementID_ = "", bool labelOnTop_ = false, std::string configSection_ = "", std::string configKey_ = "", int selectedWeaponID_ = 0, int selectedWeaponType_ = 0, int textLength_ = -1) {
        elementID = elementID_;
        labelOnTop = labelOnTop_;
        configSection = configSection_;
        configKey = configKey_;
        selectedWeaponID = selectedWeaponID_;
        selectedWeaponType = selectedWeaponType_;
        textLength = textLength_;
    }
    std::string elementID = "";
    bool labelOnTop = false;
    std::string configSection = "";
    std::string configKey = "";
    int selectedWeaponID = 0;
    int selectedWeaponType = 0;
    int textLength = -1;
};

enum MessagePopupType {
    MESSAGE_TYPE_INFO,
    MESSAGE_TYPE_SUCCESS,
    MESSAGE_TYPE_WARNING,
    MESSAGE_TYPE_ERROR
};

namespace GUI {
    extern bool IsVisible;
    extern bool IsInitialized;
    extern bool IsLastItem;
    
    extern bool SkinchangerVisible;
    extern bool ConfigsVisible;
    
    extern float LabelWidth;
    extern float LabelPercentage;
    extern int PageIndex;
    
    extern ConVar* cl_mouseenable;
    
    extern ImGuiWindow* MainWindow;
    
    extern bool IsMenuKeyPressed(SDL_Event* event);
    extern void ImPaintTraverseStart(SDL_Window* window);
    extern void ImPaintTraverseEnd();
    extern void SetStyles();
    extern void SetupGUI();
    extern void SetupConfigs();
    extern void RenderMenuFromJson(nlohmann::json data);
    extern void RenderStart(SDL_Window* window);
    extern void RenderEnd();
    extern void SetupMenu(SDL_Window* window);
    extern void LoadFontsTexture();
    extern void DrawOverlay();
#ifdef GOSX_MOJAVE_SWITCH
    extern bool IsInDarkMode();
#endif
    
    namespace Build {
        extern void AddFrameLabel(std::string label);
        extern bool AddCheckbox(std::string label, ElementConfig_t conf = {});
        extern bool AddFloatSlider(std::string label, float min, float max, ElementConfig_t conf = {});
        extern bool AddIntSlider(std::string label, float min, float max, ElementConfig_t conf = {});
        extern bool AddCombo(std::string label, const char **items, int items_count, int height_in_items = -1, ElementConfig_t conf = {});
        extern bool AddKeyInput(std::string label, bool allowMouseLeft = true, ElementConfig_t conf = {}, bool withModifiers = false);
        extern bool AddColorButton(std::string label, ElementConfig_t conf = {});
        extern bool AddSelectable(std::string label, ElementConfig_t conf = {}, bool odd = false);
        extern bool AddTextInput(std::string label, ElementConfig_t conf = {});
        extern bool AddMenuTextInput(std::string label, ElementConfig_t conf = {});
        extern void AddLabelText(std::string label, std::string text, ElementConfig_t conf = {});
        extern bool AddIconButton(std::string icon, ImVec2 size, std::string additionalText = "", ImVec4 background = {1.0f, 0.0f, 0.0f, 1.0f}, ImVec4 hoverBackground = {1.0f, 0.0f, 0.0f, 1.0f});
        extern float GetAvailWidth();
        extern void AddSpace(ImVec2 size);
        extern void AddCustomText(std::string text_string, int font_flags = 0, ImVec4 color = {1.0f, 1.0f, 1.0f, 1.0f});
        
        extern void StartSelectList(ImGuiID id, const ImVec2& size, ImGuiWindowFlags flags = 0);
        extern bool AddDefaultSelectable(const char* label, bool is_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0,0));
        extern bool AddDefaultSelectable(const char* label, bool* is_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0,0));
        extern void EndSelectList();
        
        extern bool IsKeyListening;
    }
    
    namespace MessagePopup {
        extern long durationTime;
        extern bool durationExpired;
        extern long lastDuration;
        extern long defaultDuration;
        extern std::string lastMessage;
        extern MessagePopupType lastType;
        
        extern void Tick();
        extern void AddMessage(std::string message, MessagePopupType type = MESSAGE_TYPE_INFO, long duration = 2000);
    }
    
    namespace SkinChanger {
        extern int SelectedWeapon;
        extern int SelectedTeam;
        extern std::string FilteredSkin;
        extern std::map<int, std::string> Weapons;
        extern std::vector<const char*> EntityQuality;
        extern bool ShowAllSkins;
        extern bool ShowCustomKnives;
        
        extern bool ShowChangeList;
        
        extern EconomyItem_t currentConfig;
        extern Item_t WeaponItem;
        extern int SelectedSkinsTab;
#ifdef GOSX_STICKER_CHANGER
        extern int SelectedStickerSlot;
        extern std::map<int, std::string> FilteredSticker;
#endif
#ifdef GOSX_SKINCHANGER_RARITY
        extern std::map<int, bool> FilteredRarities;
#endif
        extern std::vector<const char*> TeamSelect;
        
        extern void Setup();
        extern void RunWindow();
        extern void SetupTeamSelect();
        extern void SetupWeaponList();
        extern void SetupChangeList();
        extern void SetupSkinList();
        extern void RenderSkinsTab();
#ifdef GOSX_STICKER_CHANGER
        extern void RenderStickerTab();
        extern void SetupStickerSelect(int slot = 0);
#endif
        extern int MapSelectedTeam();
    }
    
    namespace Configs {
        extern std::map<int, std::string> files;
        extern std::string currentConfigPath;
        extern int currentConfigIndex;
        extern std::string lastLoadedConfig;
        extern std::string currFileName;
        
        extern std::string newfileInput;
        
        extern void Setup();
        extern void RunWindow();
        extern void ReloadConfigs();
        
        extern bool CreateConfig(std::string configFile = "");
        extern bool SaveConfig(std::string configFile = "");
        extern bool LoadConfig(std::string configFile = "");
        extern bool DeleteConfig(std::string configFile = "");
        
        extern void OpenFinder();
    }
    
    namespace Tabs {
        extern void BeginTabButton(int SelectedTab, int CurrIndex);
        extern void EndTabButton(int SelectedTab, int CurrIndex);
    }
    
    namespace Fonts {
        extern ImFont* Main;
        extern ImFont* Label;
        extern ImFont* Header;
        extern ImFont* Section;
        extern ImFont* CstrikeIcons;
        extern ImFont* CstrikeIconsBig;
    }
}

#endif /** !Engine_GUI_h */
