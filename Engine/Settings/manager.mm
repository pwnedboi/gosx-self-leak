/******************************************************/
/**                                                  **/
/**      Settings/manager.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"
#include "SDK/ItemDefinitionIndex.h"
#include "Engine/Weapons/manager.h"

bool*   FirstRun = nullptr;

bool    Options::synced = false;

bool    Options::Main::enabled = true;
key     Options::Main::menu_key = (int)ButtonCode_t::KEY_MINUS;
int     Options::Main::menu_key_mods = 0;
bool    Options::Main::screenshot_cleaner = true;

int     Options::Aimbot::toggle_key = 0;
bool    Options::Aimbot::enabled = true;
bool    Options::Aimbot::full_legit = false;
int     Options::Aimbot::bone_mode = 1;
int     Options::Aimbot::fixed_bone = 2;
key     Options::Aimbot::aim_key = (int)ButtonCode_t::MOUSE_LEFT;
bool    Options::Aimbot::smoothaim = true;
float   Options::Aimbot::smoothing_factor = 0.62f;
bool    Options::Aimbot::smooth_salting = true;
float   Options::Aimbot::smooth_salt_multiplier = 0.042f;
bool    Options::Aimbot::smooth_constant_speed = false;
bool    Options::Aimbot::fov_enabled = true;
float   Options::Aimbot::field_of_view = 3.25f;
bool    Options::Aimbot::recoil_control = true;
float   Options::Aimbot::recoil_level_x = 1.8f;
float   Options::Aimbot::recoil_level_y = 1.8f;
bool    Options::Aimbot::enemy_onground_check = true;
bool    Options::Aimbot::player_onground_check = true;
bool    Options::Aimbot::smokecheck = false;
bool    Options::Aimbot::flash_check = false;
bool    Options::Aimbot::delayed_shot = true;
bool    Options::Aimbot::silent_aim = false;

bool    Options::AimbotDefault::enabled = true;
bool    Options::AimbotDefault::full_legit = false;
int     Options::AimbotDefault::bone_mode = 1;
int     Options::AimbotDefault::fixed_bone = 2;
key     Options::AimbotDefault::aim_key = (int)ButtonCode_t::MOUSE_LEFT;
bool    Options::AimbotDefault::smoothaim = true;
float   Options::AimbotDefault::smoothing_factor = 0.62f;
bool    Options::AimbotDefault::smooth_salting = true;
float   Options::AimbotDefault::smooth_salt_multiplier = 0.042f;
bool    Options::AimbotDefault::smooth_constant_speed = false;
bool    Options::AimbotDefault::fov_enabled = true;
float   Options::AimbotDefault::field_of_view = 3.25f;
bool    Options::AimbotDefault::recoil_control = true;
float   Options::AimbotDefault::recoil_level_x = 1.8f;
float   Options::AimbotDefault::recoil_level_y = 1.8f;
bool    Options::AimbotDefault::enemy_onground_check = true;
bool    Options::AimbotDefault::player_onground_check = true;
bool    Options::AimbotDefault::smokecheck = false;
bool    Options::AimbotDefault::flash_check = false;
bool    Options::AimbotDefault::delayed_shot = true;
bool    Options::AimbotDefault::silent_aim = false;

bool    Options::Chams::enabled = true;
int     Options::Chams::chams_type = 1;
bool    Options::Chams::players = true;
bool    Options::Chams::show_dead_chams = true;
bool    Options::Chams::weapons = false;
bool    Options::Chams::arms = true;
int     Options::Chams::arms_type = 1;
bool    Options::Chams::enemies = true;
bool    Options::Chams::allies = true;
int     Options::Chams::deadchams_type = 1;
int     Options::Chams::weapon_type = 1;

bool    Options::Improvements::bunnyhop = false;
int     Options::Improvements::bhop_toggle_key = 0;
bool    Options::Improvements::triggerbot = false;
bool    Options::Improvements::trigger_delay = false;
float   Options::Improvements::trigger_delay_value = 2000.f;
key     Options::Improvements::trigger_key = (int)ButtonCode_t::MOUSE_4;
bool    Options::Improvements::trigger_autoactivation = false;
bool    Options::Improvements::trigger_filter_arms = true;
bool    Options::Improvements::trigger_filter_head = true;
bool    Options::Improvements::trigger_filter_legs = true;
bool    Options::Improvements::trigger_filter_chest = true;
bool    Options::Improvements::trigger_filter_stomach = true;
bool    Options::Improvements::skin_changer = true;
bool    Options::Improvements::fov_changer = true;
float   Options::Improvements::fov = 120.f;
bool    Options::Improvements::no_scope = false;
bool    Options::Improvements::no_flash = false;
float   Options::Improvements::maxflashalpha = 215.f;
bool    Options::Improvements::rankreveal = true;
bool    Options::Improvements::always_rcs = false;
float   Options::Improvements::always_rcs_level = 1.6f;
bool    Options::Improvements::no_sky = false;
Color   Options::Improvements::no_sky_color = Color(255, 0, 0, 255);
#ifdef GOSX_GLOVE_CHANGER
bool    Options::Improvements::glove_changer = true;
#endif
bool    Options::Improvements::bhop_legit = false;
int     Options::Improvements::bhop_minhops = 3;
int     Options::Improvements::bhop_maxhops = 7;
bool    Options::Improvements::gray_walls = false;
bool    Options::Improvements::aimware_lagcrashfix = true;
bool    Options::Improvements::night_mode = false;
bool    Options::Improvements::auto_accept = false;
#ifdef GOSX_STREAM_PROOF
bool    Options::Improvements::stream_proof = false;
#endif

bool    Options::ImprovementsDefault::triggerbot = false;
bool    Options::ImprovementsDefault::trigger_delay = false;
float   Options::ImprovementsDefault::trigger_delay_value = 2000.f;
key     Options::ImprovementsDefault::trigger_key = (int)ButtonCode_t::MOUSE_4;
bool    Options::ImprovementsDefault::trigger_autoactivation = false;
bool    Options::ImprovementsDefault::trigger_filter_head = true;
bool    Options::ImprovementsDefault::trigger_filter_chest = true;
bool    Options::ImprovementsDefault::trigger_filter_stomach = true;
bool    Options::ImprovementsDefault::trigger_filter_arms = true;
bool    Options::ImprovementsDefault::trigger_filter_legs = true;
bool    Options::ImprovementsDefault::always_rcs = false;

bool    Options::Glow::enabled = true;
bool    Options::Glow::glow_player = false;
bool    Options::Glow::glow_team = false;
bool    Options::Glow::glow_weapon = true;
bool    Options::Glow::glow_bomb = true;
Color   Options::Glow::color_dropped_bomb = Color(5, 238, 1, 255);
Color   Options::Glow::color_planted_bomb = Color(253, 160, 21, 255);
bool    Options::Glow::glow_extra = true;
Color   Options::Glow::color_extra = Color(119, 72, 254, 255);
bool    Options::Glow::glow_grenades = true;
Color   Options::Glow::color_grenades = Color(31, 253, 253, 255);

Color   Options::Colors::color_ct_visible = Color(1, 223, 10, 255);
Color   Options::Colors::color_ct = Color(26, 144, 253, 255);
Color   Options::Colors::color_t_visible = Color(253, 158, 16, 255);
Color   Options::Colors::color_t = Color(218, 1, 118, 255);
Color   Options::Colors::color_ct_visible_glow = Color(1, 223, 10, 255);
Color   Options::Colors::color_ct_glow = Color(26, 144, 253, 255);
Color   Options::Colors::color_t_visible_glow = Color(253, 158, 16, 255);
Color   Options::Colors::color_t_glow = Color(218, 1, 118, 255);
Color   Options::Colors::color_player_dead = Color(255, 255, 255, 255);
Color   Options::Colors::color_weapon = Color(249, 253, 52, 255);
Color   Options::Colors::color_weapon_visible = Color(123, 254, 222, 255);
Color   Options::Colors::color_arms_visible = Color(20, 0, 14, 255);
Color   Options::Colors::fov_circle = Color(255, 0, 0, 255);
Color   Options::Colors::nosky_color = Color(0, 0, 0, 255);
Color   Options::Colors::wallbang_indicator_color = Color(31, 253, 253, 255);

bool    Options::Extras::autopistol = false;
bool    Options::Extras::autoknife = false;
bool    Options::Extras::knifebot = true;
bool    Options::Extras::auto_cock_revolver = false;

bool    Options::ExtrasDefault::auto_cock_revolver = false;

bool    Options::Drawing::enabled = true;
bool    Options::Drawing::playeresp = false;
bool    Options::Drawing::fovcircle = true;
bool    Options::Drawing::smoke_esp = true;
bool    Options::Drawing::bone_esp = false;
Color   Options::Drawing::color_bone_esp = Color(255, 255, 255, 255);
bool    Options::Drawing::bone_esp_allies = false;
bool    Options::Drawing::crosshair = true;
bool    Options::Drawing::crosshair_outline = false;
int     Options::Drawing::recoil_crosshair = 0;
int     Options::Drawing::crosshair_width = 30;
int     Options::Drawing::crosshair_thickness = 1;
int     Options::Drawing::crosshair_gap = 6;
Color   Options::Drawing::crosshair_color = Color(253, 16, 16, 255);
bool    Options::Drawing::show_wallbang_indicator = false;
bool    Options::Drawing::draw_boundingbox = true;
bool    Options::Drawing::boundingbox_outline = false;
bool    Options::Drawing::entity_view_lines = false;

bool    Options::Drawing::weapon_esp = false;
bool    Options::Drawing::weapon_opt_boundingbox = true;
bool    Options::Drawing::weapon_opt_name = true;
bool    Options::Drawing::grenade_esp = false;
bool    Options::Drawing::grenade_opt_boundingbox = true;
bool    Options::Drawing::grenade_opt_name = true;
bool    Options::Drawing::defusekit_esp = false;
bool    Options::Drawing::defusekit_opt_boundingbox = true;
bool    Options::Drawing::defusekit_opt_name = true;
bool    Options::Drawing::defusekit_opt_distance = true;
bool    Options::Drawing::bomb_esp = false;
bool    Options::Drawing::bomb_opt_boundingbox = true;
bool    Options::Drawing::bomb_opt_name = true;
bool    Options::Drawing::bomb_opt_distance = true;

bool    Options::Drawing::draw_name = true;
bool    Options::Drawing::draw_healthbar = true;
bool    Options::Drawing::draw_healthnumber = true;
bool    Options::Drawing::draw_armorbar = true;
bool    Options::Drawing::draw_weapon_name = false;
bool    Options::Drawing::draw_distance = false;
bool    Options::Drawing::draw_c4 = false;
bool    Options::Drawing::draw_armor = false;
bool    Options::Drawing::draw_defkit = false;
bool    Options::Drawing::list_enabled = true;
float   Options::Drawing::list_x = 10.f;
float   Options::Drawing::list_y = 400.f;
int     Options::Drawing::bomb_timer = 0;
bool    Options::Drawing::sound_esp = false;
float   Options::Drawing::visible_duration = 1.000000;
bool    Options::Drawing::hit_marker = true;
bool    Options::Drawing::hit_marker_sound = true;
int     Options::Drawing::hit_marker_style = 0;
float   Options::Drawing::hit_marker_volume = 1.0f;

bool    Options::Radar::enabled = true;
int     Options::Radar::size = 180;
int     Options::Radar::pos_x = 10;
int     Options::Radar::pos_y = 50;
int     Options::Radar::zoom = 1;
int     Options::Radar::style = 1;

bool    Options::GrenadeHelper::enabled = true;
float   Options::GrenadeHelper::aim_distance = 50.f;
float   Options::GrenadeHelper::visible_distance = 250.f;
Color   Options::GrenadeHelper::color_grenade_he = Color(67, 254, 153, 255);
Color   Options::GrenadeHelper::color_grenade_smoke = Color(253, 161, 52, 255);
Color   Options::GrenadeHelper::color_grenade_flash = Color(1, 102, 253, 255);
Color   Options::GrenadeHelper::color_grenade_inc = Color(254, 72, 181, 255);
bool    Options::GrenadeHelper::aim_assist = true;
float   Options::GrenadeHelper::aim_fov = 1.78f;
bool    Options::GrenadeHelper::smoothaim = true;
bool    Options::GrenadeHelper::developer_mode = false;

#ifdef GOSX_BACKTRACKING
bool    Options::Backtracking::enabled = false;
int     Options::Backtracking::backtrack_ticks = 12;
int     Options::Backtracking::backtrack_hitbox = (int)ECSPlayerBones::head_0;
int     Options::Backtracking::backtrack_visual_type = 0;
bool    Options::Backtracking::visibility_check = true;
Color   Options::Backtracking::backtrack_color = Color(0, 0, 0, 255);
#endif

bool    Options::GrenadePrediction::enabled = false;
bool    Options::GrenadePrediction::last_path_stays = false;
float   Options::GrenadePrediction::path_width = 1.5f;
int     Options::GrenadePrediction::hit_size = 10;
Color   Options::GrenadePrediction::path_color = Color(210, 255, 0, 255);
Color   Options::GrenadePrediction::hit_color = Color(0, 123, 143, 255);

bool    Options::Config::auto_save = false;
bool    Options::Config::weapon_icons = true;

bool    Options::AntiCheat::faceit_safe = false;
bool    Options::AntiCheat::mouse_event_aim = false;
int     Options::AntiCheat::targeting = 0;

#ifdef GOSX_THIRDPERSON
bool    Options::Thirdperson::enabled = false;
float   Options::Thirdperson::distance = 100.0f;
int     Options::Thirdperson::toggle_key = 58;
#endif

#ifdef GOSX_RAGE_MODE
bool    Options::Rage::enabled = false;
bool    Options::Rage::engine_predict = true;
bool    Options::Rage::hit_scan = false;
bool    Options::Rage::auto_shoot = false;
bool    Options::Rage::auto_scope = false;
bool    Options::Rage::silent_aim = false;
float   Options::Rage::fov_multiplier = 1.f;
bool    Options::Rage::auto_wall = false;
float   Options::Rage::autowall_min_damage = 25.f;
bool    Options::Rage::anti_aim = false;
int     Options::Rage::antiaim_pitch = 0;
float   Options::Rage::antiaim_custom_pitch = 0.f;
int     Options::Rage::antiaim_yaw = 0;
float   Options::Rage::antiaim_custom_yaw = 0.f;
bool    Options::Rage::edge_aa = true;
bool    Options::Rage::resolver = false;
bool    Options::Rage::resolve_all = false;
int     Options::Rage::resolver_mode = 1;
int     Options::Rage::resolver_ticks = 30;
int     Options::Rage::resolver_modulo = 2;
bool    Options::Rage::autocrouch = false;
bool    Options::Rage::auto_stop = false;
bool    Options::Rage::anti_untrusted = true;
bool    Options::Rage::back_tracking = false;
bool    Options::Rage::hitchance = false;
int     Options::Rage::hitchance_shots = 30;
float   Options::Rage::hitchance_percent = 65.0f;

bool    Options::ClantagChanger::enabled = false;
std::string Options::ClantagChanger::tag = "";
bool    Options::ClantagChanger::animated = false;
int     Options::ClantagChanger::animation_type = 0;
bool    Options::ClantagChanger::hide_name = false;
float   Options::ClantagChanger::animation_speed = 0.5f;

bool    Options::RageMisc::fakelag = false;
int     Options::RageMisc::fakelag_ticks = 16;
bool    Options::RageMisc::fakelag_adaptive = true;
bool    Options::RageMisc::no_visual_recoil = false;
bool    Options::RageMisc::fake_walk = false;
int     Options::RageMisc::fake_walk_key = 0;
bool    Options::RageMisc::circle_strafe = false;
int     Options::RageMisc::circle_strafe_key = 0;

bool    Options::AutoStrafe::enabled = false;
int     Options::AutoStrafe::strafe_type = 0;
bool    Options::AutoStrafe::silent = false;
#endif

#ifdef GOSX_OVERWATCH_REVEAL
bool    Options::OverwatchReveal::enabled = true;
#endif

#ifdef GOSX_MOJAVE_SWITCH
ImVec4 ImGuiColors::ImGuiCol_Text                    = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_WindowBg                = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ChildWindowBg           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_PopupBg                 = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_BorderShadow            = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_FrameBg                 = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_FrameBgHovered          = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_FrameBgActive           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_TitleBg                 = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_TitleBgCollapsed        = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_TitleBgActive           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_MenuBarBg               = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ScrollbarBg             = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ScrollbarGrab           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ScrollbarGrabHovered    = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ScrollbarGrabActive     = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_CheckMark               = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_SliderGrab              = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_SliderGrabActive        = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_Button                  = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ButtonHovered           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ButtonActive            = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_Header                  = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_HeaderHovered           = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_HeaderActive            = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_Column                  = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_ResizeGrip              = {0.0f, 0.0f, 0.0f, 1.0f};
ImVec4 ImGuiColors::ImGuiCol_SelectableBg            = {0.0f, 0.0f, 0.0f, 1.0f};
#endif

std::map<std::string, std::shared_ptr<CSettingsManager>> CSettingsManager::instances = {};

CSettingsManager::CSettingsManager(std::string file) {
    std::string iniPath = Functions::GetSettingsDir();
    std::string settingsFile = iniPath.append(file);

    iniFile = strdup(settingsFile.c_str());
    ini.SetUnicode();
    ini.LoadFile(iniFile);
}

bool CSettingsManager::Install() {
    if (!FirstRun) {
        FirstRun = new bool();
    }
    
    std::string gosxDir = Functions::GetSettingsDir();
    std::string installedFile = gosxDir + "installed_latest";
    
    if (Functions::FileExist(installedFile)) {
        return true;
    }
    
    if (!Functions::DirWritable(gosxDir)) {
        return false;
    }
    
    Functions::RemoveFilesRec(gosxDir);

    std::ofstream menuIni(std::string(gosxDir).append("menu.ini").c_str());
    menuIni << "; This file is auto generated. Do not delete it." << std::endl;
    menuIni << "[Main]" << std::endl;
    menuIni << "settings_file = " << std::endl;
    menuIni.close();

    std::ofstream wepIni(std::string(gosxDir).append("skins.ini").c_str());
    wepIni << "; This file is auto generated. Do not delete it." << std::endl;
    wepIni.close();

    std::ofstream installedOutput(std::string(gosxDir).append("installed_latest").c_str());
    installedOutput << "; This file is auto generated. Do not delete it." << std::endl;
    installedOutput << "; We need it to determine if the hack was initialy installed." << std::endl;
    installedOutput << "; Deleting it will tell gosx to reset all your settings once injected." << std::endl;
    installedOutput.close();
    
    *FirstRun = true;
    
    return true;
}

void CSettingsManager::ReloadSettings() {
    ini.Reset();
    ini.LoadFile(iniFile);
}

void CSettingsManager::SyncSettings() {
    if (Options::synced) {
        return;
    }
    
    std::shared_ptr<CSettingsManager> currentConfig = CSettingsManager::Instance(currentConfigName);
    if (!currentConfig) {
        return;
    }

    Options::Main::enabled = currentConfig->GetSetting<bool>("Main", "enabled", Options::Main::enabled);
    Options::Main::menu_key = currentConfig->GetSetting<int>("Main", "menu_key", Options::Main::menu_key);
    Options::Main::screenshot_cleaner = currentConfig->GetSetting<bool>("Main", "screenshot_cleaner", Options::Main::screenshot_cleaner);

    Options::Aimbot::toggle_key = currentConfig->GetSetting<int>("Aimbot", "toggle_key", Options::Aimbot::toggle_key);
    Options::Aimbot::enabled = currentConfig->GetSetting<bool>("Aimbot", "enabled", Options::Aimbot::enabled);
    Options::AimbotDefault::enabled = Options::Aimbot::enabled;
    Options::Aimbot::full_legit = currentConfig->GetSetting<bool>("Aimbot", "full_legit", Options::Aimbot::full_legit);
    Options::AimbotDefault::full_legit = Options::Aimbot::full_legit;
    Options::Aimbot::bone_mode = currentConfig->GetSetting<int>("Aimbot", "bone_mode", Options::Aimbot::bone_mode);
    Options::AimbotDefault::bone_mode = Options::Aimbot::bone_mode;
    Options::Aimbot::fixed_bone = currentConfig->GetSetting<int>("Aimbot", "fixed_bone", Options::Aimbot::fixed_bone);
    Options::AimbotDefault::fixed_bone = Options::Aimbot::fixed_bone;
    Options::Aimbot::aim_key = currentConfig->GetSetting<int>("Aimbot", "aim_key", Options::Aimbot::aim_key);
    Options::AimbotDefault::aim_key = Options::Aimbot::aim_key;
    Options::Aimbot::smoothaim = currentConfig->GetSetting<bool>("Aimbot", "smoothaim", Options::Aimbot::smoothaim);
    Options::AimbotDefault::smoothaim = Options::Aimbot::smoothaim;
    Options::Aimbot::smoothing_factor = currentConfig->GetSetting<float>("Aimbot", "smoothing_factor", Options::Aimbot::smoothing_factor);
    Options::AimbotDefault::smoothing_factor = Options::Aimbot::smoothing_factor;
    Options::Aimbot::smooth_salting = currentConfig->GetSetting<bool>("Aimbot", "smooth_salting", Options::Aimbot::smooth_salting);
    Options::AimbotDefault::smooth_salting = Options::Aimbot::smooth_salting;
    Options::Aimbot::smooth_salt_multiplier = currentConfig->GetSetting<float>("Aimbot", "smooth_salt_multiplier", Options::Aimbot::smooth_salt_multiplier);
    Options::AimbotDefault::smooth_salt_multiplier = Options::Aimbot::smooth_salt_multiplier;
    Options::Aimbot::smooth_constant_speed = currentConfig->GetSetting<bool>("Aimbot", "smooth_constant_speed", Options::Aimbot::smooth_constant_speed);
    Options::AimbotDefault::smooth_constant_speed = Options::Aimbot::smooth_constant_speed;
    Options::Aimbot::fov_enabled = currentConfig->GetSetting<bool>("Aimbot", "fov_enabled", Options::Aimbot::fov_enabled);
    Options::AimbotDefault::fov_enabled = Options::Aimbot::fov_enabled;
    Options::Aimbot::field_of_view = currentConfig->GetSetting<float>("Aimbot", "field_of_view", Options::Aimbot::field_of_view);
    Options::AimbotDefault::field_of_view = Options::Aimbot::field_of_view;
    Options::Aimbot::recoil_control = currentConfig->GetSetting<bool>("Aimbot", "recoil_control", Options::Aimbot::recoil_control);
    Options::AimbotDefault::recoil_control = Options::Aimbot::recoil_control;
    Options::Aimbot::recoil_level_x = currentConfig->GetSetting<float>("Aimbot", "recoil_level_x", Options::Aimbot::recoil_level_x);
    Options::AimbotDefault::recoil_level_x = Options::Aimbot::recoil_level_x;
    Options::Aimbot::recoil_level_y = currentConfig->GetSetting<float>("Aimbot", "recoil_level_y", Options::Aimbot::recoil_level_y);
    Options::AimbotDefault::recoil_level_y = Options::Aimbot::recoil_level_y;
    Options::Aimbot::enemy_onground_check = currentConfig->GetSetting<bool>("Aimbot", "enemy_onground_check", Options::Aimbot::enemy_onground_check);
    Options::AimbotDefault::enemy_onground_check = Options::Aimbot::enemy_onground_check;
    Options::Aimbot::player_onground_check = currentConfig->GetSetting<bool>("Aimbot", "player_onground_check", Options::Aimbot::player_onground_check);
    Options::AimbotDefault::player_onground_check = Options::Aimbot::player_onground_check;
    Options::Aimbot::smokecheck = currentConfig->GetSetting<bool>("Aimbot", "smokecheck", Options::Aimbot::smokecheck);
    Options::AimbotDefault::smokecheck = Options::Aimbot::smokecheck;
    Options::Aimbot::flash_check = currentConfig->GetSetting<bool>("Aimbot", "flash_check", Options::Aimbot::flash_check);
    Options::AimbotDefault::flash_check = Options::Aimbot::flash_check;
    Options::Aimbot::delayed_shot = currentConfig->GetSetting<bool>("Aimbot", "delayed_shot", Options::Aimbot::delayed_shot);
    Options::AimbotDefault::delayed_shot = Options::Aimbot::delayed_shot;
    Options::Aimbot::silent_aim = currentConfig->GetSetting<bool>("Aimbot", "silent_aim", Options::Aimbot::silent_aim);
    Options::AimbotDefault::silent_aim = Options::Aimbot::silent_aim;

    Options::Chams::enabled = currentConfig->GetSetting<bool>("Chams", "enabled", Options::Chams::enabled);
    Options::Chams::chams_type = currentConfig->GetSetting<int>("Chams", "chams_type", Options::Chams::chams_type);
    Options::Chams::players = currentConfig->GetSetting<bool>("Chams", "players", Options::Chams::players);
    Options::Chams::show_dead_chams = currentConfig->GetSetting<bool>("Chams", "show_dead_chams", Options::Chams::show_dead_chams);
    Options::Chams::weapons = currentConfig->GetSetting<bool>("Chams", "weapons", Options::Chams::weapons);
    Options::Chams::arms = currentConfig->GetSetting<bool>("Chams", "arms", Options::Chams::arms);
    Options::Chams::arms_type = currentConfig->GetSetting<int>("Chams", "arms_type", Options::Chams::arms_type);
    Options::Chams::enemies = currentConfig->GetSetting<bool>("Chams", "enemies", Options::Chams::enemies);
    Options::Chams::allies = currentConfig->GetSetting<bool>("Chams", "allies", Options::Chams::allies);
    Options::Chams::weapon_type = currentConfig->GetSetting<int>("Chams", "weapon_type", Options::Chams::weapon_type);
    Options::Chams::deadchams_type = currentConfig->GetSetting<int>("Chams", "deadchams_type", Options::Chams::deadchams_type);

    Options::Improvements::bunnyhop = currentConfig->GetSetting<bool>("Improvements", "bunnyhop", Options::Improvements::bunnyhop);
    Options::Improvements::bhop_toggle_key = currentConfig->GetSetting<int>("Improvements", "bhop_toggle_key", Options::Improvements::bhop_toggle_key);
    Options::Improvements::triggerbot = currentConfig->GetSetting<bool>("Improvements", "triggerbot", Options::Improvements::triggerbot);
    Options::ImprovementsDefault::triggerbot = Options::Improvements::triggerbot;
    Options::Improvements::trigger_delay = currentConfig->GetSetting<bool>("Improvements", "trigger_delay", Options::Improvements::trigger_delay);
    Options::ImprovementsDefault::trigger_delay = Options::Improvements::trigger_delay;
    Options::Improvements::trigger_delay_value = currentConfig->GetSetting<float>("Improvements", "trigger_delay_value", Options::Improvements::trigger_delay_value);
    Options::ImprovementsDefault::trigger_delay_value = Options::Improvements::trigger_delay_value;
    Options::Improvements::trigger_key = currentConfig->GetSetting<int>("Improvements", "trigger_key", Options::Improvements::trigger_key);
    Options::ImprovementsDefault::trigger_key = Options::Improvements::trigger_key;
    Options::Improvements::trigger_autoactivation = currentConfig->GetSetting<bool>("Improvements", "trigger_autoactivation", Options::Improvements::trigger_autoactivation);
    Options::ImprovementsDefault::trigger_autoactivation = Options::Improvements::trigger_autoactivation;
    
    Options::Improvements::trigger_filter_arms = currentConfig->GetSetting<bool>("Improvements", "trigger_filter_arms", Options::Improvements::trigger_filter_arms);
    Options::ImprovementsDefault::trigger_filter_arms = Options::Improvements::trigger_filter_arms;
    Options::Improvements::trigger_filter_head = currentConfig->GetSetting<bool>("Improvements", "trigger_filter_head", Options::Improvements::trigger_filter_head);
    Options::ImprovementsDefault::trigger_filter_head = Options::Improvements::trigger_filter_head;
    Options::Improvements::trigger_filter_legs = currentConfig->GetSetting<bool>("Improvements", "trigger_filter_legs", Options::Improvements::trigger_filter_legs);
    Options::ImprovementsDefault::trigger_filter_legs = Options::Improvements::trigger_filter_legs;
    Options::Improvements::trigger_filter_stomach = currentConfig->GetSetting<bool>("Improvements", "trigger_filter_stomach", Options::Improvements::trigger_filter_stomach);
    Options::ImprovementsDefault::trigger_filter_stomach = Options::Improvements::trigger_filter_stomach;
    Options::Improvements::trigger_filter_chest = currentConfig->GetSetting<bool>("Improvements", "trigger_filter_chest", Options::Improvements::trigger_filter_chest);
    Options::ImprovementsDefault::trigger_filter_chest = Options::Improvements::trigger_filter_chest;
    
    Options::Improvements::skin_changer = currentConfig->GetSetting<bool>("Improvements", "skin_changer", Options::Improvements::skin_changer);
    Options::Improvements::fov_changer = currentConfig->GetSetting<bool>("Improvements", "fov_changer", Options::Improvements::fov_changer);
    Options::Improvements::fov = currentConfig->GetSetting<float>("Improvements", "fov", Options::Improvements::fov);
    Options::Improvements::no_scope = currentConfig->GetSetting<bool>("Improvements", "no_scope", Options::Improvements::no_scope);
    Options::Improvements::no_flash = currentConfig->GetSetting<bool>("Improvements", "no_flash", Options::Improvements::no_flash);
    Options::Improvements::maxflashalpha = currentConfig->GetSetting<float>("Improvements", "maxflashalpha", Options::Improvements::maxflashalpha);
    Options::Improvements::rankreveal = currentConfig->GetSetting<bool>("Improvements", "rankreveal", Options::Improvements::rankreveal);
    Options::Improvements::always_rcs = currentConfig->GetSetting<bool>("Improvements", "always_rcs", Options::Improvements::always_rcs);
    Options::ImprovementsDefault::always_rcs = Options::Improvements::always_rcs;
    Options::Improvements::always_rcs_level = currentConfig->GetSetting<float>("Improvements", "always_rcs_level", Options::Improvements::always_rcs_level);
    Options::Improvements::no_sky = currentConfig->GetSetting<bool>("Improvements", "no_sky", Options::Improvements::no_sky);
    Options::Improvements::auto_accept = currentConfig->GetSetting<bool>("Improvements", "auto_accept", Options::Improvements::auto_accept);
#ifdef GOSX_GLOVE_CHANGER
    Options::Improvements::glove_changer = currentConfig->GetSetting<bool>("Improvements", "glove_changer", Options::Improvements::glove_changer);
#endif
    Options::Improvements::bhop_legit = currentConfig->GetSetting<bool>("Improvements", "bhop_legit", Options::Improvements::bhop_legit);
    Options::Improvements::bhop_minhops = currentConfig->GetSetting<int>("Improvements", "bhop_minhops", Options::Improvements::bhop_minhops);
    Options::Improvements::bhop_maxhops = currentConfig->GetSetting<int>("Improvements", "bhop_maxhops", Options::Improvements::bhop_maxhops);
    Options::Improvements::gray_walls = currentConfig->GetSetting<bool>("Improvements", "gray_walls", Options::Improvements::gray_walls);
    Options::Improvements::aimware_lagcrashfix = currentConfig->GetSetting<bool>("Improvements", "aimware_lagcrashfix", Options::Improvements::aimware_lagcrashfix);
    Options::Improvements::night_mode = currentConfig->GetSetting<bool>("Improvements", "night_mode", Options::Improvements::night_mode);
#ifdef GOSX_STREAM_PROOF
    Options::Improvements::stream_proof = currentConfig->GetSetting<bool>("Improvements", "stream_proof", Options::Improvements::stream_proof);
#endif

    Options::Glow::enabled = currentConfig->GetSetting<bool>("Glow", "enabled", Options::Glow::enabled);
    Options::Glow::glow_player = currentConfig->GetSetting<bool>("Glow", "glow_player", Options::Glow::glow_player);
    Options::Glow::glow_team = currentConfig->GetSetting<bool>("Glow", "glow_team", Options::Glow::glow_team);
    Options::Glow::glow_weapon = currentConfig->GetSetting<bool>("Glow", "glow_weapon", Options::Glow::glow_weapon);
    Options::Glow::glow_bomb = currentConfig->GetSetting<bool>("Glow", "glow_bomb", Options::Glow::glow_bomb);
    Options::Glow::color_dropped_bomb = currentConfig->GetColorSetting("Glow", "color_dropped_bomb", Options::Glow::color_dropped_bomb.ToString());
    Options::Glow::color_planted_bomb = currentConfig->GetColorSetting("Glow", "color_planted_bomb", Options::Glow::color_planted_bomb.ToString());
    Options::Glow::glow_extra = currentConfig->GetSetting<bool>("Glow", "glow_extra", Options::Glow::glow_extra);
    Options::Glow::color_extra = currentConfig->GetColorSetting("Glow", "color_extra", Options::Glow::color_extra.ToString());
    Options::Glow::glow_grenades = currentConfig->GetSetting<bool>("Glow", "glow_grenades", Options::Glow::glow_grenades);
    Options::Glow::color_grenades = currentConfig->GetColorSetting("Glow", "color_grenades", Options::Glow::color_grenades.ToString());

    // Chams
    Options::Colors::color_ct_visible = currentConfig->GetColorSetting("Colors", "color_ct_visible", Options::Colors::color_ct_visible.ToString());
    Options::Colors::color_ct = currentConfig->GetColorSetting("Colors", "color_ct", Options::Colors::color_ct.ToString());
    Options::Colors::color_t_visible = currentConfig->GetColorSetting("Colors", "color_t_visible", Options::Colors::color_t_visible.ToString());
    Options::Colors::color_t = currentConfig->GetColorSetting("Colors", "color_t", Options::Colors::color_t.ToString());
    // Glow
    Options::Colors::color_ct_visible_glow = currentConfig->GetColorSetting("Colors", "color_ct_visible_glow", Options::Colors::color_ct_visible_glow.ToString());
    Options::Colors::color_ct_glow = currentConfig->GetColorSetting("Colors", "color_ct_glow", Options::Colors::color_ct_glow.ToString());
    Options::Colors::color_t_visible_glow = currentConfig->GetColorSetting("Colors", "color_t_visible_glow", Options::Colors::color_t_visible_glow.ToString());
    Options::Colors::color_t_glow = currentConfig->GetColorSetting("Colors", "color_t_glow", Options::Colors::color_t_glow.ToString());
    // Other
    Options::Colors::color_player_dead = currentConfig->GetColorSetting("Colors", "color_player_dead", Options::Colors::color_player_dead.ToString());
    Options::Colors::color_weapon = currentConfig->GetColorSetting("Colors", "color_weapon", Options::Colors::color_weapon.ToString());
    Options::Colors::color_weapon_visible = currentConfig->GetColorSetting("Colors", "color_weapon_visible", Options::Colors::color_weapon_visible.ToString());
    Options::Colors::color_arms_visible = currentConfig->GetColorSetting("Colors", "color_arms_visible", Options::Colors::color_arms_visible.ToString());
    Options::Colors::fov_circle = currentConfig->GetColorSetting("Colors", "fov_circle", Options::Colors::fov_circle.ToString());
    Options::Colors::nosky_color = currentConfig->GetColorSetting("Colors", "nosky_color", Options::Colors::nosky_color.ToString());
    Options::Colors::wallbang_indicator_color = currentConfig->GetColorSetting("Colors", "wallbang_indicator_color", Options::Colors::wallbang_indicator_color.ToString());

    Options::Extras::autopistol = currentConfig->GetSetting<bool>("Extras", "autopistol", Options::Extras::autopistol);
    Options::Extras::autoknife = currentConfig->GetSetting<bool>("Extras", "autoknife", Options::Extras::autoknife);
    Options::Extras::knifebot = currentConfig->GetSetting<bool>("Extras", "knifebot", Options::Extras::knifebot);
    Options::Extras::auto_cock_revolver = currentConfig->GetSetting<bool>("Extras", "auto_cock_revolver", Options::Extras::auto_cock_revolver);
    Options::ExtrasDefault::auto_cock_revolver = Options::Extras::auto_cock_revolver;

    Options::Drawing::enabled = currentConfig->GetSetting<bool>("Drawing", "enabled", Options::Drawing::enabled);
    Options::Drawing::playeresp = currentConfig->GetSetting<bool>("Drawing", "playeresp", Options::Drawing::playeresp);
    Options::Drawing::fovcircle = currentConfig->GetSetting<bool>("Drawing", "fovcircle", Options::Drawing::fovcircle);
    Options::Drawing::smoke_esp = currentConfig->GetSetting<bool>("Drawing", "smoke_esp", Options::Drawing::smoke_esp);
    Options::Drawing::bone_esp = currentConfig->GetSetting<bool>("Drawing", "bone_esp", Options::Drawing::bone_esp);
    Options::Drawing::color_bone_esp = currentConfig->GetColorSetting("Drawing", "color_bone_esp", Options::Drawing::color_bone_esp.ToString());
    Options::Drawing::bone_esp_allies = currentConfig->GetSetting<bool>("Drawing", "bone_esp_allies", Options::Drawing::bone_esp_allies);
    Options::Drawing::crosshair = currentConfig->GetSetting<bool>("Drawing", "crosshair", Options::Drawing::crosshair);
    Options::Drawing::crosshair_outline = currentConfig->GetSetting<bool>("Drawing", "crosshair_outline", Options::Drawing::crosshair_outline);
    Options::Drawing::recoil_crosshair = currentConfig->GetSetting<int>("Drawing", "recoil_crosshair", Options::Drawing::recoil_crosshair);
    Options::Drawing::crosshair_width = currentConfig->GetSetting<int>("Drawing", "crosshair_width", Options::Drawing::crosshair_width);
    Options::Drawing::crosshair_thickness = currentConfig->GetSetting<int>("Drawing", "crosshair_thickness", Options::Drawing::crosshair_thickness);
    Options::Drawing::crosshair_gap = currentConfig->GetSetting<int>("Drawing", "crosshair_gap", Options::Drawing::crosshair_gap);
    Options::Drawing::crosshair_color = currentConfig->GetColorSetting("Drawing", "crosshair_color", Options::Drawing::crosshair_color.ToString());
    Options::Drawing::show_wallbang_indicator = currentConfig->GetSetting<bool>("Drawing", "show_wallbang_indicator", Options::Drawing::show_wallbang_indicator);
    Options::Drawing::draw_boundingbox = currentConfig->GetSetting<bool>("Drawing", "draw_boundingbox", Options::Drawing::draw_boundingbox);
    Options::Drawing::boundingbox_outline = currentConfig->GetSetting<bool>("Drawing", "boundingbox_outline", Options::Drawing::boundingbox_outline);
    
    Options::Drawing::weapon_esp = currentConfig->GetSetting<bool>("Drawing", "weapon_esp", Options::Drawing::weapon_esp);
    Options::Drawing::weapon_opt_name = currentConfig->GetSetting<bool>("Drawing", "weapon_opt_name", Options::Drawing::weapon_opt_name);
    Options::Drawing::weapon_opt_boundingbox = currentConfig->GetSetting<bool>("Drawing", "weapon_opt_boundingbox", Options::Drawing::weapon_opt_boundingbox);
    Options::Drawing::grenade_esp = currentConfig->GetSetting<bool>("Drawing", "grenade_esp", Options::Drawing::grenade_esp);
    Options::Drawing::grenade_opt_name = currentConfig->GetSetting<bool>("Drawing", "grenade_opt_name", Options::Drawing::grenade_opt_name);
    Options::Drawing::grenade_opt_boundingbox = currentConfig->GetSetting<bool>("Drawing", "grenade_opt_boundingbox", Options::Drawing::grenade_opt_boundingbox);
    Options::Drawing::defusekit_esp = currentConfig->GetSetting<bool>("Drawing", "defusekit_esp", Options::Drawing::defusekit_esp);
    Options::Drawing::defusekit_opt_name = currentConfig->GetSetting<bool>("Drawing", "defusekit_opt_name", Options::Drawing::defusekit_opt_name);
    Options::Drawing::defusekit_opt_boundingbox = currentConfig->GetSetting<bool>("Drawing", "defusekit_opt_boundingbox", Options::Drawing::defusekit_opt_boundingbox);
    Options::Drawing::defusekit_opt_distance = currentConfig->GetSetting<bool>("Drawing", "defusekit_opt_boundingbox", Options::Drawing::defusekit_opt_distance);
    Options::Drawing::bomb_esp = currentConfig->GetSetting<bool>("Drawing", "weapon_esp", Options::Drawing::bomb_esp);
    Options::Drawing::bomb_opt_name = currentConfig->GetSetting<bool>("Drawing", "bomb_opt_name", Options::Drawing::bomb_opt_name);
    Options::Drawing::bomb_opt_boundingbox = currentConfig->GetSetting<bool>("Drawing", "bomb_opt_boundingbox", Options::Drawing::bomb_opt_boundingbox);
    Options::Drawing::bomb_opt_distance = currentConfig->GetSetting<bool>("Drawing", "bomb_opt_distance", Options::Drawing::bomb_opt_distance);
    
    Options::Drawing::draw_name = currentConfig->GetSetting<bool>("Drawing", "draw_name", Options::Drawing::draw_name);
    Options::Drawing::draw_healthbar = currentConfig->GetSetting<bool>("Drawing", "draw_healthbar", Options::Drawing::draw_healthbar);
    Options::Drawing::draw_healthnumber = currentConfig->GetSetting<bool>("Drawing", "draw_healthnumber", Options::Drawing::draw_healthnumber);
    Options::Drawing::draw_armorbar = currentConfig->GetSetting<bool>("Drawing", "draw_armorbar", Options::Drawing::draw_armorbar);
    Options::Drawing::draw_weapon_name = currentConfig->GetSetting<bool>("Drawing", "draw_weapon_name", Options::Drawing::draw_weapon_name);
    Options::Drawing::draw_distance = currentConfig->GetSetting<bool>("Drawing", "draw_distance", Options::Drawing::draw_distance);
    Options::Drawing::draw_c4 = currentConfig->GetSetting<bool>("Drawing", "draw_c4", Options::Drawing::draw_c4);
    Options::Drawing::draw_armor = currentConfig->GetSetting<bool>("Drawing", "draw_armor", Options::Drawing::draw_armor);
    Options::Drawing::draw_defkit = currentConfig->GetSetting<bool>("Drawing", "draw_defkit", Options::Drawing::draw_defkit);
    Options::Drawing::list_enabled = currentConfig->GetSetting<bool>("Drawing", "list_enabled", Options::Drawing::list_enabled);
    Options::Drawing::list_x = currentConfig->GetSetting<float>("Drawing", "list_x", Options::Drawing::list_x);
    Options::Drawing::list_y = currentConfig->GetSetting<float>("Drawing", "list_y", Options::Drawing::list_y);
    Options::Drawing::bomb_timer = currentConfig->GetSetting<int>("Drawing", "bomb_timer", Options::Drawing::bomb_timer);
    Options::Drawing::sound_esp = currentConfig->GetSetting<bool>("Drawing", "sound_esp", Options::Drawing::sound_esp);
    Options::Drawing::visible_duration = currentConfig->GetSetting<float>("Drawing", "visible_duration", Options::Drawing::visible_duration);
    Options::Drawing::hit_marker = currentConfig->GetSetting<bool>("Drawing", "hit_marker", Options::Drawing::hit_marker);
    Options::Drawing::hit_marker_sound = currentConfig->GetSetting<bool>("Drawing", "hit_marker_sound", Options::Drawing::hit_marker_sound);
    Options::Drawing::hit_marker_style = currentConfig->GetSetting<int>("Drawing", "hit_marker_style", Options::Drawing::hit_marker_style);
    Options::Drawing::hit_marker_volume = currentConfig->GetSetting<float>("Drawing", "hit_marker_volume", Options::Drawing::hit_marker_volume);
    Options::Drawing::entity_view_lines = currentConfig->GetSetting<bool>("Drawing", "entity_view_lines", Options::Drawing::entity_view_lines);

    Options::Radar::enabled = currentConfig->GetSetting<bool>("Radar", "enabled", Options::Radar::enabled);
    Options::Radar::size = currentConfig->GetSetting<int>("Radar", "size", Options::Radar::size);
    Options::Radar::zoom = currentConfig->GetSetting<int>("Radar", "zoom", Options::Radar::zoom);
    Options::Radar::pos_x = currentConfig->GetSetting<int>("Radar", "pos_x", Options::Radar::pos_x);
    Options::Radar::pos_y = currentConfig->GetSetting<int>("Radar", "pos_y", Options::Radar::pos_y);
    Options::Radar::style = currentConfig->GetSetting<int>("Radar", "style", Options::Radar::style);

    Options::GrenadeHelper::enabled = currentConfig->GetSetting<bool>("GrenadeHelper", "enabled", Options::GrenadeHelper::enabled);
    Options::GrenadeHelper::aim_distance = currentConfig->GetSetting<float>("GrenadeHelper", "aim_distance", Options::GrenadeHelper::aim_distance);
    Options::GrenadeHelper::visible_distance = currentConfig->GetSetting<float>("GrenadeHelper", "visible_distance", Options::GrenadeHelper::visible_distance);
    Options::GrenadeHelper::color_grenade_he = currentConfig->GetColorSetting("GrenadeHelper", "color_grenade_he", Options::GrenadeHelper::color_grenade_he.ToString());
    Options::GrenadeHelper::color_grenade_smoke = currentConfig->GetColorSetting("GrenadeHelper", "color_grenade_smoke", Options::GrenadeHelper::color_grenade_smoke.ToString());
    Options::GrenadeHelper::color_grenade_flash = currentConfig->GetColorSetting("GrenadeHelper", "color_grenade_flash", Options::GrenadeHelper::color_grenade_flash.ToString());
    Options::GrenadeHelper::color_grenade_inc = currentConfig->GetColorSetting("GrenadeHelper", "color_grenade_inc", Options::GrenadeHelper::color_grenade_inc.ToString());
    Options::GrenadeHelper::aim_assist = currentConfig->GetSetting<bool>("GrenadeHelper", "aim_assist", Options::GrenadeHelper::aim_assist);
    Options::GrenadeHelper::aim_fov = currentConfig->GetSetting<float>("GrenadeHelper", "aim_fov", Options::GrenadeHelper::aim_fov);
    Options::GrenadeHelper::smoothaim = currentConfig->GetSetting<bool>("GrenadeHelper", "smoothaim", Options::GrenadeHelper::smoothaim);
    Options::GrenadeHelper::developer_mode = currentConfig->GetSetting<bool>("GrenadeHelper", "developer_mode", Options::GrenadeHelper::developer_mode);

#ifdef GOSX_BACKTRACKING
    Options::Backtracking::enabled = currentConfig->GetSetting<bool>("Backtracking", "enabled", Options::Backtracking::enabled);
    Options::Backtracking::backtrack_visual_type = currentConfig->GetSetting<int>("Backtracking", "backtrack_visual_type", Options::Backtracking::backtrack_visual_type);
    Options::Backtracking::backtrack_ticks = currentConfig->GetSetting<int>("Backtracking", "backtrack_ticks", Options::Backtracking::backtrack_ticks);
    Options::Backtracking::backtrack_hitbox = currentConfig->GetSetting<int>("Backtracking", "backtrack_hitbox", Options::Backtracking::backtrack_hitbox);
    Options::Backtracking::visibility_check = currentConfig->GetSetting<bool>("Backtracking", "visibility_check", Options::Backtracking::visibility_check);
    Options::Backtracking::backtrack_color = currentConfig->GetColorSetting("Backtracking", "backtrack_color", Options::Backtracking::backtrack_color.ToString());
#endif

    Options::GrenadePrediction::enabled = currentConfig->GetSetting<bool>("GrenadePrediction", "enabled", Options::GrenadePrediction::enabled);
    Options::GrenadePrediction::last_path_stays = currentConfig->GetSetting<bool>("GrenadePrediction", "last_path_stays", Options::GrenadePrediction::last_path_stays);
    Options::GrenadePrediction::path_width = currentConfig->GetSetting<float>("GrenadePrediction", "path_width", Options::GrenadePrediction::path_width);
    Options::GrenadePrediction::hit_size = currentConfig->GetSetting<int>("GrenadePrediction", "hit_size", Options::GrenadePrediction::hit_size);
    Options::GrenadePrediction::path_color = currentConfig->GetColorSetting("GrenadePrediction", "path_color", Options::GrenadePrediction::path_color.ToString());
    Options::GrenadePrediction::hit_color = currentConfig->GetColorSetting("GrenadePrediction", "hit_color", Options::GrenadePrediction::hit_color.ToString());
    
    Options::Config::auto_save = currentConfig->GetSetting<bool>("Config", "auto_save", Options::Config::auto_save);
    Options::Config::weapon_icons = currentConfig->GetSetting<bool>("Config", "weapon_icons", Options::Config::weapon_icons);
    
    Options::AntiCheat::faceit_safe = currentConfig->GetSetting<bool>("AntiCheat", "faceit_safe", Options::AntiCheat::faceit_safe);
    Options::AntiCheat::mouse_event_aim = currentConfig->GetSetting<bool>("AntiCheat", "mouse_event_aim", Options::AntiCheat::mouse_event_aim);
    Options::AntiCheat::targeting = currentConfig->GetSetting<int>("AntiCheat", "targeting", Options::AntiCheat::targeting);
 
#ifdef GOSX_THIRDPERSON
    Options::Thirdperson::enabled = currentConfig->GetSetting<bool>("Thirdperson", "enabled", Options::Thirdperson::enabled);
    Options::Thirdperson::distance = currentConfig->GetSetting<float>("Thirdperson", "distance", Options::Thirdperson::distance);
    Options::Thirdperson::toggle_key = currentConfig->GetSetting<int>("Thirdperson", "toggle_key", Options::Thirdperson::toggle_key);
#endif
    
#ifdef GOSX_RAGE_MODE
    Options::Rage::enabled = currentConfig->GetSetting<bool>("Rage", "enabled", Options::Rage::enabled);
    Options::Rage::engine_predict = currentConfig->GetSetting<bool>("Rage", "engine_predict", Options::Rage::engine_predict);
    Options::Rage::hit_scan = currentConfig->GetSetting<bool>("Rage", "hit_scan", Options::Rage::hit_scan);
    Options::Rage::auto_shoot = currentConfig->GetSetting<bool>("Rage", "auto_shoot", Options::Rage::auto_shoot);
    Options::Rage::auto_scope = currentConfig->GetSetting<bool>("Rage", "auto_scope", Options::Rage::auto_scope);
    Options::Rage::silent_aim = currentConfig->GetSetting<bool>("Rage", "silent_aim", Options::Rage::silent_aim);
    Options::Rage::fov_multiplier = currentConfig->GetSetting<float>("Rage", "fov_multiplier", Options::Rage::fov_multiplier);
    Options::Rage::auto_wall = currentConfig->GetSetting<bool>("Rage", "auto_wall", Options::Rage::auto_wall);
    Options::Rage::autowall_min_damage = currentConfig->GetSetting<float>("Rage", "autowall_min_damage", Options::Rage::autowall_min_damage);
    Options::Rage::anti_aim = currentConfig->GetSetting<bool>("Rage", "anti_aim", Options::Rage::anti_aim);
    Options::Rage::antiaim_pitch = currentConfig->GetSetting<int>("Rage", "antiaim_pitch", Options::Rage::antiaim_pitch);
    Options::Rage::antiaim_custom_pitch = currentConfig->GetSetting<float>("Rage", "antiaim_custom_pitch", Options::Rage::antiaim_custom_pitch);
    Options::Rage::antiaim_yaw = currentConfig->GetSetting<int>("Rage", "antiaim_yaw", Options::Rage::antiaim_yaw);
    Options::Rage::antiaim_custom_yaw = currentConfig->GetSetting<float>("Rage", "antiaim_custom_yaw", Options::Rage::antiaim_custom_yaw);
    Options::Rage::resolver = currentConfig->GetSetting<bool>("Rage", "resolver", Options::Rage::resolver);
    Options::Rage::resolve_all = currentConfig->GetSetting<bool>("Rage", "resolve_all", Options::Rage::resolve_all);
    Options::Rage::resolver_mode = currentConfig->GetSetting<int>("Rage", "resolver_mode", Options::Rage::resolver_mode);
    Options::Rage::resolver_ticks = currentConfig->GetSetting<int>("Rage", "resolver_ticks", Options::Rage::resolver_ticks);
    Options::Rage::resolver_modulo = currentConfig->GetSetting<int>("Rage", "resolver_modulo", Options::Rage::resolver_modulo);
    Options::Rage::autocrouch = currentConfig->GetSetting<bool>("Rage", "autocrouch", Options::Rage::autocrouch);
    Options::Rage::auto_stop = currentConfig->GetSetting<bool>("Rage", "auto_stop", Options::Rage::auto_stop);
    Options::Rage::anti_untrusted = currentConfig->GetSetting<bool>("Rage", "anti_untrusted", Options::Rage::anti_untrusted);
    Options::Rage::edge_aa = currentConfig->GetSetting<bool>("Rage", "edge_aa", Options::Rage::edge_aa);
    Options::Rage::hitchance_percent = currentConfig->GetSetting<float>("Rage", "hitchance_percent", Options::Rage::hitchance_percent);
    Options::Rage::hitchance_shots = currentConfig->GetSetting<int>("Rage", "hitchance_shots", Options::Rage::hitchance_shots);
    Options::Rage::hitchance = currentConfig->GetSetting<bool>("Rage", "hitchance", Options::Rage::hitchance);
    
    Options::ClantagChanger::enabled = currentConfig->GetSetting<bool>("ClantagChanger", "enabled", Options::ClantagChanger::enabled);
    Options::ClantagChanger::tag = currentConfig->GetStringSetting("ClantagChanger", "tag", Options::ClantagChanger::tag);
    Options::ClantagChanger::animated = currentConfig->GetSetting<bool>("ClantagChanger", "animated", Options::ClantagChanger::animated);
    Options::ClantagChanger::animation_type = currentConfig->GetSetting<int>("ClantagChanger", "animation_type", Options::ClantagChanger::animation_type);
    Options::ClantagChanger::hide_name = currentConfig->GetSetting<bool>("ClantagChanger", "hide_name", Options::ClantagChanger::hide_name);
    Options::ClantagChanger::animation_speed = currentConfig->GetSetting<float>("ClantagChanger", "animation_speed", Options::ClantagChanger::animation_speed);
    
    Options::RageMisc::fakelag = currentConfig->GetSetting<bool>("RageMisc", "fakelag", Options::RageMisc::fakelag);
    Options::RageMisc::fakelag_ticks = currentConfig->GetSetting<float>("RageMisc", "fakelag_ticks", Options::RageMisc::fakelag_ticks);
    Options::RageMisc::fakelag_adaptive = currentConfig->GetSetting<bool>("RageMisc", "fakelag_adaptive", Options::RageMisc::fakelag_adaptive);
    Options::RageMisc::no_visual_recoil = currentConfig->GetSetting<bool>("RageMisc", "no_visual_recoil", Options::RageMisc::no_visual_recoil);
    Options::RageMisc::fake_walk = currentConfig->GetSetting<bool>("RageMisc", "fake_walk", Options::RageMisc::fake_walk);
    Options::RageMisc::fake_walk_key = currentConfig->GetSetting<int>("RageMisc", "fake_walk_key", Options::RageMisc::fake_walk_key);
    Options::RageMisc::circle_strafe = currentConfig->GetSetting<bool>("RageMisc", "circle_strafe", Options::RageMisc::circle_strafe);
    Options::RageMisc::circle_strafe_key = currentConfig->GetSetting<int>("RageMisc", "circle_strafe_key", Options::RageMisc::circle_strafe_key);
    
    Options::AutoStrafe::enabled = currentConfig->GetSetting<bool>("AutoStrafe", "enabled", Options::AutoStrafe::enabled);
    Options::AutoStrafe::strafe_type = currentConfig->GetSetting<int>("AutoStrafe", "strafe_type", Options::AutoStrafe::strafe_type);
    Options::AutoStrafe::silent = currentConfig->GetSetting<bool>("AutoStrafe", "silent", Options::AutoStrafe::silent);
#endif
    
#ifdef GOSX_OVERWATCH_REVEAL
    Options::OverwatchReveal::enabled = currentConfig->GetSetting<bool>("OverwatchReveal", "enabled", Options::OverwatchReveal::enabled);
#endif
    
    Options::synced = true;
}

bool CSettingsManager::HasWeaponBasedConfig(int index, std::string sectionName) {
    return HasWeaponBasedConfig(GetEntityNameForIndex(index), sectionName);
}

bool CSettingsManager::HasWeaponBasedConfig(CSWeaponType type, std::string sectionName) {
    return HasWeaponBasedConfig(GetEntityNameForWeaponType(type), sectionName);
}

bool CSettingsManager::HasWeaponBasedConfig(std::string entityName, std::string sectionName) {
    CSimpleIniA::TNamesDepend sections;
    CSettingsManager::Instance(currentConfigName)->GetAllSections(sections);
    sections.sort(CSimpleIniA::Entry::LoadOrder());
    if (sectionName != "") {
        entityName = entityName + "_" + sectionName;
    }
    
    for (auto sect : sections) {
        if (std::string(sect.pItem).find(entityName) != std::string::npos) {
            return true;
        }
    }
    
    return false;
}

bool CSettingsManager::DeleteWeaponBasedConfig(int index, std::string sectionName) {
    return DeleteWeaponBasedConfig(GetEntityNameForIndex(index), sectionName);
}

bool CSettingsManager::DeleteWeaponBasedConfig(std::string entityName, std::string sectionName) {
    CSimpleIniA::TNamesDepend sections;
    std::shared_ptr<CSettingsManager> config = CSettingsManager::Instance(currentConfigName);
    if (!config) {
        return false;
    }
    config->GetAllSections(sections);
    sections.sort(CSimpleIniA::Entry::LoadOrder());
    if (sectionName != "") {
        entityName = entityName + "_" + sectionName;
    }
    
    for (auto sect : sections) {
        if (std::string(sect.pItem).find(entityName) != std::string::npos) {
            return config->DeleteSection(sect.pItem);
        }
    }
    
    return false;
}

bool CSettingsManager::DeleteWeaponBasedConfig(CSWeaponType type, std::string sectionName) {
    return DeleteWeaponBasedConfig(GetEntityNameForWeaponType(type), sectionName);
}

void CSettingsManager::UpdateConfigForWeapon(std::string entityName, CSWeaponType type) {
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
        
        if (!strcmp(entityName.c_str(), ItemDefinitionIndex.at(index).entity_name)) {
            UpdateConfigForWeapon(index, type);
            break;
        }
    }
}

void CSettingsManager::UpdateConfigForWeapon(int index, CSWeaponType type) {
    if (index == weapon_none) {
        return;
    }
    
    std::shared_ptr<CSettingsManager> weaponConfig = CSettingsManager::Instance(currentConfigName);
    if (!weaponConfig) {
        return;
    }
    
    std::string AimbotSect = GetConfigSectionForWeapon(index, "Aimbot");
    std::string TypeAimbotSect = GetEntityNameForWeaponType(type, "Aimbot");
    Options::Aimbot::enabled = weaponConfig->GetSetting<bool>(TypeAimbotSect, "enabled", Options::AimbotDefault::enabled);
    Options::Aimbot::enabled = weaponConfig->GetSetting<bool>(AimbotSect, "enabled", Options::Aimbot::enabled);
    Options::Aimbot::full_legit = weaponConfig->GetSetting<bool>(TypeAimbotSect, "full_legit", Options::AimbotDefault::full_legit);
    Options::Aimbot::full_legit = weaponConfig->GetSetting<bool>(AimbotSect, "full_legit", Options::Aimbot::full_legit);
    Options::Aimbot::bone_mode = weaponConfig->GetSetting<int>(TypeAimbotSect, "bone_mode", Options::AimbotDefault::bone_mode);
    Options::Aimbot::bone_mode = weaponConfig->GetSetting<int>(AimbotSect, "bone_mode", Options::Aimbot::bone_mode);
    Options::Aimbot::fixed_bone = weaponConfig->GetSetting<int>(TypeAimbotSect, "fixed_bone", Options::AimbotDefault::fixed_bone);
    Options::Aimbot::fixed_bone = weaponConfig->GetSetting<int>(AimbotSect, "fixed_bone", Options::Aimbot::fixed_bone);
    Options::Aimbot::aim_key = weaponConfig->GetSetting<int>(TypeAimbotSect, "aim_key", Options::AimbotDefault::aim_key);
    Options::Aimbot::aim_key = weaponConfig->GetSetting<int>(AimbotSect, "aim_key", Options::Aimbot::aim_key);
    Options::Aimbot::smoothaim = weaponConfig->GetSetting<bool>(TypeAimbotSect, "smoothaim", Options::AimbotDefault::smoothaim);
    Options::Aimbot::smoothaim = weaponConfig->GetSetting<bool>(AimbotSect, "smoothaim", Options::Aimbot::smoothaim);
    Options::Aimbot::smoothing_factor = weaponConfig->GetSetting<float>(TypeAimbotSect, "smoothing_factor", Options::AimbotDefault::smoothing_factor);
    Options::Aimbot::smoothing_factor = weaponConfig->GetSetting<float>(AimbotSect, "smoothing_factor", Options::Aimbot::smoothing_factor);
    Options::Aimbot::smooth_salting = weaponConfig->GetSetting<bool>(TypeAimbotSect, "smooth_salting", Options::AimbotDefault::smooth_salting);
    Options::Aimbot::smooth_salting = weaponConfig->GetSetting<bool>(AimbotSect, "smooth_salting", Options::Aimbot::smooth_salting);
    Options::Aimbot::smooth_salt_multiplier = weaponConfig->GetSetting<float>(TypeAimbotSect, "smooth_salt_multiplier", Options::AimbotDefault::smooth_salt_multiplier);
    Options::Aimbot::smooth_salt_multiplier = weaponConfig->GetSetting<float>(AimbotSect, "smooth_salt_multiplier", Options::Aimbot::smooth_salt_multiplier);
    Options::Aimbot::smooth_constant_speed = weaponConfig->GetSetting<bool>(TypeAimbotSect, "smooth_constant_speed", Options::AimbotDefault::smooth_constant_speed);
    Options::Aimbot::smooth_constant_speed = weaponConfig->GetSetting<bool>(AimbotSect, "smooth_constant_speed", Options::Aimbot::smooth_constant_speed);
    Options::Aimbot::fov_enabled = weaponConfig->GetSetting<bool>(TypeAimbotSect, "fov_enabled", Options::AimbotDefault::fov_enabled);
    Options::Aimbot::fov_enabled = weaponConfig->GetSetting<bool>(AimbotSect, "fov_enabled", Options::Aimbot::fov_enabled);
    Options::Aimbot::field_of_view = weaponConfig->GetSetting<float>(TypeAimbotSect, "field_of_view", Options::AimbotDefault::field_of_view);
    Options::Aimbot::field_of_view = weaponConfig->GetSetting<float>(AimbotSect, "field_of_view", Options::Aimbot::field_of_view);
    Options::Aimbot::recoil_control = weaponConfig->GetSetting<bool>(TypeAimbotSect, "recoil_control", Options::AimbotDefault::recoil_control);
    Options::Aimbot::recoil_control = weaponConfig->GetSetting<bool>(AimbotSect, "recoil_control", Options::Aimbot::recoil_control);
    Options::Aimbot::recoil_level_x = weaponConfig->GetSetting<float>(TypeAimbotSect, "recoil_level_x", Options::AimbotDefault::recoil_level_x);
    Options::Aimbot::recoil_level_x = weaponConfig->GetSetting<float>(AimbotSect, "recoil_level_x", Options::Aimbot::recoil_level_x);
    Options::Aimbot::recoil_level_y = weaponConfig->GetSetting<float>(TypeAimbotSect, "recoil_level_y", Options::AimbotDefault::recoil_level_y);
    Options::Aimbot::recoil_level_y = weaponConfig->GetSetting<float>(AimbotSect, "recoil_level_y", Options::Aimbot::recoil_level_y);
    Options::Aimbot::enemy_onground_check = weaponConfig->GetSetting<bool>(TypeAimbotSect, "enemy_onground_check", Options::AimbotDefault::enemy_onground_check);
    Options::Aimbot::enemy_onground_check = weaponConfig->GetSetting<bool>(AimbotSect, "enemy_onground_check", Options::Aimbot::enemy_onground_check);
    Options::Aimbot::player_onground_check = weaponConfig->GetSetting<bool>(TypeAimbotSect, "player_onground_check", Options::AimbotDefault::player_onground_check);
    Options::Aimbot::player_onground_check = weaponConfig->GetSetting<bool>(AimbotSect, "player_onground_check", Options::Aimbot::player_onground_check);
    Options::Aimbot::smokecheck = weaponConfig->GetSetting<bool>(TypeAimbotSect, "smokecheck", Options::AimbotDefault::smokecheck);
    Options::Aimbot::smokecheck = weaponConfig->GetSetting<bool>(AimbotSect, "smokecheck", Options::Aimbot::smokecheck);
    Options::Aimbot::flash_check = weaponConfig->GetSetting<bool>(TypeAimbotSect, "flash_check", Options::AimbotDefault::flash_check);
    Options::Aimbot::flash_check = weaponConfig->GetSetting<bool>(AimbotSect, "flash_check", Options::Aimbot::flash_check);
    Options::Aimbot::delayed_shot = weaponConfig->GetSetting<bool>(TypeAimbotSect, "delayed_shot", Options::AimbotDefault::delayed_shot);
    Options::Aimbot::delayed_shot = weaponConfig->GetSetting<bool>(AimbotSect, "delayed_shot", Options::Aimbot::delayed_shot);
    Options::Aimbot::silent_aim = weaponConfig->GetSetting<bool>(TypeAimbotSect, "silent_aim", Options::AimbotDefault::silent_aim);
    Options::Aimbot::silent_aim = weaponConfig->GetSetting<bool>(AimbotSect, "silent_aim", Options::Aimbot::silent_aim);
    
    std::string ImprovementsSect = GetConfigSectionForWeapon(index, "Improvements");
    std::string TypeImprovementsSect = GetEntityNameForWeaponType(type, "Improvements");
    Options::Improvements::triggerbot = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "triggerbot", Options::ImprovementsDefault::triggerbot);
    Options::Improvements::triggerbot = weaponConfig->GetSetting<bool>(ImprovementsSect, "triggerbot", Options::Improvements::triggerbot);
    Options::Improvements::trigger_delay = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_delay", Options::ImprovementsDefault::trigger_delay);
    Options::Improvements::trigger_delay = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_delay", Options::Improvements::trigger_delay);
    Options::Improvements::trigger_delay_value = weaponConfig->GetSetting<float>(TypeImprovementsSect, "trigger_delay_value", Options::ImprovementsDefault::trigger_delay_value);
    Options::Improvements::trigger_delay_value = weaponConfig->GetSetting<float>(ImprovementsSect, "trigger_delay_value", Options::Improvements::trigger_delay_value);
    Options::Improvements::trigger_key = weaponConfig->GetSetting<int>(TypeImprovementsSect, "trigger_key", Options::ImprovementsDefault::trigger_key);
    Options::Improvements::trigger_key = weaponConfig->GetSetting<int>(ImprovementsSect, "trigger_key", Options::Improvements::trigger_key);
    Options::Improvements::trigger_autoactivation = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_autoactivation", Options::ImprovementsDefault::trigger_autoactivation);
    Options::Improvements::trigger_autoactivation = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_autoactivation", Options::Improvements::trigger_autoactivation);
    Options::Improvements::always_rcs = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "always_rcs", Options::ImprovementsDefault::always_rcs);
    Options::Improvements::always_rcs = weaponConfig->GetSetting<bool>(ImprovementsSect, "always_rcs", Options::Improvements::always_rcs);
    Options::Improvements::trigger_filter_arms = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_filter_arms", Options::ImprovementsDefault::trigger_filter_arms);
    Options::Improvements::trigger_filter_arms = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_filter_arms", Options::Improvements::trigger_filter_arms);
    Options::Improvements::trigger_filter_head = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_filter_head", Options::ImprovementsDefault::trigger_filter_head);
    Options::Improvements::trigger_filter_head = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_filter_head", Options::Improvements::trigger_filter_head);
    Options::Improvements::trigger_filter_legs = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_filter_legs", Options::ImprovementsDefault::trigger_filter_legs);
    Options::Improvements::trigger_filter_legs = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_filter_legs", Options::Improvements::trigger_filter_legs);
    Options::Improvements::trigger_filter_stomach = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_filter_stomach", Options::ImprovementsDefault::trigger_filter_stomach);
    Options::Improvements::trigger_filter_stomach = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_filter_stomach", Options::Improvements::trigger_filter_stomach);
    Options::Improvements::trigger_filter_chest = weaponConfig->GetSetting<bool>(TypeImprovementsSect, "trigger_filter_chest", Options::ImprovementsDefault::trigger_filter_chest);
    Options::Improvements::trigger_filter_chest = weaponConfig->GetSetting<bool>(ImprovementsSect, "trigger_filter_chest", Options::Improvements::trigger_filter_chest);
    
    std::string ExtrasSect = GetConfigSectionForWeapon(index, "Extras");
    std::string TypeExtrasSect = GetEntityNameForWeaponType(type, "Extras");
    Options::Extras::auto_cock_revolver = weaponConfig->GetSetting<bool>(TypeExtrasSect, "auto_cock_revolver", Options::ExtrasDefault::auto_cock_revolver);
    Options::Extras::auto_cock_revolver = weaponConfig->GetSetting<bool>(ExtrasSect, "auto_cock_revolver", Options::Extras::auto_cock_revolver);
};

std::string CSettingsManager::GetConfigSectionForWeapon(int index, std::string sectionName) {
    std::string entityName = GetEntityNameForIndex(index);
    
    return entityName + "_" + sectionName;
}

std::string CSettingsManager::GetEntityNameForIndex(int index) {
    std::string weaponEntity;
    if (ItemDefinitionIndex.find(index) != ItemDefinitionIndex.end()) {
        Item_t weaponEntityItem = ItemDefinitionIndex.at(index);
        return weaponEntity.append(weaponEntityItem.entity_name);
    }
    
    return weaponEntity.append("weapon_all");
}

std::string CSettingsManager::GetEntityNameForWeaponType(CSWeaponType type, std::string extraString) {
    std::string weaponType = "";
    switch (type) {
        case CSWeaponType::WEAPONTYPE_PISTOL:
            weaponType = "weapontype_pistol";
            break;
        case CSWeaponType::WEAPONTYPE_SHOTGUN:
            weaponType = "weapontype_shotgun";
            break;
        case CSWeaponType::WEAPONTYPE_SUBMACHINEGUN:
            weaponType = "weapontype_smg";
            break;
        case CSWeaponType::WEAPONTYPE_RIFLE:
            weaponType = "weapontype_rifle";
            break;
        case CSWeaponType::WEAPONTYPE_SNIPER_RIFLE:
            weaponType = "weapontype_sniper";
            break;
        case CSWeaponType::WEAPONTYPE_MACHINEGUN:
            weaponType = "weapontype_heavy";
            break;
        default:
            weaponType = "weapontype_none";
            break;
    }
    
    if (extraString != "") {
        weaponType.append("_" + extraString);
    }
    
    return weaponType;
}

void CSettingsManager::SetBoolValue(std::string section, std::string key, bool value) {
    if (GUI::IsVisible || IsInit) {
        ini.SetBoolValue(section.c_str(), key.c_str(), (bool)value);
        
        if (Options::Config::auto_save) {
            SaveSettings();
        }
    }
}

void CSettingsManager::SetDoubleValue(std::string section, std::string key, float value) {
    if (GUI::IsVisible || IsInit) {
        ini.SetDoubleValue(section.c_str(), key.c_str(), value);
        
        if (Options::Config::auto_save) {
            SaveSettings();
        }
    }
}

void CSettingsManager::SetIntValue(std::string section, std::string key, int value) {
    if (GUI::IsVisible || IsInit) {
        ini.SetLongValue(section.c_str(), key.c_str(), (long)value);
        
        if (Options::Config::auto_save || IsInit) {
            SaveSettings();
        }
    }
}

void CSettingsManager::SetValue(std::string section, std::string key, std::string value) {
    if (GUI::IsVisible || IsInit) {
        ini.SetValue(section.c_str(), key.c_str(), value.c_str());
        
        if (Options::Config::auto_save) {
            SaveSettings();
        }
    }
}

std::string CSettingsManager::GetValue(std::string section, std::string key) {
    return std::string(ini.GetValue(section.c_str(), key.c_str()));
}

void CSettingsManager::SetColorValue(std::string section, std::string key, Color value) {
    char color[30];
    sprintf(color, "%i,%i,%i,%i", value.r(), value.g(), value.b(), value.a());

    SetValue(section.c_str(), key.c_str(), color);
    
    if (Options::Config::auto_save) {
        SaveSettings();
    }
}

void CSettingsManager::SaveSettings(
    bool fromGameEvent,
    bool buttonClicked,
    std::string customPath,
    bool forceSave
) {
    if (!forceSave) {
        if (!GUI::IsVisible && !fromGameEvent) {
            return;
        }
    }

    Functions::CreateDir(Functions::GetSettingsDir() + "configs/");
    
    if (customPath != "") {
        ini.SaveFile(std::string(Functions::GetSettingsDir() + customPath).c_str());
    } else {
        ini.SaveFile(iniFile);
    }
}

std::string CSettingsManager::GetStringSetting(std::string section, std::string key, std::string defaultValue) {
    return ini.GetValue(section.c_str(), key.c_str(), defaultValue.c_str());
}

Color CSettingsManager::GetColorSetting(std::string section, std::string key, std::string defaultValue) {
    std::string value = GetStringSetting(section, key, defaultValue);
    if (value == "") {
        return Color(0, 0, 0);
    }

    std::vector<std::string> colors = Functions::split<std::string>(value, ",");
    return Color(
        atof(colors[0].c_str()),
        atof(colors[1].c_str()),
        atof(colors[2].c_str()),
        atof(colors[3].c_str())
    );
}

bool CSettingsManager::HasSkinConfiguration(std::string section, int team) {
    CSimpleIniA::TNamesDepend sections;
    CSettingsManager::Instance("skins.ini")->GetAllSections(sections);
    sections.sort(CSimpleIniA::Entry::LoadOrder());
    
    if (section == "weapon_knife" || section == "weapon_knife_t" || section == "glove_t" || section == "glove_ct") {
        team = TEAM_NONE;
    }

    bool HasConfig = false;
    std::string teamSection = section;
    if (team == TEAM_T || team == TEAM_CT) {
        teamSection.append(team == TEAM_T ? "_t" : "_ct");
        
        for (auto sect : sections) {
            if (teamSection == std::string(sect.pItem)) {
                HasConfig = true;
                
                break;
            }
        }
    }
    
    if (!HasConfig) {
        for (auto sect : sections) {
            if (section == std::string(sect.pItem)) {
                HasConfig = true;
                
                break;
            }
        }
    }

    return HasConfig;
}

EconomyItem_t CSettingsManager::GetSkinConfiguration(std::string section, int team) {
    EconomyItem_t weapon_config;
    
    if (section == "weapon_knife" || section == "weapon_knife_t" || section == "glove_t" || section == "glove_ct") {
        team = TEAM_NONE;
    }
    
    std::string teamSection = section;
    if (team == TEAM_T || team == TEAM_CT) {
        teamSection.append(team == TEAM_T ? "_t" : "_ct");
    }

    if (HasSkinConfiguration(teamSection)) {
        weapon_config.entity_quality = (int)ini.GetLongValue(teamSection.c_str(), "entity_quality", -1);
        weapon_config.fallback_paint_kit = (int)ini.GetLongValue(teamSection.c_str(), "fallback_paint_kit", -1);
        weapon_config.fallback_seed = (int)ini.GetLongValue(teamSection.c_str(), "fallback_seed", -1);
        weapon_config.fallback_wear = (float)ini.GetDoubleValue(teamSection.c_str(), "fallback_wear", 0.000001f);
        weapon_config.fallback_stattrak = (int)ini.GetLongValue(teamSection.c_str(), "fallback_stattrak", -1);
        weapon_config.item_definition_index = (int)ini.GetLongValue(teamSection.c_str(), "item_definition_index", -1);
        weapon_config.custom_name = std::string(ini.GetValue(teamSection.c_str(), "custom_name", ""));
#ifdef GOSX_STICKER_CHANGER
        if (!WeaponManager::IsKnife(weapon_config.item_definition_index) && section != "weapon_knife" && section != "weapon_knife_t" && section != "glove_t" && section != "glove_ct") {
            weapon_config.sticker_slot1 = (int)ini.GetLongValue(teamSection.c_str(), "sticker_slot1", -1);
            weapon_config.sticker_slot2 = (int)ini.GetLongValue(teamSection.c_str(), "sticker_slot2", -1);
            weapon_config.sticker_slot3 = (int)ini.GetLongValue(teamSection.c_str(), "sticker_slot3", -1);
            weapon_config.sticker_slot4 = (int)ini.GetLongValue(teamSection.c_str(), "sticker_slot4", -1);
        }
#endif

        return weapon_config;
    }
    
    weapon_config.entity_quality = (int)ini.GetLongValue(section.c_str(), "entity_quality", -1);
    weapon_config.fallback_paint_kit = (int)ini.GetLongValue(section.c_str(), "fallback_paint_kit", -1);
    weapon_config.fallback_seed = (int)ini.GetLongValue(section.c_str(), "fallback_seed", -1);
    weapon_config.fallback_wear = (float)ini.GetDoubleValue(section.c_str(), "fallback_wear", 0.000001f);
    weapon_config.fallback_stattrak = (int)ini.GetLongValue(section.c_str(), "fallback_stattrak", -1);
    weapon_config.item_definition_index = (int)ini.GetLongValue(section.c_str(), "item_definition_index", -1);
    weapon_config.custom_name = std::string(ini.GetValue(section.c_str(), "custom_name", ""));
#ifdef GOSX_STICKER_CHANGER
    if (!WeaponManager::IsKnife(weapon_config.item_definition_index) && section != "weapon_knife" && section != "weapon_knife_t" && section != "glove_t" && section != "glove_ct") {
        weapon_config.sticker_slot1 = (int)ini.GetLongValue(section.c_str(), "sticker_slot1", -1);
        weapon_config.sticker_slot2 = (int)ini.GetLongValue(section.c_str(), "sticker_slot2", -1);
        weapon_config.sticker_slot3 = (int)ini.GetLongValue(section.c_str(), "sticker_slot3", -1);
        weapon_config.sticker_slot4 = (int)ini.GetLongValue(section.c_str(), "sticker_slot4", -1);
    }
#endif
    
    return weapon_config;
}

void CSettingsManager::SetSkinConfiguration(std::string section, EconomyItem_t config, int team) {
    if (section == "weapon_knife" || section == "weapon_knife_t" || section == "glove_t" || section == "glove_ct") {
        team = TEAM_NONE;
    }
    
    std::string teamSection = section;
    if (team == TEAM_T || team == TEAM_CT) {
        teamSection.append(team == TEAM_T ? "_t" : "_ct");
    }
    
    SetIntValue(teamSection, "entity_quality", config.entity_quality);
    SetIntValue(teamSection, "fallback_paint_kit", config.fallback_paint_kit);
    SetIntValue(teamSection, "fallback_seed", config.fallback_seed);
    SetDoubleValue(teamSection, "fallback_wear", config.fallback_wear);
    SetIntValue(teamSection, "fallback_stattrak", config.fallback_stattrak);
    SetIntValue(teamSection, "item_definition_index", config.item_definition_index);
    SetValue(teamSection, "custom_name", config.custom_name.c_str());
#ifdef GOSX_STICKER_CHANGER
    if (!WeaponManager::IsKnife(config.item_definition_index) && section != "weapon_knife" && section != "weapon_knife_t" && section != "glove_t" && section != "glove_ct") {
        SetIntValue(teamSection, "sticker_slot1", config.sticker_slot1);
        SetIntValue(teamSection, "sticker_slot2", config.sticker_slot2);
        SetIntValue(teamSection, "sticker_slot3", config.sticker_slot3);
        SetIntValue(teamSection, "sticker_slot4", config.sticker_slot4);
    }
#endif
    
    SaveSettings(true);
}

void CSettingsManager::DeleteSkinConfiguration(std::string section, int team) {
    if (section == "weapon_knife" || section == "weapon_knife_t" || section == "glove_t" || section == "glove_ct") {
        team = TEAM_NONE;
    }
    
    std::string teamSection = section;
    if (team == TEAM_T || team == TEAM_CT) {
        teamSection.append(team == TEAM_T ? "_t" : "_ct");
    }
    
    if (ini.Delete(teamSection.c_str(), NULL)) {
        SaveSettings();
    }
}

bool CSettingsManager::IsEmpty() {
    return ini.IsEmpty();
}

bool CSettingsManager::DeleteSection(std::string section) {
    bool returnValue = ini.Delete(section.c_str(), NULL);
    
    if (returnValue) {
        if (Options::Config::auto_save) {
            SaveSettings();
        }
    }
    
    return returnValue;
}

void CSettingsManager::SaveAll(std::string customFile, bool IsNew, bool assign) {
    std::shared_ptr<CSettingsManager> currentSaveConfig = CSettingsManager::Instance(customFile);
    if (!currentSaveConfig) {
        return;
    }
    if (IsNew) {
        currentSaveConfig->SetIsInit(true);
        bool OriginAutoSave = Options::Config::auto_save;
        if (Options::Config::auto_save) {
            Options::Config::auto_save = false;
        }
        
        currentSaveConfig->SetBoolValue("Main", "enabled", Options::Main::enabled);
        currentSaveConfig->SetIntValue("Main", "menu_key", Options::Main::menu_key);
        currentSaveConfig->SetBoolValue("Main", "screenshot_cleaner", Options::Main::screenshot_cleaner);
        
        currentSaveConfig->SetIntValue("Aimbot", "toggle_key", Options::Aimbot::toggle_key);
        currentSaveConfig->SetBoolValue("Aimbot", "enabled", Options::Aimbot::enabled);
        currentSaveConfig->SetBoolValue("Aimbot", "full_legit", Options::Aimbot::full_legit);
        currentSaveConfig->SetIntValue("Aimbot", "bone_mode", Options::Aimbot::bone_mode);
        currentSaveConfig->SetIntValue("Aimbot", "fixed_bone", Options::Aimbot::fixed_bone);
        currentSaveConfig->SetIntValue("Aimbot", "aim_key", Options::Aimbot::aim_key);
        currentSaveConfig->SetBoolValue("Aimbot", "smoothaim", Options::Aimbot::smoothaim);
        currentSaveConfig->SetDoubleValue("Aimbot", "smoothing_factor", Options::Aimbot::smoothing_factor);
        currentSaveConfig->SetBoolValue("Aimbot", "smooth_salting", Options::Aimbot::smooth_salting);
        currentSaveConfig->SetDoubleValue("Aimbot", "smooth_salt_multiplier", Options::Aimbot::smooth_salt_multiplier);
        currentSaveConfig->SetBoolValue("Aimbot", "smooth_constant_speed", Options::Aimbot::smooth_constant_speed);
        currentSaveConfig->SetBoolValue("Aimbot", "fov_enabled", Options::Aimbot::fov_enabled);
        currentSaveConfig->SetDoubleValue("Aimbot", "field_of_view", Options::Aimbot::field_of_view);
        currentSaveConfig->SetBoolValue("Aimbot", "recoil_control", Options::Aimbot::recoil_control);
        currentSaveConfig->SetDoubleValue("Aimbot", "recoil_level_x", Options::Aimbot::recoil_level_x);
        currentSaveConfig->SetDoubleValue("Aimbot", "recoil_level_y", Options::Aimbot::recoil_level_y);
        currentSaveConfig->SetBoolValue("Aimbot", "enemy_onground_check", Options::Aimbot::enemy_onground_check);
        currentSaveConfig->SetBoolValue("Aimbot", "player_onground_check", Options::Aimbot::player_onground_check);
        currentSaveConfig->SetBoolValue("Aimbot", "smokecheck", Options::Aimbot::smokecheck);
        currentSaveConfig->SetBoolValue("Aimbot", "flash_check", Options::Aimbot::flash_check);
        currentSaveConfig->SetBoolValue("Aimbot", "delayed_shot", Options::Aimbot::delayed_shot);
        currentSaveConfig->SetBoolValue("Aimbot", "silent_aim", Options::Aimbot::silent_aim);
        
        currentSaveConfig->SetBoolValue("Chams", "enabled", Options::Chams::enabled);
        currentSaveConfig->SetIntValue("Chams", "chams_type", Options::Chams::chams_type);
        currentSaveConfig->SetBoolValue("Chams", "players", Options::Chams::players);
        currentSaveConfig->SetBoolValue("Chams", "show_dead_chams", Options::Chams::show_dead_chams);
        currentSaveConfig->SetBoolValue("Chams", "weapons", Options::Chams::weapons);
        currentSaveConfig->SetBoolValue("Chams", "arms", Options::Chams::arms);
        currentSaveConfig->SetIntValue("Chams", "arms_type", Options::Chams::arms_type);
        currentSaveConfig->SetBoolValue("Chams", "enemies", Options::Chams::enemies);
        currentSaveConfig->SetBoolValue("Chams", "allies", Options::Chams::allies);
        currentSaveConfig->SetIntValue("Chams", "weapon_type", Options::Chams::weapon_type);
        currentSaveConfig->SetIntValue("Chams", "deadchams_type", Options::Chams::deadchams_type);
        
        currentSaveConfig->SetBoolValue("Improvements", "bunnyhop", Options::Improvements::bunnyhop);
        currentSaveConfig->SetIntValue("Improvements", "bhop_toggle_key", Options::Improvements::bhop_toggle_key);
        currentSaveConfig->SetBoolValue("Improvements", "triggerbot", Options::Improvements::triggerbot);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_delay", Options::Improvements::trigger_delay);
        currentSaveConfig->SetDoubleValue("Improvements", "trigger_delay_value", Options::Improvements::trigger_delay_value);
        currentSaveConfig->SetIntValue("Improvements", "trigger_key", Options::Improvements::trigger_key);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_autoactivation", Options::Improvements::trigger_autoactivation);
        
        currentSaveConfig->SetBoolValue("Improvements", "trigger_filter_arms", Options::Improvements::trigger_filter_arms);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_filter_head", Options::Improvements::trigger_filter_head);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_filter_legs", Options::Improvements::trigger_filter_legs);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_filter_stomach", Options::Improvements::trigger_filter_stomach);
        currentSaveConfig->SetBoolValue("Improvements", "trigger_filter_chest", Options::Improvements::trigger_filter_chest);
        
        currentSaveConfig->SetBoolValue("Improvements", "skin_changer", Options::Improvements::skin_changer);
        currentSaveConfig->SetBoolValue("Improvements", "fov_changer", Options::Improvements::fov_changer);
        currentSaveConfig->SetDoubleValue("Improvements", "fov", Options::Improvements::fov);
        currentSaveConfig->SetBoolValue("Improvements", "no_scope", Options::Improvements::no_scope);
        currentSaveConfig->SetBoolValue("Improvements", "no_flash", Options::Improvements::no_flash);
        currentSaveConfig->SetDoubleValue("Improvements", "maxflashalpha", Options::Improvements::maxflashalpha);
        currentSaveConfig->SetBoolValue("Improvements", "rankreveal", Options::Improvements::rankreveal);
        currentSaveConfig->SetBoolValue("Improvements", "always_rcs", Options::Improvements::always_rcs);
        currentSaveConfig->SetDoubleValue("Improvements", "always_rcs_level", Options::Improvements::always_rcs_level);
        currentSaveConfig->SetBoolValue("Improvements", "no_sky", Options::Improvements::no_sky);
        currentSaveConfig->SetBoolValue("Improvements", "auto_accept", Options::Improvements::auto_accept);
#ifdef GOSX_GLOVE_CHANGER
        currentSaveConfig->SetBoolValue("Improvements", "glove_changer", Options::Improvements::glove_changer);
#endif
        currentSaveConfig->SetBoolValue("Improvements", "bhop_legit", Options::Improvements::bhop_legit);
        currentSaveConfig->SetIntValue("Improvements", "bhop_minhops", Options::Improvements::bhop_minhops);
        currentSaveConfig->SetIntValue("Improvements", "bhop_maxhops", Options::Improvements::bhop_maxhops);
        currentSaveConfig->SetBoolValue("Improvements", "gray_walls", Options::Improvements::gray_walls);
        currentSaveConfig->SetBoolValue("Improvements", "aimware_lagcrashfix", Options::Improvements::aimware_lagcrashfix);
        currentSaveConfig->SetBoolValue("Improvements", "night_mode", Options::Improvements::night_mode);
#ifdef GOSX_STREAM_PROOF
        currentSaveConfig->SetBoolValue("Improvements", "stream_proof", Options::Improvements::stream_proof);
#endif
        
        currentSaveConfig->SetBoolValue("Glow", "enabled", Options::Glow::enabled);
        currentSaveConfig->SetBoolValue("Glow", "glow_player", Options::Glow::glow_player);
        currentSaveConfig->SetBoolValue("Glow", "glow_team", Options::Glow::glow_team);
        currentSaveConfig->SetBoolValue("Glow", "glow_weapon", Options::Glow::glow_weapon);
        currentSaveConfig->SetBoolValue("Glow", "glow_bomb", Options::Glow::glow_bomb);
        currentSaveConfig->SetColorValue("Glow", "color_dropped_bomb", Options::Glow::color_dropped_bomb);
        currentSaveConfig->SetColorValue("Glow", "color_planted_bomb", Options::Glow::color_planted_bomb);
        currentSaveConfig->SetBoolValue("Glow", "glow_extra", Options::Glow::glow_extra);
        currentSaveConfig->SetColorValue("Glow", "color_extra", Options::Glow::color_extra);
        currentSaveConfig->SetBoolValue("Glow", "glow_grenades", Options::Glow::glow_grenades);
        currentSaveConfig->SetColorValue("Glow", "color_grenades", Options::Glow::color_grenades);
        
        currentSaveConfig->SetColorValue("Colors", "color_ct_visible", Options::Colors::color_ct_visible);
        currentSaveConfig->SetColorValue("Colors", "color_ct", Options::Colors::color_ct);
        currentSaveConfig->SetColorValue("Colors", "color_t_visible", Options::Colors::color_t_visible);
        currentSaveConfig->SetColorValue("Colors", "color_t", Options::Colors::color_t);
        currentSaveConfig->SetColorValue("Colors", "color_ct_visible_glow", Options::Colors::color_ct_visible_glow);
        currentSaveConfig->SetColorValue("Colors", "color_ct_glow", Options::Colors::color_ct_glow);
        currentSaveConfig->SetColorValue("Colors", "color_t_visible_glow", Options::Colors::color_t_visible_glow);
        currentSaveConfig->SetColorValue("Colors", "color_t_glow", Options::Colors::color_t_glow);
        currentSaveConfig->SetColorValue("Colors", "color_player_dead", Options::Colors::color_player_dead);
        currentSaveConfig->SetColorValue("Colors", "color_weapon", Options::Colors::color_weapon);
        currentSaveConfig->SetColorValue("Colors", "color_weapon_visible", Options::Colors::color_weapon_visible);
        currentSaveConfig->SetColorValue("Colors", "color_arms_visible", Options::Colors::color_arms_visible);
        currentSaveConfig->SetColorValue("Colors", "fov_circle", Options::Colors::fov_circle);
        currentSaveConfig->SetColorValue("Colors", "nosky_color", Options::Colors::nosky_color);
        currentSaveConfig->SetColorValue("Colors", "wallbang_indicator_color", Options::Colors::wallbang_indicator_color);
        
        currentSaveConfig->SetBoolValue("Extras", "autopistol", Options::Extras::autopistol);
        currentSaveConfig->SetBoolValue("Extras", "autoknife", Options::Extras::autoknife);
        currentSaveConfig->SetBoolValue("Extras", "knifebot", Options::Extras::knifebot);
        currentSaveConfig->SetBoolValue("Extras", "auto_cock_revolver", Options::Extras::auto_cock_revolver);
        
        currentSaveConfig->SetBoolValue("Drawing", "enabled", Options::Drawing::enabled);
        currentSaveConfig->SetBoolValue("Drawing", "playeresp", Options::Drawing::playeresp);
        currentSaveConfig->SetBoolValue("Drawing", "fovcircle", Options::Drawing::fovcircle);
        currentSaveConfig->SetBoolValue("Drawing", "smoke_esp", Options::Drawing::smoke_esp);
        currentSaveConfig->SetBoolValue("Drawing", "bone_esp", Options::Drawing::bone_esp);
        currentSaveConfig->SetColorValue("Drawing", "color_bone_esp", Options::Drawing::color_bone_esp);
        currentSaveConfig->SetBoolValue("Drawing", "bone_esp_allies", Options::Drawing::bone_esp_allies);
        currentSaveConfig->SetBoolValue("Drawing", "crosshair", Options::Drawing::crosshair);
        currentSaveConfig->SetBoolValue("Drawing", "crosshair_outline", Options::Drawing::crosshair_outline);
        currentSaveConfig->SetIntValue("Drawing", "recoil_crosshair", Options::Drawing::recoil_crosshair);
        currentSaveConfig->SetIntValue("Drawing", "crosshair_width", Options::Drawing::crosshair_width);
        currentSaveConfig->SetIntValue("Drawing", "crosshair_thickness", Options::Drawing::crosshair_thickness);
        currentSaveConfig->SetIntValue("Drawing", "crosshair_gap", Options::Drawing::crosshair_gap);
        currentSaveConfig->SetColorValue("Drawing", "crosshair_color", Options::Drawing::crosshair_color);
        currentSaveConfig->SetBoolValue("Drawing", "show_wallbang_indicator", Options::Drawing::show_wallbang_indicator);
        currentSaveConfig->SetBoolValue("Drawing", "draw_boundingbox", Options::Drawing::draw_boundingbox);
        currentSaveConfig->SetBoolValue("Drawing", "boundingbox_outline", Options::Drawing::boundingbox_outline);
        
        currentSaveConfig->SetBoolValue("Drawing", "weapon_esp", Options::Drawing::weapon_esp);
        currentSaveConfig->SetBoolValue("Drawing", "weapon_opt_name", Options::Drawing::weapon_opt_name);
        currentSaveConfig->SetBoolValue("Drawing", "weapon_opt_boundingbox", Options::Drawing::weapon_opt_boundingbox);
        currentSaveConfig->SetBoolValue("Drawing", "grenade_esp", Options::Drawing::grenade_esp);
        currentSaveConfig->SetBoolValue("Drawing", "grenade_opt_name", Options::Drawing::grenade_opt_name);
        currentSaveConfig->SetBoolValue("Drawing", "grenade_opt_boundingbox", Options::Drawing::grenade_opt_boundingbox);
        currentSaveConfig->SetBoolValue("Drawing", "defusekit_esp", Options::Drawing::defusekit_esp);
        currentSaveConfig->SetBoolValue("Drawing", "defusekit_opt_name", Options::Drawing::defusekit_opt_name);
        currentSaveConfig->SetBoolValue("Drawing", "defusekit_opt_boundingbox", Options::Drawing::defusekit_opt_boundingbox);
        currentSaveConfig->SetBoolValue("Drawing", "defusekit_opt_distance", Options::Drawing::defusekit_opt_distance);
        currentSaveConfig->SetBoolValue("Drawing", "bomb_esp", Options::Drawing::bomb_esp);
        currentSaveConfig->SetBoolValue("Drawing", "bomb_opt_name", Options::Drawing::bomb_opt_name);
        currentSaveConfig->SetBoolValue("Drawing", "bomb_opt_boundingbox", Options::Drawing::bomb_opt_boundingbox);
        currentSaveConfig->SetBoolValue("Drawing", "bomb_opt_distance", Options::Drawing::bomb_opt_distance);
        
        currentSaveConfig->SetBoolValue("Drawing", "draw_name", Options::Drawing::draw_name);
        currentSaveConfig->SetBoolValue("Drawing", "draw_healthbar", Options::Drawing::draw_healthbar);
        currentSaveConfig->SetBoolValue("Drawing", "draw_healthnumber", Options::Drawing::draw_healthnumber);
        currentSaveConfig->SetBoolValue("Drawing", "draw_armorbar", Options::Drawing::draw_armorbar);
        currentSaveConfig->SetBoolValue("Drawing", "draw_weapon_name", Options::Drawing::draw_weapon_name);
        currentSaveConfig->SetBoolValue("Drawing", "draw_distance", Options::Drawing::draw_distance);
        currentSaveConfig->SetBoolValue("Drawing", "draw_c4", Options::Drawing::draw_c4);
        currentSaveConfig->SetBoolValue("Drawing", "draw_armor", Options::Drawing::draw_armor);
        currentSaveConfig->SetBoolValue("Drawing", "draw_defkit", Options::Drawing::draw_defkit);
        currentSaveConfig->SetBoolValue("Drawing", "list_enabled", Options::Drawing::list_enabled);
        currentSaveConfig->SetDoubleValue("Drawing", "list_x", Options::Drawing::list_x);
        currentSaveConfig->SetDoubleValue("Drawing", "list_y", Options::Drawing::list_y);
        currentSaveConfig->SetIntValue("Drawing", "bomb_timer", Options::Drawing::bomb_timer);
        currentSaveConfig->SetBoolValue("Drawing", "sound_esp", Options::Drawing::sound_esp);
        currentSaveConfig->SetDoubleValue("Drawing", "visible_duration", Options::Drawing::visible_duration);
        currentSaveConfig->SetBoolValue("Drawing", "hit_marker", Options::Drawing::hit_marker);
        currentSaveConfig->SetBoolValue("Drawing", "hit_marker_sound", Options::Drawing::hit_marker_sound);
        currentSaveConfig->SetIntValue("Drawing", "hit_marker_style", Options::Drawing::hit_marker_style);
        currentSaveConfig->SetDoubleValue("Drawing", "hit_marker_volume", Options::Drawing::hit_marker_volume);
        currentSaveConfig->SetBoolValue("Drawing", "entity_view_lines", Options::Drawing::entity_view_lines);
        
        currentSaveConfig->SetBoolValue("Radar", "enabled", Options::Radar::enabled);
        currentSaveConfig->SetIntValue("Radar", "size", Options::Radar::size);
        currentSaveConfig->SetIntValue("Radar", "zoom", Options::Radar::zoom);
        currentSaveConfig->SetIntValue("Radar", "pos_x", Options::Radar::pos_x);
        currentSaveConfig->SetIntValue("Radar", "pos_y", Options::Radar::pos_y);
        currentSaveConfig->SetIntValue("Radar", "style", Options::Radar::style);
        
        currentSaveConfig->SetBoolValue("GrenadeHelper", "enabled", Options::GrenadeHelper::enabled);
        currentSaveConfig->SetDoubleValue("GrenadeHelper", "aim_distance", Options::GrenadeHelper::aim_distance);
        currentSaveConfig->SetDoubleValue("GrenadeHelper", "visible_distance", Options::GrenadeHelper::visible_distance);
        currentSaveConfig->SetColorValue("GrenadeHelper", "color_grenade_he", Options::GrenadeHelper::color_grenade_he);
        currentSaveConfig->SetColorValue("GrenadeHelper", "color_grenade_smoke", Options::GrenadeHelper::color_grenade_smoke);
        currentSaveConfig->SetColorValue("GrenadeHelper", "color_grenade_flash", Options::GrenadeHelper::color_grenade_flash);
        currentSaveConfig->SetColorValue("GrenadeHelper", "color_grenade_inc", Options::GrenadeHelper::color_grenade_inc);
        currentSaveConfig->SetBoolValue("GrenadeHelper", "aim_assist", Options::GrenadeHelper::aim_assist);
        currentSaveConfig->SetDoubleValue("GrenadeHelper", "aim_fov", Options::GrenadeHelper::aim_fov);
        currentSaveConfig->SetBoolValue("GrenadeHelper", "smoothaim", Options::GrenadeHelper::smoothaim);
        currentSaveConfig->SetBoolValue("GrenadeHelper", "developer_mode", Options::GrenadeHelper::developer_mode);

#ifdef GOSX_BACKTRACKING
        currentSaveConfig->SetBoolValue("Backtracking", "enabled", Options::Backtracking::enabled);
        currentSaveConfig->SetIntValue("Backtracking", "backtrack_visual_type", Options::Backtracking::backtrack_visual_type);
        currentSaveConfig->SetIntValue("Backtracking", "backtrack_ticks", Options::Backtracking::backtrack_ticks);
        currentSaveConfig->SetIntValue("Backtracking", "backtrack_hitbox", Options::Backtracking::backtrack_hitbox);
        currentSaveConfig->SetBoolValue("Backtracking", "visibility_check", Options::Backtracking::visibility_check);
        currentSaveConfig->SetColorValue("Backtracking", "backtrack_color", Options::Backtracking::backtrack_color);
#endif
        
        currentSaveConfig->SetBoolValue("GrenadePrediction", "enabled", Options::GrenadePrediction::enabled);
        currentSaveConfig->SetBoolValue("GrenadePrediction", "last_path_stays", Options::GrenadePrediction::last_path_stays);
        currentSaveConfig->SetDoubleValue("GrenadePrediction", "path_width", Options::GrenadePrediction::path_width);
        currentSaveConfig->SetIntValue("GrenadePrediction", "hit_size", Options::GrenadePrediction::hit_size);
        currentSaveConfig->SetColorValue("GrenadePrediction", "path_color", Options::GrenadePrediction::path_color);
        currentSaveConfig->SetColorValue("GrenadePrediction", "hit_color", Options::GrenadePrediction::hit_color);
        
        currentSaveConfig->SetBoolValue("Config", "auto_save", OriginAutoSave);
        currentSaveConfig->SetBoolValue("Config", "weapon_icons", Options::Config::weapon_icons);
        
        currentSaveConfig->SetBoolValue("AntiCheat", "faceit_safe", Options::AntiCheat::faceit_safe);
        currentSaveConfig->SetBoolValue("AntiCheat", "mouse_event_aim", Options::AntiCheat::mouse_event_aim);
        currentSaveConfig->SetIntValue("AntiCheat", "targeting", Options::AntiCheat::targeting);
        
#ifdef GOSX_OVERWATCH_REVEAL
        currentSaveConfig->SetBoolValue("OverwatchReveal", "enabled", Options::OverwatchReveal::enabled);
#endif
       
#ifdef GOSX_THIRDPERSON
        currentSaveConfig->SetBoolValue("Thirdperson", "enabled", Options::Thirdperson::enabled);
        currentSaveConfig->SetDoubleValue("Thirdperson", "distance", Options::Thirdperson::distance);
        currentSaveConfig->SetIntValue("Thirdperson", "toggle_key", Options::Thirdperson::toggle_key);
#endif
        
        
#ifdef GOSX_RAGE_MODE
        currentSaveConfig->SetBoolValue("Rage", "enabled", Options::Rage::enabled);
        currentSaveConfig->SetBoolValue("Rage", "engine_predict", Options::Rage::engine_predict);
        currentSaveConfig->SetBoolValue("Rage", "hit_scan", Options::Rage::hit_scan);
        currentSaveConfig->SetBoolValue("Rage", "auto_shoot", Options::Rage::auto_shoot);
        currentSaveConfig->SetBoolValue("Rage", "auto_scope", Options::Rage::auto_scope);
        currentSaveConfig->SetBoolValue("Rage", "silent_aim", Options::Rage::silent_aim);
        currentSaveConfig->SetDoubleValue("Rage", "fov_multiplier", Options::Rage::fov_multiplier);
        currentSaveConfig->SetBoolValue("Rage", "auto_wall", Options::Rage::auto_wall);
        currentSaveConfig->SetDoubleValue("Rage", "autowall_min_damage", Options::Rage::autowall_min_damage);
        currentSaveConfig->SetBoolValue("Rage", "anti_aim", Options::Rage::anti_aim);
        currentSaveConfig->SetIntValue("Rage", "antiaim_pitch", Options::Rage::antiaim_pitch);
        currentSaveConfig->SetDoubleValue("Rage", "antiaim_custom_pitch", Options::Rage::antiaim_custom_pitch);
        currentSaveConfig->SetIntValue("Rage", "antiaim_yaw", Options::Rage::antiaim_yaw);
        currentSaveConfig->SetDoubleValue("Rage", "antiaim_custom_yaw", Options::Rage::antiaim_custom_yaw);
        currentSaveConfig->SetBoolValue("Rage", "resolver", Options::Rage::resolver);
        currentSaveConfig->SetBoolValue("Rage", "resolve_all", Options::Rage::resolve_all);
        currentSaveConfig->SetIntValue("Rage", "resolver_mode", Options::Rage::resolver_mode);
        currentSaveConfig->SetIntValue("Rage", "resolver_ticks", Options::Rage::resolver_ticks);
        currentSaveConfig->SetIntValue("Rage", "resolver_modulo", Options::Rage::resolver_modulo);
        currentSaveConfig->SetBoolValue("Rage", "autocrouch", Options::Rage::autocrouch);
        currentSaveConfig->SetBoolValue("Rage", "auto_stop", Options::Rage::auto_stop);
        currentSaveConfig->SetBoolValue("Rage", "anti_untrusted", Options::Rage::anti_untrusted);
        currentSaveConfig->SetBoolValue("Rage", "edge_aa", Options::Rage::edge_aa);
        currentSaveConfig->SetDoubleValue("Rage", "hitchance_percent", Options::Rage::hitchance_percent);
        currentSaveConfig->SetIntValue("Rage", "hitchance_shots", Options::Rage::hitchance_shots);
        currentSaveConfig->SetBoolValue("Rage", "hitchance", Options::Rage::hitchance);
        
        currentSaveConfig->SetBoolValue("ClantagChanger", "enabled", Options::ClantagChanger::enabled);
        currentSaveConfig->SetValue("ClantagChanger", "tag", Options::ClantagChanger::tag);
        currentSaveConfig->SetBoolValue("ClantagChanger", "animated", Options::ClantagChanger::animated);
        currentSaveConfig->SetIntValue("ClantagChanger", "animation_type", Options::ClantagChanger::animation_type);
        currentSaveConfig->SetBoolValue("ClantagChanger", "hide_name", Options::ClantagChanger::hide_name);
        currentSaveConfig->SetDoubleValue("ClantagChanger", "animation_speed", Options::ClantagChanger::animation_speed);
        
        currentSaveConfig->SetBoolValue("RageMisc", "fakelag", Options::RageMisc::fakelag);
        currentSaveConfig->SetIntValue("RageMisc", "fakelag_ticks", Options::RageMisc::fakelag_ticks);
        currentSaveConfig->SetBoolValue("RageMisc", "fakelag_adaptive", Options::RageMisc::fakelag_adaptive);
        currentSaveConfig->SetBoolValue("RageMisc", "no_visual_recoil", Options::RageMisc::no_visual_recoil);
        currentSaveConfig->SetBoolValue("RageMisc", "fake_walk", Options::RageMisc::fake_walk);
        currentSaveConfig->SetIntValue("RageMisc", "fake_walk_key", Options::RageMisc::fake_walk_key);
        currentSaveConfig->SetBoolValue("RageMisc", "circle_strafe", Options::RageMisc::circle_strafe);
        currentSaveConfig->SetIntValue("RageMisc", "circle_strafe_key", Options::RageMisc::circle_strafe_key);
        
        currentSaveConfig->SetBoolValue("AutoStrafe", "enabled", Options::AutoStrafe::enabled);
        currentSaveConfig->SetIntValue("AutoStrafe", "strafe_type", Options::AutoStrafe::strafe_type);
        currentSaveConfig->SetBoolValue("AutoStrafe", "silent", Options::AutoStrafe::silent);
#endif
        currentSaveConfig->SetIsInit(false);
        if (!Options::Config::auto_save && OriginAutoSave) {
            Options::Config::auto_save = OriginAutoSave;
        }
    }
    
    currentSaveConfig->SaveSettings(false, false, customFile, true);
    if (IsNew) {
        currentConfigName = customFile;
        
        if (assign) {
            CSettingsManager::Instance("menu.ini")->SetValue("Main", "settings_file", customFile.c_str());
            CSettingsManager::Instance("menu.ini")->SaveSettings(false, false, "", true);
        }
        
        currentSaveConfig->ReloadSettings();
    }
    
    Options::synced = false;
    SyncSettings();
}

