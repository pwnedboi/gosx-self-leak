/******************************************************/
/**                                                  **/
/**      SDK/IDemoPlayer.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IDemoPlayer_h
#define SDK_IDemoPlayer_h

#include "SDK.h"

#ifdef GOSX_OVERWATCH_REVEAL
class DemoPlaybackParameter_t {
private:
    uint8_t    _pad0[0x10];
public:
    uint32_t    m_is_overwatch;
private:
    uint8_t    _pad1[0x88];
};

class CDemoFile;

class IDemoPlayer {
public:
    CDemoFile* GetDemoFile() {
        return *reinterpret_cast<CDemoFile**>(uintptr_t(this) + 0x8);
    }
    
    DemoPlaybackParameter_t* GetPlaybackParameter() {
        return *reinterpret_cast<DemoPlaybackParameter_t**>(uintptr_t(this) + 0x5F8);
    }
    
    bool IsInOverwatch() {
        DemoPlaybackParameter_t* PlaybackParameter = GetPlaybackParameter();
        return (PlaybackParameter && PlaybackParameter->m_is_overwatch);
    }
    
    void SetOverwatchState(bool state) {
        DemoPlaybackParameter_t* PlaybackParameter = GetPlaybackParameter();
        if (PlaybackParameter) {
            PlaybackParameter->m_is_overwatch = state;
        }
    }
    
    bool IsPlayingDemo() {
        typedef bool(*IsPlayingDemoFn) (void*);
        return Interfaces::Function<IsPlayingDemoFn>(this, 5)(this);
    }
    
    bool IsPlayingTimeDemo() {
        typedef bool(*IsPlayingTimeDemoFn) (void*);
        return Interfaces::Function<IsPlayingTimeDemoFn>(this, 7)(this);
    }
};

extern IDemoPlayer* DemoPlayer;
#endif

#endif /** !SDK_IDemoPlayer_h */
