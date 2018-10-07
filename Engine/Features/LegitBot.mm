/******************************************************/
/**                                                  **/
/**      Features/LegitBot.cpp                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "LegitBot.h"

Features::CLegitBot::CLegitBot() {
    this->RegisterKeyBind(
        "aim_enabled",
        &Options::Aimbot::toggle_key,
        &Options::Aimbot::enabled,
        "Aimbot",
        "enabled"
    );
}

int Features::CLegitBot::GetBestBone(C_CSPlayer* TargetEntity, CUserCmd* pCmd) {
    int BestBone = (int)Hitboxes::HITBOX_NONE;
    bool SmokeCheck = Options::Aimbot::smokecheck;
    bool IsFullLegit = Options::Aimbot::full_legit;

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return BestBone;
    }

    float closestBone = Options::Aimbot::fov_enabled ? Options::Aimbot::field_of_view : 180.0f;
    for (int hit = 0; hit < HITBOX_RIGHT_THIGH; hit++) {
        if (IsFullLegit && hit == Hitboxes::HITBOX_HEAD) {
            continue;
        }

        Vector vMin, vMax;
        Vector Hitbox = TargetEntity->GetPredictedPosition(hit, vMin, vMax);
        if (!Utils::IsVisible(LocalPlayer, TargetEntity, Hitbox, 180.0f, SmokeCheck)) {
            continue;
        }

        float fov = Math::GetFov(
            this->CurrentAngle,
            LocalPlayer->GetEyePos(),
            Hitbox
        );
        
        if (fov < closestBone) {
            BestBone = hit;
            closestBone = fov;
        }
    }

    return BestBone;
}

C_CSPlayer* Features::CLegitBot::FindTarget(CUserCmd* pCmd) {
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return nullptr;
    }

    float m_bestfov = Options::Aimbot::fov_enabled ? Options::Aimbot::field_of_view : 180.0f;

    C_CSPlayer* m_bestent = nullptr;
    EntityTeam lTeam = (EntityTeam)LocalPlayer->GetTeamNum();

    for (int i = 1; i <= Engine->GetMaxClients(); i++) {
        C_CSPlayer* entity = (C_CSPlayer*)EntList->GetClientEntity(i);
        if (!entity || !entity->IsValidLivePlayer() || entity->IsImmune()) {
            continue;
        }
        
        if (lTeam == (EntityTeam)entity->GetTeamNum()) {
            continue;
        }

        if (Options::Aimbot::enemy_onground_check && !entity->IsOnGround()) {
            continue;
        }

        int AimBone = Options::Aimbot::bone_mode == 1 ? Options::Aimbot::fixed_bone : this->GetBestBone(entity, pCmd);
        if ((Hitboxes)AimBone == Hitboxes::HITBOX_NONE) {
            continue;
        }

        Vector vMin, vMax;
        Vector Hitbox = entity->GetPredictedPosition(AimBone, vMin, vMax);
        if (!Utils::IsVisible(LocalPlayer, entity, Hitbox, 180.0f, Options::Aimbot::smokecheck)) {
            continue;
        }

        float fov = Math::GetFov(
            this->CurrentAngle,
            LocalPlayer->GetEyePos(),
            Hitbox
        );

        if (fov < m_bestfov) {
            m_lockedBone = (Hitboxes)AimBone;
            m_bestfov = fov;
            m_bestent = entity;
        }
    }

    if (!m_bestent || !m_bestent->IsValidLivePlayer() || m_bestent->IsImmune()) {
        return nullptr;
    }

    return m_bestent;
}

void Features::CLegitBot::AimTarget(CUserCmd* pCmd) {
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    EItemDefinitionIndex currWepIndex = (EItemDefinitionIndex)currentWeapon->EntityId();
    QAngle AimAngles;

    Vector vMin, vMax;
    Vector EnemyPos = m_lockedEntity->GetPredictedPosition((int)m_lockedBone, vMin, vMax);
    if (!Utils::IsVisible(LocalPlayer, m_lockedEntity, EnemyPos, 180.0f, Options::Aimbot::smokecheck)) {
        return;
    }
    
    /*if (Options::AntiCheat::targeting == 1) {
        Vector minDelta = vMin - EnemyPos;
        Vector maxDelta = vMax - EnemyPos;
        
        float RandomX = Utils::RandomFloat(minDelta.x, maxDelta.x);
        float RandomY = Utils::RandomFloat(minDelta.y, maxDelta.y);
        
        EnemyPos.x += RandomX;
        EnemyPos.y += RandomY;
    }*/
    
    Vector dir = LocalPlayer->GetEyePos() - EnemyPos;
    Math::VectorNormalize(dir);
    Math::VectorAngles(dir, AimAngles);

    this->RecoilControl(AimAngles, LocalPlayer);
    if (/*Options::AntiCheat::targeting == 0 && */!this->IsLowFovSilentAim()) {
        this->SmoothAngle(AimAngles, this->CurrentRawAngle, pCmd);
    }
    
    Math::NormalizeAngles(AimAngles);
    Math::ClampAngle(AimAngles);

    if (AimAngles.IsValid()) {
        *Glob::AimbotIsAiming = true;
        if (!Options::AntiCheat::mouse_event_aim && this->IsLowFovSilentAim()) {
            pCmd->viewangles = AimAngles;
        } else {
            /*if (Options::AntiCheat::faceit_safe) {
                float m_flSensitivity, m_flYaw, m_flPitch;
                if (this->GetMouseData(m_flSensitivity, m_flYaw, m_flPitch)) {
                    Vector Pixels = this->GetDeltaPixels(oldAngle, AnglesToWrite, m_flSensitivity, m_flPitch, m_flYaw);
                    pCmd->mousedx = Pixels.x;
                    pCmd->mousedy = Pixels.y;
                }
            }*/
            
            // Done and working
            if (Options::AntiCheat::mouse_event_aim || Options::AntiCheat::faceit_safe) {
                Vector Pixels = Vector();
                float m_flSensitivity, m_flYaw, m_flPitch;
                if (this->GetMouseData(m_flSensitivity, m_flYaw, m_flPitch)) {
                    Pixels = this->GetDeltaPixels(this->CurrentRawAngle, AimAngles, m_flSensitivity, m_flPitch, m_flYaw);
                }
                
                if (Pixels.IsValid()) {
                    NSPoint MousePointer = [NSEvent mouseLocation];
                    
                    float MouseMoveX, MouseMoveY;
                    MouseMoveX = MousePointer.x + Pixels.x;
                    MouseMoveY = MousePointer.y + Pixels.y;
                
                    CGEventRef mouseMove = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(MouseMoveX, MouseMoveY), kCGMouseButtonLeft);
                    CGEventPost(kCGHIDEventTap, mouseMove);
                    CFRelease(mouseMove);
                }
            } else {
                Math::NormalizeAngles(AimAngles);
                Math::ClampAngle(AimAngles);
                
                Engine->SetViewAngles(AimAngles);
            }
        }
        
        if (Options::Aimbot::delayed_shot) {
            this->DelayedShot(currentWeapon, pCmd);
        }
        if (Options::Extras::auto_cock_revolver && currWepIndex == EItemDefinitionIndex::weapon_revolver) {
            this->AutoCockRevolver(pCmd);
        }
    }
}

void Features::CLegitBot::Salt(float& smooth) {
    float sine = sin((*GlobalVars)->tickcount);
    float salt = sine * Options::Aimbot::smooth_salt_multiplier;
    float oval = smooth + salt;

    smooth *= oval;
}

void Features::CLegitBot::SmoothAngle(QAngle& angle, QAngle CurrentAngle, CUserCmd* pCmd, bool forceConstantSpeed) {
    if (!Options::Aimbot::smoothaim) {
        return;
    }

    QAngle delta = angle - CurrentAngle;
    Math::NormalizeAngles(delta);

    float smooth = powf(Options::Aimbot::smoothing_factor, 0.4f);
    smooth = std::min(0.959999f, smooth);

    if (Options::Aimbot::smooth_salting) {
        CLegitBot::Salt(smooth);
    }

    QAngle toChange = QAngle();

    if (Options::Aimbot::smooth_constant_speed || forceConstantSpeed) {
        float coeff = (1.0f - smooth) / delta.Length() * 4.0f;
        coeff = std::min(1.0f, coeff);
        toChange = delta * coeff;
    } else {
        toChange = delta - delta * smooth;
    }

    angle = CurrentAngle + toChange;
}

void Features::CLegitBot::CreateMove(CUserCmd* pCmd) {
    this->KeybindTick();
    
    if (!Options::Aimbot::enabled) {
        return;
    }

    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        this->Reset();
        
        return;
    }

    currentWeapon = LocalPlayer->GetActiveWeapon();
    if (!currentWeapon || !currentWeapon->CanShoot()) {
        this->Reset();
        
        return;
    }

    EItemDefinitionIndex currWepIndex = (EItemDefinitionIndex)currentWeapon->EntityId();
    if (Options::Aimbot::player_onground_check && !LocalPlayer->IsOnGround()) {
        this->Reset();
        
        return;
    }

    if (Options::Aimbot::flash_check && LocalPlayer->IsFlashed()) {
        this->Reset();
        
        return;
    }

    if (!WeaponManager::IsValidWeapon((int)currWepIndex)) {
        this->Reset();
        
        return;
    }

    ButtonCode_t aimKey = (ButtonCode_t)Options::Aimbot::aim_key;
    ButtonCode_t volverKey = ButtonCode_t::MOUSE_RIGHT;
    if (aimKey != ButtonCode_t::KEY_FIRST && aimKey != ButtonCode_t::MOUSE_LEFT) {
        volverKey = aimKey;
    } else {
        aimKey = ButtonCode_t::MOUSE_LEFT;
    }

    if (
        (!InputSystem->IsButtonDown(aimKey) && currWepIndex != EItemDefinitionIndex::weapon_revolver) ||
        (!InputSystem->IsButtonDown(volverKey) && currWepIndex == EItemDefinitionIndex::weapon_revolver)
    ) {
        this->Reset();
        
        return;
    }
    
    Engine->GetViewAngles(CurrentRawAngle);
    CurrentAngle = this->GetAimAngles();

    if (
        !m_lockedEntity ||
        m_lockedEntity->IsDormant() ||
        !m_lockedEntity->IsAlive() ||
        m_lockedEntity->GetHealth() < 1 ||
        m_lockedEntity->IsImmune() ||
        m_lockedBone == Hitboxes::HITBOX_NONE
    ) {
        this->Reset();

        m_lockedEntity = this->FindTarget(pCmd);
        if (
            !m_lockedEntity ||
            m_lockedEntity->IsDormant() ||
            !m_lockedEntity->IsAlive() ||
            m_lockedEntity->GetHealth() < 1 ||
            m_lockedEntity->IsImmune() ||
            m_lockedBone == Hitboxes::HITBOX_NONE
        ) {
            this->Reset();
            
            return;
        }
    }

    EnginePrediction->Start(pCmd);
    {
        this->AimTarget(pCmd);
    }
    EnginePrediction->End();
}

void Features::CLegitBot::DelayedShot(C_BaseCombatWeapon* weapon, CUserCmd* pCmd) {
    if (!weapon) {
        return;
    }

    if (
        weapon->GetAmmo() == 0 ||
        !WeaponManager::IsValidWeapon(weapon->EntityId()) ||
        !WeaponManager::IsDelayedWeapon(weapon->EntityId())
    ) {
        return;
    }

    pCmd->buttons &= ~IN_ATTACK;
    pCmd->buttons &= ~IN_ATTACK2;

    if (!LocalPlayer || !LocalPlayer->IsValidLivePlayer()) {
        return;
    }

    if (!m_lockedEntity || !m_lockedEntity->IsValidLivePlayer() || m_lockedEntity->IsImmune()) {
        return;
    }

    if (this->CanHitTarget(m_lockedEntity, weapon, pCmd)) {
        if (weapon->EntityId() == EItemDefinitionIndex::weapon_revolver) {
            pCmd->buttons |= IN_ATTACK2;
        } else {
            pCmd->buttons |= IN_ATTACK;
        }
    }
}

bool Features::CLegitBot::IsLowFovSilentAim() {
    return Options::Aimbot::silent_aim && Options::Aimbot::field_of_view <= 0.70f;
}

QAngle Features::CLegitBot::GetDeltaPixels(QAngle viewAngle, QAngle &AimAngle, const float m_flSensitivity, const float m_flYaw, const float m_flPitch) {
    Vector AimPixels = this->AnglesToPixels(viewAngle, AimAngle, m_flSensitivity, m_flPitch, m_flYaw);
    
    AimPixels.x = round(AimPixels.x / m_flSensitivity) * m_flSensitivity;
    AimPixels.y = round(AimPixels.y / m_flSensitivity) * m_flSensitivity;
    QAngle DeltaAngle = this->PixelsDeltaToAnglesDelta(AimPixels, m_flSensitivity, m_flPitch, m_flYaw);
    
    AimAngle = viewAngle + DeltaAngle;
    
    Math::NormalizeAngles(AimAngle);
    Math::ClampAngle(AimAngle);
    
    return this->AnglesToPixels(viewAngle, AimAngle, m_flSensitivity, m_flPitch, m_flYaw);
}

std::shared_ptr<Features::CLegitBot> Aim = std::make_unique<Features::CLegitBot>();
