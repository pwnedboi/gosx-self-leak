/******************************************************/
/**                                                  **/
/**      Features/ThirdPerson.mm                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "ThirdPerson.h"

#ifdef GOSX_THIRDPERSON
Features::CThirdPerson::CThirdPerson() {
    this->RegisterKeyBind(
        "tp_enabled",
        &Options::Thirdperson::toggle_key,
        &Options::Thirdperson::enabled,
        "Thirdperson",
        "enabled"
    );
}

void Features::CThirdPerson::ResetInput() {
    if (!Input) {
        Interfaces::InitInput();
    }
    
    Input->m_fCameraInThirdPerson = false;
    Input->m_vecCameraOffset.z = 0.0f;
}

void Features::CThirdPerson::OverrideView(CViewSetup *pSetup) {
#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        this->ResetInput();
        
        return;
    }
#endif
    
    if (!Options::Thirdperson::enabled) {
        this->ResetInput();
        
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        this->ResetInput();
        
        return;
    }
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }
    
    if (!Input) {
        Interfaces::InitInput();
    }
    
    if (
        WeaponManager::IsScopeWeapon(ActiveWeapon->EntityId()) &&
        !WeaponManager::IsSniper(ActiveWeapon->EntityId()) &&
        LocalPlayer->IsScoped()
    ) {
        this->ResetInput();
        
        return;
    }
    
    if (LocalPlayer->GetTeamNum() != TEAM_CT && LocalPlayer->GetTeamNum() != TEAM_T) {
        this->ResetInput();
        
        return;
    }
    
    Input->m_fCameraInThirdPerson = true;
    Input->m_vecCameraOffset.z = this->GetDistance(LocalPlayer, Options::Thirdperson::distance);
}

void Features::CThirdPerson::PreFrameStageNotify(ClientFrameStage_t stage) {
    if (stage != ClientFrameStage_t::FRAME_RENDER_START) {
        return;
    }
    
    if (!Engine->IsInGame() || !Engine->IsConnected()) {
        this->ResetInput();
        
        return;
    }
    
#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        this->ResetInput();
        
        return;
    }
#endif
    
    this->KeybindTick();
    
    if (!Options::Thirdperson::enabled || !Input->m_fCameraInThirdPerson) {
        this->ResetInput();
        
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || !LocalPlayer->IsAlive() || LocalPlayer->IsDormant()) {
        this->ResetInput();
        
        return;
    }
    
    C_BaseCombatWeapon* ActiveWeapon = LocalPlayer->GetActiveWeapon();
    if (!ActiveWeapon) {
        return;
    }
    
    if (
        WeaponManager::IsScopeWeapon(ActiveWeapon->EntityId()) &&
        !WeaponManager::IsSniper(ActiveWeapon->EntityId()) &&
        LocalPlayer->IsScoped()
    ) {
        this->ResetInput();
        
        return;
    }
    
    *LocalPlayer->ThirdpersonAngle() = *Glob::ThirdpersonAngles;
}

float Features::CThirdPerson::GetDistance(C_CSPlayer* LocalPlayer, float SettingsDistance) {
    Vector InverseAngles;
    Engine->GetViewAngles(InverseAngles);
    
    InverseAngles.x *= -1.f;
    InverseAngles.y += 180.f;
    
    Vector direction;
    Math::AngleVectors(InverseAngles, &direction);
    
    CTraceFilterWorldAndPropsOnly filter;
    trace_t trace;
    Ray_t ray;
    
    ray.Init(LocalPlayer->GetEyePos(), LocalPlayer->GetEyePos() + (direction * (SettingsDistance + 5.f)));
    Trace->TraceRay(ray, MASK_ALL, &filter, &trace);
    
    return SettingsDistance * trace.fraction;
}

std::shared_ptr<Features::CThirdPerson> ThirdPerson = std::make_unique<Features::CThirdPerson>();
#endif
