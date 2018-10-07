/******************************************************/
/**                                                  **/
/**      Features/HitMarker.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-05                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_HitMarker_h
#define Features_HitMarker_h

#include "SDK/SDK.h"
#include "Engine/Drawing/manager.h"
#include "Engine/Resource/hitmarker_mp3.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

namespace Features {
    struct HitMarkerData_t {
        void Init(bool DidDamage, float DamageTime) {
            this->DidDamage = DidDamage;
            this->DamageTime = DamageTime;
        }
        bool DidDamage = false;
        float DamageTime = 0.0f;
    };

    class CHitMarker {
    public:
        ~CHitMarker();
        void FireEvent(IGameEvent* event);
        void PaintTraverse();
        void ResetDamageData();
        void PlaySound();
    protected:
        HitMarkerData_t DamageData = {false, 0.0f};
        NSData* HitmarkerSound = nullptr;
        NSSound* HitmarkerSoundObject = nullptr;
    };
}

extern std::shared_ptr<Features::CHitMarker> HitMarker;

#endif /** !Features_HitMarker_h */
