/******************************************************/
/**                                                  **/
/**      Hooks/CreateMove.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CreateMove.h"

#ifdef GOSX_THIRDPERSON
Vector* Glob::ThirdpersonAngles = nullptr;
#endif
#ifdef GOSX_RAGE_MODE
bool* CreateMove::SendPacket = nullptr;
#endif

void FeatureManager::CreateMoveFeature::CreateMove(void* thisptr, float sample_input_frametime, CUserCmd* pCmd) {
    if (!pCmd || !pCmd->command_number) {
        return;
    }
    
    if (!Options::Main::enabled || GUI::IsVisible || (!Engine->IsInGame() && !Engine->IsConnected())) {
        return;
    }
    
    C_CSPlayer* LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer || (LocalPlayer->GetTeamNum() != TEAM_T && LocalPlayer->GetTeamNum() != TEAM_CT)) {
        return;
    }
    
#ifdef GOSX_RAGE_MODE
    *Glob::SendPacket = *CreateMove::SendPacket;
    *CreateMove::SendPacket = true;
#endif
    
    Ranks->CreateMove(pCmd);
    BunnyHop->CreateMove(pCmd);
#ifdef GOSX_RAGE_MODE
    AutoStrafe->CreateMove(pCmd);
    CircleStrafe->CreateMove(pCmd);
#endif
    WeaponSwitch->CreateMove(pCmd);
    GrenadeHelper->CreateMove(pCmd);
    GrenadePrediction->CreateMove(pCmd);
    
#ifdef GOSX_RAGE_MODE
    if (Options::Rage::enabled) {
        EnginePrediction->Start(pCmd);
        {
            AntiAim->CreateMove(pCmd);
            RageBot->CreateMove(pCmd);
            FakeLag->CreateMove(pCmd);
            FakeWalk->CreateMove(pCmd);
            TriggerBot->CreateMove(pCmd);
            KnifeBot->CreateMove(pCmd);
            AlwaysRCS->CreateMove(pCmd);
        
#ifdef GOSX_BACKTRACKING
            Backtracking->CreateMove(pCmd);
#endif
        }
        EnginePrediction->End();
    } else {
#endif
        Aim->CreateMove(pCmd);
        TriggerBot->CreateMove(pCmd);
        KnifeBot->CreateMove(pCmd);
        AlwaysRCS->CreateMove(pCmd);
        
#ifdef GOSX_BACKTRACKING
        Backtracking->CreateMove(pCmd);
#endif
#ifdef GOSX_RAGE_MODE
    }
#endif
    
#ifdef GOSX_RAGE_MODE
    if (*CreateMove::SendPacket) {
#endif
#ifdef GOSX_THIRDPERSON
        *Glob::ThirdpersonAngles = pCmd->viewangles;
#endif
#ifdef GOSX_RAGE_MODE
    }
#endif
}

bool HookManager::HOOKED_CreateMove(void* thisptr, float sample_input_frametime, CUserCmd* pCmd) {
    static CreateMoveFn oCreateMove = vmtClientMode->orig<CreateMoveFn>(INDEX_CREATEMOVE);
    oCreateMove(thisptr, sample_input_frametime, pCmd);

    FeatureManager::CreateMoveFeature::CreateMove(thisptr, sample_input_frametime, pCmd);
    
    return false;
}
