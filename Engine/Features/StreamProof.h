/******************************************************/
/**                                                  **/
/**      Features/StreamProof.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_StreamProof_h
#define Features_StreamProof_h

#include "Engine/common.h"

#ifdef GOSX_STREAM_PROOF
namespace Features {
    class CStreamProof {
    public:
        void FrameStageNotify();
        bool Active(bool _liveCheck = false);
        void ToogleCaptureBuffer(bool _active = false);
        bool SyphonInjected();
    protected:
        bool syphon_injected = false;
        GLint* capture_buffer = nullptr;
    };
}

extern std::shared_ptr<Features::CStreamProof> StreamProof;
#endif

#endif /** !Features_StreamProof_h */
