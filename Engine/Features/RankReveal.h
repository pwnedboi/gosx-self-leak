/******************************************************/
/**                                                  **/
/**      Features/RankReveal.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_RankReveal_h
#define Features_RankReveal_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    class CRankReveal {
    public:
        void CreateMove(CUserCmd* pCmd);
    };
}

extern std::shared_ptr<Features::CRankReveal> Ranks;

#endif /** !Features_RankReveal_h */
