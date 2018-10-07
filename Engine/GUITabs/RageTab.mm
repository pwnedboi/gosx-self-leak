/******************************************************/
/**                                                  **/
/**      GUITabs/RageTab.mm                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-07-27                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "RageTab.h"

#ifdef GOSX_RAGE_MODE
#include "Engine/Features/Rage/ClantagChanger.h"

std::vector<const char*> GUI::RageTab::PitchAAList = {
    "Emotion",
    "Up",
    "Down",
    "Custom Pitch",
    "Dance",
    "Static Up Fake",
    "Static Down Fake",
    "Lisp Down",
    "Angel Down",
    "Angel Up",
    "Random"
};

std::vector<const char*> GUI::RageTab::YawAAList = {
    "Backwards",
    "Left",
    "Right",
    "Custom Yaw",
    "Spin Fast",
    "Spin Slow",
    "Jitter",
    "Back Jitter",
    "Side",
    "Static AA",
    "Static Jitter",
    "Static Small Jitter",
    "Lisp",
    "Lisp Side",
    "Lisp Jitter",
    "Angel Backwards",
    "Angel Inverse",
    "Angel Spin",
    "Random"
};

std::vector<const char*> GUI::RageTab::ResolverModes = {
    "Off",
    "Force",
    "Delta",
    "Steady",
    "Modulo",
    "Pose Param",
    "All"
};

std::vector<const char*> GUI::RageTab::ClantagAnimationTypes = {
    "Right to Left",
    "Left to Right"
};

std::vector<const char*> GUI::RageTab::AutostrafeTypes = {
    "Forward",
    "Backward",
    "Left",
    "Right",
    "RAGE!!!1111"
};

int GUI::RageTab::SelectedTab = 0;

void GUI::RageTab::Render() {
    ImGuiStyle& style = ImGui::GetStyle();
    ImGuiWindow* window = ImGui::GetCurrentWindowRead();
    
    static std::vector<std::string> Tabs = {
        "Aim",
        "Antiaim",
        "Resolver",
        "Misc",
        "Clantag"
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
        ImGui::BeginChildFrame(10, ImVec2(0.0f, 22.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            IsLastItem = true;
            GUI::Build::AddCheckbox("Rage Enabled", {"rage_enabled", false, "Rage", "enabled"});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
        draw->AddLine(ImVec2(Cursor.x, window->DC.CursorPos.y), ImVec2(Cursor.x + ImGui::GetContentRegionAvail().x, window->DC.CursorPos.y), ImColor(0.20f, 0.20f, 0.20f, 1.0f), 2.0f);
        draw->AddRectFilled(ImVec2(Cursor.x - 10.0f, window->DC.CursorPos.y + 1.0f), ImVec2(Cursor.x + 205.0f, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y + 10.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        ImGui::BeginChildFrame(1, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            switch (SelectedTab) {
                case 0:
                    RenderAimTab(window);
                    break;
                case 1:
                    RenderAntiaimTab(window);
                    break;
                case 2:
                    RenderResolverTab(window);
                    break;
                case 3:
                    RenderMiscTab(window);
                    break;
                case 4:
                    RenderClantagTab(window);
                    break;
            }
        }
        ImGui::EndChildFrame();
    }
    ImGui::PopStyleVar(1);
    ImGui::PopStyleColor(3);
}

void GUI::RageTab::RenderAimTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Hitscan", {"", false, "Rage", "hit_scan"});
        Build::AddCheckbox("Hitchance", {"", false, "Rage", "hitchance"});
        ImGui::NewLine();
        Build::AddCheckbox("Silent Aim", {"", false, "Rage", "silent_aim"});
        Build::AddCheckbox("Auto Walls", {"", false, "Rage", "auto_wall"});
        ImGui::NewLine();
        Build::AddCheckbox("Auto-Shoot", {"", false, "Rage", "auto_shoot"});
        Build::AddCheckbox("Auto-Scope", {"", false, "Rage", "auto_scope"});
        Build::AddCheckbox("Auto-Crouch", {"", false, "Rage", "autocrouch"});
        Build::AddCheckbox("Auto-Stop", {"", false, "Rage", "auto_stop"});
        ImGui::NewLine();
        IsLastItem = true;
        Build::AddCheckbox("Anti Untrusted", {"", false, "Rage", "anti_untrusted"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        Build::AddFloatSlider("FOV Multipl.", 1.0f, 35.0f, {"", true, "Rage", "fov_multiplier"});
        ImGui::NewLine();
        Build::AddIntSlider("Hitchance Shots", 1, 256, {"", true, "Rage", "hitchance_shots"});
        Build::AddFloatSlider("Hitchance percent", 0.0f, 100.0f, {"", true, "Rage", "hitchance_percent"});
        ImGui::NewLine();
        IsLastItem = true;
        Build::AddFloatSlider("Auto Wall min. Dmg.", 1.0f, 500.0f, {"", true, "Rage", "autowall_min_damage"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::RageTab::RenderAntiaimTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(20, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Enabled", {"", false, "Rage", "anti_aim"});
        IsLastItem = true;
        Build::AddCheckbox("Edge AA", {"", false, "Rage", "edge_aa"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(21, ImVec2(0.0f, 0.0f));
    {
        Build::AddCombo("Pitch", PitchAAList.data(), (int)PitchAAList.size(), -1, {"", true, "Rage", "antiaim_pitch"});
        Build::AddFloatSlider("Custom Pitch", -89.0f, 89.0f, {"", true, "Rage", "antiaim_custom_pitch"});
        Build::AddCombo("Yaw", YawAAList.data(), (int)YawAAList.size(), -1, {"", true, "Rage", "antiaim_yaw"});
        IsLastItem = true;
        Build::AddFloatSlider("Custom Yaw", -180.0f, 180.0f, {"", true, "Rage", "antiaim_custom_yaw"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::RageTab::RenderResolverTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(30, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Enabled", {"", false, "Rage", "resolver"});
        Build::AddCheckbox("All", {"", false, "Rage", "resolve_all"});
        IsLastItem = true;
        Build::AddCheckbox("Backtracking", {"", false, "Rage", "back_tracking"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(31, ImVec2(0.0f, 0.0f));
    {
        Build::AddCombo("Pitch", ResolverModes.data(), (int)ResolverModes.size(), -1, {"", true, "Rage", "resolver_mode"});
        Build::AddIntSlider("Ticks", 1, 25, {"", true, "Rage", "resolver_ticks"});
        IsLastItem = true;
        Build::AddIntSlider("Modulo", 1, 10, {"", true, "Rage", "resolver_modulo"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::RageTab::RenderMiscTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(50, ImVec2(200.0f, 0.0f));
    {
        Build::AddCheckbox("Thirdperson", {"thirdperson_enabled", false, "Rage", "thirdperson_enabled"});
        ImGui::NewLine();
        Build::AddCheckbox("Fakelag ", {"fakelag_enabled", false, "RageMisc", "fakelag"});
        Build::AddCheckbox("Adaptive Fakelag", {"fakelag_adaptive", false, "RageMisc", "fakelag_adaptive"});
        ImGui::NewLine();
        Build::AddCheckbox("Autostrafe", {"as_enabled", false, "AutoStrafe", "enabled"});
        Build::AddCheckbox("Autostrafe silent", {"as_silent", false, "AutoStrafe", "silent"});
        ImGui::NewLine();
        Build::AddCheckbox("No visual recoil", {"nvr_enabled", false, "RageMisc", "no_visual_recoil"});
        ImGui::NewLine();
        Build::AddCheckbox("Fake Walk", {"fw_enabled", false, "RageMisc", "fake_walk"});
        IsLastItem = true;
        Build::AddCheckbox("Circle-strafe", {"cs_enabled", false, "RageMisc", "circle_strafe"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(51, ImVec2(0.0f, 0.0f));
    {
        Build::AddFloatSlider("Thirdperson Distance", 1.0f, 500.0f, {"", true, "Rage", "thirdperson_distance"});
        Build::AddKeyInput("Thirdperson toggle key", false, {"", true, "Rage", "thirdperson_toggle"});
        ImGui::NewLine();
        Build::AddIntSlider("Fakelag Packets", 1, 16, {"", true, "RageMisc", "fakelag_ticks"});
        ImGui::NewLine();
        Build::AddCombo("Autostrafe Type", AutostrafeTypes.data(), (int)AutostrafeTypes.size(), -1, {"", true, "Autostrafe", "strafe_type"});
        ImGui::NewLine();
        Build::AddKeyInput("Fake Walk key", false, {"", true, "RageMisc", "fake_walk_key"});
        IsLastItem = true;
        Build::AddKeyInput("Circle-strafe key", false, {"", true, "RageMisc", "circle_strafe_key"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::RageTab::RenderClantagTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(60, ImVec2(200.0f, 0.0f));
    {
        if (Build::AddCheckbox("Enabled", {"ct_enabled", false, "ClantagChanger", "enabled"})) {
            ClantagChanger->Reset();
        }
        if (Build::AddCheckbox("Hide nickname", {"", false, "ClantagChanger", "hide_name"})) {
            ClantagChanger->Reset();
        }
        IsLastItem = true;
        if (Build::AddCheckbox("Animated", {"", false, "ClantagChanger", "animated"})) {
            ClantagChanger->Reset();
        }
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(61, ImVec2(0.0f, 0.0f));
    {
        if (Build::AddCombo("Animation type", ClantagAnimationTypes.data(), (int)ClantagAnimationTypes.size(), -1, {"", true, "ClantagChanger", "animation_type"})) {
            ClantagChanger->Reset();
        }
        if (Build::AddFloatSlider("Animation Speed", 0.000001f, 1.0f, {"", true, "ClantagChanger", "animation_speed"})) {
            ClantagChanger->Reset();
        }
        IsLastItem = true;
        if (Build::AddMenuTextInput("Custom Clantag", {"", true, "ClantagChanger", "tag", 0, 14})) {
            ClantagChanger->Reset();
        }
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}
#endif
