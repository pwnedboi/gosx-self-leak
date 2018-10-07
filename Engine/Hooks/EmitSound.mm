/******************************************************/
/**                                                  **/
/**      Hooks/EmitSound.cpp                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "SDK/SDK.h"
#include "Engine/Hooks/manager.h"

#ifdef GOSX_AUTO_ACCEPT
typedef bool(*SetReadyFn) (const char*);
bool Glob::IsEmitSoundHooked = false;
SetReadyFn SetReady = NULL;

void HookManager::HOOKED_EmitSound(void *thisptr, IRecipientFilter &filter, int iEntIndex, int iChannel, const char *pSoundEntry, unsigned int nSoundEntryHash, const char *pSample, float flVolume, int nSeed, soundlevel_t iSoundLevel, int iFlags, int iPitch, const Vector *pOrigin, const Vector *pDirection, void *pUtlVecOrigins, bool bUpdatePositions, float soundtime, int speakerentity, void* unknown) {
    static EmitSoundFn oEmitSound = vmtSound->GetOriginalMethod<EmitSoundFn>(INDEX_EMITSOUND);
    
    oEmitSound(thisptr, filter, iEntIndex, iChannel, pSoundEntry, nSoundEntryHash, pSample, flVolume, nSeed, iSoundLevel, iFlags, iPitch, pOrigin, pDirection, pUtlVecOrigins, bUpdatePositions, soundtime, speakerentity, unknown);
    
    if (Engine->IsConnected() || Engine->IsInGame()) {
        return;
    }
    
    if (!Options::Improvements::auto_accept) {
        return;
    }
    
    if (std::string(pSoundEntry) != "UIPanorama.popup_accept_match_beep") {
        return;
    }
    
    if (!SetReady) {
        uintptr_t SetReadyPtr = PatternScanner->GetProcedure(
            "client_panorama.dylib",
            "48 8B BD ? ? FF FF 48 8D 35 ? ? ? ? E8 ? ? ? ? 85 C0 74 19"
        ) - 0x17A;
        SetReady = reinterpret_cast<SetReadyFn>(SetReadyPtr);
    }
    
    SetReady("");
    
    vmtSound->ReleaseVMT();
    Glob::IsEmitSoundHooked = false;
}
#endif
