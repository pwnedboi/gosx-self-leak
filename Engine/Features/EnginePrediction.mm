/******************************************************/
/**                                                  **/
/**      Features/EnginePrediction.mm                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "EnginePrediction.h"
#include "SDK/Checksum_MD5.h"

CEnginePrediction::CEnginePrediction() {}

CMoveData m_MoveData;

void CEnginePrediction::Start(CUserCmd* cmd) {
    m_flOldCurtime = (*GlobalVars)->curtime;
    m_flOldFrametime = (*GlobalVars)->frametime;
    
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    MoveHelper->SetHost(LocalPlayer);

    *m_nPredictionSeed = MD5_PseudoRandom(cmd->command_number) & 0x7FFFFFFF;

    oldPFlags = *LocalPlayer->GetFlags();

    (*GlobalVars)->curtime = LocalPlayer->GetTickBase() * (*GlobalVars)->interval_per_tick;
    (*GlobalVars)->frametime = (*GlobalVars)->interval_per_tick;

    GameMovement->StartTrackPredictionErrors(LocalPlayer);

    memset(&m_MoveData, 0, sizeof(m_MoveData));
    Prediction->SetupMove(LocalPlayer, cmd, MoveHelper, &m_MoveData);
    GameMovement->ProcessMovement(LocalPlayer, &m_MoveData);
    Prediction->FinishMove(LocalPlayer, cmd, &m_MoveData);
}

void CEnginePrediction::End() {
    if (!LocalPlayer) {
        return;
    }

    GameMovement->FinishTrackPredictionErrors(LocalPlayer);
    MoveHelper->SetHost(NULL);

    *m_nPredictionSeed = -1;
    *LocalPlayer->GetFlags() = oldPFlags;

    (*GlobalVars)->curtime = m_flOldCurtime;
    (*GlobalVars)->frametime = m_flOldFrametime;
}

std::shared_ptr<CEnginePrediction> EnginePrediction = std::make_unique<CEnginePrediction>();
