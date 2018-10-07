/******************************************************/
/**                                                  **/
/**      Features/FlashReducer.h                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_FlashReducer_h
#define Features_FlashReducer_h

#include "SDK/CCSPlayer.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    class CFlashReducer {
    public:
        void FrameStageNotify();
    };
}

extern std::shared_ptr<Features::CFlashReducer> FlashReducer;

#endif /** !Features_FlashReducer_h */
