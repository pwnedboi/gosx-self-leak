/******************************************************/
/**                                                  **/
/**      Engine/GUI.cpp                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "GUI.h"
#include "Engine/Fonts/futura_medium.h"
#include "Engine/Fonts/futura_bold.h"
#include "Engine/Fonts/fontawesome_icons.h"
#include "Engine/Fonts/cstrike_icons.h"
#include "Engine/Drawing/manager.h"
#include "Engine/Weapons/manager.h"
#include "SDK/Definitions.h"
#include "SDK/Thirdparty/DynSkin.h"

namespace GUI {
    bool IsVisible = false;
    bool IsInitialized = false;
    bool IsLastItem = false;
    int PageIndex = 0;
    
    bool SkinchangerVisible = false;
    bool ConfigsVisible = false;
    
    ConVar* cl_mouseenable = nullptr;
    
    float LabelWidth = 135.0f;
    float LabelPercentage = 45.0f;
    
    ImGuiWindow* MainWindow = nullptr;
    
    bool IsMenuKeyPressed(SDL_Event* event) {
        return event->key.keysym.sym == (SDL_Keycode)Options::Main::menu_key;
    }
    
    void SetStyles() {
        ImGuiStyle& style = ImGui::GetStyle();
        
        float rounding = 2.25f;
        float spacing = 5.0f;
        float padding = 5.0f;
        
        style.WindowPadding = ImVec2(0.0f, 0.0f);
        style.WindowRounding = rounding;
        style.WindowTitleAlign = ImVec2(0.50f, 0.50f);
        style.FramePadding = ImVec2(padding, padding);
        style.FrameRounding = rounding;
        style.ItemSpacing = ImVec2(spacing, spacing);
        style.ItemInnerSpacing = ImVec2(spacing, spacing);
        style.IndentSpacing = 0.0f;
        style.ScrollbarSize = 12.0f;
        style.ScrollbarRounding = rounding / 2.0f;
        style.GrabRounding = rounding;
        style.GrabMinSize = 0.0f;
        
#ifdef GOSX_MOJAVE_SWITCH
        if (IsInDarkMode()) {
            style.Colors[ImGuiCol_Text]                  = {1.00f, 1.00f, 1.00f, 1.00f};
            style.Colors[ImGuiCol_WindowBg]              = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_ChildWindowBg]         = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_PopupBg]               = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_BorderShadow]          = {0.00f, 0.00f, 0.00f, 1.00f};
            style.Colors[ImGuiCol_FrameBg]               = {0.27f, 0.27f, 0.27f, 1.00f};
            style.Colors[ImGuiCol_FrameBgHovered]        = {0.31f, 0.31f, 0.31f, 1.00f};
            style.Colors[ImGuiCol_FrameBgActive]         = {0.00f, 0.42f, 0.60f, 0.39f};
            style.Colors[ImGuiCol_TitleBg]               = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_TitleBgCollapsed]      = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_TitleBgActive]         = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_MenuBarBg]             = {0.12f, 0.12f, 0.12f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarBg]           = {0.20f, 0.25f, 0.30f, 0.00f};
            style.Colors[ImGuiCol_ScrollbarGrab]         = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarGrabHovered]  = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarGrabActive]   = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_CheckMark]             = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_SliderGrab]            = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_SliderGrabActive]      = {0.26f, 0.86f, 0.55f, 1.00f};
            style.Colors[ImGuiCol_Button]                = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_ButtonHovered]         = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_ButtonActive]          = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_Header]                = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_HeaderHovered]         = {0.00f, 0.42f, 0.60f, 0.80f};
            style.Colors[ImGuiCol_HeaderActive]          = {0.00f, 0.42f, 0.60f, 0.80f};
            style.Colors[ImGuiCol_Column]                = {0.50f, 0.50f, 0.50f, 1.00f};
            style.Colors[ImGuiCol_ResizeGrip]            = {1.00f, 1.00f, 1.00f, 1.00f};
            style.Colors[ImGuiCol_SelectableBg]          = {0.00f, 0.00f, 0.00f, 0.00f};
        } else {
            style.Colors[ImGuiCol_Text]                  = {0.00f, 0.00f, 0.00f, 1.00f};
            style.Colors[ImGuiCol_WindowBg]              = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_ChildWindowBg]         = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_PopupBg]               = {0.18f, 0.18f, 0.18f, 1.00f};
            style.Colors[ImGuiCol_BorderShadow]          = {0.00f, 0.00f, 0.00f, 1.00f};
            style.Colors[ImGuiCol_FrameBg]               = {0.27f, 0.27f, 0.27f, 1.00f};
            style.Colors[ImGuiCol_FrameBgHovered]        = {0.31f, 0.31f, 0.31f, 1.00f};
            style.Colors[ImGuiCol_FrameBgActive]         = {0.00f, 0.42f, 0.60f, 0.39f};
            style.Colors[ImGuiCol_TitleBg]               = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_TitleBgCollapsed]      = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_TitleBgActive]         = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_MenuBarBg]             = {0.12f, 0.12f, 0.12f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarBg]           = {0.20f, 0.25f, 0.30f, 0.00f};
            style.Colors[ImGuiCol_ScrollbarGrab]         = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarGrabHovered]  = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_ScrollbarGrabActive]   = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_CheckMark]             = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_SliderGrab]            = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_SliderGrabActive]      = {0.26f, 0.86f, 0.55f, 1.00f};
            style.Colors[ImGuiCol_Button]                = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_ButtonHovered]         = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_ButtonActive]          = {0.11f, 0.76f, 0.42f, 1.00f};
            style.Colors[ImGuiCol_Header]                = {0.00f, 0.42f, 0.60f, 1.00f};
            style.Colors[ImGuiCol_HeaderHovered]         = {0.00f, 0.42f, 0.60f, 0.80f};
            style.Colors[ImGuiCol_HeaderActive]          = {0.00f, 0.42f, 0.60f, 0.80f};
            style.Colors[ImGuiCol_Column]                = {0.50f, 0.50f, 0.50f, 1.00f};
            style.Colors[ImGuiCol_ResizeGrip]            = {1.00f, 1.00f, 1.00f, 1.00f};
            style.Colors[ImGuiCol_SelectableBg]          = {0.00f, 0.00f, 0.00f, 0.00f};
        }
#endif
        
        style.Colors[ImGuiCol_Text]                  = {1.00f, 1.00f, 1.00f, 1.00f};
        style.Colors[ImGuiCol_WindowBg]              = {0.18f, 0.18f, 0.18f, 1.00f};
        style.Colors[ImGuiCol_ChildWindowBg]         = {0.18f, 0.18f, 0.18f, 1.00f};
        style.Colors[ImGuiCol_PopupBg]               = {0.18f, 0.18f, 0.18f, 1.00f};
        style.Colors[ImGuiCol_BorderShadow]          = {0.00f, 0.00f, 0.00f, 1.00f};
        style.Colors[ImGuiCol_FrameBg]               = {0.27f, 0.27f, 0.27f, 1.00f};
        style.Colors[ImGuiCol_FrameBgHovered]        = {0.31f, 0.31f, 0.31f, 1.00f};
        style.Colors[ImGuiCol_FrameBgActive]         = {0.00f, 0.42f, 0.60f, 0.39f};
        style.Colors[ImGuiCol_TitleBg]               = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_TitleBgCollapsed]      = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_TitleBgActive]         = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_MenuBarBg]             = {0.12f, 0.12f, 0.12f, 1.00f};
        style.Colors[ImGuiCol_ScrollbarBg]           = {0.20f, 0.25f, 0.30f, 0.00f};
        style.Colors[ImGuiCol_ScrollbarGrab]         = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_ScrollbarGrabHovered]  = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_ScrollbarGrabActive]   = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_CheckMark]             = {0.11f, 0.76f, 0.42f, 1.00f};
        style.Colors[ImGuiCol_SliderGrab]            = {0.11f, 0.76f, 0.42f, 1.00f};
        style.Colors[ImGuiCol_SliderGrabActive]      = {0.26f, 0.86f, 0.55f, 1.00f};
        style.Colors[ImGuiCol_Button]                = {0.11f, 0.76f, 0.42f, 1.00f};
        style.Colors[ImGuiCol_ButtonHovered]         = {0.11f, 0.76f, 0.42f, 1.00f};
        style.Colors[ImGuiCol_ButtonActive]          = {0.11f, 0.76f, 0.42f, 1.00f};
        style.Colors[ImGuiCol_Header]                = {0.00f, 0.42f, 0.60f, 1.00f};
        style.Colors[ImGuiCol_HeaderHovered]         = {0.00f, 0.42f, 0.60f, 0.80f};
        style.Colors[ImGuiCol_HeaderActive]          = {0.00f, 0.42f, 0.60f, 0.80f};
        style.Colors[ImGuiCol_Column]                = {0.50f, 0.50f, 0.50f, 1.00f};
        style.Colors[ImGuiCol_ResizeGrip]            = {1.00f, 1.00f, 1.00f, 1.00f};
        style.Colors[ImGuiCol_SelectableBg]          = {0.00f, 0.00f, 0.00f, 0.00f};
    }
    
    void RenderStart(SDL_Window* window) {
        int width, height;
        SDL_GetWindowSize(window, &width, &height);
        
        ImGui::SetNextWindowPos(ImVec2(0, 0), ImGuiSetCond_Always);
        ImGui::SetNextWindowSize(ImVec2(width, height), ImGuiSetCond_Always);
        ImGui::Begin(
            "",
            NULL,
            ImVec2(width, height),
            0.f,
            ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoSavedSettings | ImGuiWindowFlags_NoInputs
        );
    }
    
    void RenderEnd() {
        ImGui::End();
    }
    
    void SetupMenu(SDL_Window* window) {
        if (!IsVisible) {
            return;
        }
        
        static std::vector<std::string> tabs = {
            "Legit",
#ifdef GOSX_RAGE_MODE
            "Rage",
#endif
            "Drawing",
            "Visuals",
            "Settings"
        };
        
        static float buttonMaxWidth = 150.0f;
        static int itemCount = (int)(tabs.size() + 2);
        if (((itemCount * buttonMaxWidth) + (itemCount - 1)) > *Glob::SDLResW) {
            buttonMaxWidth = (*Glob::SDLResW - (itemCount - 1)) / itemCount;
        }

        static float ButtonHeight = 40.0f;
        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowMinSize, ImVec2(0,0));
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
        ImVec4 buttonmenu;
        ImVec4 buttonmenuNorm = {0.20f, 0.20f, 0.20f, 1.0f};
        ImVec4 buttonmenuHover = {0.28f, 0.28f, 0.28f, 1.0f};
        ImVec4 buttonmenuActive = {0.11f, 0.76f, 0.42f, 1.0f};
#ifdef GOSX_STREAM_PROOF
        if (StreamProof->Active()) {
            ImGui::PushStyleColor(ImGuiCol_WindowBg, {0.42f, 0.14f, 0.67f, 1.0f});
            buttonmenuNorm = {0.51f, 0.18f, 0.82f, 1.0f};
            buttonmenuHover = {0.61f, 0.34f, 0.86f, 1.0f};
        }
#endif
        ImGui::SetNextWindowSize(ImVec2((float)*Glob::SDLResW, ButtonHeight), ImGuiSetCond_Always);
        ImGui::SetNextWindowPos(ImVec2(0.0f, 0.0f), ImGuiSetCond_Always);
        if (ImGui::Begin("##MainMenuBar", NULL, ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoSavedSettings)) {
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 0.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 0.0f)); {
                ImGui::PushFont(Fonts::Header); {
                    float buttonOverallWidth = ((tabs.size() + 2) * buttonMaxWidth) + (tabs.size() + 1);
                    float leftMargin = (float)(*Glob::SDLResW / 2) - (buttonOverallWidth / 2);
                    ImGui::SameLine(0.0f, leftMargin);
                    int cnt = 0;
                    for (std::string tab : tabs) {
                        ImGuiButtonFlags flags = 0;
                        
                        buttonmenu = buttonmenuNorm;
                        if (PageIndex == cnt) {
                            buttonmenu = buttonmenuActive;
                            flags = ImGuiButtonFlags_Disabled;
                        }
                        ImGui::PushStyleColor(ImGuiCol_Button, buttonmenu);
                        buttonmenu = buttonmenuHover;
                        ImGui::PushStyleColor(ImGuiCol_ButtonActive, buttonmenu);
                        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, buttonmenuHover); {
                            if (ImGui::ButtonEx(tab.c_str(), ImVec2(buttonMaxWidth, ButtonHeight), flags)) {
                                PageIndex = cnt;
                            }
                        } ImGui::PopStyleColor(3);
                        ImGui::SameLine();
                        cnt++;
                    }

                    buttonmenu = buttonmenuNorm;
                    if (SkinchangerVisible) {
                        buttonmenu = buttonmenuActive;
                    }
                    ImGui::PushStyleColor(ImGuiCol_Button, buttonmenu);
                    buttonmenu = buttonmenuHover;
                    ImGui::PushStyleColor(ImGuiCol_ButtonActive, buttonmenu);
                    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, buttonmenuHover); {
                        if (ImGui::ButtonEx("Skin Changer", ImVec2(buttonMaxWidth, ButtonHeight))) {
                            SkinchangerVisible = !SkinchangerVisible;
                        }
                    } ImGui::PopStyleColor(3);
                    ImGui::SameLine();
                
                    buttonmenu = buttonmenuNorm;
                    if (ConfigsVisible) {
                        buttonmenu = buttonmenuActive;
                    }
                    ImGui::PushStyleColor(ImGuiCol_Button, buttonmenu);
                    buttonmenu = buttonmenuHover;
                    ImGui::PushStyleColor(ImGuiCol_ButtonActive, buttonmenu);
                    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, buttonmenuHover); {
                        if (ImGui::Button("Configs", ImVec2(buttonMaxWidth, ButtonHeight))) {
                            ConfigsVisible = !ConfigsVisible;
                        }
                    
                        if (*FirstRun) {
                            ConfigsVisible = true;
                        }
                    } ImGui::PopStyleColor(3);
                } ImGui::PopFont();
            } ImGui::PopStyleVar(2);
            ImGui::End();
        }
#ifdef GOSX_STREAM_PROOF
        if (StreamProof->Active()) {
            ImGui::PopStyleColor(1);
        }
#endif
        ImGui::PopStyleVar(3);
    }
    
#ifdef GOSX_MOJAVE_SWITCH
    bool IsInDarkMode() {
        NSAppearance *appearance = NSAppearance.currentAppearance;
        if (@available(*, macOS 10.14)) {
            return appearance.name == NSAppearanceNameDarkAqua;
        }
        
        return false;
    }
#endif
    
    void SetupGUI() {
        if (!IsVisible) {
            return;
        }
        
        if (!IsInitialized) {
            SkinChanger::Setup();
            Configs::Setup();
            GrenadeHelperDev::Setup();
            
            ImGuiWindowSettings* ini = ImGui::GetSettings("##Options");
            if (!ini) {
                ImGuiWindowSettings* newIni = ImGui::CreateSettings("##Options");
                newIni->Size = ImVec2(500.0f, 300.0f);
                ImGui::SaveSettings();
                ImGui::SetNextWindowSize(ImVec2(500.0f, 300.0f));
            }
            
            IsInitialized = true;
        }
        
        ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.28f, 0.28f, 0.28f, 1.0f));
        ImGui::PushStyleColor(ImGuiCol_ChildWindowBg, ImVec4(0.28f, 0.28f, 0.28f, 1.0f));
        if (ImGui::Begin("##Options", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar)) {
            ImGui::BeginChild(1000001); {
#ifdef GOSX_RAGE_MODE
                switch (PageIndex) {
                    case 0:
                    default:
                        LegitTab::Render();
                        break;
                    case 1:
                        RageTab::Render();
                        break;
                    case 2:
                        DrawingTab::Render();
                        break;
                    case 3:
                        VisualsTab::Render();
                        break;
                    case 4:
                        SettingsTab::Render();
                        break;
                }
#else
                switch (PageIndex) {
                    case 0:
                    default:
                        LegitTab::Render();
                        break;
                    case 1:
                        DrawingTab::Render();
                        break;
                    case 2:
                        VisualsTab::Render();
                        break;
                    case 3:
                        SettingsTab::Render();
                        break;
                }
#endif
            } ImGui::EndChild();
            ImGui::End();
        } ImGui::PopStyleColor(2);
        
        SkinChanger::RunWindow();
        Configs::RunWindow();
        GrenadeHelperDev::RunWindow();
    }
    
    
    
    ImFont* Fonts::Main = nullptr;
    ImFont* Fonts::Label = nullptr;
    ImFont* Fonts::Header = nullptr;
    ImFont* Fonts::Section = nullptr;
    ImFont* Fonts::CstrikeIcons = nullptr;
    ImFont* Fonts::CstrikeIconsBig = nullptr;
    
    namespace SkinChanger {
        int SelectedWeapon = (int)EItemDefinitionIndex::weapon_deagle;
        int SelectedTeam = TEAM_NONE;
        int SelectedSkinsTab = 0;
        std::map<int, std::string> Weapons;
        
        bool ShowChangeList = false;
        EconomyItem_t currentConfig;
        Item_t WeaponItem = Item_t("", "", "", "");
        
        bool ShowAllSkins = false;
        bool ShowCustomKnives = false;
        std::string FilteredSkin = "";
#ifdef GOSX_SKINCHANGER_RARITY
        std::map<int, bool> FilteredRarities = {
            {(int)EntityRarityType::rarity_common, true},
            {(int)EntityRarityType::rarity_uncommon, true},
            {(int)EntityRarityType::rarity_rare, true},
            {(int)EntityRarityType::rarity_mythical, true},
            {(int)EntityRarityType::rarity_legendary, true},
            {(int)EntityRarityType::rarity_ancient, true},
            {(int)EntityRarityType::rarity_immortal, true},
            {(int)EntityRarityType::rarity_unusual, true}
        };
#endif

        std::vector<const char*> EntityQuality = {
            "Normal",
            "Genuine",
            "Vintage",
            "Unusual",
            "Community",
            "Developer",
            "Self-Made",
            "Customized",
            "Strange",
            "Completed",
            "Tournament"
        };
        
        std::vector<const char*> TeamSelect = {
            "All",
            "Terrorist",
            "Counter-Terrorist"
        };
        
        void Setup() {
            SelectedWeapon = (int)EItemDefinitionIndex::weapon_deagle;
            if (strlen(WeaponItem.display_name) == 0 && ItemDefinitionIndex.find(SelectedWeapon) != ItemDefinitionIndex.end()) {
                WeaponItem = ItemDefinitionIndex.at(SelectedWeapon);
            }
            
            for (int index = (int)EItemDefinitionIndex::weapon_deagle; index < (int)EItemDefinitionIndex::glove_max; index++) {
                if (ItemDefinitionIndex.find(index) != ItemDefinitionIndex.end()) {
                    if (
                        WeaponManager::IsGrenade(index) ||
                        (
                         index >= (int)EItemDefinitionIndex::weapon_max &&
                         index != (int)EItemDefinitionIndex::glove_t &&
                         index != (int)EItemDefinitionIndex::glove_ct
                        ) ||
                        index == (int)EItemDefinitionIndex::weapon_taser ||
                        index == (int)EItemDefinitionIndex::weapon_c4
                    ) {
                        continue;
                    }
                    
                    Item_t currItem = ItemDefinitionIndex.at(index);
                    
                    Weapons[index] = std::string(currItem.display_name);
                }
            }
        }
        
        void RunWindow() {
            if (!SkinchangerVisible) {
                return;
            }

#ifdef GOSX_STICKER_CHANGER
            static std::vector<std::string> Tabs = {
                "Skins & Gloves",
                "Stickers"
            };
#endif
            
            ShowAllSkins = CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("SkinChanger", "show_all_skins", ShowAllSkins);
            ShowCustomKnives = CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("SkinChanger", "show_all_knives", ShowCustomKnives);
            
            ImGui::SetNextWindowSize(ImVec2(700, 450), ImGuiSetCond_Always);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
            std::string WindowTitle = "Skins | Gloves";
#ifdef GOSX_STICKER_CHANGER
            WindowTitle.append(" | Stickers");
#endif
            if (ImGui::Begin(WindowTitle.c_str(), NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar)) {
                DrawManager->DrawRect((int)ImGui::GetCurrentWindow()->DC.CursorPos.x, (int)ImGui::GetCurrentWindow()->DC.CursorPos.y, 180, (int)ImGui::GetContentRegionAvail().y + 100, Color((int)(0.28f * 255), (int)(0.28f * 255), (int)(0.28f * 255)));
                ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0.0f, 0.0f));
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
                ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0.0f);
                ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.0f});
                ImGui::BeginChildFrame(9901, ImVec2(180.0f, 0.0f)); {
                    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(3.5f, 3.5f));
                    ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 5.0f);
                    SetupTeamSelect();
                
                    SetupWeaponList();
                    ImGui::PopStyleVar(2);
                } ImGui::EndChildFrame();
                ImGui::SameLine();
                ImGui::PopStyleVar(2);
            
#ifdef GOSX_STICKER_CHANGER
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 0.0f));
                ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0.0f);
                ImGui::BeginChildFrame(9902, ImVec2(0.0f, ImGui::GetContentRegionAvail().y), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar); {
                    ImGui::BeginGroup(); {
                        ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 0.0f));
                        ImVec2 ButtonSize = ImVec2((ImGui::GetWindowWidth() / Tabs.size()) - 1.0f, 25.0f);
                        for (int i = 0; i < Tabs.size(); i++) {
                            std::string ButtonTitle = Tabs.at(i);
                            if ((WeaponManager::IsKnife(SelectedWeapon) || WeaponManager::IsGlove(SelectedWeapon)) && i == 1) {
                                ButtonTitle.append(" ").append(ICON_FA_LOCK);
                            }
                            
                            int BackupSelectedSkinsTab = SelectedSkinsTab;
                            Tabs::BeginTabButton(BackupSelectedSkinsTab, i); {
                                if (ImGui::Button(ButtonTitle.c_str(), ButtonSize)) {
                                    if ((WeaponManager::IsKnife(SelectedWeapon) || WeaponManager::IsGlove(SelectedWeapon)) && i == 1) {
                                        SelectedSkinsTab = 0;
                                    } else {
                                        SelectedSkinsTab = i;
                                    }
                                }
                            } Tabs::EndTabButton(BackupSelectedSkinsTab, i);
                            
                            if (!(i > (Tabs.size() - 1))) {
                                ImGui::SameLine();
                            }
                        }
                        ImGui::PopStyleVar(1);
                    }
                    ImGui::EndGroup();
                
                    ImGui::BeginGroup(); {
                        DrawManager->DrawRect((int)ImGui::GetCurrentWindow()->DC.CursorPos.x, (int)ImGui::GetCurrentWindow()->DC.CursorPos.y, (int)ImGui::GetWindowWidth() + 100, (int)ImGui::GetWindowHeight() + 100, Color((int)(0.28f * 255), (int)(0.28f * 255), (int)(0.28f * 255)));
                        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
                        ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 5.0f);
                        switch (SelectedSkinsTab) {
                            case 0:
                                RenderSkinsTab();
                                break;
                            case 1:
                                RenderStickerTab();
                                break;
                        }
                        ImGui::PopStyleVar(2);
                    } ImGui::EndGroup();
                }
                ImGui::EndChildFrame();
                ImGui::PopStyleVar(3);
#else
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 0.0f));
                ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0.0f);
                ImGui::BeginChildFrame(9902, ImVec2(0.0f, ImGui::GetContentRegionAvail().y), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar); {
                    ImGui::BeginGroup(); {
                        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
                        ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 5.0f);
                        RenderSkinsTab();
                        ImGui::PopStyleVar(2);
                    } ImGui::EndGroup();
                } ImGui::EndChildFrame();
                ImGui::PopStyleVar(3);
#endif
                ImGui::PopStyleColor(1);
                ImGui::End();
            } ImGui::PopStyleVar(1);
        }
        
        void RenderSkinsTab() {
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 5.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(5.0f, 5.0f)); {
                ImGui::BeginChildFrame(9990, ImVec2(0.0f, 0.0f)); {
                    ImGui::Columns(2, NULL, false); {
                        SetupChangeList();
                        SetupSkinList();
                    } ImGui::NextColumn(); {
                        ImGui::BeginChildFrame(4, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollbar); {
                            ImGui::PushItemWidth(ImGui::GetContentRegionAvail().x); {
                                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 0.0f)); {
                                    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                                    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
#ifdef GOSX_MP7TOMP5_FIX
                                        if (SelectedWeapon == EItemDefinitionIndex::weapon_mp7) {
                                            bool mp5sdOn = currentConfig.item_definition_index == EItemDefinitionIndex::weapon_mp5sd;
                                            ImGui::PushFont(Fonts::Label); {
                                                Build::AddCustomText("Convert to MP5 SD", FONTFLAG_DROPSHADOW);
                                            }
                                            ImGui::PopFont();
                                            ImGui::Checkbox("##MP7ToMP5SD", &mp5sdOn);
                                            if (mp5sdOn && currentConfig.item_definition_index != EItemDefinitionIndex::weapon_mp5sd) {
                                                currentConfig.item_definition_index = EItemDefinitionIndex::weapon_mp5sd;
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            } else if (!mp5sdOn && currentConfig.item_definition_index != -1) {
                                                currentConfig.item_definition_index = -1;
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            }
                                        }
#endif
                                        ImGui::PushFont(Fonts::Label); {
                                            Build::AddCustomText("Wear", FONTFLAG_DROPSHADOW);
                                        } ImGui::PopFont();
                                        if (ImGui::SliderFloat("##Wear", &currentConfig.fallback_wear, 0.000001f, 1.0f)) {
                                            Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                        }
                                    
                                        if (!WeaponManager::IsGlove(currentConfig.item_definition_index) && !WeaponManager::IsGlove(SelectedWeapon)) {
                                            ImGui::PushFont(Fonts::Label); {
                                                Build::AddCustomText("Quality", FONTFLAG_DROPSHADOW);
                                            } ImGui::PopFont();
                                            if (ImGui::Combo("##Quality", &currentConfig.entity_quality, EntityQuality.data(), (int)EntityQuality.size())) {
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            }
                                        }
                                    
                                        ImGui::PushFont(Fonts::Label); {
                                            Build::AddCustomText("Seed", FONTFLAG_DROPSHADOW);
                                        } ImGui::PopFont();
                                        if (ImGui::SliderInt("##Seed", &currentConfig.fallback_seed, 0, 10000)) {
                                            Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                        }
                                    
                                        if (!WeaponManager::IsGlove(currentConfig.item_definition_index) && !WeaponManager::IsGlove(SelectedWeapon)) {
                                            bool statTrakOn = currentConfig.fallback_stattrak > -1;
                                            ImGui::PushFont(Fonts::Label); {
                                                Build::AddCustomText("StatTrak", FONTFLAG_DROPSHADOW);
                                            } ImGui::PopFont();
                                            ImGui::Checkbox("##StatTrak", &statTrakOn);
                                            if (statTrakOn && currentConfig.fallback_stattrak == -1) {
                                                currentConfig.fallback_stattrak = 0;
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            } else if (!statTrakOn && currentConfig.fallback_stattrak > -1) {
                                                currentConfig.fallback_stattrak = -1;
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            }
                                            
                                            ImGui::PushFont(Fonts::Label); {
                                                Build::AddCustomText("Nametag", FONTFLAG_DROPSHADOW);
                                            } ImGui::PopFont();
                                            char inputText[18] = "";
                                            if (currentConfig.custom_name.length() > 0) {
                                                sprintf(inputText, "%s", currentConfig.custom_name.c_str());
                                            }
                                            if (ImGui::InputText("##Nametag", inputText, sizeof(inputText))) {
                                                currentConfig.custom_name = std::string(inputText);
                                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                            }
                                        }
                                    
                                        ImGui::NewLine();
                                        ImGui::NewLine();
                                    }
                                    ImGui::PopStyleColor(2);
                                
                                    if (Engine->IsConnected() && Engine->IsInGame()) {
                                        if (Build::AddIconButton(ICON_FA_REFRESH, ImVec2(ImGui::GetContentRegionAvail().x, 18.0f), "Apply Skins", {0.0f, 0.70f, 0.0f, 1.0f}, {0.0f, 0.78f, 0.0f, 1.0f})) {
                                            GUI::MessagePopup::AddMessage("Skins applied!", MESSAGE_TYPE_SUCCESS, 1500);
                                            GetLocalClient(-1)->ForceFullUpdate();
                                            Glob::SkinsConfig->ReloadSettings();
                                        }
                                    }
                                    if (Glob::SkinsConfig->HasSkinConfiguration(std::string(WeaponItem.entity_name), MapSelectedTeam())) {
                                        if (Build::AddIconButton(ICON_FA_TRASH, ImVec2(ImGui::GetContentRegionAvail().x, 18.0f), "Delete Skin", {0.70f, 0.0f, 0.0f, 1.0f}, {0.78f, 0.0f, 0.0f, 1.0f})) {
                                            Glob::SkinsConfig->DeleteSkinConfiguration(WeaponItem.entity_name, MapSelectedTeam());
                                            GUI::MessagePopup::AddMessage("Skin deleted!", MESSAGE_TYPE_INFO, 2500);
                                        }
                                    }
                                } ImGui::PopStyleVar(1);
                            } ImGui::PopItemWidth();
                        } ImGui::EndChildFrame();
                    } ImGui::Columns(1);
                } ImGui::EndChildFrame();
            } ImGui::PopStyleVar(2);
        }

#ifdef GOSX_STICKER_CHANGER
        void RenderStickerTab() {
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(2.0f, 5.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(5.0f, 5.0f)); {
                ImGui::BeginChildFrame(9990, ImVec2(0.0f, 0.0f)); {
                    ImGui::Columns(4, NULL, false); {
                        SetupStickerSelect(0);
                    } ImGui::NextColumn(); {
                        SetupStickerSelect(1);
                    } ImGui::NextColumn(); {
                        SetupStickerSelect(2);
                    } ImGui::NextColumn(); {
                        SetupStickerSelect(3);
                    } ImGui::Columns(1);
                } ImGui::EndChildFrame();
            } ImGui::PopStyleVar(2);
        }
#endif
        
        void SetupTeamSelect() {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("Select Team", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();

            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
                    ImGui::PushItemWidth(Build::GetAvailWidth());
                    if (ImGui::Combo("##teamSelectCombo", &SelectedTeam, TeamSelect.data(), (int)TeamSelect.size())) {
                        SelectedWeapon = (int)EItemDefinitionIndex::weapon_deagle;
                        if (strlen(WeaponItem.display_name) == 0 && ItemDefinitionIndex.find(SelectedWeapon) != ItemDefinitionIndex.end()) {
                            WeaponItem = ItemDefinitionIndex.at(SelectedWeapon);
                        }
                        
                        if (Glob::SkinsConfig->HasSkinConfiguration(std::string(WeaponItem.entity_name), MapSelectedTeam())) {
                            currentConfig = Glob::SkinsConfig->GetSkinConfiguration(std::string(WeaponItem.entity_name), MapSelectedTeam());
                        } else {
                            currentConfig.Reset();
                        }
                    }
                    ImGui::PopItemWidth();
                } ImGui::PopStyleVar(1);
            } ImGui::PopStyleColor(2);
        }
        
        void SetupWeaponList() {
            ImGuiStyle& style = ImGui::GetStyle();

            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 5.0f));
            ImGui::BeginChildFrame(69990, ImVec2(0.0f, 26.0f), ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse); {
                ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f));
                if (ImGui::Checkbox("Show Custom Knives", &ShowCustomKnives)) {
                    CSettingsManager::Instance(currentConfigName)->SetBoolValue("SkinChanger", "show_all_knives", ShowCustomKnives);
                    CSettingsManager::Instance(currentConfigName)->SaveSettings();
                }
                ImGui::PopStyleVar(1);
                ImGui::PopStyleColor(2);
            } ImGui::EndChildFrame();
            ImGui::PopStyleVar(1);
            
            static ImVec4 even = {0.0f, 0.0f, 0.0f, 0.0f};
            static ImVec4 odd = {1.0f, 1.0f, 1.0f, 0.075f};
            
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                Build::StartSelectList(1, ImVec2(0.0f, 0.0f)); {
                    int c = 0;
                    for (auto item : SkinChanger::Weapons) {
                        if (!ShowCustomKnives && WeaponManager::IsCustomKnife(item.first)) {
                            continue;
                        }
                        
                        if (
                            (MapSelectedTeam() == TEAM_T && !WeaponManager::IsTerrorWeapon(item.first)) ||
                            (MapSelectedTeam() == TEAM_CT && !WeaponManager::IsCounterTerrorWeapon(item.first)) ||
                            (MapSelectedTeam() == TEAM_NONE && !WeaponManager::IsForAll(item.first))
                        ) {
                            continue;
                        }
                        
                        ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                            Item_t currItem = ItemDefinitionIndex.at(item.first);
                            
                            bool isNotSelected = SkinChanger::SelectedWeapon != item.first;
                            bool HasSkinConfig = Glob::SkinsConfig->HasSkinConfiguration(std::string(currItem.entity_name), MapSelectedTeam());
                            if (HasSkinConfig && isNotSelected) {
                                ImVec4 color = style.Colors[ImGuiCol_TitleBg];
                                color.w = 0.25f;
                                
                                ImGui::PushStyleColor(ImGuiCol_SelectableBg, color);
                            }
                            
                            if (Build::AddDefaultSelectable(Options::Config::weapon_icons ? item.second.append(" " + WeaponManager::GetWeaponIcon(item.first)).c_str() : item.second.c_str(), !isNotSelected)) {
                                SkinChanger::SelectedWeapon = item.first;
                                SkinChanger::WeaponItem = currItem;
                                
                                if (Glob::SkinsConfig->HasSkinConfiguration(std::string(currItem.entity_name), MapSelectedTeam())) {
                                    currentConfig = Glob::SkinsConfig->GetSkinConfiguration(currItem.entity_name, MapSelectedTeam());
                                } else {
                                    currentConfig.Reset();
                                }
                            }
                            
                            if (HasSkinConfig && isNotSelected) {
                                ImGui::PopStyleColor(1);
                            }
                        } ImGui::PopStyleColor(1);
                        
                        c++;
                    }
                } Build::EndSelectList();
            } ImGui::PopStyleColor(2);
        }
        
#ifdef GOSX_STICKER_CHANGER
        int SelectedStickerSlot = 0;
        std::map<int, std::string> FilteredSticker;
        void SetupStickerSelect(int slot) {
            ImGuiStyle& style = ImGui::GetStyle();
            
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText(std::string("Slot ").append(std::to_string(slot + 1)), FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
            
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
                    ImGui::PushItemWidth(Build::GetAvailWidth() - 20.0f);
                    char filterText[18] = "";
                    sprintf(filterText, "%s", FilteredSticker[slot].c_str());
                    if (ImGui::InputText(std::string("##StickerFilter").append(std::to_string(slot)).c_str(), filterText, 18)) {
                        FilteredSticker[slot] = std::string(filterText);
                    }
                    ImGui::PopItemWidth();
                    ImGui::SameLine();
                    ImGui::Text("%s", ICON_FA_FILTER);
                } ImGui::PopStyleVar(1);
            } ImGui::PopStyleColor(2);
            
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {

                GUI::Build::StartSelectList(30 + slot, ImVec2(0.0f, 0.0f)); {
                    static ImVec4 even = {0.0f, 0.0f, 0.0f, 0.0f};
                    static ImVec4 odd = {1.0f, 1.0f, 1.0f, 0.075f};
                    int c = 0;
                    
                    for (std::shared_ptr<CSkinSticker> sticker : Glob::SkinList->GetStickerList()) {
                        if (sticker->GetName() == "") {
                            continue;
                        }
                        
                        if (FilteredSticker[slot] != "") {
                            std::string StickerName = sticker->GetName();
                            std::string FilteredStickerTmp = FilteredSticker[slot];
                            std::transform(StickerName.begin(), StickerName.end(), StickerName.begin(), ::tolower);
                            std::transform(FilteredStickerTmp.begin(), FilteredStickerTmp.end(), FilteredStickerTmp.begin(), ::tolower);
                            if (StickerName.find(FilteredStickerTmp) == std::string::npos) {
                                continue;
                            }
                        }
                        
                        bool IsSelected = false;
                        switch (slot) {
                            case 0:
                                IsSelected = (bool)(currentConfig.sticker_slot1 == sticker->GetID());
                                break;
                            case 1:
                                IsSelected = (bool)(currentConfig.sticker_slot2 == sticker->GetID());
                                break;
                            case 2:
                                IsSelected = (bool)(currentConfig.sticker_slot3 == sticker->GetID());
                                break;
                            case 3:
                                IsSelected = (bool)(currentConfig.sticker_slot4 == sticker->GetID());
                                break;
                        }
                        
                        ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                        
                            if (IsSelected) {
                                ImVec4 color = style.Colors[ImGuiCol_TitleBg];
                                color.w = 0.25f;
                                
                                ImGui::PushStyleColor(ImGuiCol_SelectableBg, color);
                            }
                        
#ifdef GOSX_SKINCHANGER_RARITY
                            bool hasRarity = false;
                            if (ItemDefinitionRarity.find(sticker->GetRarity()) != ItemDefinitionRarity.end()) {
                                hasRarity = true;
                                ImGui::PushStyleColor(ImGuiCol_SelectableBg, ItemDefinitionRarity.at(sticker->GetRarity()).display_color.ToImVec4());
                            }
#endif
                            if (Build::AddDefaultSelectable(sticker->GetName().c_str(), IsSelected)) {
                                switch (slot) {
                                    case 0:
                                        currentConfig.sticker_slot1 = sticker->GetID();
                                        break;
                                    case 1:
                                        currentConfig.sticker_slot2 = sticker->GetID();
                                        break;
                                    case 2:
                                        currentConfig.sticker_slot3 = sticker->GetID();
                                        break;
                                    case 3:
                                        currentConfig.sticker_slot4 = sticker->GetID();
                                        break;
                                }
                                Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                            }
#ifdef GOSX_SKINCHANGER_RARITY
                            if (hasRarity) {
                                ImGui::PopStyleColor(1);
                            }
#endif
                            
                            if (IsSelected) {
                                ImGui::PopStyleColor(1);
                            }
                            
                        } ImGui::PopStyleColor(1);
                        
                        c++;
                    }
                } GUI::Build::EndSelectList();
                
            } ImGui::PopStyleColor(2);
        }
#endif
        
        void SetupChangeList() {
            if (!WeaponManager::IsDefaultKnife(SelectedWeapon) && !WeaponManager::IsGlove(SkinChanger::SelectedWeapon)) {
                if (ShowChangeList) {
                    ShowChangeList = false;
                }
                
                return;
            }
            
            if (!ShowChangeList) {
                ShowChangeList = true;
            }

            static ImVec4 even = {0.0f, 0.0f, 0.0f, 0.0f};
            static ImVec4 odd = {1.0f, 1.0f, 1.0f, 0.075f};
            int c = 0;
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                
                GUI::Build::StartSelectList(2, ImVec2(0.0f, 100.0f)); {
                    if (WeaponManager::IsDefaultKnife(SkinChanger::SelectedWeapon)) {
                        for (int index = (int)EItemDefinitionIndex::weapon_knife_bayonet; index < (int)EItemDefinitionIndex::weapon_max; index++) {
                            if (ItemDefinitionIndex.find(index) == ItemDefinitionIndex.end()) {
                                continue;
                            }
                            
                            ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                                Item_t currItem = ItemDefinitionIndex.at(index);
                                if (Build::AddDefaultSelectable(Options::Config::weapon_icons ? std::string(currItem.display_name).append(" " + WeaponManager::GetWeaponIcon(index)).c_str() : currItem.display_name, currentConfig.item_definition_index == index)) {
                                    currentConfig.item_definition_index = index;
                                    Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                }
                            } ImGui::PopStyleColor(1);
                            
                            c++;
                        }
                    } else if (WeaponManager::IsGlove(SkinChanger::SelectedWeapon)) {
                        for (int index = (int)EItemDefinitionIndex::studded_bloodhound_gloves; index < (int)EItemDefinitionIndex::glove_max; index++) {
                            if (index == (int)EItemDefinitionIndex::glove_t || index == (int)EItemDefinitionIndex::glove_ct) {
                                continue;
                            }
                            if (ItemDefinitionIndex.find(index) == ItemDefinitionIndex.end()) {
                                continue;
                            }
                            
                            ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                                Item_t currItem = ItemDefinitionIndex.at(index);
                                if (Build::AddDefaultSelectable(currItem.display_name, currentConfig.item_definition_index == index)) {
                                    currentConfig.item_definition_index = index;
                                    Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                }
                            } ImGui::PopStyleColor(1);
                            
                            c++;
                        }
                    }
                } GUI::Build::EndSelectList();
                
            } ImGui::PopStyleColor(2);
        }
        
        void SetupSkinList() {
            if (ShowChangeList) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Skin", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
            }
            if (Glob::SkinList->HasSkins("weapon_all")) {
                ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f));
                if (ImGui::Checkbox("Show All Skins", &ShowAllSkins)) {
                    CSettingsManager::Instance(currentConfigName)->SetBoolValue("SkinChanger", "show_all_skins", ShowAllSkins);
                    CSettingsManager::Instance(currentConfigName)->SaveSettings();
                }
                ImGui::PopStyleVar(1);
                ImGui::PopStyleColor(2);
            }
            
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
                    ImGui::PushItemWidth(Build::GetAvailWidth() - 20.0f);
                    char filterText[18] = "";
                    sprintf(filterText, "%s", FilteredSkin.c_str());
                    if (ImGui::InputText(std::string("##SkinFilter").c_str(), filterText, 18)) {
                        FilteredSkin = std::string(filterText);
                    }
                    ImGui::PopItemWidth();
                    ImGui::SameLine();
                    ImGui::Text("%s", ICON_FA_FILTER);
                } ImGui::PopStyleVar(1);
            } ImGui::PopStyleColor(2);

#ifdef GOSX_SKINCHANGER_RARITY
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 0.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 10.0f);
            for (int i = (int)EntityRarityType::rarity_common; i <= (int)EntityRarityType::rarity_immortal; i++) {
                SkinRarity_t rarity = ItemDefinitionRarity.at(i);
                Color RarityColor = rarity.display_color;
                if (FilteredRarities[i]) {
                    RarityColor.SetA(255);
                }
                
                ImGui::PushStyleColor(ImGuiCol_Button, RarityColor.ToImVec4());
                ImGui::PushStyleColor(ImGuiCol_ButtonActive, RarityColor.ToImVec4());
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, RarityColor.ToImVec4());
                std::string ToolTipID = std::string("##filter_rarity_").append(rarity.origin_name);
                if (ImGui::Button(ToolTipID.c_str(), ImVec2(16.0f, 16.0f))) {
                    FilteredRarities[i] = !FilteredRarities[i];
                }
                
                ImGui::PopStyleColor(3);
                
                if (i != (int)EntityRarityType::rarity_immortal) {
                    ImGui::SameLine();
                }
            }
            ImGui::PopStyleVar(2);
#endif
            
            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                
                GUI::Build::StartSelectList(3, ImVec2(0.0f, 0.0f)); {
                    if (ShowAllSkins) {
                        if (Glob::SkinList->HasSkins("weapon_all")) {
                            CSkinWeapon SkinsWeapon = Glob::SkinList->GetWeaponSkins("weapon_all");
                            
                            for (std::shared_ptr<CSkinData> skin : SkinsWeapon._skinData) {
#ifdef GOSX_SKINCHANGER_RARITY
                                if (!FilteredRarities[(int)skin->GetRarity()]) {
                                    continue;
                                }
#endif
                                
                                if (FilteredSkin != "") {
                                    std::string StickerName = skin->GetRealName();
                                    std::string FilteredStickerTmp = FilteredSkin;
                                    std::transform(StickerName.begin(), StickerName.end(), StickerName.begin(), ::tolower);
                                    std::transform(FilteredStickerTmp.begin(), FilteredStickerTmp.end(), FilteredStickerTmp.begin(), ::tolower);
                                    if (StickerName.find(FilteredStickerTmp) == std::string::npos) {
                                        continue;
                                    }
                                }
                                
                                std::string skinName = skin->GetRealName();
                                if (skin->GetPhase() != "") {
                                    skinName.append(" (");
                                    skinName.append(skin->GetPhase());
                                    skinName.append(")");
                                }
                                
#ifdef GOSX_SKINCHANGER_RARITY
                                bool hasRarity = false;
                                if (ItemDefinitionRarity.find((int)skin->GetRarity()) != ItemDefinitionRarity.end()) {
                                    hasRarity = true;
                                    ImGui::PushStyleColor(ImGuiCol_SelectableBg, ItemDefinitionRarity.at((int)skin->GetRarity()).display_color.ToImVec4());
                                }
#endif
                                if (Build::AddDefaultSelectable(skinName.c_str(), currentConfig.fallback_paint_kit == skin->GetSkinId())) {
                                    currentConfig.fallback_paint_kit = skin->GetSkinId();
                                    Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                }
                                
#ifdef GOSX_SKINCHANGER_RARITY
                                if (hasRarity) {
                                    ImGui::PopStyleColor(1);
                                }
#endif
                            }
                        } else {
                            ShowAllSkins = false;
                        }
                    } else {
                        Item_t currEntity = WeaponItem;
                        if ((WeaponManager::IsKnife(SelectedWeapon) || WeaponManager::IsGlove(SelectedWeapon)) && ItemDefinitionIndex.find(currentConfig.item_definition_index) != ItemDefinitionIndex.end()) {
                            currEntity = ItemDefinitionIndex.at(currentConfig.item_definition_index);
                        }
                    
                        if (Glob::SkinList->HasSkins(std::string(currEntity.entity_name))) {
                            CSkinWeapon SkinsWeapon = Glob::SkinList->GetWeaponSkins(std::string(currEntity.entity_name));

                            for (std::shared_ptr<CSkinData> skin : SkinsWeapon._skinData) {
#ifdef GOSX_SKINCHANGER_RARITY
                                if (!FilteredRarities[(int)skin->GetRarity()]) {
                                    continue;
                                }
#endif
                                
                                if (FilteredSkin != "") {
                                    std::string StickerName = skin->GetRealName();
                                    std::string FilteredStickerTmp = FilteredSkin;
                                    std::transform(StickerName.begin(), StickerName.end(), StickerName.begin(), ::tolower);
                                    std::transform(FilteredStickerTmp.begin(), FilteredStickerTmp.end(), FilteredStickerTmp.begin(), ::tolower);
                                    if (StickerName.find(FilteredStickerTmp) == std::string::npos) {
                                        continue;
                                    }
                                }
                                
                                std::string skinName = skin->GetRealName();
                                if (skin->GetPhase() != "") {
                                    skinName.append(" (");
                                    skinName.append(skin->GetPhase());
                                    skinName.append(")");
                                }
                                
#ifdef GOSX_SKINCHANGER_RARITY
                                bool hasRarity = false;
                                if (ItemDefinitionRarity.find((int)skin->GetRarity()) != ItemDefinitionRarity.end()) {
                                    hasRarity = true;
                                    ImGui::PushStyleColor(ImGuiCol_SelectableBg, ItemDefinitionRarity.at((int)skin->GetRarity()).display_color.ToImVec4());
                                }
#endif
                                if (Build::AddDefaultSelectable(skinName.c_str(), currentConfig.fallback_paint_kit == skin->GetSkinId())) {
                                    currentConfig.fallback_paint_kit = skin->GetSkinId();
                                    Glob::SkinsConfig->SetSkinConfiguration(WeaponItem.entity_name, currentConfig, MapSelectedTeam());
                                }

#ifdef GOSX_SKINCHANGER_RARITY
                                if (hasRarity) {
                                    ImGui::PopStyleColor(1);
                                }
#endif
                            }
                        }
                    }
                } GUI::Build::EndSelectList();
                
            } ImGui::PopStyleColor(2);
        }
        
        int MapSelectedTeam() {
            switch (SelectedTeam) {
                case 1:
                    return TEAM_T;
                case 2:
                    return TEAM_CT;
                default:
                    return TEAM_NONE;
            }
        }
    }
    
    namespace Configs {
        std::map<int, std::string> files;
        std::string currentConfigPath = "";
        int currentConfigIndex = 0;
        std::string lastLoadedConfig = "";
        std::string currFileName = "";
        
        std::string newfileInput = "";
        
        void Setup() {
            currentConfigPath = Functions::GetSettingsDir();
            currentConfigPath.append("configs/");
            currentConfigIndex = -1;

            currFileName = "";
            
            ReloadConfigs();
        }
        
        void RunWindow() {
            if (!ConfigsVisible) {
                return;
            }
            
            ImGui::SetNextWindowSize(ImVec2(300, 350), ImGuiSetCond_Always);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(10.0f, 10.0f));
            if (ImGui::Begin("Configs", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar)) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Config List", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
            
                GUI::Build::StartSelectList(2000001, ImVec2(0.0f, 75.0f)); {
                    for (auto file : files) {
                        if (currentConfigIndex == -1 && currentConfigName == "configs/" + file.second) {
                            currentConfigIndex = file.first;
                        }
                        
                        std::string listLabel = "configs/";
                        listLabel.append(file.second);
                        
                        if (Build::AddDefaultSelectable(listLabel.c_str(), currentConfigIndex == file.first)) {
                            currentConfigIndex = file.first;
                        }
                    }
                } GUI::Build::EndSelectList();
                
                if (currentConfigIndex != -1) {
                    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 5.0f)); {
                        if (Build::AddIconButton(ICON_FA_FLOPPY_O, ImVec2(0.0f, 18.0f), "Save", ImColor(0.0f, 0.70f, 0.0f), ImColor(0.0f, 0.78f, 0.0f))) {
                            SaveConfig();
                        }
                        ImGui::SameLine();
                        if (Build::AddIconButton(ICON_FA_EXCHANGE, ImVec2(0.0f, 18.0f), "Load", ImColor(0.0f, 0.42f, 0.6f), ImColor(0.0f, 0.5f, 0.6f))) {
                            LoadConfig();
                        }
                        ImGui::SameLine();
                        if (Build::AddIconButton(ICON_FA_TRASH, ImVec2(0.0f, 18.0f), "Delete", ImColor(0.70f, 0.0f, 0.0f), ImColor(0.78f, 0.0f, 0.0f))) {
                            DeleteConfig();
                        }
                    } ImGui::PopStyleVar(1);
                    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 5.0f)); {
                        if (Build::AddIconButton(ICON_FA_WPEXPLORER, ImVec2(0.0f, 18.0f), "Open Finder", ImColor(0.3f, 0.3f, 0.3f), ImColor(0.38f, 0.38f, 0.38f))) {
                            OpenFinder();
                        }
                    } ImGui::PopStyleVar(1);
                }

                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("New Config", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                ImGui::BeginChildFrame(2000002, ImVec2(0.0f, 70.0f)); {
                    char CharConfigName[48] = "";
                    ImGui::PushFont(Fonts::Label); {
                        Build::AddCustomText("New Config", FONTFLAG_DROPSHADOW);
                    } ImGui::PopFont();
                    if (newfileInput != "") {
                        sprintf(CharConfigName, "%s", newfileInput.c_str());
                    }
                
                    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
                        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 0.0f)); {
                            ImGui::InputText("##File name", CharConfigName, sizeof(CharConfigName));
                        }
                        ImGui::PopStyleVar(1);
                    }
                    ImGui::PopStyleColor(2);
                    if (strlen(CharConfigName) > 0) {
                        newfileInput = std::string(CharConfigName);
                    }

                    if (Build::AddIconButton(std::string(ICON_FA_FLOPPY_O).append(" ").append(ICON_FA_EXCHANGE), ImVec2(0.0f, 18.0f), "Create", ImColor(0.0f, 0.70f, 0.0f), ImColor(0.0f, 0.78f, 0.0f))) {
                        if (newfileInput != "") {
                            CreateConfig(newfileInput);
                        } else {
                            MessagePopup::AddMessage("Config name missing!", MESSAGE_TYPE_WARNING, 2800);
                        }
                    }
                } ImGui::EndChildFrame();

                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Settings", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                ImGui::BeginChildFrame(2000003, ImVec2(0.0f, 0.0f)); {
                    IsLastItem = true;
                    if (Build::AddCheckbox("Auto Save Configs", {"", false, "Config", "auto_save"})) {
                        Options::Config::auto_save = CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("Config", "auto_save");
                    }
                    IsLastItem = false;
                } ImGui::EndChildFrame();
            
                ImGui::End();
            } ImGui::PopStyleVar(1);
        }
        
        void ReloadConfigs() {
            files.clear();
            
            DIR* dir = opendir(currentConfigPath.c_str());
            if (dir) {
                int count = 0;
                while (dirent* file = readdir(dir)) {
                    if (strcmp(file->d_name, ".") && strcmp(file->d_name, "..") && strcmp(file->d_name, ".DS_Store")) {
                        files[count] = std::string().append(file->d_name);
                        count++;
                    }
                }
                closedir(dir);
            }
        }
        
        bool SaveConfig(std::string configFile) {
            if (currentConfigIndex == -1) {
                MessagePopup::AddMessage("No config selected!", MESSAGE_TYPE_WARNING, 2800);
                
                return false;
            }
            if (configFile == "") {
                configFile = "configs/";
                configFile.append(files.at(currentConfigIndex).c_str());
            }
            
            CSettingsManager::SaveAll(configFile);
            
            GUI::MessagePopup::AddMessage("Config saved!", MESSAGE_TYPE_SUCCESS, 2000);
            return true;
        }
        
        bool LoadConfig(std::string configFile) {
            if (currentConfigIndex == -1) {
                MessagePopup::AddMessage("No config selected!", MESSAGE_TYPE_WARNING, 2800);
                
                return false;
            }
            if (configFile == "") {
                configFile = "configs/";
                configFile.append(files.at(currentConfigIndex).c_str());
            }
            
            CSettingsManager::Instance("menu.ini")->SetValue("Main", "settings_file", configFile.c_str());
            CSettingsManager::Instance("menu.ini")->SaveSettings();
            currentConfigName = configFile;
            
            CSettingsManager::Instance(currentConfigName);
            Options::synced = false;
            CSettingsManager::SyncSettings();
            
            GUI::MessagePopup::AddMessage("Config loaded!", MESSAGE_TYPE_INFO, 2000);
            
            return true;
        }
        
        bool DeleteConfig(std::string configFile) {
            if (currentConfigIndex == -1) {
                MessagePopup::AddMessage("No config selected!", MESSAGE_TYPE_WARNING, 2800);
                
                return false;
            }
            std::string filePath = currentConfigPath;
            if (configFile == "") {
                filePath.append(files.at(currentConfigIndex).c_str());
            } else {
                filePath.append(configFile);
            }
            
            if (Functions::FileExist(filePath)) {
                if (std::remove(filePath.c_str()) == 0) {
                    ReloadConfigs();
                    GUI::MessagePopup::AddMessage("Config deleted!", MESSAGE_TYPE_SUCCESS, 2000);
                    
                    return true;
                }
            }
            
            return false;
        }
        
        bool CreateConfig(std::string configFile) {
            std::string filePath = "configs/";
            Functions::CreateDir(Functions::GetSettingsDir() + filePath);
            if (configFile == "") {
                MessagePopup::AddMessage("Config name missing!", MESSAGE_TYPE_WARNING, 2800);
                
                return false;
            } else {
                filePath.append(configFile).append(".ini");
            }
            
            if (filePath == "configs/") {
                MessagePopup::AddMessage("Config name missing!", MESSAGE_TYPE_WARNING, 2800);
                
                return false;
            }
            
            CSettingsManager::SaveAll(filePath, true, true);
            
            newfileInput = "";
            
            ReloadConfigs();
            GUI::MessagePopup::AddMessage("Config created!", MESSAGE_TYPE_SUCCESS, 2000);
            
            return true;
        }
        
        void OpenFinder() {
            std::string command = "open " + Functions::GetSettingsDir();
            system(command.c_str());
        }
    }
}


bool GUI::Build::IsKeyListening = false;
bool GUI::Build::AddCheckbox(std::string label, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    bool defaultValue = activeConfig->GetSetting<bool>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<bool>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<bool>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        ImVec2 TextSize = ImGui::CalcTextSize(label.c_str(), NULL, true);
        float spacing = (float)(LabelWidth - TextSize.x);
        ImGui::SameLine(spacing, 0.0f);
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    }
    ImGui::PopFont();
    ImGui::SameLine();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::PushItemWidth(GetAvailWidth());
        if (ImGui::Checkbox(std::string("##").append(label).append(conf.elementID).c_str(), &defaultValue)) {
            if (conf.configSection != "" && conf.configKey != "") {
                CSettingsManager::Instance(currentConfigName)->SetBoolValue(activeConfigSection, conf.configKey, defaultValue);
            }
            valueChanged = true;
        }
        ImGui::PopItemWidth();
    } ImGui::PopStyleColor(2);
    if (!IsLastItem) {
        ImGui::NewLine();
    }
    
    return valueChanged;
}

bool GUI::Build::AddFloatSlider(std::string label, float min, float max, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    float defaultValue = activeConfig->GetSetting<float>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<float>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<float>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
            ImGui::PushItemWidth(GetAvailWidth());
            if (ImGui::SliderFloat(std::string("##").append(label).append(conf.elementID).c_str(), &defaultValue, min, max)) {
                if (conf.configSection != "" && conf.configKey != "") {
                    CSettingsManager::Instance(currentConfigName)->SetDoubleValue(activeConfigSection, conf.configKey, defaultValue);
                }
                valueChanged = true;
            }
            ImGui::PopItemWidth();
        } ImGui::PopStyleVar(1);
    } ImGui::PopStyleColor(3);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

bool GUI::Build::AddIntSlider(std::string label, float min, float max, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    int defaultValue = activeConfig->GetSetting<int>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
            ImGui::PushItemWidth(GetAvailWidth());
            if (ImGui::SliderInt(std::string("##").append(label).append(conf.elementID).c_str(), &defaultValue, min, max)) {
                if (conf.configSection != "" && conf.configKey != "") {
                    CSettingsManager::Instance(currentConfigName)->SetIntValue(activeConfigSection, conf.configKey, defaultValue);
                }
                valueChanged = true;
            }
            ImGui::PopItemWidth();
        } ImGui::PopStyleVar(1);
    } ImGui::PopStyleColor(3);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

void GUI::Build::AddFrameLabel(std::string label) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushFont(Fonts::Section); {
        ImGui::TextColored(style.Colors[ImGuiCol_TitleBg], "%s", label.c_str());
    } ImGui::PopFont();
}

bool GUI::Build::AddCombo(std::string label, const char **items, int items_count, int height_in_items, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    int defaultValue = activeConfig->GetSetting<int>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
            ImGui::PushItemWidth(GetAvailWidth());
            ImGui::PushStyleColor(ImGuiCol_ButtonHovered, {0.26f, 0.86f, 0.55f, 1.0f});
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, {3.0f, 3.0f});
            if (ImGui::Combo(std::string("##").append(label).append(conf.elementID).c_str(), &defaultValue, items, items_count, height_in_items)) {
                if (conf.configSection != "" && conf.configKey != "") {
                    CSettingsManager::Instance(currentConfigName)->SetIntValue(activeConfigSection, conf.configKey, defaultValue);
                }
                valueChanged = true;
            }
            ImGui::PopStyleVar(1);
            ImGui::PopStyleColor(1);
            ImGui::PopItemWidth();
        } ImGui::PopStyleVar(1);
    } ImGui::PopStyleColor(3);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

void GUI::Build::AddLabelText(std::string label, std::string text, ElementConfig_t conf) {
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::TextWrapped("%s", text.c_str());
    } ImGui::PopStyleColor(3);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
}

bool GUI::Build::AddKeyInput(std::string label, bool allowMouseLeft, ElementConfig_t conf, bool withModifiers) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    int defaultValue = activeConfig->GetSetting<int>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<int>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    std::string text = Keys::Get(defaultValue);
    
    if (SetKeyCodeState::shouldListen && *SetKeyCodeState::keyOutput == defaultValue) {
        text = "-- press a key --";
    } else {
        text = std::string(text);
    }
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }

    ImGui::PushItemWidth(GetAvailWidth());
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 0.0f)); {
        if (ImGui::Button(text.c_str(), ImVec2(100.0f, 0.0f))) {
            SetKeyCodeState::shouldListen = true;
            SetKeyCodeState::keyOutput = &defaultValue;
            SetKeyCodeState::allowMouseLeft = allowMouseLeft;
            SetKeyCodeState::configSection = activeConfigSection;
            SetKeyCodeState::configKey = conf.configKey;
            SetKeyCodeState::withModifiers = withModifiers;
            IsKeyListening = true;
        }
    } ImGui::PopStyleVar(1);
    ImGui::PopItemWidth();
    
    if (!SetKeyCodeState::shouldListen && IsKeyListening) {
        IsKeyListening = false;
        valueChanged = true;
    }
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

bool GUI::Build::AddColorButton(std::string label, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    Color defaultValue = activeConfig->GetColorSetting(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetColorSetting(activeConfigSection, conf.configKey, defaultValue.ToString());
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetColorSetting(activeConfigSection, conf.configKey, defaultValue.ToString());
        }
    }

    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    // Frame padding start
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 0.0f)); {
        ImVec4 buttonColor = ImVec4(
            (float)(defaultValue.r() / 255.0f),
            (float)(defaultValue.g() / 255.0f),
            (float)(defaultValue.b() / 255.0f),
            (float)(defaultValue.a() / 255.0f)
        );
        ImVec2 ButtonSize = ImVec2(35.0f, 20.0f);
        if (conf.labelOnTop) {
            ButtonSize = ImVec2(ImGui::GetContentRegionAvail().x, 0.0f);
        }
        if (ImGui::ColorButton(std::string("      ##").append(conf.elementID).c_str(), buttonColor, ImGuiColorEditFlags_NoTooltip)) {
            ImGui::OpenPopup(std::string(conf.elementID).append("_picker").c_str());
        }
    
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, {3.0f, 3.0f});
        if (ImGui::BeginPopup(std::string(conf.elementID).append("_picker").c_str())) {
            static int colorpickerflags = ImGuiColorEditFlags_NoSmallPreview |
                                          ImGuiColorEditFlags_NoInputs |
                                          ImGuiColorEditFlags_NoLabel |
                                          ImGuiColorEditFlags_NoTooltip |
                                          ImGuiColorEditFlags_NoSidePreview |
                                          ImGuiColorEditFlags_AlphaBar;
            if (
                ImGui::ColorPicker4(
                    std::string(conf.elementID).append("_color").c_str(),
                    (float*)&buttonColor,
                    colorpickerflags
                )
            ) {
                defaultValue.SetR((int)(buttonColor.x * 255.0f));
                defaultValue.SetG((int)(buttonColor.y * 255.0f));
                defaultValue.SetB((int)(buttonColor.z * 255.0f));
                defaultValue.SetA((int)(buttonColor.w * 255.0f));
            
                if (conf.configSection != "" && conf.configKey != "") {
                    CSettingsManager::Instance(currentConfigName)->SetColorValue(activeConfigSection, conf.configKey, defaultValue);
                }
                valueChanged = true;
            }
            
            ImGui::EndPopup();
        }
        ImGui::PopStyleVar(1);
    } ImGui::PopStyleVar(1);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

bool GUI::Build::AddSelectable(std::string label, ElementConfig_t conf, bool odd) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    bool defaultValue = activeConfig->GetSetting<bool>(conf.configSection, conf.configKey);
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = activeConfig->GetSetting<bool>(activeConfigSection, conf.configKey, defaultValue);
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetSetting<bool>(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    if (odd) {
        ImGui::PushStyleColor(ImGuiCol_SelectableBg, {1.0f, 1.0f, 1.0f, 0.075f});
    }
    
    bool returnValue = false;
    if (conf.configKey != "" && conf.configSection != "") {
        if (Build::AddDefaultSelectable(label.c_str(), &defaultValue)) {
            CSettingsManager::Instance(currentConfigName)->SetBoolValue(activeConfigSection, conf.configKey, defaultValue);
            
            returnValue = true;
        }
    }
    
    if (odd) {
        ImGui::PopStyleColor(1);
    }
    
    return returnValue;
}

bool GUI::Build::AddTextInput(std::string label, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    std::string defaultValue = std::string(activeConfig->GetStringSetting(conf.configSection, conf.configKey));
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = std::string(activeConfig->GetStringSetting(activeConfigSection, conf.configKey, defaultValue.c_str()));
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetStringSetting(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    char inputText[256] = "";
    sprintf(inputText, "%s", defaultValue.c_str());
    
    if (conf.configKey != "" && conf.configSection != "") {
        if (ImGui::InputText(std::string("##").append(label).c_str(), inputText, sizeof(inputText))) {
            CSettingsManager::Instance(currentConfigName)->SetValue(activeConfigSection, conf.configKey, std::string(inputText).c_str());
            
            return true;
        }
    }
    
    return false;
}
    
bool GUI::Build::AddMenuTextInput(std::string label, ElementConfig_t conf) {
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    std::string defaultValue = std::string(activeConfig->GetStringSetting(conf.configSection, conf.configKey));
    std::string activeConfigSection = conf.configSection;
    if (conf.selectedWeaponID != EItemDefinitionIndex::weapon_none) {
        activeConfigSection = CSettingsManager::GetConfigSectionForWeapon(conf.selectedWeaponID, conf.configSection);
        defaultValue = std::string(activeConfig->GetStringSetting(activeConfigSection, conf.configKey, defaultValue.c_str()));
    } else {
        if (conf.selectedWeaponType != 0) {
            activeConfigSection = CSettingsManager::GetEntityNameForWeaponType((CSWeaponType)conf.selectedWeaponType, conf.configSection);
            defaultValue = activeConfig->GetStringSetting(activeConfigSection, conf.configKey, defaultValue);
        }
    }
    
    bool valueChanged = false;
    ImGui::PushFont(Fonts::Label); {
        if (!conf.labelOnTop) {
            float spacing = (float)(LabelWidth - ImGui::CalcTextSize(label.c_str(), NULL, true).x);
            ImGui::SameLine(spacing, 0.0f);
        }
        Build::AddCustomText(label, FONTFLAG_DROPSHADOW);
    } ImGui::PopFont();
    if (!conf.labelOnTop) {
        ImGui::SameLine();
    }
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f}); {
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f)); {
            ImGui::PushItemWidth(GetAvailWidth());

            char inputText[14] = "";
            sprintf(inputText, "%s", defaultValue.c_str());
            if (ImGui::InputText(std::string("##").append(label).c_str(), inputText, sizeof(inputText))) {
                if (conf.configSection != "" && conf.configKey != "") {
                    CSettingsManager::Instance(currentConfigName)->SetValue(activeConfigSection, conf.configKey, std::string(inputText).c_str());
                }
                valueChanged = true;
            }
        
            ImGui::PopItemWidth();
        } ImGui::PopStyleVar(1);
    } ImGui::PopStyleColor(2);
    
    if (!conf.labelOnTop) {
        if (!IsLastItem) {
            ImGui::NewLine();
        }
    }
    
    return valueChanged;
}

bool GUI::Build::AddIconButton(std::string icon, ImVec2 size, std::string additionalText, ImVec4 background, ImVec4 hoverBackground) {
    std::string buttonText = icon;
    if (additionalText != "") {
        buttonText.append("  ").append(additionalText);
    }
    
    bool wasPressed = false;
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 0.0f));
    ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0.5f, 0.49f)); {
        ImGui::PushStyleColor(ImGuiCol_Button, background);
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, hoverBackground);
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, hoverBackground); {
            wasPressed = ImGui::Button(buttonText.c_str(), size);
        } ImGui::PopStyleColor(3);
    } ImGui::PopStyleVar(2);
    
    return wasPressed;
}

void GUI::Build::AddSpace(ImVec2 size) {
    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, {0.0f, 0.0f});
    ImGui::PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {0.0f, 0.0f});
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, {0.0f, 0.0f}); {
        ImGui::Dummy(size);
    } ImGui::PopStyleVar(3);
}

void GUI::Build::AddCustomText(std::string text_string, int font_flags, ImVec4 color) {
    ImGuiContext& g = *ImGui::GetCurrentContext();
    
    ImVec2 CursorPos = ImGui::GetCurrentWindow()->DC.CursorPos;
    ImVec2 TextSize = ImGui::CalcTextSize(text_string.c_str(), NULL, true);
    DrawManager->DrawString(ImGui::GetFont(), (int)CursorPos.x, (int)CursorPos.y, font_flags, {(uint8_t)(color.x * 255.0f), (uint8_t)(color.y * 255.0f), (uint8_t)(color.z * 255.0f), (uint8_t)(color.w * 255.0f)}, false, text_string.c_str());
    Build::AddSpace({TextSize.x, TextSize.y + g.Style.ItemInnerSpacing.y});
}

float GUI::Build::GetAvailWidth() {
    return ImGui::GetContentRegionAvail().x;
}

void GUI::Build::StartSelectList(ImGuiID id, const ImVec2 &size, ImGuiWindowFlags flags) {
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, {5.0f, 5.0f});
    ImGui::BeginChildFrame(id, size, flags);
}

bool GUI::Build::AddDefaultSelectable(const char* label, bool is_selected, ImGuiSelectableFlags flags, const ImVec2& size) {
    bool ret = false;
    
    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, {5.0f, 5.0f}); {
        ret = ImGui::Selectable(label, is_selected, flags, size);
    } ImGui::PopStyleVar(1);
    
    return ret;
}

bool GUI::Build::AddDefaultSelectable(const char* label, bool* is_selected, ImGuiSelectableFlags flags, const ImVec2& size) {
    bool ret = false;
    
    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, {3.0f, 3.0f}); {
        ret = ImGui::Selectable(label, is_selected, flags, size);
    } ImGui::PopStyleVar(1);
    
    return ret;
}

void GUI::Build::EndSelectList() {
    ImGui::EndChildFrame();
    ImGui::PopStyleVar(1);
}

long GUI::MessagePopup::lastDuration = 2000;
long GUI::MessagePopup::durationTime = 0;
bool GUI::MessagePopup::durationExpired = false;
std::string GUI::MessagePopup::lastMessage = "";
MessagePopupType GUI::MessagePopup::lastType = MESSAGE_TYPE_INFO;

void GUI::MessagePopup::Tick() {
    if (lastMessage == "") {
        durationTime = 0;
        durationExpired = false;
        
        return;
    }

    long currTime = Functions::GetTimeStamp();
    if (durationTime == 0) {
        durationTime = currTime;
    }
    
    long currentDelay = currTime - durationTime;
    if (currentDelay > lastDuration) {
        durationExpired = true;
        durationTime = 0;
    }
    
    if (durationExpired) {
        lastMessage = "";
        lastDuration = 2000;
        
        return;
    }
    
    ImColor borderColor, backgroundColor, textColor;
    
    switch (lastType) {
        default:
        case MESSAGE_TYPE_INFO:
            backgroundColor = ImColor(0.6f, 0.8f, 1.0f, 1.0f);
            borderColor = ImColor(0.2f, 0.4f, 1.0f, 1.0f);
            textColor = ImColor(0.3f, 0.3f, 1.0f, 1.0f);
            break;
        case MESSAGE_TYPE_SUCCESS:
            backgroundColor = ImColor(0.6f, 1.0f, 0.6f, 1.0f);
            borderColor = ImColor(0.2f, 0.8f, 0.2f, 1.0f);
            textColor = ImColor(0.0f, 0.6f, 0.2f, 1.0f);
            break;
        case MESSAGE_TYPE_ERROR:
            backgroundColor = ImColor(1.0f, 0.6f, 0.6f, 1.0f);
            borderColor = ImColor(1.0f, 0.4f, 0.0f, 1.0f);
            textColor = ImColor(1.0f, 0.2f, 0.0f, 1.0f);
            break;
        case MESSAGE_TYPE_WARNING:
            backgroundColor = ImColor(1.0f, 1.0f, 0.6f, 1.0f);
            borderColor = ImColor(1.0f, 1.0f, 0.0f, 1.0f);
            textColor = ImColor(0.8f, 0.6f, 0.0f, 1.0f);
            break;
    }
    
    if (!durationExpired) {
        ImVec2 TextSizeIcon = ImGui::CalcTextSize(ICON_FA_INFO_CIRCLE);
        ImVec2 TextSizeMessage = ImGui::CalcTextSize(lastMessage.c_str());
        
        ImGui::SetNextWindowPos(ImVec2(10.0f, 55.0f));
        ImGui::SetNextWindowSize(ImVec2(TextSizeMessage.x + TextSizeIcon.x + 28.0f, std::fmaxf(TextSizeIcon.y, TextSizeMessage.y) + 22.0f));
        ImGui::PushStyleColor(ImGuiCol_WindowBg, borderColor.Value);
        ImGui::PushStyleColor(ImGuiCol_FrameBg, backgroundColor.Value);
        ImGui::PushStyleColor(ImGuiCol_Text, textColor.Value); {
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(2.0f, 2.0f));
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(8.0f, 8.0f)); {
                if (ImGui::Begin("##messagePopup", NULL, ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoSavedSettings | ImGuiWindowFlags_NoInputs)) {
                    ImGui::BeginChildFrame(1010, ImVec2(0.0f, 0.0f)); {
                        switch (lastType) {
                            default:
                            case MESSAGE_TYPE_INFO:
                                ImGui::Text(ICON_FA_INFO_CIRCLE);
                                break;
                            case MESSAGE_TYPE_SUCCESS:
                                ImGui::Text(ICON_FA_CHECK_CIRCLE);
                                break;
                            case MESSAGE_TYPE_ERROR:
                                ImGui::Text(ICON_FA_BAN);
                                break;
                            case MESSAGE_TYPE_WARNING:
                                ImGui::Text(ICON_FA_EXCLAMATION_CIRCLE);
                                break;
                        }
                        ImGui::SameLine();
                        ImGui::Text("%s", lastMessage.c_str());
                    } ImGui::EndChildFrame();
                    ImGui::End();
                }
            } ImGui::PopStyleVar(2);
        } ImGui::PopStyleColor(3);
    }
}

void GUI::MessagePopup::AddMessage(std::string message, MessagePopupType type, long duration) {
    lastMessage = message;
    lastType = type;
    if (duration != lastDuration) {
        lastDuration = duration;
    }
}

void GUI::LoadFontsTexture() {
    ImGuiIO& io = ImGui::GetIO();
    
    ImFontConfig main_font_config;
    Fonts::Main = io.Fonts->AddFontFromMemoryCompressedTTF(FuturaMedium_compressed_data, FuturaMedium_compressed_size, 16.0f, &main_font_config);
    
    static const ImWchar csgo_icons_ranges[] = {ICON_CSGO_MIN, ICON_CSGO_MAX, 0};
    main_font_config.PixelSnapH = true;
    main_font_config.MergeMode = true;
    io.Fonts->AddFontFromMemoryCompressedTTF(CStrike_compressed_data, CStrike_compressed_size, 16.0f, &main_font_config, csgo_icons_ranges);
    
    static const ImWchar icons_ranges[] = {ICON_MIN_FA, ICON_MAX_FA, 0};
    main_font_config.MergeMode = true;
    io.Fonts->AddFontFromMemoryCompressedTTF(FontAwesome_compressed_data, FontAwesome_compressed_size, 16.0f, &main_font_config, icons_ranges);
    
    Fonts::Label = io.Fonts->AddFontFromMemoryCompressedTTF(FuturaMedium_compressed_data, FuturaMedium_compressed_size, 14.0f);
    Fonts::Header = io.Fonts->AddFontFromMemoryCompressedTTF(FuturaMedium_compressed_data, FuturaMedium_compressed_size, 18.0f);
    Fonts::Section = io.Fonts->AddFontFromMemoryCompressedTTF(FuturaBold_compressed_data, FuturaBold_compressed_size, 13.0f);
    
    ImFontConfig csgo_icons_config; csgo_icons_config.PixelSnapH = true;
    Fonts::CstrikeIcons = io.Fonts->AddFontFromMemoryCompressedTTF(CStrike_compressed_data, CStrike_compressed_size, 20.0f, &csgo_icons_config, csgo_icons_ranges);
    
    ImFontConfig csgo_icons_big_config; csgo_icons_big_config.PixelSnapH = true;
    Fonts::CstrikeIconsBig = io.Fonts->AddFontFromMemoryCompressedTTF(CStrike_compressed_data, CStrike_compressed_size, 50.0f, &csgo_icons_big_config, csgo_icons_ranges);
    
    unsigned char* pixels;
    int width, height;
    io.Fonts->GetTexDataAsAlpha8(&pixels, &width, &height);
    
    GLuint tex_id;
    glGenTextures(1, &tex_id);
    glBindTexture(GL_TEXTURE_2D, tex_id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixels);

    io.Fonts->TexID = (void *)(intptr_t)tex_id;
}

void GUI::Tabs::BeginTabButton(int SelectedTab, int CurrIndex) {
    if (SelectedTab != CurrIndex) {
        ImGui::PushStyleColor(ImGuiCol_Button, {0.20f, 0.20f, 0.20f, 1.0f});
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, {0.24f, 0.24f, 0.24f, 1.0f});
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, {0.24f, 0.24f, 0.24f, 1.0f});
    } else {
        ImGui::PushStyleColor(ImGuiCol_Button, {0.28f, 0.28f, 0.28f, 1.0f});
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, {0.28f, 0.28f, 0.28f, 1.0f});
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, {0.28f, 0.28f, 0.28f, 1.0f});
    }
}

void GUI::Tabs::EndTabButton(int SelectedTab, int CurrIndex) {
    ImGui::PopStyleColor(3);
}
