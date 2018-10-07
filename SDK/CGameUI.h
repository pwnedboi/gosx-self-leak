/******************************************************/
/**                                                  **/
/**      SDK/CGameUI.h                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CGameUI_h
#define SDK_CGameUI_h

class ECommandMsgBoxSlot;

class CGameUI {
public:
    virtual void Initialize(CreateInterfaceFn appFactory) = 0; // 0
    virtual void PostInit(void) = 0; // 1
    virtual void Connect(CreateInterfaceFn appFactory) = 0; // 2
    virtual void Start(void) = 0; // 3
    virtual void Shutdown(void) = 0; // 4
    virtual void RunFrame(void) = 0; // 4
    virtual void OnGameUIActivated(void) = 0; // 6
    virtual void OnGameUIHidden(void) = 0; // 7
    virtual void OLD_OnConnectToServer(const char *game, int IP, int port) = 0; // 8
    virtual void OnDisconnectFromServer_OLD(uint8_t eSteamLoginFailure, const char *username) = 0; // 9
    virtual void OnLevelLoadingStarted(char const* unkChar, bool bShowProgressDialog) = 0; // 10
    virtual void OnLevelLoadingFinished(bool bError, const char *failureReason, const char *extendedReason) = 0; // 11
    virtual void StartLoadingScreenForCommand(char const* command) = 0; // 12
    virtual void StartLoadingScreenForKeyValues(KeyValues* value) = 0; // 13
    virtual void UpdateProgressBar(float progress, const char *statusText) = 0; // 14
    virtual void SetShowProgressText(bool show) = 0; // 15
    virtual void UpdateSecondaryProgressBar(float value, const wchar_t* text) = 0; // 16
    virtual void SetProgressLevelName(char const* levelName) = 0; // 16
    virtual void ShowMessageDialog(const uint nType, VPANEL* pOwner) = 0; // 17
    virtual void ShowMessageDialog(const char* message, const char* title) = 0; // 18
    virtual void CreateCommandMsgBox(const char* title, const char* message, bool ok = true, bool cancel = false, const char* unk1 = "", const char* unk2 = "", const char* unk3 = "", const char* unk4 = "") = 0; // 19
    virtual void CreateCommandMsgBoxInSlot(ECommandMsgBoxSlot, char const*, char const*, bool, bool, char const*, char const*, char const*, char const*) = 0; // 20
    virtual void SetLoadingBackgroundDialog(VPANEL panel) = 0; // 21
    virtual void OnConnectToServer2(const char *game, int IP, int connectionPort, int queryPort) = 0; // 22
    virtual void SetProgressOnStart(void) = 0; // 23
    virtual void OnDisconnectFromServer(uint8_t eSteamLoginFailure) = 0; // 24
    virtual void NeedConnectionProblemWaitScreen(void) = 0; // 25
    virtual void ShowPasswordUI(char const* unkChar) = 0; // 26
    virtual void LoadingProgressWantsIsolatedRender(bool) = 0; // 27
    virtual bool IsPlayingFullScreenVideo(void) = 0; // 28
    virtual bool IsTransitionEffectEnabled(void) = 0; // 29
    virtual bool IsInLevel(void) = 0; // 30
    virtual void RestoreTopLevelMenu(void) = 0; // 31
    virtual void StartProgressBar(void) = 0; // 32
    virtual void ContinueProgressBar(float value, bool unkBool) = 0; // 33
    virtual void StopProgressBar(bool unkBool, const char* unkChar1, const char* unkChar2) = 0; // 34
    virtual void SetProgressBarStatusText(char const*, bool) = 0; // 35
    virtual void SetSecondaryProgressBar(float length) = 0; // 36
    virtual void SetSecondaryProgressBarText(const wchar_t* barText) = 0; // 37
};

extern CGameUI* GameUI;

#endif /** !SDK_CGameUI_h */
