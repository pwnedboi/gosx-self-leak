/******************************************************/
/**                                                  **/
/**      SDK/IEngineSound.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-16                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IEngineSound_h
#define SDK_IEngineSound_h

class Vector;

#define SOUND_FROM_UI_PANEL -2
#define SOUND_FROM_LOCAL_PLAYER -1
#define SOUND_FROM_WORLD 0

#define PITCH_NORM 100
#define PITCH_LOW 95
#define PITCH_HIGH 120

#define SND_STOP (1 << 2)
#define SND_STOP_LOOPING (1 << 5)

#define SNDLEVEL_TO_COMPATIBILITY_MODE(x)   ((soundlevel_t)(int)((x) + 256))
#define SNDLEVEL_FROM_COMPATIBILITY_MODE(x) ((soundlevel_t)(int)((x) - 256))
#define SNDLEVEL_IS_COMPATIBILITY_MODE(x)   ((x) >= soundlevel_t(256))

#define IENGINESOUND_CLIENT_INTERFACE_VERSION    "IEngineSoundClient003"
#define IENGINESOUND_SERVER_INTERFACE_VERSION    "IEngineSoundServer003"

enum soundlevel_t
{
    SNDLVL_NONE         = 0,
    SNDLVL_20dB         = 20,    // rustling leaves
    SNDLVL_25dB         = 25,    // whispering
    SNDLVL_30dB         = 30,    // library
    SNDLVL_35dB         = 35,
    SNDLVL_40dB         = 40,
    SNDLVL_45dB         = 45,    // refrigerator
    SNDLVL_50dB         = 50,    // 3.9    // average home
    SNDLVL_55dB         = 55,    // 3.0
    SNDLVL_IDLE         = 60,    // 2.0
    SNDLVL_60dB         = 60,    // 2.0    // normal conversation, clothes dryer
    SNDLVL_65dB         = 65,    // 1.5    // washing machine, dishwasher
    SNDLVL_STATIC       = 66,    // 1.25
    SNDLVL_70dB         = 70,    // 1.0    // car, vacuum cleaner, mixer, electric sewing machine
    SNDLVL_NORM         = 75,
    SNDLVL_75dB         = 75,    // 0.8    // busy traffic
    SNDLVL_80dB         = 80,    // 0.7    // mini-bike, alarm clock, noisy restaurant, office tabulator, outboard motor, passing snowmobile
    SNDLVL_TALKING      = 80,    // 0.7
    SNDLVL_85dB         = 85,    // 0.6    // average factory, electric shaver
    SNDLVL_90dB         = 90,    // 0.5    // screaming child, passing motorcycle, convertible ride on frw
    SNDLVL_95dB         = 95,
    SNDLVL_100dB        = 100,    // 0.4    // subway train, diesel truck, woodworking shop, pneumatic drill, boiler shop, jackhammer
    SNDLVL_105dB        = 105,    // helicopter, power mower
    SNDLVL_110dB        = 110,    // snowmobile drvrs seat, inboard motorboat, sandblasting
    SNDLVL_120dB        = 120,    // auto horn, propeller aircraft
    SNDLVL_130dB        = 130,    // air raid siren
    SNDLVL_GUNFIRE      = 140,    // 0.27    // THRESHOLD OF PAIN, gunshot, jet engine
    SNDLVL_140dB        = 140,    // 0.2
    SNDLVL_150dB        = 150,    // 0.2
    SNDLVL_180dB        = 180,    // rocket launching
};

typedef void* FileNameHandle_t;

struct SndInfo_t {
    int m_nGuid;
    FileNameHandle_t m_filenameHandle;
    int m_nSoundSource;
    int m_nChannel;
    int m_nSpeakerEntity;
    float m_flVolume;
    float m_flLastSpatializedVolume;
    float m_flRadius;
    int m_nPitch;
    Vector *m_pOrigin;
    Vector *m_pDirection;
    bool m_bUpdatePositions;
    bool m_bIsSentence;
    bool m_bDryMix;
    bool m_bSpeaker;
    bool m_bSpecialDSP;
    bool m_bFromServer;
};

class IRecipientFilter {
public:
    virtual         ~IRecipientFilter() {}
    virtual bool    IsReliable( void ) const = 0;
    virtual bool    IsInitMessage( void ) const = 0;
    virtual int     GetRecipientCount( void ) const = 0;
    virtual int     GetRecipientIndex( int slot ) const = 0;
};



class IEngineSound {
public:
    virtual bool PrecacheSound(const char *pSample, bool bPreload = false, bool bIsUISound = false) = 0;
    virtual bool IsSoundPrecached(const char *pSample) = 0;
    virtual void PrefetchSound(const char *pSample) = 0;
    virtual float GetSoundDuration(const char *pSample) = 0;
    virtual void EmitSound(IRecipientFilter& filter, int iEntIndex, int iChannel, const char *pSample,
                           float flVolume, float flAttenuation, int iFlags = 0, int iPitch = PITCH_NORM, int iSpecialDSP = 0,
                           const Vector *pOrigin = NULL, const Vector *pDirection = NULL, CUtlVector<Vector>* pUtlVecOrigins = NULL, bool bUpdatePositions = true, float soundtime = 0.0f, int speakerentity = -1) = 0;
    virtual void EmitSound(IRecipientFilter& filter, int iEntIndex, int iChannel, const char *pSample,
                           float flVolume, soundlevel_t iSoundlevel, int iFlags = 0, int iPitch = PITCH_NORM, int iSpecialDSP = 0,
                           const Vector *pOrigin = NULL, const Vector *pDirection = NULL, CUtlVector<Vector>* pUtlVecOrigins = NULL, bool bUpdatePositions = true, float soundtime = 0.0f, int speakerentity = -1) = 0;
    virtual void EmitSentenceByIndex(IRecipientFilter& filter, int iEntIndex, int iChannel, int iSentenceIndex,
                                     float flVolume, soundlevel_t iSoundlevel, int iFlags = 0, int iPitch = PITCH_NORM,int iSpecialDSP = 0,
                                     const Vector *pOrigin = NULL, const Vector *pDirection = NULL, CUtlVector<Vector>* pUtlVecOrigins = NULL, bool bUpdatePositions = true, float soundtime = 0.0f, int speakerentity = -1) = 0;
    virtual void StopSound(int iEntIndex, int iChannel, const char *pSample) = 0;
    virtual void StopAllSounds(bool bClearBuffers) = 0;
    virtual void SetRoomType(IRecipientFilter& filter, int roomType) = 0;
    virtual void SetPlayerDSP(IRecipientFilter& filter, int dspType, bool fastReset) = 0;
    virtual void EmitAmbientSound(const char *pSample, float flVolume, int iPitch = PITCH_NORM, int flags = 0, float soundtime = 0.0f) = 0;
    virtual float GetDistGainFromSoundLevel(soundlevel_t soundlevel, float dist) = 0;
    virtual int  GetGuidForLastSoundEmitted() = 0;
    virtual bool IsSoundStillPlaying(int guid) = 0;
    virtual void StopSoundByGuid(int guid) = 0;
    virtual void SetVolumeByGuid(int guid, float fvol) = 0;
    virtual void GetActiveSounds(CUtlVector<SndInfo_t>& sndlist) = 0;
    virtual void PrecacheSentenceGroup(const char *pGroupName) = 0;
    virtual void NotifyBeginMoviePlayback() = 0;
    virtual void NotifyEndMoviePlayback() = 0;
};

extern IEngineSound* Sound;

#endif /** !SDK_IEngineSound_h */
