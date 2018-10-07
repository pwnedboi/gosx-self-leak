/******************************************************/
/**                                                  **/
/**      Features/GrenadeHelper.cpp                  **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "GrenadeHelper.h"
#include "LegitBot.h"

Features::GrenadeInfo::GrenadeInfo(GrenadeType gType, Vector pos, QAngle angle,ThrowType tType, const char* name) {
    this->gType = gType;
    this->pos = pos;
    this->angle = angle;
    this->tType = tType;
    this->name = name;
}

Features::GrenadeType Features::CGrenadeHelper::getGrenadeType(C_BaseCombatWeapon* wpn) {
    ClientClass* clientClass = wpn->GetClientClass();
    if (clientClass->m_ClassID == EClassIds::CHEGrenade) {
        return GrenadeType::HEGRENADE;
    }

    if (clientClass->m_ClassID == EClassIds::CSmokeGrenade) {
        return GrenadeType::SMOKE;
    }

    if (clientClass->m_ClassID == EClassIds::CFlashbang || clientClass->m_ClassID == EClassIds::CDecoyGrenade) {
        return GrenadeType::FLASH;
    }

    return GrenadeType::MOLOTOV;
}

Color Features::CGrenadeHelper::getColor(GrenadeType type) {
    switch (type) {
        case GrenadeType::HEGRENADE:
            return Options::GrenadeHelper::color_grenade_he;
        case GrenadeType::SMOKE:
            return Options::GrenadeHelper::color_grenade_smoke;
        case GrenadeType::FLASH:
            return Options::GrenadeHelper::color_grenade_flash;
        case GrenadeType::MOLOTOV:
            return Options::GrenadeHelper::color_grenade_inc;
        default:
            return Color(255, 255, 255);
    }
}

void Features::CGrenadeHelper::DrawGrenadeInfo(std::shared_ptr<GrenadeInfo> info) {
    if (!info) {
        return;
    }

    Vector pos2d;
    if (!Utils::WorldToScreen(Vector(info->pos.x, info->pos.y, info->pos.z), pos2d)) {
        return;
    }

    Color clr = getColor(info->gType);
    float radius = 20;
    DrawManager->Circle(Vector2D(pos2d.x, pos2d.y), radius * 1.5f, radius, clr);
    DrawManager->DrawString(nullptr, pos2d.x, pos2d.y, FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", info->name);
}

void Features::CGrenadeHelper::DrawAimHelp(std::shared_ptr<GrenadeInfo> info) {
    if (!info) {
        return;
    }
    
    Vector infoVec;
    Math::AngleVectors(info->angle, infoVec);
    infoVec *= 150 / infoVec.Length();
    infoVec += info->pos;

    Vector posVec;
    if (!Utils::WorldToScreen(infoVec, posVec)) {
        return;
    }

    Vector2D pos2d(posVec.x, posVec.y);
    static float radius = 5.0f;
    DrawManager->Circle(pos2d, radius * 1.5f, radius, Color(255, 0, 0));
    DrawManager->DrawLine(*Glob::SDLResW / 2, *Glob::SDLResH / 2, posVec.x, posVec.y, Color(255, 0, 0));
}

void Features::CGrenadeHelper::PaintTraverse() {
    if (!Engine->IsInGame() || !Engine->IsConnected() || !Options::GrenadeHelper::enabled) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }

    CSWeaponType weaponType = ActiveWeapon->GetCSWpnData()->m_WeaponType;
    if (weaponType != CSWeaponType::WEAPONTYPE_GRENADE) {
        return;
    }

    std::shared_ptr<CSettingsManager> config = CSettingsManager::Instance(GetCurrentMapConfigName().c_str());

    CSimpleIniA::TNamesDepend sections;
    config->GetAllSections(sections);
    sections.sort(CSimpleIniA::Entry::LoadOrder());

    for (auto section : sections) {
        if (!section.pItem) {
            continue;
        }

        std::shared_ptr<GrenadeInfo> grenadeInfo = PrepareGrenadeInfo(config, section);
        if (!grenadeInfo) {
            continue;
        }

        if (getGrenadeType(ActiveWeapon) != grenadeInfo->gType) {
            continue;
        }

        float dist = grenadeInfo->pos.DistTo(LocalPlayer->GetEyePos());
        if (dist > Options::GrenadeHelper::visible_distance) {
            continue;
        }

        DrawGrenadeInfo(grenadeInfo);

        if (dist < Options::GrenadeHelper::aim_distance) {
            DrawAimHelp(grenadeInfo);
        }
    }
}

void Features::CGrenadeHelper::AimAssist(CUserCmd* cmd) {
    if (!Options::GrenadeHelper::enabled) {
        return;
    }

    if (
        (!Options::GrenadeHelper::aim_assist && !Options::GrenadeHelper::developer_mode) ||
        !Engine->IsInGame()
    ) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive()) {
        return;
    }

    ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }

    if (ActiveWeapon->GetCSWpnData()->m_WeaponType != CSWeaponType::WEAPONTYPE_GRENADE) {
        return;
    }

    if (!Options::GrenadeHelper::aim_assist) {
        return;
    }

    std::shared_ptr<CSettingsManager> config = CSettingsManager::Instance(GetCurrentMapConfigName().c_str());

    CSimpleIniA::TNamesDepend sections;
    config->GetAllSections(sections);
    sections.sort(CSimpleIniA::Entry::LoadOrder());

    bool shootThisTick = cmd->buttons & IN_ATTACK;
    if (!shootThisTick && !shotLastTick) {
        return;
    }

    std::shared_ptr<GrenadeInfo> grenadeInfo = nullptr;
    float distOnScreen = 0.f;
    float dist = 0.f;

    for (auto section : sections) {
        if (!section.pItem) {
            continue;
        }

        std::shared_ptr<GrenadeInfo> act = PrepareGrenadeInfo(config, section);
        if (!act) {
            continue;
        }

        if (getGrenadeType(ActiveWeapon) != act->gType) {
            continue;
        }

        float dist3D = LocalPlayer->GetEyePos().DistTo(act->pos);
        if (dist3D > Options::GrenadeHelper::aim_distance) {
            continue;
        }

        float actDistOnScreen = Math::GetFov(act->angle, LocalPlayer->GetViewAngle());
        if ((grenadeInfo &&  distOnScreen < actDistOnScreen) || actDistOnScreen > Options::GrenadeHelper::aim_fov) {
            continue;
        }

        grenadeInfo = act;
        distOnScreen = actDistOnScreen;
        dist = dist3D;
    }

    if (!grenadeInfo) {
        return;
    }

    if (!shootThisTick && shotLastTick && dist < 5) {
        QAngle newViewAngle = grenadeInfo->angle;
        if (grenadeInfo->tType == ThrowType::JUMP) {
            cmd->buttons |= IN_JUMP;
        }
        if (grenadeInfo->tType == ThrowType::WALK) {
            cmd->buttons |= IN_WALK;
        }

        if (Options::GrenadeHelper::smoothaim) {
            CLegitBot::SmoothAngle(newViewAngle, cmd->viewangles, cmd);
        }

        Math::NormalizeAngles(newViewAngle);
        Math::ClampAngle(newViewAngle);

        if (newViewAngle.IsValid()) {
            Engine->SetViewAngles(newViewAngle);
        }
    } else {
        if (dist > 0.5f) {
            QAngle movement = Math::CalcAngle(LocalPlayer->GetEyePos(), grenadeInfo->pos);
            if (cmd->forwardmove < dist) {
                cmd->forwardmove = dist * 2;
            }
            cmd->sidemove = 0;
            cmd->buttons |= IN_WALK;

            Math::NormalizeAngles(movement);
            Math::ClampAngle(movement);

            Math::CorrectMovement(movement, cmd, cmd->forwardmove, cmd->sidemove);
        }
        if (cmd->viewangles != grenadeInfo->angle) {
            QAngle oldViewAngle = cmd->viewangles;
            QAngle newViewAngle = grenadeInfo->angle;

            if (Options::GrenadeHelper::smoothaim) {
                CLegitBot::SmoothAngle(newViewAngle, cmd->viewangles, cmd);
            }

            Math::NormalizeAngles(newViewAngle);
            Math::ClampAngle(newViewAngle);
            if (newViewAngle.IsValid()) {
                Engine->SetViewAngles(newViewAngle);
                Math::CorrectMovement(oldViewAngle, cmd, cmd->forwardmove, cmd->sidemove);
            }
        }
    }
}

void Features::CGrenadeHelper::SavePosition(std::string Name, QAngle ViewAngle, Vector PlayerPosition, GrenadeType GrenadeType, int throwType, std::string mapName) {
    std::ofstream logFile;
    
    std::string filePath;
    filePath.append(Functions::GetSettingsDir());
    filePath.append("grenade_configs/");
    
    Functions::CreateDir(filePath);
    if (mapName == "") {
        filePath.append(Engine->GetLevelNameShort());
    } else {
        filePath.append(mapName);
    }
    filePath.append(".ini");

    logFile.open(filePath.c_str(), std::ios::out | std::ios::app);

    if (!logFile.good()) {
        logFile.close();
        return;
    }

    logFile << "[" << Name << "]" << std::endl;
    logFile << "position_x = " << PlayerPosition.x << std::endl;
    logFile << "position_y = " << PlayerPosition.y << std::endl;
    logFile << "position_z = " <<PlayerPosition.z << std::endl;
    logFile << "view_angle_x = " << ViewAngle.x << std::endl;
    logFile << "view_angle_y = " << ViewAngle.y << std::endl;
    logFile << "grenade_type = " << GrenadeType << std::endl;
    logFile << "throw_type = " << throwType << std::endl;
    logFile << std::endl;

    logFile.close();
}

void Features::CGrenadeHelper::CreateMove(CUserCmd* cmd) {
    AimAssist(cmd);
    shotLastTick = cmd->buttons & IN_ATTACK;
}

std::shared_ptr<Features::GrenadeInfo> Features::CGrenadeHelper::PrepareGrenadeInfo(std::shared_ptr<CSettingsManager> config, CSimpleIniA::Entry section) {
    return std::make_unique<GrenadeInfo>(
      (GrenadeType)config->GetSetting<int>(section.pItem, "grenade_type"),
      Vector(
          config->GetSetting<float>(section.pItem, "position_x"),
          config->GetSetting<float>(section.pItem, "position_y"),
          config->GetSetting<float>(section.pItem, "position_z")
      ),
      QAngle(
          config->GetSetting<float>(section.pItem, "view_angle_x"),
          config->GetSetting<float>(section.pItem, "view_angle_y"),
          0.f
      ),
      (ThrowType)config->GetSetting<int>(section.pItem, "throw_type"),
      section.pItem
    );
}

std::string Features::CGrenadeHelper::GetCurrentMapConfigName() {
    std::string configName;
    configName.append("grenade_configs/");
    configName.append(Functions::Basename(Engine->GetLevelNameShort()));
    configName.append(".ini");
    
    return configName;
}

std::shared_ptr<Features::CGrenadeHelper> GrenadeHelper = std::make_unique<Features::CGrenadeHelper>();
