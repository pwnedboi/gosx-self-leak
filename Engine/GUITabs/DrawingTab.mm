/******************************************************/
/**                                                  **/
/**      GUITabs/DrawingTab.cpp                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "DrawingTab.h"

#include "SDK/ItemDefinitionIndex.h"
#include "SDK/Vector2D.h"
#include "Engine/Drawing/manager.h"
#include "Engine/Features/Esp.h"
#include "Engine/Features/GrenadeHelper.h"

std::vector<const char*> GUI::DrawingTab::BombTimerModes = {
    "Off",
    "All",
    "On-Screen",
    "In world"
};

std::vector<const char*> GUI::DrawingTab::HitmarkerStyles = {
    "Triangles",
    "Call of Duty"
};

std::vector<const char*> GUI::DrawingTab::RecoilCrosshairTypes = {
    "Off",
    "Move main X-hair",
    "Standalone RCS X-hair"
};

std::vector<const char*> GUI::DrawingTab::RadarStyles = {
    "InGame style",
    "GO:SX style"
};

int GUI::DrawingTab::SelectedTab = 0;

void GUI::DrawingTab::Render() {
    ImGuiStyle& style = ImGui::GetStyle();
    ImGuiWindow* window = ImGui::GetCurrentWindowRead();
    
    static std::vector<std::string> Tabs = {
        "ESP",
        "Grenadehelper",
        "Static Crosshair",
        "Spectator List",
        "Radar"
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
        draw->AddRectFilled(ImVec2(Cursor.x - 10.0f, window->DC.CursorPos.y + 1.0f), ImVec2(Cursor.x + 205.0f, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y + 10.0f), ImColor(0.20f, 0.20f, 0.20f, 1.0f));
        ImGui::BeginChildFrame(1, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
        {
            switch (SelectedTab) {
                case 0:
                    RenderESPTab(window);
                    break;
                case 1:
                    RenderGrenadehelperTab(window);
                    break;
                case 2:
                    RenderCrosshairTab(window, draw);
                    break;
                case 3:
                    RenderSpectatorTab(window);
                    break;
                case 4:
                    RenderRadarTab(window);
                    break;
            }
        }
        ImGui::EndChildFrame();
    
    }
    ImGui::PopStyleVar(1);
    ImGui::PopStyleColor(3);
}

void GUI::DrawingTab::RenderESPTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    ImDrawList* draw = ImGui::GetWindowDrawList();
    
    static std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);

    ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.0f});
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Player ESP", {"", false, "Drawing", "playeresp"});
        GUI::Build::AddCheckbox("Bounding Box Outline", {"", false, "Drawing", "boundingbox_outline"});
        GUI::Build::AddCheckbox("Aim Tracers", {"", false, "Drawing", "entity_view_lines"});
        GUI::Build::AddCheckbox("Show Allies ESP", {"", false, "Drawing", "bone_esp_allies"});
        GUI::Build::AddCheckbox("Smoke Head-Dot", {"", false, "Drawing", "smoke_esp"});
        GUI::Build::AddCheckbox("Skeleton ESP", {"", false, "Drawing", "bone_esp"});
        ImGui::NewLine();
        GUI::Build::AddCheckbox("Weapon ESP", {"", false, "Drawing", "weapon_esp"});
        GUI::Build::AddCheckbox("Grenade ESP", {"", false, "Drawing", "grenade_esp"});
        GUI::Build::AddCheckbox("Defuse-Kit ESP", {"", false, "Drawing", "defusekit_esp"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Bomb ESP", {"", false, "Drawing", "bomb_esp"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
    ImGui::BeginChildFrame(12, ImVec2(160.0f, 0.0f));
    {
        ImGui::PushFont(Fonts::Label); {
            Build::AddCustomText("ESP Preview", FONTFLAG_DROPSHADOW);
        } ImGui::PopFont();
        ImVec2 contentSize = ImVec2(150.0f, 250.0f);
        ImVec2 StartingPoint = ImVec2(ImGui::GetCurrentWindow()->DC.CursorPos.x + 18.0f, ImGui::GetCurrentWindow()->DC.CursorPos.y + 30.0f);
    
        draw->AddRectFilled(ImGui::GetCurrentWindow()->DC.CursorPos, ImVec2(ImGui::GetCurrentWindow()->DC.CursorPos.x + contentSize.x, ImGui::GetCurrentWindow()->DC.CursorPos.y + contentSize.y), ImColor(1.0f, 1.0f, 1.0f, 0.5f), 5.0f);
    
        ESPPreview(draw, StartingPoint, ImVec2(100.0f, 180.0f));
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleVar(1);
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(13, ImVec2(0.0f, 0.0f));
    {
        ImGui::PushStyleColor(ImGuiCol_FrameBg, ImVec4(0.0f, 0.0f, 0.0f, 0.3f));
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
        {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("ESP Elements", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
        
            GUI::Build::StartSelectList(100, ImVec2(0.0f, 110.0f)); {
                GUI::Build::AddSelectable("Bounding Box", {"", true, "Drawing", "draw_boundingbox"});
                GUI::Build::AddSelectable("Name", {"", true, "Drawing", "draw_name"}, true);
                GUI::Build::AddSelectable("Healthbar", {"", true, "Drawing", "draw_healthbar"});
                GUI::Build::AddSelectable("Health Number", {"", true, "Drawing", "draw_healthnumber"}, true);
                GUI::Build::AddSelectable("Armorbar", {"", true, "Drawing", "draw_armorbar"});
                GUI::Build::AddSelectable("Weapon", {"", true, "Drawing", "draw_weapon_name"}, true);
                GUI::Build::AddSelectable("Distance", {"", true, "Drawing", "draw_distance"});
                GUI::Build::AddSelectable("C4 Icon", {"", true, "Drawing", "draw_c4"}, true);
                GUI::Build::AddSelectable("Armor Icon", {"", true, "Drawing", "draw_armor"});
                GUI::Build::AddSelectable("Defuse Kit Icon", {"", true, "Drawing", "draw_defkit"}, true);
            } GUI::Build::EndSelectList();
        
            if (activeConfig->GetSetting<bool>("Drawing", "weapon_esp", Options::Drawing::weapon_esp)) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Weapon ESP Elements", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                GUI::Build::StartSelectList(200, ImVec2(0.0f, 56.0f)); {
                    GUI::Build::AddSelectable("Bounding Box", {"", true, "Drawing", "weapon_opt_boundingbox"});
                    GUI::Build::AddSelectable("Name", {"", true, "Drawing", "weapon_opt_name"}, true);
                } GUI::Build::EndSelectList();
            }
        
            if (activeConfig->GetSetting<bool>("Drawing", "grenade_esp", Options::Drawing::grenade_esp)) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Grenade ESP Elements", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                GUI::Build::StartSelectList(201, ImVec2(0.0f, 56.0f)); {
                    GUI::Build::AddSelectable("Bounding Box", {"", true, "Drawing", "grenade_opt_boundingbox"});
                    GUI::Build::AddSelectable("Name", {"", true, "Drawing", "grenade_opt_name"}, true);
                } GUI::Build::EndSelectList();
            }
        
            if (activeConfig->GetSetting<bool>("Drawing", "defusekit_esp", Options::Drawing::defusekit_esp)) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Defuse-Kit ESP Elements", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                GUI::Build::StartSelectList(202, ImVec2(0.0f, 56.0f)); {
                    GUI::Build::AddSelectable("Bounding Box", {"", true, "Drawing", "defusekit_opt_boundingbox"});
                    GUI::Build::AddSelectable("Name", {"", true, "Drawing", "defusekit_opt_name"}, true);
                    GUI::Build::AddSelectable("Distance", {"", true, "Drawing", "defusekit_opt_distance"});
                } GUI::Build::EndSelectList();
            }
        
            if (activeConfig->GetSetting<bool>("Drawing", "bomb_esp", Options::Drawing::bomb_esp)) {
                ImGui::PushFont(Fonts::Label); {
                    Build::AddCustomText("Bomb ESP Elements", FONTFLAG_DROPSHADOW);
                } ImGui::PopFont();
                
                GUI::Build::StartSelectList(203, ImVec2(0.0f, 56.0f)); {
                    GUI::Build::AddSelectable("Bounding Box", {"", true, "Drawing", "bomb_opt_boundingbox"});
                    GUI::Build::AddSelectable("Name", {"", true, "Drawing", "bomb_opt_name"}, true);
                    GUI::Build::AddSelectable("Distance", {"", true, "Drawing", "bomb_opt_distance"});
                } GUI::Build::EndSelectList();
            }
        }
        ImGui::PopStyleColor(2);
        ImGui::NewLine();

        IsLastItem = true;
        GUI::Build::AddCombo("Bomb Timer", BombTimerModes.data(), (int)BombTimerModes.size(), -1, {"", true, "Drawing", "bomb_timer"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::DrawingTab::RenderGrenadehelperTab(ImGuiWindow* window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"gh_enabled", false, "GrenadeHelper", "enabled"});
        GUI::Build::AddCheckbox("Aim Assist", {"", false, "GrenadeHelper", "aim_assist"});
        GUI::Build::AddCheckbox("Smooth Aiming", {"", false, "GrenadeHelper", "smoothaim"});
        ImGui::NewLine();
        ImGui::NewLine();
        if (!Options::GrenadeHelper::developer_mode) {
            IsLastItem = true;
            if (GUI::Build::AddCheckbox("Enable Developer", {"", false, "GrenadeHelper", "developer_mode"})) {
                Options::GrenadeHelper::developer_mode = CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("GrenadeHelper", "developer_mode", Options::GrenadeHelper::developer_mode);
            }
            IsLastItem = false;
        } else {
            if (GUI::Build::AddCheckbox("Enable Developer", {"", false, "GrenadeHelper", "developer_mode"})) {
                Options::GrenadeHelper::developer_mode = CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("GrenadeHelper", "developer_mode", Options::GrenadeHelper::developer_mode);
            }
            ImGui::NewLine();
            if (ImGui::Button(std::string(GrenadeHelperDev::DevWindowVisible ? "Close" : "Open").append(" Developer Window").c_str())) {
                GrenadeHelperDev::DevWindowVisible = !GrenadeHelperDev::DevWindowVisible;
            }
        }
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddFloatSlider("Aim Distance", 0.0f, 500.0f, {"", true, "GrenadeHelper", "aim_distance"});
        GUI::Build::AddFloatSlider("Visibility Distance", 0.0f, 1500.0f, {"", true, "GrenadeHelper", "visible_distance"});
        IsLastItem = true;
        GUI::Build::AddFloatSlider("FOV activation", 0.0f, 30.0f, {"", true, "GrenadeHelper", "aim_fov"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::DrawingTab::RenderCrosshairTab(ImGuiWindow *window, ImDrawList* draw) {
    ImGuiStyle& style = ImGui::GetStyle();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        GUI::Build::AddCheckbox("Enabled", {"ch_enabled", false, "Drawing", "crosshair"});
        GUI::Build::AddCheckbox("With outline", {"", false, "Drawing", "crosshair_outline"});
        GUI::Build::AddCheckbox("FOV Circle", {"", false, "Drawing", "fovcircle"});
        GUI::Build::AddCheckbox("Hitmarker", {"", false, "Drawing", "hit_marker"});
        GUI::Build::AddCheckbox("Play Hitmarker Sound", {"", false, "Drawing", "hit_marker_sound"});
        IsLastItem = true;
        GUI::Build::AddCheckbox("Wallbang Indicator", {"", false, "Drawing", "show_wallbang_indicator"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    if (Options::Drawing::crosshair) {
        ImGui::SameLine();
        ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(5.0f, 5.0f));
        ImGui::BeginChildFrame(12, ImVec2(130.0f, 0.0f));
        {
            ImGui::PushFont(Fonts::Label); {
                Build::AddCustomText("Crosshair Preview", FONTFLAG_DROPSHADOW);
            } ImGui::PopFont();
            ImVec2 contentSize = ImVec2(120.0f, 120.0f);
            ImVec2 middlePoint = ImVec2(ImGui::GetCurrentWindow()->DC.CursorPos.x + (contentSize.x / 2), ImGui::GetCurrentWindow()->DC.CursorPos.y + (contentSize.y / 2));
        
            draw->AddRectFilled(ImGui::GetCurrentWindow()->DC.CursorPos, ImVec2(ImGui::GetCurrentWindow()->DC.CursorPos.x + contentSize.x, ImGui::GetCurrentWindow()->DC.CursorPos.y + contentSize.y), ImColor(1.0f, 1.0f, 1.0f, 0.5f), 5.0f);
        
            CrosshairPreview(draw, middlePoint);
        }
        ImGui::EndChildFrame();
        ImGui::PopStyleVar(1);
    }
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(13, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddIntSlider("Width", 0, 500, {"", true, "Drawing", "crosshair_width"});
        GUI::Build::AddIntSlider("Thickness", 0, 250, {"", true, "Drawing", "crosshair_thickness"});
        GUI::Build::AddIntSlider("Gap", 0, 250, {"", true, "Drawing", "crosshair_gap"});
        ImGui::NewLine();
        GUI::Build::AddCombo("Recoil Crosshair Type", RecoilCrosshairTypes.data(), (int)RecoilCrosshairTypes.size(), -1, {"", true, "Drawing", "recoil_crosshair"});
        GUI::Build::AddCombo("Hitmarker Style", HitmarkerStyles.data(), (int)HitmarkerStyles.size(), -1, {"", true, "Drawing", "hit_marker_style"});
        IsLastItem = true;
        GUI::Build::AddFloatSlider("Hitmarker Volume", 0, 1.0f, {"", true, "Drawing", "hit_marker_volume"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::DrawingTab::CrosshairPreview(ImDrawList* draw, ImVec2 middlePoint) {
    int halfScreenY = (int)middlePoint.y;
    int halfScreenX = (int)middlePoint.x;
    
    int posXstart;
    int posYstart;
    
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    
    if (activeConfig->GetSetting<bool>("Drawing", "fovcircle", Options::Drawing::fovcircle)) {
        ESP->DrawTheCircle(middlePoint.x, middlePoint.y);
    }
    
    Color colorRed = activeConfig->GetColorSetting("Drawing", "crosshair_color", Options::Drawing::crosshair_color.ToString());
    Color colorBlack = Color(0, 0, 0, 255);
    
    int chthickness = activeConfig->GetSetting<int>("Drawing", "crosshair_thickness", Options::Drawing::crosshair_thickness);
    int chgap = activeConfig->GetSetting<int>("Drawing", "crosshair_gap", Options::Drawing::crosshair_gap);
    int chwidth = activeConfig->GetSetting<int>("Drawing", "crosshair_width", Options::Drawing::crosshair_width);
    bool DrawOutline = activeConfig->GetSetting<bool>("Drawing", "crosshair_outline", Options::Drawing::crosshair_outline);
    
    int halfThickness = (int)roundf(chthickness / 2);
    int halfWidth = (int)roundf(chwidth / 2);
    int halfGap = (int)roundf(chgap / 2);
    
    if (DrawOutline) {
        posXstart = halfScreenX - halfThickness - 1;
        posYstart = halfScreenY - halfWidth - 1;
        draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + chthickness + 2), (float)(posYstart + (halfWidth - halfGap) + 2)), colorBlack.ToImColor());
        posYstart = halfScreenY + (int)roundf(chgap / 2);
        draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + chthickness + 2), (float)(posYstart + (halfWidth - halfGap) + 2)), colorBlack.ToImColor());
    }
    
    posXstart = halfScreenX - halfThickness;
    posYstart = halfScreenY - halfWidth;
    draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + chthickness), (float)(posYstart + (halfWidth - halfGap))), colorRed.ToImColor());
    posYstart = halfScreenY + halfGap + 1;
    draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + chthickness), (float)(posYstart + (halfWidth - halfGap))), colorRed.ToImColor());
    
    if (DrawOutline) {
        posXstart = halfScreenX - halfWidth - 1;
        posYstart = halfScreenY - halfThickness - 1;
        draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + (halfWidth - halfGap) + 2), (float)(posYstart + chthickness + 2)), colorBlack.ToImColor());
        posXstart = halfScreenX + halfGap;
        draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + (halfWidth - halfGap) + 2), (float)(posYstart + chthickness + 2)), colorBlack.ToImColor());
    }
    
    posXstart = halfScreenX - halfWidth;
    posYstart = halfScreenY - halfThickness;
    draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + (halfWidth - halfGap)), (float)(posYstart + chthickness)), colorRed.ToImColor());
    posXstart = halfScreenX + halfGap + 1;
    draw->AddRectFilled(ImVec2((float)posXstart, (float)posYstart), ImVec2((float)(posXstart + (halfWidth - halfGap)), (float)(posYstart + chthickness)), colorRed.ToImColor());
}

void GUI::DrawingTab::ESPPreview(ImDrawList *draw, ImVec2 position, ImVec2 size) {
    int x, y, w, h;
    x = (int)position.x;
    y = (int)position.y;
    w = (int)size.x;
    h = (int)size.y;
    
    std::shared_ptr<CSettingsManager> activeConfig = CSettingsManager::Instance(currentConfigName);
    
    float leftSideTopPadding = 0;
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_boundingbox", Options::Drawing::draw_boundingbox)) {
        ESP->DrawBox(x, y, w, h, 3, 5, activeConfig->GetColorSetting("Colors", "color_ct", Options::Colors::color_ct.ToString()), activeConfig->GetSetting<bool>("Drawing", "boundingbox_outline", Options::Drawing::boundingbox_outline));
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_name", Options::Drawing::draw_name)) {
        DrawManager->DrawString(Fonts::Section, (int)(x + (w / 2)), (int)(y - (Fonts::Section->FontSize / 2) - 1), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "Bob the Builder");
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_healthbar", Options::Drawing::draw_healthbar)) {
        int health = 75;
        
        if (health > 100) {
            health = 100;
        }
        
        int r = (int)(255 - health * 2.55);
        int g = (int)(health * 2.55);
        
        int healthBarHeight = (int)((h - 2) * health / 100);
        DrawManager->DrawRect(x - 5, y, 4, h, Color(0, 0, 0, 255));
        if (healthBarHeight > 0) {
            DrawManager->DrawRect(x - 4, y + 1 + ((h - 2) - healthBarHeight), 2, healthBarHeight, Color(r, g, 0, 255));
            if (activeConfig->GetSetting<bool>("Drawing", "draw_healthnumber", Options::Drawing::draw_healthnumber)) {
                DrawManager->DrawString(GUI::Fonts::Label, x - 2, (int)(y + 1 + (h - 2) - healthBarHeight), FONTFLAG_OUTLINE, Color(255, 255, 255), true, "%i", health);
            }
        }
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_c4", Options::Drawing::draw_c4)) {
        Vector2D textSize = DrawManager->GetTextSize(ICON_CSGO_C4, GUI::Fonts::CstrikeIcons);
        DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + w + 5 + (textSize.x / 2)), (int)(y + leftSideTopPadding), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", ICON_CSGO_C4);
        
        leftSideTopPadding += GUI::Fonts::CstrikeIcons->FontSize + 2;
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_armor", Options::Drawing::draw_armor)) {
        bool HasArmor = true;
        bool HasHelmet = true;
        std::string icon = "";
        if (HasArmor) {
            icon = ICON_CSGO_KEVLAR;
        }
        if (HasArmor && HasHelmet) {
            icon = ICON_CSGO_KEVLARHELMET;
        }
        if (icon != "") {
            Vector2D textSize = DrawManager->GetTextSize(icon.c_str(), GUI::Fonts::CstrikeIcons);
            DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + w + 5 + (textSize.x / 2)), (int)(y + leftSideTopPadding), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", icon.c_str());
            leftSideTopPadding += GUI::Fonts::CstrikeIcons->FontSize + 2;
        }
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_defkit", Options::Drawing::draw_defkit)) {
        Vector2D textSize = DrawManager->GetTextSize(ICON_CSGO_DEFUSEKIT, GUI::Fonts::CstrikeIcons);
        DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + w + 5 + (textSize.x / 2)), (int)(y + leftSideTopPadding), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", ICON_CSGO_DEFUSEKIT);
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_armorbar", Options::Drawing::draw_armorbar)) {
        int armor = 80;

        if (armor > 0) {
            if (armor > 100) {
                armor = 100;
            }
            
            bool drawHealthBar = activeConfig->GetSetting<bool>("Drawing", "draw_healthbar", Options::Drawing::draw_healthbar);
            int armorBarHeight = (int)((h - 2) * armor / 100);
            DrawManager->DrawRect(x - (!drawHealthBar ? 5 : 9), y, 4, h, Color(0, 0, 0, 255));
            if (armorBarHeight > 0) {
                DrawManager->DrawRect(x - (!drawHealthBar ? 4 : 8), y + 1 + ((h - 2) - armorBarHeight), 2, armorBarHeight, Color(0, 153, 255, 255));
            }
        }
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_weapon_name", Options::Drawing::draw_weapon_name)) {
            Vector2D textSize = DrawManager->GetTextSize(ICON_CSGO_AWP, GUI::Fonts::CstrikeIcons);
            DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + (w / 2)), (int)(y + h + (textSize.y / 2) + 2), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", ICON_CSGO_AWP);
    }
    
    if (activeConfig->GetSetting<bool>("Drawing", "draw_distance", Options::Drawing::draw_distance)) {
        float distance = 3.0f;
        
        DrawManager->DrawString(GUI::Fonts::Label, (int)(x + (w / 2)), (int)(y + h - 10), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%i M", (int)distance);
    }
}

void GUI::DrawingTab::RenderSpectatorTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();

    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        IsLastItem = true;
        GUI::Build::AddCheckbox("Enabled", {"sl_enabled", false, "Drawing", "list_enabled"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();

    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddFloatSlider("Position X", 0.0f, 2400.0f, {"", true, "Drawing", "list_x"});
        IsLastItem = true;
        GUI::Build::AddFloatSlider("Position Y", 0.0f, 1200.0f, {"", true, "Drawing", "list_y"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

void GUI::DrawingTab::RenderRadarTab(ImGuiWindow *window) {
    ImGuiStyle& style = ImGui::GetStyle();
    ImDrawList* draw = ImGui::GetWindowDrawList();
    
    ImGui::PushStyleColor(ImGuiCol_FrameBg, style.Colors[ImGuiCol_FrameBg]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgActive, style.Colors[ImGuiCol_FrameBgActive]);
    ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, style.Colors[ImGuiCol_FrameBgHovered]);
    ImGui::BeginChildFrame(11, ImVec2(200.0f, 0.0f));
    {
        IsLastItem = true;
        GUI::Build::AddCheckbox("Enabled", {"rh_enabled", false, "Radar", "enabled"});
        IsLastItem = false;
    }
    ImGui::EndChildFrame();
    
    ImVec2 LineStart = window->DC.CursorPos;
    ImVec2 LineEnd = ImVec2(window->DC.CursorPos.x, window->DC.CursorPos.y + ImGui::GetContentRegionAvail().y);
    
    draw->AddLine(LineStart, LineEnd, ImColor(0.20f, 0.20f, 0.20f, 1.0f), 2.0f);
    
    ImGui::SameLine();
    ImGui::BeginChildFrame(12, ImVec2(0.0f, 0.0f));
    {
        GUI::Build::AddCombo("Radar Style", RadarStyles.data(), (int)RadarStyles.size(), -1, {"", true, "Radar", "style"});
        ImGui::NewLine();
        if (CSettingsManager::Instance(currentConfigName)->GetSetting<int>("Radar", "style") == 1) {
            GUI::Build::AddIntSlider("Size", 0, 800, {"", true, "Radar", "size"});
            GUI::Build::AddIntSlider("Position (X)", 0, 2400, {"", true, "Radar", "pos_x"});
            GUI::Build::AddIntSlider("Position (Y)", 0, 1200, {"", true, "Radar", "pos_y"});
            IsLastItem = true;
            GUI::Build::AddIntSlider("Zoom", 0, 100, {"", true, "Radar", "zoom"});
            IsLastItem = false;
        }
    }
    ImGui::EndChildFrame();
    ImGui::PopStyleColor(3);
}

bool GUI::GrenadeHelperDev::DevWindowVisible = false;
std::vector<const char*> GUI::GrenadeHelperDev::ThrowTypes;

int GUI::GrenadeHelperDev::GInfo::throwType = 0;
std::string GUI::GrenadeHelperDev::locationInputString = "";

void GUI::GrenadeHelperDev::Setup() {
    GUI::GrenadeHelperDev::ThrowTypes = {
        "Normal",
        "Run",
        "Jump",
        "Walk",
        "Jump Run"
    };
}

void GUI::GrenadeHelperDev::RunWindow() {
    if (!DevWindowVisible) {
        return;
    }
    
    ImGui::SetNextWindowSize(ImVec2(200.0f, 350.0f), ImGuiSetCond_Always);
    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(10.0f, 10.0f));
    if (ImGui::Begin("Grenadehelper Developer", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar))
    {
        if (!Engine->IsInGame() || !Engine->IsConnected()) {
            DrawOutofgameNotice();
        } else if (Engine->IsInGame() && Engine->IsConnected()) {
            C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
            if (LocalPlayer && LocalPlayer->IsAlive() && !LocalPlayer->IsDormant()) {
                QAngle ViewAngle = LocalPlayer->GetViewAngle();
                Vector Position = *LocalPlayer->GetOrigin();
                std::string mapName = std::string(Engine->GetLevelNameShort());
                ImGui::BeginChildFrame(2000, ImVec2(0.0f, 25.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
                {
                    GUI::Build::AddLabelText("Map Name", Functions::Basename(mapName), {"", true});
                }
                ImGui::EndChildFrame();
                
                C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
                if (activeWeapon && WeaponManager::IsGrenade(activeWeapon->EntityId()) && ItemDefinitionIndex.find(activeWeapon->EntityId()) != ItemDefinitionIndex.end()) {
                    GUI::Build::AddFrameLabel("Config");
                    ImGui::BeginChildFrame(2001, ImVec2(0.0f, 140.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
                    {
                        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
                        {
                            GUI::Build::AddLabelText("Grenade Type", std::string(ItemDefinitionIndex.at(activeWeapon->EntityId()).display_name), {"", true});
                            ImGui::PushFont(Fonts::Label);
                            {
                                ImGui::Text("%s", "Throw type");
                            }
                            ImGui::PopFont();
                        
                            ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                            ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
                            {
                                ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10.0f, 0.0f));
                                {
                                    ImGui::PushItemWidth(GUI::Build::GetAvailWidth());
                                    ImGui::Combo(std::string("##").append("Throw type").c_str(), &GInfo::throwType, ThrowTypes.data(), (int)ThrowTypes.size(), -1);
                                    ImGui::PopItemWidth();
                                }
                                ImGui::PopStyleVar(1);
                            }
                            ImGui::PopStyleColor(2);
                            ImGui::BeginGroup();
                            {
                                ImGui::Columns(2, "positions", false);
                                {
                                    ImGui::PushFont(Fonts::Label);
                                    ImGui::Text("Position");
                                    ImGui::PopFont();
                                    ImGui::Text("x: %.2f", Position.x);
                                    ImGui::Text("y: %.2f", Position.y);
                                    ImGui::Text("z: %.2f", Position.z);
                                }
                                ImGui::NextColumn();
                                {
                                    ImGui::PushFont(Fonts::Label);
                                    ImGui::Text("View Angle");
                                    ImGui::PopFont();
                                    ImGui::Text("x: %.2f", ViewAngle.x);
                                    ImGui::Text("y: %.2f", ViewAngle.y);
                                }
                                ImGui::Columns(1);
                            }
                            ImGui::EndGroup();
                        }
                        ImGui::PopStyleColor(2);
                    }
                    ImGui::EndChildFrame();
                    
                    GUI::Build::AddFrameLabel("Save Location");
                    ImGui::BeginChildFrame(2002, ImVec2(0.0f, 0.0f), ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_NoScrollbar);
                    {
                        ImGui::PushStyleColor(ImGuiCol_FrameBg, {0.0f, 0.0f, 0.0f, 0.3f});
                        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, {0.0f, 0.0f, 0.0f, 0.2f});
                        {
                            char locationInput[96] = "";
                            sprintf(locationInput, "%s", locationInputString.c_str());

                            if (ImGui::InputText(std::string("##").append("Location Name").c_str(), locationInput, sizeof(locationInput))) {
                                locationInputString = std::string(locationInput);
                            }

                            ImGui::NewLine();
                            if (ImGui::Button("Save Location")) {
                                if (locationInputString == "") {
                                    locationInputString = Functions::Basename(mapName) + "_" + std::to_string((int)(Position.x + Position.y + Position.z + ViewAngle.x + ViewAngle.y));
                                }
                                GrenadeHelper->SavePosition(locationInputString, ViewAngle, Position, GrenadeHelper->getGrenadeType(activeWeapon), GInfo::throwType, Functions::Basename(mapName));
                                CSettingsManager::Instance(GrenadeHelper->GetCurrentMapConfigName().c_str())->ReloadSettings();
                                
                                locationInputString = "";
                                GInfo::throwType = 0;
                                
                                GUI::MessagePopup::AddMessage("Position saved!", MESSAGE_TYPE_INFO, 2500);
                            }
                        }
                        ImGui::PopStyleColor(2);
                    }
                    ImGui::EndChildFrame();
                } else {
                    ImGui::TextWrapped("You don't hold a grenade.\n\nPlease select a grenade to save.");
                }
            }
        }
        ImGui::End();
    }
    ImGui::PopStyleVar(1);
}

void GUI::GrenadeHelperDev::DrawOutofgameNotice() {
    ImGui::TextWrapped("It seems like you are not in-game.\n\nPlease make sure your are in-game before using this developer window.");
}
