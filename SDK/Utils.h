/******************************************************/
/**                                                  **/
/**      SDK/Utils.h                                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Utils_h
#define SDK_Utils_h

#include "SDK.h"
#include "CCSPlayer.h"
#include "KeyValues.h"
#include "Engine/Drawing/manager.h"

#define INRANGE(x, a, b)  (x >= a && x <= b) 
#define getBits(x)    (INRANGE((x&(~0x20)),'A','F') ? ((x&(~0x20)) - 'A' + 0xa) : (INRANGE(x,'0','9') ? x - '0' : 0))
#define getByte(x)    (getBits(x[0]) << 4 | getBits(x[1]))

class CHudChat;

typedef bool    (*LineGoesThroughSmokeFn) (Vector, Vector, bool);
typedef void    (*RankRevealAllFn) (float*);
typedef void    (*ForceFullUpdateFn) (int);
typedef int     (*RandomIntFn) (int, int);
typedef float   (*RandomFloatFn) (float, float);
typedef void    (*RandomSeedFn) (int);
typedef void    (*StartDrawingFn) (void*);
typedef void    (*FinishDrawingFn) (void*);
typedef void    (*InitKeyValuesFn) (KeyValues*, const char*);
typedef void    (*LoadFromBufferFn) (KeyValues*, const char*, const char*, void*, const char*, void*);
typedef void    (*SetSkyboxFn) (const char*);
#ifdef GOSX_RAGE_MODE
typedef void    (*SetClantagFn) (const char*, const char*);
#endif

enum STR_PAD {
    STR_PAD_RIGHT = 0,
    STR_PAD_LEFT,
    STR_PAD_BOTH
};

extern int* m_nPredictionSeed;

class C_CSPlayer;

namespace Utils {
    extern bool WorldToScreen(const Vector &point, Vector &screen);
    extern bool LineGoesThroughSmoke(Vector start, Vector end);
    extern void RankRevealAll(float* input);
    extern int RandomInt(int min, int max);
    extern void RandomSeed(int seed);
    extern float RandomFloat(float min, float max);
    extern bool IsVisible(C_CSPlayer* LocalPlayer, C_CSPlayer* pPlayer, int hitbox, float fov = 180.f, bool smokeCheck = false);
    extern bool IsVisible(C_CSPlayer* LocalPlayer, C_CSPlayer* pPlayer, Vector position, float fov = 180.f, bool smokeCheck = false);
    extern bool IsPointVisible(C_CSPlayer* LocalPlayer, Vector position, unsigned int fMask = MASK_SHOT, bool smokeCheck = false);
    extern bool IsPointBehind(C_CSPlayer* LocalPlayer, Vector position, QAngle playerAngles);
    extern void InitKeyValues(KeyValues* keyValues, const char* string);
    extern void LoadFromBuffer(KeyValues* keyValues, char const *resourceName, const char *pBuffer, void* pFileSystem = nullptr, const char *pPathID = NULL, void* pUnkF = nullptr);
    extern void InitPredictionData();
    extern std::string WstringToString(std::wstring wstr);
    extern void SetSkybox(std::string SkyboxName);
#ifdef GOSX_RAGE_MODE
    extern void SetClantag(std::string TagName, int suffixNum = 0);
#endif
    extern std::string StrPad(const std::string &str, int pad_length, std::string pad_string = " ", STR_PAD pad_type = STR_PAD_RIGHT);

    template<class T, class Y>
    extern T Clamp(T const &val, Y const &minVal, Y const &maxVal) {
        if (val < minVal) {
            return minVal;
        } else if (val > maxVal) {
            return maxVal;
        } else {
            return val;
        }
    }
    
    extern LineGoesThroughSmokeFn LineGoesThroughSmokeFunc;
    extern RankRevealAllFn RankRevealAllFunc;
    extern RandomIntFn RandomIntFunc;
    extern RandomFloatFn RandomFloatFunc;
    extern RandomSeedFn RandomSeedFunc;
    extern InitKeyValuesFn InitKeyValuesFunc;
    extern LoadFromBufferFn LoadFromBufferFunc;
    extern SetSkyboxFn SetSkyboxFunc;
#ifdef GOSX_RAGE_MODE
    extern SetClantagFn SetClantagFunc;
#endif
};

extern VMatrix& GetThreadSafeViewMatrix();

#endif /** !SDK_Utils_h */
