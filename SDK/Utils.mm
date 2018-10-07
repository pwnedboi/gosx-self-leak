/******************************************************/
/**                                                  **/
/**      SDK/Utils.cpp                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Utils.h"
#include "Engine/Features/LegitBot.h"
#include "Engine/Hooks/manager.h"

LineGoesThroughSmokeFn  Utils::LineGoesThroughSmokeFunc    = nullptr;
RankRevealAllFn         Utils::RankRevealAllFunc           = nullptr;
RandomIntFn             Utils::RandomIntFunc               = nullptr;
RandomFloatFn           Utils::RandomFloatFunc             = nullptr;
RandomSeedFn            Utils::RandomSeedFunc              = nullptr;
InitKeyValuesFn         Utils::InitKeyValuesFunc           = nullptr;
LoadFromBufferFn        Utils::LoadFromBufferFunc          = nullptr;
SetSkyboxFn             Utils::SetSkyboxFunc               = nullptr;
#ifdef GOSX_RAGE_MODE
SetClantagFn            Utils::SetClantagFunc              = nullptr;
#endif

int* m_nPredictionSeed = nullptr;

VMatrix& GetThreadSafeViewMatrix() {
    static VMatrix matrix;
    
    return matrix;
}

bool Utils::WorldToScreen(const Vector &origin, Vector &screen) {
    const VMatrix& w2sMatrix = GetThreadSafeViewMatrix();
    
    Vector4D clipCoords(
        (origin.x * w2sMatrix.m[0][0]) + (origin.y * w2sMatrix.m[0][1]) + (origin.z * w2sMatrix.m[0][2]) + w2sMatrix.m[0][3],
        (origin.x * w2sMatrix.m[1][0]) + (origin.y * w2sMatrix.m[1][1]) + (origin.z * w2sMatrix.m[1][2]) + w2sMatrix.m[1][3],
        0.0f,
        (origin.x * w2sMatrix.m[3][0]) + (origin.y * w2sMatrix.m[3][1]) + (origin.z * w2sMatrix.m[3][2]) + w2sMatrix.m[3][3]
    );
    
    if (clipCoords.w < 0.1f) {
        return false;
    }
    
    Vector screenCoords((clipCoords.x / clipCoords.w), (clipCoords.y / clipCoords.w), 0.0f);

    screen.x = ((*Glob::SDLResW / 2) * screenCoords.x) + (screenCoords.x + (*Glob::SDLResW / 2));
    screen.y = -((*Glob::SDLResH / 2) * screenCoords.y) + (screenCoords.y + (*Glob::SDLResH / 2));
    
    return true;
}

bool Utils::LineGoesThroughSmoke(Vector start, Vector end) {
    if (!LineGoesThroughSmokeFunc) {
        LineGoesThroughSmokeFunc = reinterpret_cast<LineGoesThroughSmokeFn>(
            PatternScanner->GetProcedure("client_panorama.dylib", "55 48 89 E5 41 57 41 56 41 54 53 48 83 EC ? F3 ? ? ? ? 0F")
        );
    }

    return LineGoesThroughSmokeFunc(start, end, true);
}

void Utils::RankRevealAll(float* input) {
    if (!RankRevealAllFunc) {
        RankRevealAllFunc = reinterpret_cast<RankRevealAllFn>(
            PatternScanner->GetPointer("client_panorama.dylib", "48 89 85 28 FE FF FF 48 C7 85 30 FE FF FF ? ? ? ? 48 8D 05", 0x15) + 0x4
        );
    }

    RankRevealAllFunc(input);
}

int Utils::RandomInt(int min, int max) {
    if (!RandomIntFunc) {
        RandomIntFunc = reinterpret_cast<RandomIntFn>(dlsym(RTLD_DEFAULT, "RandomInt"));
    }

    return RandomIntFunc(min, max);
}

float Utils::RandomFloat(float min, float max) {
    if (!RandomFloatFunc) {
        RandomFloatFunc = reinterpret_cast<RandomFloatFn>(dlsym(RTLD_DEFAULT, "RandomFloat"));
    }

    return RandomFloatFunc(min, max);
}

void Utils::RandomSeed(int seed) {
    if (!RandomSeedFunc) {
        RandomSeedFunc = reinterpret_cast<RandomSeedFn>(dlsym(RTLD_DEFAULT, "RandomSeed"));
    }
    
    RandomSeedFunc(seed);
}

bool Utils::IsVisible(C_CSPlayer* LocalPlayer, C_CSPlayer* pPlayer, int hitbox, float fov, bool smokeCheck) {
    Vector vMin, vMax;
    return IsVisible(LocalPlayer, pPlayer, pPlayer->GetPredictedPosition(hitbox, vMin, vMax), fov, smokeCheck);
}

bool Utils::IsVisible(C_CSPlayer* LocalPlayer, C_CSPlayer* pPlayer, Vector position, float fov, bool smokeCheck) {
    if (!LocalPlayer || !pPlayer) {
        return false;
    }

    if (pPlayer == LocalPlayer) {
        return false;
    }

    Vector LocalPlayerEyes = LocalPlayer->GetEyePos();

    QAngle viewAngles;
    Engine->GetViewAngles(viewAngles);
    viewAngles -= Aim->GetPunchAngle();

    if (Math::GetFov(viewAngles, LocalPlayerEyes, position) > fov) {
        return false;
    }

    Ray_t ray;
    trace_t tr;
    ray.Init(LocalPlayerEyes, position);
    CTraceFilter traceFilter;
    traceFilter.pSkip = LocalPlayer;

    Trace->TraceRay(ray, MASK_SHOT, &traceFilter, &tr);

    if (tr.allsolid || tr.startsolid) {
        return false;
    }

    if (smokeCheck && LineGoesThroughSmoke(LocalPlayerEyes, position)) {
        return false;
    }

    return tr.m_pEntityHit == pPlayer;
}

bool Utils::IsPointVisible(C_CSPlayer* LocalPlayer, Vector position, unsigned int fMask, bool smokeCheck) {
    if (!LocalPlayer) {
        return false;
    }
    
    Vector LocalPlayerEyes = LocalPlayer->GetEyePos();
    
    Ray_t ray;
    trace_t tr;
    ray.Init(LocalPlayerEyes, position);
    CTraceFilter traceFilter;
    traceFilter.pSkip = LocalPlayer;
    Trace->TraceRay(ray, fMask, &traceFilter, &tr);
    
    if (tr.allsolid || tr.startsolid) {
        return false;
    }
    
    if (smokeCheck && LineGoesThroughSmoke(LocalPlayerEyes, position)) {
        return false;
    }
    
    return tr.fraction >= 0.97f;
}

void Utils::InitKeyValues(KeyValues *keyValues, const char *string) {
    if (!InitKeyValuesFunc) {
        InitKeyValuesFunc = reinterpret_cast<InitKeyValuesFn>(
            PatternScanner->GetProcedure("client_panorama.dylib", "55 48 89 E5 41 56 53 48 83 EC ? 49 89 F6 48 89 FB C7 03")
        );
    }

    InitKeyValuesFunc(keyValues, string);
}

void Utils::LoadFromBuffer(KeyValues *keyValues, const char *resourceName, const char *pBuffer, void* pFileSystem, const char *pPathID, void* pUnkF) {
    if (!LoadFromBufferFunc) {
        LoadFromBufferFunc = reinterpret_cast<LoadFromBufferFn>(
            PatternScanner->GetProcedure("client_panorama.dylib", "48 83 EC ? 49 89 D6 49 89 F5 49 89 FC 41 B7 01 4D 85 F6") - 0xD
        );
    }

    LoadFromBufferFunc(keyValues, resourceName, pBuffer, pFileSystem, pPathID, pUnkF);
}

void Utils::InitPredictionData() {
    if (!m_nPredictionSeed) {
        m_nPredictionSeed = reinterpret_cast<int*>(
            PatternScanner->GetPointer("client_panorama.dylib", "48 8D 0D ? ? ? ? 89 01 5D C3", 0x3) + 0x4
        );
    }
    
    /*if (!m_MoveData) {
        m_MoveData = reinterpret_cast<CMoveData**>(
            PatternScanner->GetPointer("client.dylib", "48 8D 05 ? ? ? ? 48 8B 00 0F 57 C0 0F 2E 40 ? 73", 0x3) + 0x4
        );
    }*/
}

std::string Utils::WstringToString(std::wstring wstr) {
    try {
        return std::wstring_convert<std::codecvt_utf8<wchar_t>>().to_bytes(wstr);
    } catch (std::range_error) {
        std::stringstream s;
        s << wstr.c_str();
        return s.str();
    }
}

#ifdef GOSX_RAGE_MODE
void Utils::SetClantag(std::string TagName, int suffixNum) {
    if (!SetClantagFunc) {
        SetClantagFunc = reinterpret_cast<SetClantagFn>(
            PatternScanner->GetPointer("engine.dylib", "48 8D 3D ? ? ? ? 48 89 FE E8 ? ? ? ? E9", 0xB) + 0x4
        );
    }
    
    SetClantagFunc(TagName.c_str(), XorStr("gosx"));
}
#endif

std::string Utils::StrPad(const std::string &str, int pad_length, std::string pad_string, STR_PAD pad_type) {
    size_t i, j, x;
    size_t str_size = str.size();
    size_t pad_size = pad_string.size();
    if (pad_length <= str_size || pad_size < 1) {
        return str;
    }
    
    std::string o;
    o.reserve(pad_length);
    
    if (pad_type == STR_PAD_RIGHT) {
        for (i = 0, x = str_size; i < x; i++) {
            o.push_back(str[i]);
        }
        for (i = str_size; i < pad_length; ) {
            for (j = 0; j < pad_size && i < pad_length; j++, i++) {
                o.push_back(pad_string[j]);
            }
        }
    } else if (pad_type == STR_PAD_LEFT) {
        size_t a1 = pad_length - str_size;
        for (i = 0; i < a1;) {
            for (j = 0; j < pad_size && i < a1; j++, i++) {
                o.push_back( pad_string[j] );
            }
        }
        for (i = 0,x = str_size; i < x; i++) {
            o.push_back(str[i]);
        }
    } else if (pad_type == STR_PAD_BOTH) {
        size_t a1 = (pad_length - str_size) / 2;
        size_t a2 = pad_length - str_size - a1;
        for (i = 0; i < a1;) {
            for (j = 0; j < pad_size && i < a1; j++, i++) {
                o.push_back(pad_string[j]);
            }
        }
        for (i = 0, x = str_size; i < x; i++) {
            o.push_back(str[i]);
        }
        for (i = 0; i < a2;) {
            for (j = 0; j < pad_size && i < a2; j++, i++) {
                o.push_back(pad_string[j]);
            }
        }
    }
    return o;
}

bool Utils::IsPointBehind(C_CSPlayer* LocalPlayer, Vector position, QAngle playerAngles) {
    Vector toTarget = (position - *LocalPlayer->GetOrigin());
    Vector playerViewAngles;
    Math::AngleVectors(playerAngles, playerViewAngles);
    if (toTarget.Normalized().Dot(playerViewAngles) > -0.5f) {
        return false;
    } else {
        return true;
    }
}

void Utils::SetSkybox(std::string SkyboxName) {
    if (!SetSkyboxFunc) {
        SetSkyboxFunc = reinterpret_cast<SetSkyboxFn>(
            PatternScanner->GetProcedure("engine.dylib", "48 8B 00 48 89 45 D0 0F 57 C0") - 0x1E
        );
    }
    
    SetSkyboxFunc(SkyboxName.c_str());
}
