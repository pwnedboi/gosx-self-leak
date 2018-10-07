/******************************************************/
/**                                                  **/
/**      GUITabs/VisualsTab.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "VisualsTab.h"

std::vector<const char*> GUI::VisualsTab::ChamTypes = {
    "None",
    "Textured",                         // 1 = CMAT_TYPE_HID_TEX
    "Textured (Wallhack)",              // 2 = CMAT_TYPE_VIS_TEX
    "Flat",                             // 3 = CMAT_TYPE_HID_FLAT
    "Flat (Wallhack)",                  // 4 = CMAT_TYPE_VIS_FLAT
    "Textured Wireframe",               // 5 = CMAT_TYPE_HID_TEX_WIRE
    "Textured Wireframe (Wallhack)",    // 6 = CMAT_TYPE_VIS_TEX_WIRE
    "Flat Wireframe",                   // 7 = CMAT_TYPE_HID_FLAT_WIRE
    "Flat Wireframe (Wallhack)",        // 8 = CMAT_TYPE_VIS_FLAT_WIRE
    // "Model Texture (Wallhack)"          // 9 = CMAT_TYPE_ALL_MODEL
};

std::vector<const char*> GUI::VisualsTab::PlayerChamTypes = {
    "Textured",
    "Flat"
};

std::vector<const char*> GUI::VisualsTab::ArmsChamTypes = {
    "Textured",
    "Wireframe"
};

int GUI::VisualsTab::SelectedTab = 0;

void GUI::VisualsTab::Render() {
    ImGuiStyle& style = ImGui::GetStyle();
    ImGuiWindow* window = ImGui::GetCurrentWindowRead();
    
    static std::vector<std::string> Tabs = {
        "Chams",
        "Glow",
        "Grenade Prediction",
        "Colors"
#ifdef GOSX_THIRDPERSON
        ,"Thirdperson"
#endif
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
        ImGui::Dummy(ImVec2(ImGui::GetContentRegionAvail().x, 15.0f));
    
        draw->AddLine(ImVec2(Cursor.x, window->DC.CursorPos.y), ImVec2(Cursor.x + ImGui::GetContentRegionAvail().x, window->DC.CursorPos.y), ImColor(0.20f, 0.20f, 0.20f, 1.0f), 2.0f);
        if (SelectedTab != 3) {
            draw->AddRectFilled(ImVec2(Cursor.x - 10.0f, window->DC.CursorPos.y + 1.0f), ImVec2(Cursor.x + 205.0f, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y + 10.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        }
        ImGui::BeginChildFrame(1, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            switch (SelectedTab) {
                case 0:
                    RenderChamsTab(window);
                    break;
                case 1:
                    RenderGlowTab(window);
                    break;
                case 2:
                    RenderGrenadePredictionTab(window);
                    break;
                case 3:
                    RenderColorsTab(window);
                    break;
#ifdef GOSX_THIRDPERSON
                case 4:
                    RenderThirdpersonTab(window);
                    break;
#endif
            }
        }
        ImGui::EndChildFrame();
    }
    ImGui::PopStyleVar(1);
    ImGui::PopStyleColor(3);
}

void GUI::VisualsTab::RenderChamsTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"chams_enabled", false, "Chams", "enabled"});
        ImGui::NewLine();
        GUI::Build::AddCheckbox("Player Chams", {"", false, "Chams", "players"});
        GUI::Build::AddCheckbox("Dead Chams", {"", false, "Chams", "show_dead_chams"});
        GUI::Build::AddCheckbox("Weapon Chams", {"", false, "Chams", "weapons"});
        GUI::Build::AddCheckbox("Arms Chams", {"", false, "Chams", "arms"});
        ImGui::NewLine();
        GUI::Build::AddCheckbox("Show on enemies", {"", false, "Chams", "enemies"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Show on allies", {"", false, "Chams", "allies"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddCombo("Players Material", ChamTypes.data(), (int)ChamTypes.size(), -1, {"", true, "Chams", "chams_type"});
        GUI::Build::AddCombo("Dead players Material", ChamTypes.data(), (int)ChamTypes.size(), -1, {"", true, "Chams", "deadchams_type"});
        GUI::Build::AddCombo("Weapon Material", ChamTypes.data(), (int)ChamTypes.size(), -1, {"", true, "Chams", "weapon_type"});
        IsLastItem = true;
        GUI::Build::AddCombo("Arms Material", ChamTypes.data(), (int)ChamTypes.size(), -1, {"", true, "Chams", "arms_type"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::VisualsTab::RenderGlowTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"glow_enabled", false, "Glow", "enabled"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Glow own Team", {"", false, "Glow", "glow_team"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
        {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("Glow Entities", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
        
            GUI::Build::StartSelectList(200, {0.0f, 88.0f}); {
                GUI::Build::AddSelectable("Players", {"", false, "Glow", "glow_player"});
                GUI::Build::AddSelectable("Weapons", {"", false, "Glow", "glow_weapon"}, true);
                GUI::Build::AddSelectable("Bomb", {"", false, "Glow", "glow_bomb"});
                GUI::Build::AddSelectable("Defuse Kits", {"", false, "Glow", "glow_extra"}, true);
                GUI::Build::AddSelectable("Grenades", {"", false, "Glow", "glow_grenades"});
            } GUI::Build::EndSelectList();
        }
        ImGui::PopStyleColor(2);
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::VisualsTab::RenderGrenadePredictionTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(30, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"grpr_enabled", false, "GrenadePrediction", "enabled"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Last Path stays", {"", false, "GrenadePrediction", "last_path_stays"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(31, ImVec2(0.0f, 0.0f));
    {
        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
        {
            GUI::Build::AddFloatSlider("Path Size", 1.0f, 5.0f, {"", true, "GrenadePrediction", "path_width"});
            IsLastItem = true;
            GUI::Build::AddIntSlider("Hitmarker Size", 0.0f, 100.0f, {"", true, "GrenadePrediction", "hit_size"});
            IsLastItem = false;
        }
        ImGui::PopStyleColor(2);
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::VisualsTab::RenderColorsTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    ImDrawList* draw = ImGui::GetWindowDrawList();
    
    ImVec2 Cursor = window->DC.CursorPos;
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(0.0f, 0.0f));
    {
        ImVec2 ContentAvail = ImGui::GetContentRegionAvail();
        ImGui::BeginChildFrame(111, ImVec2(ContentAvail.x / 3, 0.0f));
        {
            GUI::Build::AddColorButton("Chams CT (hid)", {"color_ct", false, "Colors", "color_ct"});
            GUI::Build::AddColorButton("Chams CT (vis)", {"color_ct_visible", false, "Colors", "color_ct_visible"});
            GUI::Build::AddColorButton("Chams T (hid)", {"color_t", false, "Colors", "color_t"});
            GUI::Build::AddColorButton("Chams T (vis)", {"color_t_visible", false, "Colors", "color_t_visible"});
            GUI::Build::AddColorButton("Glow CT (hid)", {"color_ct_glow", false, "Colors", "color_ct_glow"});
            GUI::Build::AddColorButton("Glow CT (vis)", {"color_ct_visible_glow", false, "Colors", "color_ct_visible_glow"});
            GUI::Build::AddColorButton("Glow T (hid)", {"color_t_glow", false, "Colors", "color_t_glow"});
            GUI::Build::AddColorButton("Glow T (vis)", {"color_t_visible_glow", false, "Colors", "color_t_visible_glow"});
            IsLastItem = true;
            GUI::Build::AddColorButton("Dead Bodies", {"color_player_dead", false, "Colors", "color_player_dead"});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
        draw->AddRectFilled(ImVec2(Cursor.x + ((ContentAvail.x / 3) * 1), Cursor.y + 1.0f), ImVec2(Cursor.x + ((ContentAvail.x / 3) * 1) + 2.0f, Cursor.y + Cursor.y + ImGui::GetContentRegionAvail().y + 700.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        ImGui::SameLine();
        ImGui::BeginChildFrame(112, ImVec2(ContentAvail.x / 3, 0.0f));
        {
            GUI::Build::AddColorButton("Weapon Chams (hid)", {"color_weapon_visible", false, "Colors", "color_weapon_visible"});
            GUI::Build::AddColorButton("Weapon Chams (vis)", {"color_weapon", false, "Colors", "color_weapon"});
            GUI::Build::AddColorButton("Cham Arms", {"color_arms_visible", false, "Colors", "color_arms_visible"});
            GUI::Build::AddColorButton("Crosshair", {"crosshair_color", false, "Drawing", "crosshair_color"});
            GUI::Build::AddColorButton("FOV Circle", {"fov_circle", false, "Colors", "fov_circle"});
            GUI::Build::AddColorButton("Wallbang Indicator", {"wallbang_indicator_color", false, "Colors", "wallbang_indicator_color"});
            GUI::Build::AddColorButton("Skeleton", {"color_bone_esp", false, "Drawing", "color_bone_esp"});
            GUI::Build::AddColorButton("Dropped Bomb", {"color_dropped_bomb", false, "Glow", "color_dropped_bomb"});
            IsLastItem = true;
            GUI::Build::AddColorButton("Planted Bomb", {"color_planted_bomb", false, "Glow", "color_planted_bomb"});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
        draw->AddRectFilled(ImVec2(Cursor.x + ((ContentAvail.x / 3) * 2), Cursor.y + 1.0f), ImVec2(Cursor.x + ((ContentAvail.x / 3) * 2) + 2.0f, Cursor.y + Cursor.y + ImGui::GetContentRegionAvail().y + 700.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        ImGui::SameLine();
        ImGui::BeginChildFrame(113, ImVec2(ContentAvail.x / 3, 0.0f));
        {
            GUI::Build::AddColorButton("Defusekits", {"color_extra", false, "Glow", "color_extra"});
            GUI::Build::AddColorButton("No-Sky", {"nosky_color", false, "Colors", "nosky_color"});
#ifdef GOSX_BACKTRACKING
            GUI::Build::AddColorButton("Backtrack Visuals", {"backtrack_color", false, "Backtracking", "backtrack_color"});
#endif
            GUI::Build::AddColorButton("HE Grenade", {"color_grenade_he", false, "GrenadeHelper", "color_grenade_he"});
            GUI::Build::AddColorButton("Smoke Grenade", {"color_grenade_smoke", false, "GrenadeHelper", "color_grenade_smoke"});
            GUI::Build::AddColorButton("Flashbang", {"color_grenade_flash", false, "GrenadeHelper", "color_grenade_flash"});
            GUI::Build::AddColorButton("Molotov/Incendiary", {"color_grenade_inc", false, "GrenadeHelper", "color_grenade_inc"});
            GUI::Build::AddColorButton("Grenade Path", {"color_grenadepred_path", false, "GrenadePrediction", "path_color"});
            IsLastItem = true;
            GUI::Build::AddColorButton("Grenade Endmarker", {"color_grenadepred_hitmarker", false, "GrenadePrediction", "hit_color"});
            IsLastItem = false;
        }
        ImGui::EndChildFrame();
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

#ifdef GOSX_THIRDPERSON
void GUI::VisualsTab::RenderThirdpersonTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(50, ImVec2(200.0f, 0.0f));
    {
        IsLastItem = true;
        Build::AddCheckbox("Enabled", {"thirdperson_enabled", false, "Thirdperson", "enabled"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(51, ImVec2(0.0f, 0.0f));
    {
        Build::AddFloatSlider("Distance", 1.0f, 500.0f, {"", true, "Thirdperson", "distance"});
        IsLastItem = true;
        Build::AddKeyInput("Toggle key", false, {"", true, "Thirdperson", "toggle_key"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}
#endif
