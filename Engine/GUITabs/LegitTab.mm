/******************************************************/
/**                                                  **/
/**      GUITabs/LegitTab.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "LegitTab.h"
#include "SDK/ItemDefinitionIndex.h"
#include "Engine/Weapons/manager.h"
#include "Engine/Drawing/manager.h"
#include "Engine/Fonts/fontawesome_icons.h"

std::vector<const char*> GUI::LegitTab::SelectionModes = {
    "Dynamic",
    "Fixed"
};

std::vector<const char*> GUI::LegitTab::HitboxBones = {
    "Head",
    "Neck",
    "Pelvis",
    "Body",
    "Thorax",
    "Chest",
    "Upper Chest",
};

std::vector<const char*> GUI::LegitTab::TargetingModes = {
    "Normal",
    "Random Multipoint"
};

std::map<CSWeaponType, GUI::LegitTab::WeaponTypeItem_t> GUI::LegitTab::WeaponTypes = {
    {CSWeaponType::WEAPONTYPE_KNIFE, {"All", ""}},
    {CSWeaponType::WEAPONTYPE_PISTOL, {"Pistols", ICON_CSGO_P250}},
    {CSWeaponType::WEAPONTYPE_SHOTGUN, {"Shotguns", ICON_CSGO_NOVA}},
    {CSWeaponType::WEAPONTYPE_SUBMACHINEGUN, {"SMGs", ICON_CSGO_MP5SD}},
    {CSWeaponType::WEAPONTYPE_RIFLE, {"Rifles", ICON_CSGO_M4A1S}},
    {CSWeaponType::WEAPONTYPE_SNIPER_RIFLE, {"Snipers", ICON_CSGO_AWP}},
    {CSWeaponType::WEAPONTYPE_MACHINEGUN, {"Machineguns", ICON_CSGO_M249}}
};

int GUI::LegitTab::SelectedTab = 0;
int GUI::LegitTab::SelectedWeaponIndex = 0;
int GUI::LegitTab::SelectedWeaponCat = 0;
int GUI::LegitTab::SelectedWeaponBasedType = 0;
std::map<int, std::string> GUI::LegitTab::cachedWeaponList;

void GUI::LegitTab::Render() {
    ImGuiStyle& style = ImGui::GetStyle();
    ImGuiWindow* window = ImGui::GetCurrentWindowRead();
    
    if (cachedWeaponList.size() < 1) {
        for (int index = (int)EItemDefinitionIndex::weapon_none; index < (int)EItemDefinitionIndex::weapon_knife_bayonet; index++) {
            if (ItemDefinitionIndex.find(index) == ItemDefinitionIndex.end()) {
                continue;
            }
            
            if (
                WeaponManager::IsGrenade(index) ||
                index == (int)EItemDefinitionIndex::weapon_knife_t ||
                index == (int)EItemDefinitionIndex::weapon_knife ||
                index == (int)EItemDefinitionIndex::weapon_taser ||
                index == (int)EItemDefinitionIndex::weapon_c4
            ) {
                continue;
            }

            cachedWeaponList[index] = std::string(ItemDefinitionIndex.at(index).display_name);
        }
    }

    static std::vector<std::string> Tabs = {
        "Accuracy",
        "Misc",
        "Triggerbot",
        "Anti-Cheat"
    };

    ImGui::BeginGroup();
    {
        ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 0.0f));
        ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0.0f);
        static ImVec2 ButtonSize = ImVec2((ImGui::GetWindowWidth() / Tabs.size()) - 1.0f, 25.0f);
        for (int i = 0; i < Tabs.size(); i++) {
            int BackupSelectedTab = SelectedTab;
            Tabs::BeginTabButton(BackupSelectedTab, i); {
                if (ImGui::Button(Tabs.at(i).c_str(), ButtonSize)) {
                    SelectedTab = i;
                }
            } Tabs::EndTabButton(BackupSelectedTab, i);
            if (!(i > (Tabs.size() - 1))) {
                ImGui::SameLine();
            }
        }
        ImGui::PopStyleVar(2);
    }
    ImGui::EndGroup();
    
    ImDrawList* draw = ImGui::GetWindowDrawList();
    
    ImVec2 Cursor = window->DC.CursorPos;
    
    ImVec4 childFrameBg = style.Colors[ImGuiCol_FrameBg];
    childFrameBg.w = 0.0f;
    ImGui::PushStyleColor(ImGuiCol_FrameBg, childFrameBg);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, childFrameBg);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, childFrameBg);
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
    {
        ImVec2 contentSize = ImGui::GetContentRegionAvail();
        ImGui::BeginChildFrame(10, ImVec2(contentSize.x / 2, 22.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            IsLastItem = true;
            GUI::Build::AddCheckbox("Aimbot Enabled", {"aim_enabled", false, "Aimbot", "enabled", SelectedWeaponIndex, SelectedWeaponBasedType});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
        draw->AddLine({Cursor.x, window->DC.CursorPos.y}, {Cursor.x + ImGui::GetContentRegionAvail().x, window->DC.CursorPos.y}, ImColor(0.20f, 0.20f, 0.20f, 1.0f), 2.5f);
        Build::AddSpace({ImGui::GetContentRegionAvail().x, 2.0f});
        draw->AddRectFilled({Cursor.x, window->DC.CursorPos.y}, {Cursor.x + 185.0f, window->DC.CursorPos.y + 22.0f}, ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        draw->AddRectFilled({Cursor.x + 150.0f, window->DC.CursorPos.y}, {Cursor.x + 150.0f + 185.0f, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y + 10.0f}, ImColor(0.20f, 0.20f, 0.20f, 1.0f));
    
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, {0.0f, 0.0f});
        ImGui::BeginChildFrame(1000, ImVec2(150.0f, 0.0f));
        {
            static ImColor ActiveColor(0.28f, 0.28f, 0.28f, 1.0f);
            static ImColor NormalColor(0.0f, 0.0f, 0.0f, 0.0f);
            static ImColor HoverColor(0.28f, 0.28f, 0.28f, 0.5f);
            ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 0.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, {0.0f, 0.0f});
            {
                ImGui::PushFont(Fonts::Main);
                if (
                    Build::AddIconButton(
                        ICON_FA_TH_LIST,
                        {0.0f, 22.0f},
                        "Types",
                        (SelectedWeaponCat == 0 ? ActiveColor.Value : NormalColor.Value),
                        (SelectedWeaponCat == 0 ? ActiveColor.Value : HoverColor.Value)
                    )
                ) {
                    SelectedWeaponCat = 0;
                }
                ImGui::SameLine();
                if (
                    Build::AddIconButton(
                        ICON_FA_LIST,
                        {0.0f, 22.0f},
                        "Weapons",
                        (SelectedWeaponCat == 1 ? ActiveColor.Value : NormalColor.Value),
                        (SelectedWeaponCat == 1 ? ActiveColor.Value : HoverColor.Value)
                    )
                ) {
                    SelectedWeaponCat = 1;
                }
                ImGui::PopFont();
            }
            ImGui::PopStyleVar(2);
        
            if (
                (SelectedWeaponIndex != EItemDefinitionIndex::weapon_none && CSettingsManager::HasWeaponBasedConfig(SelectedWeaponIndex)) ||
                (SelectedWeaponBasedType != 0 && CSettingsManager::HasWeaponBasedConfig((CSWeaponType)SelectedWeaponBasedType))
            ) {
                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
                ImGui::BeginChildFrame(3001, ImVec2(contentSize.x / 2, 23.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
                {
                    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0.0f, 0.0f));
                    ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(1.0f, 0.0f));
                    ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0.5f, 0.0f));
                    {
                        if (SelectedWeaponIndex != EItemDefinitionIndex::weapon_none) {
                            if (ItemDefinitionIndex.find(SelectedWeaponIndex) != ItemDefinitionIndex.end()) {
                                Item_t currSelectedWeapon = ItemDefinitionIndex.at(SelectedWeaponIndex);
                                ImVec4 buttonred = {0.70f, 0.0f, 0.0f, 1.0f};
                                ImGui::PushStyleColor(ImGuiCol_Button, buttonred);
                                buttonred.x = 0.78f;
                                ImGui::PushStyleColor(ImGuiCol_ButtonActive, buttonred);
                                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, buttonred);
                                if (ImGui::Button(std::string(ICON_FA_TRASH).append("  ").append(currSelectedWeapon.display_name).c_str(), ImVec2(140.0f, 18.0f))) {
                                    if (CSettingsManager::DeleteWeaponBasedConfig(SelectedWeaponIndex)) {
                                        GUI::MessagePopup::AddMessage(std::string(currSelectedWeapon.display_name).append(" config deleted!").c_str(), MESSAGE_TYPE_SUCCESS, 2000);
                                    } else {
                                        GUI::MessagePopup::AddMessage(std::string(currSelectedWeapon.display_name).append(" config can not be deleted!").c_str(), MESSAGE_TYPE_ERROR, 2000);
                                    }
                                }
                                ImGui::PopStyleColor(3);
                            }
                        } else if (SelectedWeaponBasedType != 0) {
                            if (WeaponTypes.find((CSWeaponType)SelectedWeaponBasedType) != WeaponTypes.end()) {
                                WeaponTypeItem_t currSelectedWeaponType = WeaponTypes.at((CSWeaponType)SelectedWeaponBasedType);
                                ImVec4 buttonred = {0.70f, 0.0f, 0.0f, 1.0f};
                                ImGui::PushStyleColor(ImGuiCol_Button, buttonred);
                                buttonred.x = 0.78f;
                                ImGui::PushStyleColor(ImGuiCol_ButtonActive, buttonred);
                                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, buttonred);
                                if (ImGui::Button(std::string(ICON_FA_TRASH).append("  ").append(currSelectedWeaponType.typeName).c_str(), ImVec2(140.0f, 18.0f))) {
                                    if (CSettingsManager::DeleteWeaponBasedConfig((CSWeaponType)SelectedWeaponBasedType)) {
                                        GUI::MessagePopup::AddMessage(std::string(currSelectedWeaponType.typeName).append(" config deleted!").c_str(), MESSAGE_TYPE_SUCCESS, 2000);
                                    } else {
                                        GUI::MessagePopup::AddMessage(std::string(currSelectedWeaponType.typeName).append(" config can not be deleted!").c_str(), MESSAGE_TYPE_ERROR, 2000);
                                    }
                                }
                                ImGui::PopStyleColor(3);
                            }
                        }
                    }
                    ImGui::PopStyleVar(3);
                }
                ImGui::EndChildFrame();
                ImGui::PopStyleVar(1);
            }
        
            static ImVec4 even = {0.0f, 0.0f, 0.0f, 0.0f};
            static ImVec4 odd = {1.0f, 1.0f, 1.0f, 0.075f};
            int c = 0;
        
            GUI::Build::StartSelectList(1020, ImVec2(0.0f, 0.0f)); {
                static ImVec4 transparent = {0.0f, 0.0f, 0.0f, 0.0f};
                ImGui::PushStyleColor(ImGuiCol_Button, transparent);
                ImGui::PushStyleColor(ImGuiCol_ButtonActive, transparent);
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, transparent); {
                    if (SelectedWeaponCat == 1) {
                        SelectedWeaponBasedType = 0;
                        for (auto weapon : cachedWeaponList) {
                            ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                                bool isNotSelected = SelectedWeaponIndex != weapon.first;
                                bool HasWeaponConfig = CSettingsManager::HasWeaponBasedConfig(weapon.first);
                                if (HasWeaponConfig && isNotSelected) {
                                    ImVec4 color = style.Colors[ImGuiCol_TitleBg];
                                    color.w = 0.25f;
                                    
                                    ImGui::PushStyleColor(ImGuiCol_SelectableBg, color);
                                }
                                if (GUI::Build::AddDefaultSelectable(Options::Config::weapon_icons ? weapon.second.append(" " + WeaponManager::GetWeaponIcon(weapon.first)).c_str() : weapon.second.c_str(), !isNotSelected)) {
                                    SelectedWeaponIndex = weapon.first;
                                }
                                if (HasWeaponConfig && isNotSelected) {
                                    ImGui::PopStyleColor(1);
                                }
                            } ImGui::PopStyleColor(1);
                            
                            c++;
                        }
                    } else {
                        SelectedWeaponIndex = 0;
                        for (std::pair<CSWeaponType, WeaponTypeItem_t> weaponType : WeaponTypes) {
                            ImGui::PushStyleColor(ImGuiCol_SelectableBg, ((c % 2) ? odd : even)); {
                                bool isNotSelected = SelectedWeaponBasedType != (int)weaponType.first;
                                bool HasWeaponConfig = CSettingsManager::HasWeaponBasedConfig(weaponType.first);
                                if (HasWeaponConfig && isNotSelected) {
                                    ImVec4 color = style.Colors[ImGuiCol_TitleBg];
                                    color.w = 0.25f;
                                    
                                    ImGui::PushStyleColor(ImGuiCol_SelectableBg, color);
                                }
                                std::string weaponTypeLabel = std::string(weaponType.second.typeName);
                                if (Options::Config::weapon_icons) {
                                    weaponTypeLabel.append("  " + weaponType.second.icon);
                                }
                                if (GUI::Build::AddDefaultSelectable(weaponTypeLabel.c_str(), !isNotSelected)) {
                                    SelectedWeaponBasedType = (int)weaponType.first;
                                }
                                if (HasWeaponConfig && isNotSelected) {
                                    ImGui::PopStyleColor(1);
                                }
                            } ImGui::PopStyleColor(1);
                            
                            c++;
                        }
                    }
                } ImGui::PopStyleColor(3);
            } GUI::Build::EndSelectList();
        }
        ImGui::EndChildFrame();
        ImGui::PopStyleVar(1);
        ImGui::SameLine();
        ImGui::BeginChildFrame(1, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            switch (SelectedTab) {
                case 0:
                    RenderAccuracyTab(window);
                    break;
                case 1:
                    RenderMiscTab(window);
                    break;
                case 2:
                    RenderTriggerbotTab(window);
                    break;
                case 3:
                    RenderAnticheatTab(window);
                    break;
            }
        }
        ImGui::EndChildFrame();
    
    }
    ImGui::PopStyleVar(1);
    ImGui::PopStyleColor(3);
}

void GUI::LegitTab::RenderAccuracyTab(ImGuiWindow* window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(180.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Smoothing", {"", false, "Aimbot", "smoothaim", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCheckbox("Target in FOV", {"", false, "Aimbot", "fov_enabled", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCheckbox("Recoil Control", {"", false, "Aimbot", "recoil_control", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCheckbox("Always RCS", {"", false, "Improvements", "always_rcs", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCheckbox("Delayed Shot", {"", false, "Aimbot", "delayed_shot", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Low-FOV Silent Aim", {"", false, "Aimbot", "silent_aim", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddFloatSlider("Smoothing Factor", 0.0f, 1.0f, {"", true, "Aimbot", "smoothing_factor", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddFloatSlider("Smooth Salting", 0.0f, 0.1f, {"", true, "Aimbot", "smooth_salt_multiplier", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCombo("Hitbox Selection", SelectionModes.data(), (int)SelectionModes.size(), -1, {"", true, "Aimbot", "bone_mode", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCombo("Preferred Hitbox", HitboxBones.data(), (int)HitboxBones.size(), -1, {"", true, "Aimbot", "fixed_bone", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddFloatSlider("Target FOV", 0.000001f, 30.0f, {"", true, "Aimbot", "field_of_view", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddFloatSlider("Recoil Vertical", 0.0f, 2.0f, {"", true, "Aimbot", "recoil_level_x", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = true;
        GUI::Build::AddFloatSlider("Recoil Horizontal", 0.0f, 2.0f, {"", true, "Aimbot", "recoil_level_y", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::LegitTab::RenderMiscTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(180.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Auto switch to Pistol", {"", false, "Extras", "autopistol"});
        GUI::Build::AddCheckbox("Auto switch to Knife", {"", false, "Extras", "autoknife"});
        GUI::Build::AddCheckbox("Knifebot", {"", false, "Extras", "knifebot"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Auto Cock Revolver", {"", false, "Extras", "auto_cock_revolver", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddKeyInput("Aimbot Panic key", true, {"aim_pkey", true, "Aimbot", "toggle_key"});
        GUI::Build::AddKeyInput("Aimbot Key", true, {"", true, "Aimbot", "aim_key", SelectedWeaponIndex, SelectedWeaponBasedType});
        ImGui::NewLine();
    
        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
        {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("Checks", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
        
            GUI::Build::StartSelectList(200, ImVec2(0.0f, 88.0f)); {
                GUI::Build::AddSelectable("Enemy on ground", {"", false, "Aimbot", "enemy_onground_check", SelectedWeaponIndex, SelectedWeaponBasedType});
                GUI::Build::AddSelectable("Self on ground", {"", false, "Aimbot", "player_onground_check", SelectedWeaponIndex, SelectedWeaponBasedType}, true);
                GUI::Build::AddSelectable("Smoke", {"", false, "Aimbot", "smokecheck", SelectedWeaponIndex, SelectedWeaponBasedType});
                GUI::Build::AddSelectable("Flash", {"", false, "Aimbot", "flash_check", SelectedWeaponIndex, SelectedWeaponBasedType}, true);
            } GUI::Build::EndSelectList();
        }
        ImGui::PopStyleColor(2);
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::LegitTab::RenderTriggerbotTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(180.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"", false, "Improvements", "triggerbot", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddCheckbox("Delay", {"", false, "Improvements", "trigger_delay", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Auto activation", {"", false, "Improvements", "trigger_autoactivation", SelectedWeaponIndex, SelectedWeaponBasedType});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddFloatSlider("Delay Time", 0.0f, 2000.0f, {"", true, "Improvements", "trigger_delay_value", SelectedWeaponIndex, SelectedWeaponBasedType});
        GUI::Build::AddKeyInput("Activation Key", true, {"", true, "Improvements", "trigger_key", SelectedWeaponIndex, SelectedWeaponBasedType});

        ImGui::NewLine();
    
        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
        {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("Hitgroup Filter", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
        
            GUI::Build::StartSelectList(200, {0.0f, 88.0f}); {
                GUI::Build::AddSelectable("Head", {"", false, "Improvements", "trigger_filter_head", SelectedWeaponIndex, SelectedWeaponBasedType});
                GUI::Build::AddSelectable("Chest", {"", false, "Improvements", "trigger_filter_chest", SelectedWeaponIndex, SelectedWeaponBasedType}, true);
                GUI::Build::AddSelectable("Stomach", {"", false, "Improvements", "trigger_filter_stomach", SelectedWeaponIndex, SelectedWeaponBasedType});
                GUI::Build::AddSelectable("Arms", {"", false, "Improvements", "trigger_filter_arms", SelectedWeaponIndex, SelectedWeaponBasedType}, true);
                GUI::Build::AddSelectable("Legs", {"", false, "Improvements", "trigger_filter_legs", SelectedWeaponIndex, SelectedWeaponBasedType});
            } GUI::Build::EndSelectList();
        }
        ImGui::PopStyleColor(2);
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::LegitTab::RenderAnticheatTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(180.0f, 0.0f));
    {
        IsLastItem = true;
        GUI::Build::AddCheckbox("Mouse-move Aim (Faceit)", {"", false, "AntiCheat", "mouse_event_aim"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        IsLastItem = true;
        GUI::Build::AddCombo("Targeting", TargetingModes.data(), (int)TargetingModes.size(), -1, {"", true, "AntiCheat", "targeting"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}
