/******************************************************/
/**                                                  **/
/**      Features/Esp.cpp                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Esp.h"

void Features::CEsp::ImDrawPlayerVisuals() {
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    if (
        !Options::Drawing::playeresp &&
        !Options::Drawing::smoke_esp &&
        !Options::Drawing::bone_esp &&
        !Options::Drawing::weapon_esp &&
        !Options::Drawing::grenade_esp &&
        !Options::Drawing::defusekit_esp &&
        !Options::Drawing::bomb_esp
    ) {
        return;
    }
    
    for (int i = 1; i <= Engine->GetMaxClients(); i++) {
        C_CSPlayer* PlayerEntity = (C_CSPlayer*)EntList->GetClientEntity(i);
        if (!PlayerEntity || !PlayerEntity->IsValidLivePlayer() || PlayerEntity == LocalPlayer) {
            continue;
        }

        this->DrawESP(PlayerEntity);
        this->DrawSmokeESP(PlayerEntity);
        this->DrawBoneESP(PlayerEntity);
        this->DrawEntityViewLine(PlayerEntity);
    }
    
    if (
        !Options::Drawing::weapon_esp &&
        !Options::Drawing::grenade_esp &&
        !Options::Drawing::defusekit_esp &&
        !Options::Drawing::bomb_esp
    ) {
        return;
    }
    
    for (int i = Engine->GetMaxClients(); i < EntList->GetHighestEntityIndex(); i++) {
        C_BaseEntity* Entity = (C_BaseEntity*)EntList->GetClientEntity(i);
        if (!Entity) {
            continue;
        }
        
        ClientClass* cclass = Entity->GetClientClass();
        if (!cclass) {
            continue;
        }
        
        if (Options::Drawing::weapon_esp && Entity->IsWeapon()) {
            this->DrawWeaponESP(Entity);
            
            continue;
        }
        
        if (Options::Drawing::grenade_esp && Entity->IsGrenade()) {
            this->DrawGrenadeESP(Entity);
        
            continue;
        }
        
        if (Options::Drawing::bomb_esp && (Entity->IsBomb() || Entity->IsPlantedBomb())) {
            this->DrawBombESP(Entity);
            
            continue;
        }
        
        if (Options::Drawing::defusekit_esp && Entity->IsDefuseKit()) {
            this->DrawDefuseESP(Entity);
            
            continue;
        }
    }
}

void Features::CEsp::DrawWeaponESP(C_BaseEntity *Entity) {
    if (!Options::Drawing::weapon_esp) {
        return;
    }

    if (!Entity) {
        return;
    }
    
    float x, y, w, h;
    if (!GetBox(Entity, &x, &y, &w, &h)) {
        return;
    }
    
    C_BaseCombatWeapon* weapon = (C_BaseCombatWeapon*)Entity;
    if (!weapon) {
        return;
    }
    
    int weaponItemDefinitionIndex = weapon->EntityId();
    if (ItemDefinitionIndex.find(weaponItemDefinitionIndex) == ItemDefinitionIndex.end()) {
        return;
    }
    
    Item_t EntityDefinitions = ItemDefinitionIndex.at(weaponItemDefinitionIndex);
    if (Options::Drawing::weapon_opt_boundingbox) {
        this->DrawBox(x, y, w, h, 5, 3, Options::Colors::color_weapon_visible, Options::Drawing::boundingbox_outline);
    }
    if (Options::Drawing::weapon_opt_name) {
        Vector2D TextSize = DrawManager->GetTextSize(EntityDefinitions.display_name, GUI::Fonts::Section);
        DrawManager->DrawString(GUI::Fonts::Section, x + (w / 2), y - ((TextSize.y / 1) + 1), FONTFLAG_NONE, Color(255, 255, 255), true, EntityDefinitions.display_name);
    }
}

void Features::CEsp::DrawGrenadeESP(C_BaseEntity *Entity) {
    if (!Options::Drawing::grenade_esp) {
        return;
    }

    if (!Entity) {
        return;
    }
    
    float x, y, w, h;
    if (!GetBox(Entity, &x, &y, &w, &h)) {
        return;
    }
    
    C_BaseCombatWeapon* weapon = (C_BaseCombatWeapon*)Entity;
    if (!weapon) {
        return;
    }
    
    int weaponItemDefinitionIndex = weapon->EntityId();
    if (ItemDefinitionIndex.find(weaponItemDefinitionIndex) == ItemDefinitionIndex.end()) {
        return;
    }
    
    Item_t EntityDefinitions = ItemDefinitionIndex.at(weaponItemDefinitionIndex);
    Color grenadeColor = Options::Colors::color_weapon_visible;
    if (weaponItemDefinitionIndex == weapon_flashbang || weaponItemDefinitionIndex == weapon_decoy) {
        grenadeColor = Options::GrenadeHelper::color_grenade_flash;
    } else if (weaponItemDefinitionIndex == weapon_hegrenade) {
        grenadeColor = Options::GrenadeHelper::color_grenade_he;
    } else if (weaponItemDefinitionIndex == weapon_smokegrenade) {
        grenadeColor = Options::GrenadeHelper::color_grenade_smoke;
    } else if (weaponItemDefinitionIndex == weapon_incgrenade || weaponItemDefinitionIndex == weapon_molotov) {
        grenadeColor = Options::GrenadeHelper::color_grenade_inc;
    }

    if (Options::Drawing::grenade_opt_boundingbox) {
        this->DrawBox(x, y, w, h, 5, 3, grenadeColor, Options::Drawing::boundingbox_outline);
    }
    if (Options::Drawing::grenade_opt_name) {
        Vector2D TextSize = DrawManager->GetTextSize(EntityDefinitions.display_name, GUI::Fonts::Section);
        DrawManager->DrawString(GUI::Fonts::Section, x + (w / 2), y - ((TextSize.y / 1) + 1), FONTFLAG_NONE, Color(255, 255, 255), true, EntityDefinitions.display_name);
    }
}

void Features::CEsp::DrawBombESP(C_BaseEntity* Entity) {
    if (!Options::Drawing::bomb_esp) {
        return;
    }

    if (!Entity) {
        return;
    }
    
    float x, y, w, h;
    if (!GetBox(Entity, &x, &y, &w, &h)) {
        return;
    }
    
    if (Options::Drawing::bomb_opt_boundingbox) {
        Color BombColor = Entity->IsPlantedBomb() ? Options::Glow::color_planted_bomb : Options::Glow::color_dropped_bomb;
        DrawBox(x, y, w, h, 5, 3, BombColor, Options::Drawing::boundingbox_outline);
    }
    if (Options::Drawing::bomb_opt_name) {
        Vector2D TextSize = DrawManager->GetTextSize("Bomb", GUI::Fonts::Section);
        DrawManager->DrawString(GUI::Fonts::Section, x + (w / 2), y - ((TextSize.y / 1) + 1), FONTFLAG_NONE, Color(255, 255, 255), true, "Bomb");
    }
    if (Options::Drawing::bomb_opt_distance) {
        if (LocalPlayer->IsAlive() && !LocalPlayer->IsDormant()) {
            float distance = LocalPlayer->GetEyePos().DistTo(*Entity->GetOrigin()) * 0.01905f;
            DrawManager->DrawString(GUI::Fonts::Label, (int)(x + (w / 2)), (int)(y + h - 5), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%i M", (int)distance);
        }
    }
}

void Features::CEsp::DrawDefuseESP(C_BaseEntity* Entity) {
    if (!Options::Drawing::defusekit_esp) {
        return;
    }
    
    if (!LocalPlayer || LocalPlayer->GetTeamNum() == EntityTeam::TEAM_T || LocalPlayer->HasDefuser()) {
        return;
    }
    
    if (!Entity) {
        return;
    }
    
    float x, y, w, h;
    if (!GetBox(Entity, &x, &y, &w, &h)) {
        return;
    }
    
    if (Options::Drawing::bomb_opt_boundingbox) {
        DrawBox(x, y, w, h, 5, 3, Options::Glow::color_extra, Options::Drawing::boundingbox_outline);
    }
    if (Options::Drawing::bomb_opt_name) {
        Vector2D TextSize = DrawManager->GetTextSize("Defuse Kit", GUI::Fonts::Section);
        DrawManager->DrawString(GUI::Fonts::Section, x + (w / 2), y - ((TextSize.y / 1) + 1), FONTFLAG_NONE, Color(255, 255, 255), true, "Defuse Kit");
    }
    if (Options::Drawing::defusekit_opt_distance) {
        if (LocalPlayer->IsAlive() && !LocalPlayer->IsDormant()) {
            float distance = LocalPlayer->GetEyePos().DistTo(*Entity->GetOrigin()) * 0.01905f;
            DrawManager->DrawString(GUI::Fonts::Label, (int)(x + (w / 2)), (int)(y + h - 5), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%i M", (int)distance);
        }
    }
}

void Features::CEsp::DrawESP(C_CSPlayer* PlayerEntity) {
    if (!Options::Drawing::playeresp) {
        return;
    }

    if (!PlayerEntity || !PlayerEntity->IsValidLivePlayer() || PlayerEntity == LocalPlayer) {
        return;
    }
    
    if (!Options::Drawing::bone_esp_allies && PlayerEntity->GetTeamNum() == LocalPlayer->GetTeamNum()) {
        return;
    }

    Color clrTeam = Color(255, 255, 255, 255);
    Vector vMin, vMax;
    if (Utils::IsVisible(LocalPlayer, PlayerEntity, PlayerEntity->GetHitboxPosition(HITBOX_BODY, vMin, vMax), 180.0f, true)) {
        clrTeam = Options::Colors::color_ct_visible;
        if (PlayerEntity->GetTeamNum() == EntityTeam::TEAM_T) {
            clrTeam = Options::Colors::color_t_visible;
        }
    } else {
        clrTeam = Options::Colors::color_ct;
        if (PlayerEntity->GetTeamNum() == EntityTeam::TEAM_T) {
            clrTeam = Options::Colors::color_t;
        }
    }

    DrawESPForPlayer(PlayerEntity, clrTeam);
}

void Features::CEsp::DrawSmokeESP(C_CSPlayer* PlayerEntity) {
    if (!Options::Drawing::smoke_esp) {
        return;
    }
    
    if (Options::Drawing::playeresp || Options::Drawing::bone_esp) {
        return;
    }

    if (!PlayerEntity || !PlayerEntity->IsValidLivePlayer() || PlayerEntity == LocalPlayer) {
        return;
    }

    Vector vMin, vMax;
    Vector playerHead = PlayerEntity->GetHitboxPosition(HITBOX_HEAD, vMin, vMax);
    if (PlayerEntity->GetTeamNum() == LocalPlayer->GetTeamNum() || PlayerEntity->IsImmune() || !Utils::IsVisible(LocalPlayer, PlayerEntity, playerHead)) {
        return;
    }

    if (!Utils::LineGoesThroughSmoke(LocalPlayer->GetEyePos(), playerHead)) {
        return;
    }

    Vector HeadScreenPos;
    if (!Utils::WorldToScreen(playerHead, HeadScreenPos)) {
        return;
    }

    DrawManager->DrawTriangle(8, 4, Color(255, 255, 255, 255), (int)HeadScreenPos.x, (int)HeadScreenPos.y - 3, TriangleDirections::TRI_DOWN, true);
}

void Features::CEsp::DrawBoneESP(C_CSPlayer* PlayerEntity) {
    if (!Options::Drawing::bone_esp) {
        return;
    }

    if (!PlayerEntity || !PlayerEntity->IsValidLivePlayer() || PlayerEntity == LocalPlayer) {
        return;
    }

    if (!Options::Drawing::bone_esp_allies && PlayerEntity->GetTeamNum() == LocalPlayer->GetTeamNum()) {
        return;
    }

    QAngle viewAngle;
    Engine->GetViewAngles(viewAngle);

    studiohdr_t* pStudioModel = ModelInfo->GetStudioModel(PlayerEntity->GetModel());
    if (!pStudioModel) {
        return;
    }
    
    static matrix3x4_t matrix[MAX_STUDIO_BONES];
    if (!PlayerEntity->SetupBones(matrix, MAX_STUDIO_BONES, BONE_USED_BY_HITBOX, PlayerEntity->GetSimulationTime())) {
        return;
    }
    static int iChestBone = 6;
    
    for (int i = 0; i < pStudioModel->numbones; i++) {
        mstudiobone_t* pBone = pStudioModel->pBone(i);
        if (!pBone || !(pBone->flags & BONE_USED_BY_HITBOX) || pBone->parent == -1) {
            continue;
        }

        Vector vBone1, vBoneOut1, vBone2, vBoneOut2;
        vBone1 = {matrix[i].m_flMatVal[0][3], matrix[i].m_flMatVal[1][3], matrix[i].m_flMatVal[2][3]};
        vBone2 = {matrix[pBone->parent].m_flMatVal[0][3], matrix[pBone->parent].m_flMatVal[1][3], matrix[pBone->parent].m_flMatVal[2][3]};
        
        Vector vBreastBone;
        Vector ChestboneParent = {matrix[iChestBone + 1].m_flMatVal[0][3], matrix[iChestBone + 1].m_flMatVal[1][3], matrix[iChestBone + 1].m_flMatVal[2][3]};
        Vector Chestbone = {matrix[iChestBone].m_flMatVal[0][3], matrix[iChestBone].m_flMatVal[1][3], matrix[iChestBone].m_flMatVal[2][3]};
        Vector vUpperDirection = ChestboneParent - Chestbone;
        vBreastBone = Chestbone + vUpperDirection / 2;
        Vector vDeltaChild = vBone1 - vBreastBone;
        Vector vDeltaParent = vBone2 - vBreastBone;

        if ((vDeltaParent.Length() < 9.0f && vDeltaChild.Length() < 9.0f)) {
            vBone2 = vBreastBone;
        }
        
        if (i == iChestBone - 1) {
            vBone1 = vBreastBone;
        }
        
        if ((abs(vDeltaChild.z) < 5 && (vDeltaParent.Length() < 5.0f && vDeltaChild.Length() < 5.0f)) || i == iChestBone) {
            continue;
        }

        if (!Utils::WorldToScreen(vBone1, vBoneOut1) || !Utils::WorldToScreen(vBone2, vBoneOut2)) {
            continue;
        }
        Color boneColor = Options::Drawing::color_bone_esp;
#ifdef GOSX_STREAM_PROOF
        if (StreamProof->Active()) {
            bool visible = Utils::IsVisible(LocalPlayer, PlayerEntity, vBone1) &&
                           Utils::IsVisible(LocalPlayer, PlayerEntity, vBone2);
            bool isTerror = PlayerEntity->GetTeamNum() == TEAM_T;
            boneColor = Options::Colors::color_ct;
            if (visible) {
                boneColor = Options::Colors::color_ct_visible;
            }
            if (isTerror) {
                boneColor = Options::Colors::color_t;
                if (visible) {
                    boneColor = Options::Colors::color_t_visible;
                }
            }
        }
#endif
        DrawManager->DrawLine(vBoneOut1.x, vBoneOut1.y, vBoneOut2.x, vBoneOut2.y, boneColor, 1.5f);
    }
}

void Features::CEsp::DrawCrossHair() {
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        if (GetCrosshairCvar()->GetInt() == 0) {
            GetCrosshairCvar()->SetValue(1);
        }
        
        return;
    }
    
    int halfScreenY = *Glob::SDLResH / 2;
    int halfScreenX = *Glob::SDLResW / 2;
    
    int posXstart;
    int posYstart;

    Color colorRed = Options::Drawing::crosshair_color;
    Color colorBlack = Color(0, 0, 0, 255);
    
    int crosshairX = 0, crosshairY = 0;

    if ((Options::Drawing::crosshair && Options::Drawing::recoil_crosshair == 1) || Options::Drawing::recoil_crosshair == 2) {
        QAngle punchAngle = LocalPlayer->AimPunch();

        if (punchAngle.x != 0.f || punchAngle.y != 0.f) {
            float settingsFov = 90.0f;
            if (Options::Improvements::fov_changer) {
                settingsFov = Options::Improvements::fov;
            }
            int dx = (int)(*Glob::SDLResW / settingsFov);
            int dy = (int)(*Glob::SDLResH / settingsFov);

            crosshairX = (int)(halfScreenX - (dx * punchAngle.y));
            crosshairY = (int)(halfScreenY + (dy * punchAngle.x));

            if (Options::Drawing::crosshair && Options::Drawing::recoil_crosshair == 1) {
                halfScreenX = crosshairX;
                halfScreenY = crosshairY;
            }
        }
    }

    if (!LocalPlayer->IsScoped() && Options::Drawing::crosshair) {
        bool canShow = true;
#ifdef GOSX_STREAM_PROOF
        if (StreamProof->Active()) {
            C_BaseCombatWeapon* activeWeapon = LocalPlayer->GetActiveWeapon();
            if (activeWeapon) {
                if (!WeaponManager::IsSniper(activeWeapon->EntityId())) {
                    canShow = false;
                }
            }
        }
#endif
        if (canShow) {
            int chthickness = Options::Drawing::crosshair_thickness;
            int chgap = Options::Drawing::crosshair_gap;
            int chwidth = Options::Drawing::crosshair_width;

            int halfThickness = (int)roundf(chthickness / 2);
            int halfWidth = (int)roundf(chwidth / 2);
            int halfGap = (int)roundf(chgap / 2);

            if (Options::Drawing::crosshair_outline) {
                posXstart = halfScreenX - halfThickness - 1;
                posYstart = halfScreenY - halfWidth - 1;
                DrawManager->DrawRect(posXstart, posYstart, chthickness + 2, (halfWidth - halfGap) + 2, colorBlack);
                posYstart = halfScreenY + (int)roundf(chgap / 2);
                DrawManager->DrawRect(posXstart, posYstart, chthickness + 2, (halfWidth - halfGap) + 2, colorBlack);
            }

            posXstart = halfScreenX - halfThickness;
            posYstart = halfScreenY - halfWidth;
            DrawManager->DrawRect(posXstart, posYstart, chthickness, (halfWidth - halfGap), colorRed);
            posYstart = halfScreenY + halfGap + 1;
            DrawManager->DrawRect(posXstart, posYstart, chthickness, (halfWidth - halfGap), colorRed);

            if (Options::Drawing::crosshair_outline) {
                posXstart = halfScreenX - halfWidth - 1;
                posYstart = halfScreenY - halfThickness - 1;
                DrawManager->DrawRect(posXstart, posYstart, (halfWidth - halfGap) + 2, chthickness + 2, colorBlack);
                posXstart = halfScreenX + halfGap;
                DrawManager->DrawRect(posXstart, posYstart, (halfWidth - halfGap) + 2, chthickness + 2, colorBlack);
            }

            posXstart = halfScreenX - halfWidth;
            posYstart = halfScreenY - halfThickness;
            DrawManager->DrawRect(posXstart, posYstart, (halfWidth - halfGap), chthickness, colorRed);
            posXstart = halfScreenX + halfGap + 1;
            DrawManager->DrawRect(posXstart, posYstart, (halfWidth - halfGap), chthickness, colorRed);
            
            if (GetCrosshairCvar()->GetInt() == 1) {
                GetCrosshairCvar()->SetValue(0);
            }
        } else {
            if (GetCrosshairCvar()->GetInt() == 0) {
                GetCrosshairCvar()->SetValue(1);
            }
        }
    } else {
        if (GetCrosshairCvar()->GetInt() == 0) {
            GetCrosshairCvar()->SetValue(1);
        }
    }
    
    if (Options::Drawing::recoil_crosshair == 2 && crosshairX > 0 && crosshairY > 0) {
        int rcsChSize = (Options::Drawing::crosshair_width / 2);
        
        if (Options::Drawing::crosshair_outline) {
            DrawManager->DrawRect((crosshairX - (Options::Drawing::crosshair_thickness / 2)) - 1, (crosshairY - (rcsChSize / 2)) - 1, Options::Drawing::crosshair_thickness + 2, rcsChSize + 2, colorBlack);
            DrawManager->DrawRect((crosshairX - (rcsChSize / 2)) - 1, (crosshairY - (Options::Drawing::crosshair_thickness / 2)) - 1, rcsChSize + 2, Options::Drawing::crosshair_thickness + 2, colorBlack);
        }
        
        DrawManager->DrawRect(crosshairX - (Options::Drawing::crosshair_thickness / 2), crosshairY - (rcsChSize / 2), Options::Drawing::crosshair_thickness, rcsChSize, Color(255, 255, 255));
        DrawManager->DrawRect(crosshairX - (rcsChSize / 2), crosshairY - (Options::Drawing::crosshair_thickness / 2), rcsChSize, Options::Drawing::crosshair_thickness, Color(255, 255, 255));
    }
}

void Features::CEsp::DrawFOVCircle() {
    if (!Options::Drawing::fovcircle || !Options::Aimbot::enabled) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    C_BaseCombatWeapon* currentWeapon = LocalPlayer->GetActiveWeapon();
    if (!currentWeapon || currentWeapon->GetAmmo() == 0 || !WeaponManager::IsValidWeapon(currentWeapon->EntityId())) {
        return;
    }
    
    DrawTheCircle((float)(*Glob::SDLResW / 2), (float)(*Glob::SDLResH / 2), LocalPlayer->IsScoped());
}

void Features::CEsp::DrawTheCircle(float x, float y, bool IsZoomedIn) {
    float aimbotFov = Options::Aimbot::fov_enabled ? Options::Aimbot::field_of_view : 360.0f;
#ifdef GOSX_RAGE_MODE
    if (Options::Rage::enabled && Options::Rage::fov_multiplier > 1.0f) {
        aimbotFov *= Options::Rage::fov_multiplier;
    }
#endif
    float settingsFov = 90.0f;
    if (Options::Improvements::fov_changer) {
        settingsFov = IsZoomedIn ? *Glob::ZoomedFov : Options::Improvements::fov;
    }
    
    float radius = tanf(DEG2RAD(aimbotFov) / 2) / tanf(DEG2RAD(settingsFov) / 2) * *Glob::SDLResW;
    
    bool Wallbangable = false;
    float WallbangDamage = 0.0f;
    if (Options::Drawing::show_wallbang_indicator && Engine->IsConnected() && Engine->IsInGame()) {
        if (LocalPlayer && LocalPlayer->IsValidLivePlayer()) {
            Wallbangable = AutoWalls->CanWallbang(LocalPlayer, WallbangDamage);
            
            if (WallbangDamage > 0.0f) {
                char ReadableDamage[55];
                sprintf(ReadableDamage, "%.2f", WallbangDamage);
                
                DrawManager->DrawString(GUI::Fonts::Label, (int)(x + radius), (int)(y - radius), FONTFLAG_NONE, Color(255, 255, 255), false, ReadableDamage);
            }
        }
    }
    
    DrawManager->Circle(Vector2D(x, y), radius * 1.5f, radius, Wallbangable ? Options::Colors::wallbang_indicator_color : Options::Colors::fov_circle);
}

void Features::CEsp::DrawScope() {
    if (!Options::Improvements::no_scope
#ifdef GOSX_STREAM_PROOF
        || StreamProof->Active()
#endif
    ) {
        return;
    }

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer() || !LocalPlayer->IsScoped()) {
        return;
    }

    static Color black = Color(0, 0, 0, 155);

    static int ResHalfW = *Glob::SDLResW / 2;
    static int ResHalfH = *Glob::SDLResH / 2;
    DrawManager->DrawLine(ResHalfW, 0, ResHalfH, *Glob::SDLResH, Options::Drawing::crosshair_color);
    if (Options::Drawing::crosshair_outline) {
        DrawManager->DrawLine(ResHalfW + 1, 0, ResHalfH + 1, *Glob::SDLResH, black);
    }
    DrawManager->DrawLine(0, ResHalfH, *Glob::SDLResW, ResHalfH, Options::Drawing::crosshair_color);
    if (Options::Drawing::crosshair_outline) {
        DrawManager->DrawLine(0, ResHalfH + 1, *Glob::SDLResW, ResHalfH + 1, black);
    }
}

void Features::CEsp::DrawESPForPlayer(C_CSPlayer *PlayerEntity, Color clrTeam) {
    if (!LocalPlayer) {
        return;
    }
    
    if (!PlayerEntity || PlayerEntity->IsDormant() || !PlayerEntity->IsAlive()) {
        return;
    }
    
    float x, y, w, h;
    if (!GetBox(PlayerEntity, &x, &y, &w, &h)) {
        return;
    }
    
    float leftSideTopPadding = 0.0f;
    leftSideTopPadding += GUI::Fonts::CstrikeIcons->FontSize / 2;
    float oldScale = GUI::Fonts::CstrikeIcons->Scale;
    float FontScale = oldScale;
    float distance = GUI::Fonts::CstrikeIcons->FontSize;
    if (LocalPlayer->IsAlive() && !LocalPlayer->IsDormant()) {
        Vector entityPosition = PlayerEntity->GetBonePosition((int)PlayerBones::Upper_Chest);
        Vector lpPosition = LocalPlayer->GetEyePos();
        distance = lpPosition.DistTo(entityPosition);
        
        FontScale = GUI::Fonts::CstrikeIcons->FontSize / Utils::Clamp<float, float>(distance * 0.0725, GUI::Fonts::CstrikeIcons->FontSize, 1000.0f);
        GUI::Fonts::CstrikeIcons->Scale = FontScale;
    }
    
    if (Options::Drawing::draw_boundingbox) {
        DrawBox(x, y, w, h, 3, 5, clrTeam, Options::Drawing::boundingbox_outline);
    }
    
    if (Options::Drawing::draw_name) {
        player_info_t info;
        if (Engine->GetPlayerInfo(PlayerEntity->EntIndex(), &info)) {
            DrawManager->DrawString(GUI::Fonts::Section, (int)(x + (w / 2)), (int)(y - (GUI::Fonts::Section->FontSize / 2) - 1), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", info.name);
        }
    }
    
    
    if (PlayerEntity->GetTeamNum() == TEAM_T) {
        if (Options::Drawing::draw_c4 && (*GameRules)->IsBombDefuseMap() && (*PlayerResource)->HasC4(PlayerEntity->EntIndex())) {
            Vector2D textSize = DrawManager->GetTextSize(ICON_CSGO_C4, GUI::Fonts::CstrikeIcons);
            DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + w + 5 + (textSize.x / 2)), (int)(y + leftSideTopPadding), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", ICON_CSGO_C4);
            
            leftSideTopPadding += ((textSize.y + 2) * FontScale);
        }
    }
    
    if (Options::Drawing::draw_armor) {
        bool HasArmor = PlayerEntity->GetArmor() > 0;
        bool HasHelmet = PlayerEntity->HasHelmet();
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
            
            leftSideTopPadding += ((textSize.y + 2) * FontScale);
        }
    }
    
    if (PlayerEntity->GetTeamNum() == TEAM_CT) {
        if (Options::Drawing::draw_defkit && (*GameRules)->IsBombDefuseMap() && PlayerEntity->HasDefuser()) {
            Vector2D textSize = DrawManager->GetTextSize(ICON_CSGO_DEFUSEKIT, GUI::Fonts::CstrikeIcons);
            DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + w + 5 + (textSize.x / 2)), (int)(y + leftSideTopPadding), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", ICON_CSGO_DEFUSEKIT);
        }
    }
    
    if (Options::Drawing::draw_armorbar) {
        int armor = PlayerEntity->GetArmor();
        
        if (armor > 0) {
            if (armor > 100) {
                armor = 100;
            }
            
            int armorBarHeight = (int)((h - 2) * armor / 100);
            DrawManager->DrawRect(x - (!Options::Drawing::draw_healthbar ? 5 : 9), y, 4, h, Color(0, 0, 0, 255));
            if (armorBarHeight > 0) {
                DrawManager->DrawRect(x - (!Options::Drawing::draw_healthbar ? 4 : 8), y + 1 + ((h - 2) - armorBarHeight), 2, armorBarHeight, Color(0, 153, 255, 255));
            }
        }
    }
    
    if (Options::Drawing::draw_healthbar) {
        int health = PlayerEntity->GetHealth();
        
        if (health > 100) {
            health = 100;
        }
        
        int r = (int)(255 - health * 2.55);
        int g = (int)(health * 2.55);
        
        float healthBarHeight = (int)((h - 2) * health / 100);
        DrawManager->DrawRect(x - 5, y, 4, h, Color(0, 0, 0, 255));
        if (healthBarHeight > 0) {
            DrawManager->DrawRect(x - 4, (int)(y + 1 + (h - 2) - healthBarHeight), 2, (int)healthBarHeight, Color(r, g, 0, 255));
            if (Options::Drawing::draw_healthnumber) {
                DrawManager->DrawString(GUI::Fonts::Label, x - 2, (int)(y + 1 + (h - 2) - healthBarHeight), FONTFLAG_OUTLINE, Color(255, 255, 255), true, "%i", health);
            }
        }
    }
    
    if (Options::Drawing::draw_weapon_name) {
        C_BaseCombatWeapon* entityWeapon = PlayerEntity->GetActiveWeapon();
        if (entityWeapon) {
            Vector2D textSize = DrawManager->GetTextSize(entityWeapon->GetGunIcon().c_str(), GUI::Fonts::CstrikeIcons);
            DrawManager->DrawString(GUI::Fonts::CstrikeIcons, (int)(x + (w / 2)), (int)(y + h + (textSize.y / 2) + 2), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%s", entityWeapon->GetGunIcon().c_str());
        }
    }
    
    if (Options::Drawing::draw_distance) {
        if (LocalPlayer->IsAlive()) {
            distance *= 0.01905f;
            
            DrawManager->DrawString(GUI::Fonts::Label, (int)(x + (w / 2)), (int)(y + h - 10), FONTFLAG_NONE, Color(255, 255, 255, 255), true, "%i M", (int)distance);
        }
    }
    
    GUI::Fonts::CstrikeIcons->Scale = oldScale;
    GUI::Fonts::Section->Scale = oldScale;
    GUI::Fonts::Label->Scale = oldScale;
}

bool Features::CEsp::GetBox(C_BaseEntity* Entity, float *x, float *y, float *w, float *h) {
    Vector origin, min, max;
    origin = *Entity->GetOrigin();
    
    if (origin.x == 0.0f && origin.y == 0.0f && origin.z == 0.0f) {
        return false;
    }
    
    min = Entity->Collideable()->OBBMins() + origin;
    max = Entity->Collideable()->OBBMaxs() + origin;

    Vector pointList[] = {
        Vector(min.x, min.y, min.z),
        Vector(min.x, max.y, min.z),
        Vector(max.x, max.y, min.z),
        Vector(max.x, min.y, min.z),
        Vector(max.x, max.y, max.z),
        Vector(min.x, max.y, max.z),
        Vector(min.x, min.y, max.z),
        Vector(max.x, min.y, max.z)
    };
    
    Vector flb, brt, blb, frt, frb, brb, blt, flt;
    
    if (
        !Utils::WorldToScreen(pointList[3], flb) ||
        !Utils::WorldToScreen(pointList[5], brt) ||
        !Utils::WorldToScreen(pointList[0], blb) ||
        !Utils::WorldToScreen(pointList[4], frt) ||
        !Utils::WorldToScreen(pointList[2], frb) ||
        !Utils::WorldToScreen(pointList[1], brb) ||
        !Utils::WorldToScreen(pointList[6], blt) ||
        !Utils::WorldToScreen(pointList[7], flt)
    ) {
        return false;
    }
    
    Vector arr[] = { flb, brt, blb, frt, frb, brb, blt, flt };
    
    float left = flb.x;
    float top = flb.y;
    float right = flb.x;
    float bottom = flb.y;
    
    for (int i = 1; i < 8; i++) {
        if (left > arr[i].x) {
            left = arr[i].x;
        }
        if (bottom < arr[i].y) {
            bottom = arr[i].y;
        }
        if (right < arr[i].x) {
            right = arr[i].x;
        }
        if (top > arr[i].y) {
            top = arr[i].y;
        }
    }
    
    *x = left;
    *y = top;
    *w = right - left;
    *h = bottom - top;

    return true;
}

void Features::CEsp::DrawBox(float x, float y, float w, float h, int cx, int cy, Color clrColor, bool outline) {
    int xElementWidth = w / cx;
    int yElementHeight = h / cy;
    int elementHeight = 1;
    int elementWidth = 1;
    
    int offset = 0;
    if (outline) {
        elementHeight = 3;
        elementWidth = 3;
        xElementWidth += 2;
        yElementHeight += 2;

        DrawManager->DrawRect(x + offset, y + offset, xElementWidth, elementHeight, Color(0, 0, 0));
        DrawManager->DrawRect(x + offset, y + offset, elementHeight, yElementHeight, Color(0, 0, 0));
        
        DrawManager->DrawRect(x + w - xElementWidth + offset, y + offset, xElementWidth, elementHeight, Color(0, 0, 0));
        DrawManager->DrawRect(x + w - elementWidth + offset, y + offset, elementWidth, yElementHeight, Color(0, 0, 0));
        
        DrawManager->DrawRect(x + offset, y + h - elementHeight + offset, xElementWidth, elementHeight, Color(0, 0, 0));
        DrawManager->DrawRect(x + offset, y + h - yElementHeight + offset, elementWidth, yElementHeight, Color(0, 0, 0));
        
        DrawManager->DrawRect(x + w - xElementWidth + offset, y + h - elementHeight + offset, xElementWidth, elementHeight, Color(0, 0, 0));
        DrawManager->DrawRect(x + w - elementWidth + offset, y + h - yElementHeight + offset, elementWidth, yElementHeight, Color(0, 0, 0));
        
        elementHeight = 1;
        elementWidth = 1;
        xElementWidth -= 2;
        yElementHeight -= 2;
        offset = 1;
    }
    
    DrawManager->DrawRect(x + offset, y + offset, xElementWidth, elementHeight, clrColor);
    DrawManager->DrawRect(x + offset, y + offset, elementHeight, yElementHeight, clrColor);
    
    DrawManager->DrawRect(x + w - xElementWidth - offset, y + offset, xElementWidth, elementHeight, clrColor);
    DrawManager->DrawRect(x + w - elementWidth - offset, y + offset, elementWidth, yElementHeight, clrColor);
    
    DrawManager->DrawRect(x + offset, y + h - elementHeight - offset, xElementWidth, elementHeight, clrColor);
    DrawManager->DrawRect(x + offset, y + h - yElementHeight - offset, elementWidth, yElementHeight, clrColor);
    
    DrawManager->DrawRect(x + w - xElementWidth - offset, y + h - elementHeight - offset, xElementWidth, elementHeight, clrColor);
    DrawManager->DrawRect(x + w - elementWidth - offset, y + h - yElementHeight - offset, elementWidth, yElementHeight, clrColor);
}

void Features::CEsp::DrawEntityViewLine(C_CSPlayer* Entity) {
    if (!Options::Drawing::entity_view_lines) {
        return;
    }
    
    if (!Options::Drawing::bone_esp_allies && Entity->GetTeamNum() == LocalPlayer->GetTeamNum()) {
        return;
    }

    QAngle EntityViewAngle = Entity->GetViewAngle();
    
    Vector traceStart, traceEnd, forward;
    trace_t tr;
    
    Math::AngleVectors(EntityViewAngle, forward);
    
    traceStart = Entity->GetEyePos() + (forward * 10.0f);
    traceEnd = traceStart + (forward * 8192.0f);

    Ray_t ray;
    CTraceFilter traceFilter;
    traceFilter.pSkip = Entity;
    
    ray.Init(traceStart, traceEnd);
    Trace->TraceRay(ray, MASK_SHOT, &traceFilter, &tr);

    Vector ScreenStart, ScreenEnd;
    if (
        !Utils::WorldToScreen(traceStart, ScreenStart) ||
        !Utils::WorldToScreen(tr.endpos, ScreenEnd)
    ) {
        return;
    }
    
    DrawManager->DrawLine(
        (int)ScreenStart.x,
        (int)ScreenStart.y,
        (int)ScreenEnd.x,
        (int)ScreenEnd.y,
        Options::Colors::wallbang_indicator_color,
        1.5f
    );
    Color EndPointColor = Options::Colors::wallbang_indicator_color;
    EndPointColor.SetA(120);
    DrawManager->FilledCircle(
        Vector2D(ScreenEnd.x, ScreenEnd.y),
        15.0f,
        3.0f,
        EndPointColor
    );
}

std::shared_ptr<Features::CEsp> ESP = std::make_unique<Features::CEsp>();
