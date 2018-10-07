/******************************************************/
/**                                                  **/
/**      Settings/manager.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Settings_manager_h
#define Settings_manager_h

#include "SDK/Thirdparty/SimpleIni.h"
#include "Engine/common.h"
#include "SDK/Color.h"
#include "SDK/CCSWpnInfo.h"
#include "Engine/functions.h"
#include "SDK/EconomyItem.h"
#include "SDK/Definitions.h"
#include "Engine/Weapons/manager.h"

typedef int key;
class Color;

namespace Options {
    extern bool synced;
    
    namespace Main {
        extern bool     enabled;
        extern key      menu_key;
        extern int      menu_key_mods;
        extern bool     screenshot_cleaner;
    };
    
    namespace Aimbot {
        extern bool     enabled;
        extern int      toggle_key;
        extern bool     full_legit;
        extern int      bone_mode;
        extern int      fixed_bone;
        extern key      aim_key;
        extern bool     smoothaim;
        extern float    smoothing_factor;
        extern bool     smooth_salting;
        extern float    smooth_salt_multiplier;
        extern bool     smooth_constant_speed;
        extern bool     fov_enabled;
        extern float    field_of_view;
        extern bool     recoil_control;
        extern float    recoil_level_x;
        extern float    recoil_level_y;
        extern bool     enemy_onground_check;
        extern bool     player_onground_check;
        extern bool     smokecheck;
        extern bool     flash_check;
        extern bool     delayed_shot;
        extern bool     silent_aim;
    };
    
    namespace AimbotDefault {
        extern bool     enabled;
        extern bool     full_legit;
        extern int      bone_mode;
        extern int      fixed_bone;
        extern key      aim_key;
        extern bool     smoothaim;
        extern float    smoothing_factor;
        extern bool     smooth_salting;
        extern float    smooth_salt_multiplier;
        extern bool     smooth_constant_speed;
        extern bool     fov_enabled;
        extern float    field_of_view;
        extern bool     recoil_control;
        extern float    recoil_level_x;
        extern float    recoil_level_y;
        extern bool     enemy_onground_check;
        extern bool     player_onground_check;
        extern bool     smokecheck;
        extern bool     flash_check;
        extern bool     delayed_shot;
        extern bool     silent_aim;
    };
    
    namespace Chams {
        extern bool     enabled;
        extern int      chams_type;
        extern bool     players;
        extern bool     show_dead_chams;
        extern bool     weapons;
        extern bool     arms;
        extern int      arms_type;
        extern bool     enemies;
        extern bool     allies;
        extern int      deadchams_type;
        extern int      weapon_type;
    };
    
    namespace Improvements {
        extern bool     bunnyhop;
        extern int      bhop_toggle_key;
        extern bool     triggerbot;
        extern bool     trigger_delay;
        extern float    trigger_delay_value;
        extern key      trigger_key;
        extern bool     trigger_autoactivation;
        extern bool     trigger_filter_head;
        extern bool     trigger_filter_chest;
        extern bool     trigger_filter_stomach;
        extern bool     trigger_filter_arms;
        extern bool     trigger_filter_legs;
        extern bool     skin_changer;
        extern bool     fov_changer;
        extern float    fov;
        extern bool     no_scope;
        extern bool     no_flash;
        extern float    maxflashalpha;
        extern bool     rankreveal;
        extern bool     always_rcs;
        extern float    always_rcs_level;
        extern bool     no_sky;
        extern Color    no_sky_color;
#ifdef GOSX_GLOVE_CHANGER
        extern bool     glove_changer;
#endif
        extern bool     bhop_legit;
        extern int      bhop_minhops;
        extern int      bhop_maxhops;
        extern bool     gray_walls;
        extern bool     aimware_lagcrashfix;
        extern bool     night_mode;
        extern bool     auto_accept;
#ifdef GOSX_STREAM_PROOF
        extern bool     stream_proof;
#endif
    };
    
    namespace ImprovementsDefault {
        extern bool     triggerbot;
        extern bool     trigger_delay;
        extern float    trigger_delay_value;
        extern key      trigger_key;
        extern bool     trigger_autoactivation;
        extern bool     trigger_filter_head;
        extern bool     trigger_filter_chest;
        extern bool     trigger_filter_stomach;
        extern bool     trigger_filter_arms;
        extern bool     trigger_filter_legs;
        extern bool     always_rcs;
    };
    
    namespace Glow {
        extern bool     enabled;
        extern bool     glow_player;
        extern bool     glow_team;
        extern bool     glow_weapon;
        extern bool     glow_bomb;
        extern Color    color_dropped_bomb;
        extern Color    color_planted_bomb;
        extern bool     glow_extra;
        extern Color    color_extra;
        extern bool     glow_grenades;
        extern Color    color_grenades;
    };
    
    namespace Colors {
        extern Color    color_ct_visible;
        extern Color    color_ct;
        extern Color    color_t_visible;
        extern Color    color_t;
        extern Color    color_player_dead;
        extern Color    color_weapon;
        extern Color    color_weapon_visible;
        extern Color    color_arms_visible;
        extern Color    fov_circle;
        extern Color    nosky_color;
        extern Color    wallbang_indicator_color;
        extern Color    color_ct_glow;
        extern Color    color_ct_visible_glow;
        extern Color    color_t_glow;
        extern Color    color_t_visible_glow;
    };
    
    namespace Extras {
        extern bool     autopistol;
        extern bool     autoknife;
        extern bool     knifebot;
        extern bool     auto_cock_revolver;
    };
    
    namespace ExtrasDefault {
        extern bool     auto_cock_revolver;
    };
    
    namespace Drawing {
        extern bool     enabled;
        extern bool     playeresp;
        extern bool     fovcircle;
        extern bool     smoke_esp;
        extern bool     bone_esp;
        extern Color    color_bone_esp;
        extern bool     bone_esp_allies;
        extern bool     crosshair;
        extern bool     crosshair_outline;
        extern int      recoil_crosshair;
        extern int      crosshair_width;
        extern int      crosshair_thickness;
        extern int      crosshair_gap;
        extern Color    crosshair_color;
        extern bool     show_wallbang_indicator;
        extern bool     draw_boundingbox;
        extern bool     boundingbox_outline;
        extern bool     weapon_esp;
        extern bool     weapon_opt_boundingbox;
        extern bool     weapon_opt_name;
        extern bool     grenade_esp;
        extern bool     grenade_opt_boundingbox;
        extern bool     grenade_opt_name;
        extern bool     defusekit_esp;
        extern bool     defusekit_opt_boundingbox;
        extern bool     defusekit_opt_name;
        extern bool     defusekit_opt_distance;
        extern bool     bomb_esp;
        extern bool     bomb_opt_boundingbox;
        extern bool     bomb_opt_name;
        extern bool     bomb_opt_distance;
        extern bool     draw_name;
        extern bool     draw_healthbar;
        extern bool     draw_healthnumber;
        extern bool     draw_armorbar;
        extern bool     draw_weapon_name;
        extern bool     draw_distance;
        extern bool     draw_c4;
        extern bool     draw_armor;
        extern bool     draw_defkit;
        extern bool     list_enabled;
        extern float    list_x;
        extern float    list_y;
        extern int      bomb_timer;
        extern bool     sound_esp;
        extern float    visible_duration;
        extern bool     hit_marker;
        extern bool     hit_marker_sound;
        extern int      hit_marker_style;
        extern float    hit_marker_volume;
        extern bool     entity_view_lines;
    };
    
    namespace Radar {
        extern bool     enabled;
        extern int      size;
        extern int      pos_x;
        extern int      pos_y;
        extern int      zoom;
        extern int      style;
    };
    
    namespace GrenadeHelper {
        extern bool     enabled;
        extern float    aim_distance;
        extern float    visible_distance;
        extern Color    color_grenade_he;
        extern Color    color_grenade_smoke;
        extern Color    color_grenade_flash;
        extern Color    color_grenade_inc;
        extern bool     aim_assist;
        extern float    aim_fov;
        extern bool     smoothaim;
        extern bool     developer_mode;
    };
    
#ifdef GOSX_BACKTRACKING
    namespace Backtracking {
        extern bool  enabled;
        extern int   backtrack_ticks;
        extern int   backtrack_hitbox;
        extern int   backtrack_visual_type;
        extern bool  visibility_check;
        extern Color backtrack_color;
    };
#endif
    
    namespace GrenadePrediction {
        extern bool     enabled;
        extern bool     last_path_stays;
        extern float    path_width;
        extern int      hit_size;
        extern Color    path_color;
        extern Color    hit_color;
    };
    
    namespace Config {
        extern bool auto_save;
        extern bool weapon_icons;
    };
    
    namespace AntiCheat {
        extern bool faceit_safe;
        extern bool mouse_event_aim;
        extern  int targeting;
    };
    
#ifdef GOSX_THIRDPERSON
    namespace Thirdperson {
        extern bool     enabled;
        extern float    distance;
        extern int      toggle_key;
    };
#endif
    
#ifdef GOSX_RAGE_MODE
    namespace Rage {
        extern bool     enabled;
        extern bool     engine_predict;
        extern bool     hit_scan;
        extern bool     auto_shoot;
        extern bool     auto_scope;
        extern bool     silent_aim;
        extern float    fov_multiplier;
        extern bool     auto_wall;
        extern float    autowall_min_damage;
        extern bool     anti_aim;
        extern int      antiaim_pitch;
        extern float    antiaim_custom_pitch;
        extern int      antiaim_yaw;
        extern float    antiaim_custom_yaw;
        extern bool     resolver;
        extern bool     resolve_all;
        extern int      resolver_mode;
        extern int      resolver_ticks;
        extern int      resolver_modulo;
        extern bool     autocrouch;
        extern bool     auto_stop;
        extern bool     anti_untrusted;
        extern bool     back_tracking;
        extern bool     edge_aa;
        extern bool     hitchance;
        extern int      hitchance_shots;
        extern float    hitchance_percent;
    };
    
    namespace ClantagChanger {
        extern bool     enabled;
        extern std::string tag;
        extern bool     animated;
        extern int      animation_type;
        extern bool     hide_name;
        extern float    animation_speed;
    };
    
    namespace RageMisc {
        extern bool     fakelag;
        extern int      fakelag_ticks;
        extern bool     fakelag_adaptive;
        extern bool     no_visual_recoil;
        extern bool     fake_walk;
        extern int      fake_walk_key;
        extern bool     circle_strafe;
        extern int      circle_strafe_key;
    };
    
    namespace AutoStrafe {
        extern bool     enabled;
        extern int      strafe_type;
        extern bool     silent;
    };
#endif
    
#ifdef GOSX_OVERWATCH_REVEAL
    namespace OverwatchReveal {
        extern bool enabled;
    };
#endif
}

#ifdef GOSX_MOJAVE_SWITCH
namespace ImGuiColors {
    extern ImVec4 ImGuiCol_Text;
    extern ImVec4 ImGuiCol_WindowBg;
    extern ImVec4 ImGuiCol_ChildWindowBg;
    extern ImVec4 ImGuiCol_PopupBg;
    extern ImVec4 ImGuiCol_BorderShadow;
    extern ImVec4 ImGuiCol_FrameBg;
    extern ImVec4 ImGuiCol_FrameBgHovered;
    extern ImVec4 ImGuiCol_FrameBgActive;
    extern ImVec4 ImGuiCol_TitleBg;
    extern ImVec4 ImGuiCol_TitleBgCollapsed;
    extern ImVec4 ImGuiCol_TitleBgActive;
    extern ImVec4 ImGuiCol_MenuBarBg;
    extern ImVec4 ImGuiCol_ScrollbarBg;
    extern ImVec4 ImGuiCol_ScrollbarGrab;
    extern ImVec4 ImGuiCol_ScrollbarGrabHovered;
    extern ImVec4 ImGuiCol_ScrollbarGrabActive;
    extern ImVec4 ImGuiCol_CheckMark;
    extern ImVec4 ImGuiCol_SliderGrab;
    extern ImVec4 ImGuiCol_SliderGrabActive;
    extern ImVec4 ImGuiCol_Button;
    extern ImVec4 ImGuiCol_ButtonHovered;
    extern ImVec4 ImGuiCol_ButtonActive;
    extern ImVec4 ImGuiCol_Header;
    extern ImVec4 ImGuiCol_HeaderHovered;
    extern ImVec4 ImGuiCol_HeaderActive;
    extern ImVec4 ImGuiCol_Column;
    extern ImVec4 ImGuiCol_ResizeGrip;
    extern ImVec4 ImGuiCol_SelectableBg;
}
#endif

class CSettingsManager {
public:
    CSettingsManager(std::string file);
    void ReloadSettings();
    bool IsEmpty();
    bool DeleteSection(std::string section);
    void SaveSettings(bool fromGameEvent = false, bool buttonClicked = false, std::string customPath = "", bool forceSave = false);
    
    // Setter
    void SetBoolValue(std::string section, std::string key, bool value);
    void SetDoubleValue(std::string section, std::string key, float value);
    void SetIntValue(std::string section, std::string key, int value);
    void SetValue(std::string section, std::string key, std::string value);
    void SetColorValue(std::string section, std::string key, Color value);
    
    // Getter
    std::string GetValue(std::string section, std::string key);
    std::string GetStringSetting(std::string section, std::string key, std::string defaultValue = "");
    Color GetColorSetting(std::string section, std::string key, std::string defaultValue = "255,255,255,255");
    
    // Special skinchanger config methods
    bool HasSkinConfiguration(std::string section, int team = 0);
    EconomyItem_t GetSkinConfiguration(std::string section, int team = 0);
    void SetSkinConfiguration(std::string section, EconomyItem_t config, int team = 0);
    void DeleteSkinConfiguration(std::string section, int team = 0);
public:
    // Public static method definitions
    static void SyncSettings();
    static bool HasWeaponBasedConfig(int index, std::string sectionName = "");
    static bool HasWeaponBasedConfig(std::string entity, std::string sectionName = "");
    static bool HasWeaponBasedConfig(CSWeaponType type, std::string sectionName = "");
    static bool DeleteWeaponBasedConfig(int index, std::string sectionName = "");
    static bool DeleteWeaponBasedConfig(std::string entityName, std::string sectionName = "");
    static bool DeleteWeaponBasedConfig(CSWeaponType type, std::string sectionName = "");
    static void UpdateConfigForWeapon(int index, CSWeaponType type = CSWeaponType::WEAPONTYPE_KNIFE);
    static void UpdateConfigForWeapon(std::string entity, CSWeaponType type = CSWeaponType::WEAPONTYPE_KNIFE);
    static std::string GetEntityNameForIndex(int index);
    static std::string GetEntityNameForWeaponType(CSWeaponType type, std::string extraString = "");
    static std::string GetConfigSectionForWeapon(int index, std::string sectionName);
    static bool Install();
    static void SaveAll(std::string customFile = "", bool IsNew = false, bool assign = false);
public:
    // public static inline methods
    template<typename T>
    static std::vector<T> split(const T & str, const T & delimiters) {
        std::vector<T> v;
        size_t start = 0;
        auto pos = str.find_first_of(delimiters, start);
        while (pos != T::npos) {
            if (pos != start) {
                v.emplace_back(str, start, pos - start);
            }
            start = pos + 1;
            pos = str.find_first_of(delimiters, start);
        }
        if (start < str.length()) {
            v.emplace_back(str, start, str.length() - start);
        }
        return v;
    }

    template<typename type>
    type GetSetting(std::string section, std::string key, type defaultValue = 0) {
        type value = 0;
        if (typeid(type) == typeid(float)) {
            value = (float)ini.GetDoubleValue(section.c_str(), key.c_str(), defaultValue);
        } else if (typeid(type) == typeid(bool)) {
            value = ini.GetBoolValue(section.c_str(), key.c_str(), defaultValue);
        } else if (typeid(type) == typeid(int)) {
            value = (int)ini.GetLongValue(section.c_str(), key.c_str(), defaultValue);
        }

        return value;
    }
    
    static std::shared_ptr<CSettingsManager> Instance(std::string file) {
        if (!instances[file]) {
            instances[file] = std::make_unique<CSettingsManager>(file);
        }
        return instances[file];
    }

    void GetAllSections(CSimpleIniA::TNamesDepend &a_names) {
        ini.GetAllSections(a_names);
    }

    void GetAllKeys(const char *a_pSection, CSimpleIniA::TNamesDepend &a_names) {
        ini.GetAllKeys(a_pSection, a_names);
    }
    
    void SetIsInit(bool value) {
        IsInit = value;
    }
    
    bool GetIsInit() {
        return IsInit;
    }
protected:
    static std::map<std::string, std::shared_ptr<CSettingsManager>> instances;
    CSimpleIniA                                     ini;
    char*                                           iniFile;
    bool                                            IsInit = false;
};

extern std::string currentConfigName;

#endif /** !Settings_manager_h */
