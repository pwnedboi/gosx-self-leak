/******************************************************/
/**                                                  **/
/**      Features/StreamProof.mm                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "StreamProof.h"

#ifdef GOSX_STREAM_PROOF
void Features::CStreamProof::FrameStageNotify() {
    if (this->syphon_injected || !Options::Main::enabled) {
        return;
    }
    
    this->syphon_injected = reinterpret_cast<uintptr_t>(dlsym(RTLD_DEFAULT, "CGLFlushDrawableOverride")) != 0x0;
    if (this->syphon_injected) {
        this->capture_buffer = reinterpret_cast<GLint*>(dlsym(RTLD_DEFAULT, "capture_buffer"));
        if (this->Active(true)) {
            GUI::MessagePopup::AddMessage("Stream-proof mode activated!\n\nSome features have been deavtivated:\n- Chams\n- Glow\n- Night-Mode\n- FOV-Changer\n- Gray Textures\n...\n\nYou also should disable Skins and Gloves to look the most legit on stream.", MESSAGE_TYPE_INFO, 5500);
        }
    }
}

bool Features::CStreamProof::Active(bool _liveCheck) {
    return this->SyphonInjected() && (_liveCheck ? CSettingsManager::Instance(currentConfigName)->GetSetting<bool>("Improvements", "stream_proof", Options::Improvements::stream_proof) : Options::Improvements::stream_proof);
}

void Features::CStreamProof::ToogleCaptureBuffer(bool _active) {
    if (!this->capture_buffer) {
        return;
    }
    
    if (_active) {
        *this->capture_buffer = GL_BACK;
    } else {
        *this->capture_buffer = GL_FRONT;
    }
}

bool Features::CStreamProof::SyphonInjected() {
    return this->syphon_injected && this->capture_buffer != nullptr;
}

std::shared_ptr<Features::CStreamProof> StreamProof = std::make_unique<Features::CStreamProof>();
#endif
