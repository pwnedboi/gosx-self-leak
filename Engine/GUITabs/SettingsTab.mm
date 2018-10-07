/******************************************************/
/**                                                  **/
/**      GUITabs/SettingsTab.cpp                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SettingsTab.h"

#include "Engine/Hooks/manager.h"
#ifdef GOSX_BACKTRACKING
#include "Engine/Features/BackTracking.h"
#endif

int GUI::SettingsTab::SelectedTab = 0;

std::vector<const char*> GUI::SettingsTab::HitboxBones = {
    "Pelvis",
    "Lower Chest",
    "Chest",
    "Middle Chest",
    "Upeer Chest",
    "Neck",
    "Head",
    "Clavicle Left",
    "Upper Arm Left",
    "Lower Arm Left",
    "Left Hand"
    "Clavicle Right",
    "Upper Arm Right",
    "Lower Arm Right",
    "Right Hand"
};

std::vector<const char*> GUI::SettingsTab::BacktrackVisualType {
    "Off",
    "Dot",
    "Skeleton"
};

#ifdef GOSX_BACKTRACKING
std::vector<std::string> GUI::SettingsTab::Tabs = {
    "Improvements",
    "Bunnyhop",
    "Backtracking"
};
#else
std::vector<std::string> GUI::SettingsTab::Tabs = {
    "Improvements",
    "Bunnyhop"
};
#endif

void GUI::SettingsTab::Render() {
    ImGuiStyle& style = ImGui::GetStyle();
    ImGuiWindow* window = ImGui::GetCurrentWindowRead();
    
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
        ImGui::BeginChildFrame(10, ImVec2(0.0f, 22.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            IsLastItem = true;
            GUI::Build::AddCheckbox("Hack Enabled", {"hack_enabled", false, "Main", "enabled"});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
        draw->AddLine(ImVec2(Cursor.x, window->DC.CursorPos.y), ImVec2(Cursor.x + ImGui::GetContentRegionAvail().x, window->DC.CursorPos.y), ImColor(0.20f, 0.20f, 0.20f, 1.0f), 2.0f);
        draw->AddRectFilled(ImVec2(Cursor.x - 10.0f, window->DC.CursorPos.y + 1.0f), ImVec2(Cursor.x + 205.0f, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y + 10.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        ImGui::BeginChildFrame(1, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
#ifdef GOSX_BACKTRACKING
        switch (SelectedTab) {
            case 0:
                RenderImprovementsTab(window);
                break;
            case 1:
                RenderBunnyhopTab(window);
                break;
            case 2:
                RenderBacktrackingTab(window);
                break;
        }
#else
        switch (SelectedTab) {
            case 0:
                RenderImprovementsTab(window);
                break;
            case 1:
                RenderBunnyhopTab(window);
                break;
        }
#endif
        }
        ImGui::EndChildFrame();
    
    }
    ImGui::PopStyleVar(1);
    ImGui::PopStyleColor(3);
}

void GUI::SettingsTab::RenderImprovementsTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Clean Screenshots", {"", false, "Main", "screenshot_cleaner"});
        Build::AddCheckbox("Skin Changer", {"", false, "Improvements", "skin_changer"});
#ifdef GOSX_GLOVE_CHANGER
        Build::AddCheckbox("Glove Changer", {"", false, "Improvements", "glove_changer"});
#endif
        Build::AddCheckbox("Remove Scope", {"", false, "Improvements", "no_scope"});
        Build::AddCheckbox("Show all ranks", {"", false, "Improvements", "rankreveal"});
        Build::AddCheckbox("No/Reduce Flash", {"", false, "Improvements", "no_flash"});
        Build::AddCheckbox("Remove Skybox", {"", false, "Improvements", "no_sky"});
        Build::AddCheckbox("Gray Textures", {"", false, "Improvements", "gray_walls"});
        Build::AddCheckbox("Night Mode", {"", false, "Improvements", "night_mode"});
        // Build::AddCheckbox("Auto-Accept", {"", false, "Improvements", "auto_accept"});
#ifdef GOSX_OVERWATCH_REVEAL
        Build::AddCheckbox("Overwatch Reveal", {"", false, "OverwatchReveal", "enabled"});
#endif
#ifdef GOSX_STREAM_PROOF
        if (Build::AddCheckbox("Stream-proof", {"", false, "Improvements", "stream_proof"})) {
            if (StreamProof->Active(true)) {
                GUI::MessagePopup::AddMessage("Stream-proof mode activated!\n\nSome features have been deavtivated:\n- Chams\n- Glow\n- Night-Mode\n- FOV-Changer\n- Gray Textures\n...\n\nYou also should disable Skins and Gloves to look the most legit on stream.", MESSAGE_TYPE_INFO, 5500);
            } else if (!StreamProof->Active(true)) {
                GUI::MessagePopup::AddMessage("Stream-proof mode deactivated!\n\nAll features have been restored!", MESSAGE_TYPE_SUCCESS, 3000);
            }
        }
#endif
        ImGui::NewLine();
        IsLastItem = true;
        if (Build::AddCheckbox("Menu Weapon Icons", {"", false, "Config", "weapon_icons"})) {
            Options::Config::weapon_icons = !Options::Config::weapon_icons;
        }
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        Build::AddFloatSlider("Field of View", 35.0f, 150.f, {"", true, "Improvements", "fov"});
        IsLastItem = true;
        Build::AddFloatSlider("Flash transparency", 0.0f, 1.0f, {"", true, "Improvements", "maxflashalpha"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::SettingsTab::RenderBunnyhopTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Enabled", {"", false, "Improvements", "bunnyhop"});
        IsLastItem = true;
        Build::AddCheckbox("Legit Mode", {"", false, "Improvements", "bhop_legit"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        Build::AddKeyInput("Toggle Key", false, {"", true, "Improvements", "bhop_toggle_key"});
        Build::AddIntSlider("Min. Hops", 1, 35, {"", true, "Improvements", "bhop_minhops"});
        IsLastItem = true;
        Build::AddIntSlider("Max. Hops", 1, 50, {"", true, "Improvements", "bhop_maxhops"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

#ifdef GOSX_BACKTRACKING
void GUI::SettingsTab::RenderBacktrackingTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"", false, "Backtracking", "enabled"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Visibiliy Check", {"", false, "Backtracking", "visibility_check"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        if (GUI::Build::AddIntSlider("Ticks", 0, 12, {"", true, "Backtracking", "backtrack_ticks"})) {
            Backtracking->InvalidateData();
        }
        GUI::Build::AddCombo("Visual Type", BacktrackVisualType.data(), (int)BacktrackVisualType.size(), -1, {"", true, "Backtracking", "backtrack_visual_type"});
        IsLastItem = true;
        GUI::Build::AddCombo("Hitbox to track", HitboxBones.data(), (int)HitboxBones.size(), -1, {"", true, "Backtracking", "backtrack_hitbox"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}
#endif
