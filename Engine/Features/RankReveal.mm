/******************************************************/
/**                                                  **/
/**      Features/RankReveal.cpp                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "RankReveal.h"

void Features::CRankReveal::CreateMove(CUserCmd *pCmd) {
#ifdef GOSX_STREAM_PROOF
    if (!Options::Improvements::rankreveal || StreamProof->Active()) {
        return;
    }
#else
    if (!Options::Improvements::rankreveal) {
        return;
    }
#endif
    
    if (pCmd->buttons & IN_SCORE) {
        float input[3];
        Utils::RankRevealAll(input);
    }
}

std::shared_ptr<Features::CRankReveal> Ranks = std::make_unique<Features::CRankReveal>();
