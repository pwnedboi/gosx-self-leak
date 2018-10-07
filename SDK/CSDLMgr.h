/******************************************************/
/**                                                  **/
/**      SDK/CSDLMgr.h                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-29                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CSDLMgr_h
#define SDK_CSDLMgr_h

#include "SDK/Interfaces.h"
#include "SDK/CocoaDef.h"

typedef void *PseudoGLContextPtr;
typedef struct SDL_Cursor SDL_Cursor;
typedef struct SDL_Window SDL_Window;

/*class CShowPixelsParams {
public:
    GLuint  m_srcTexName;
    int     m_width;
    int     m_height;
    bool    m_vsyncEnable;
    bool    m_fsEnable;     // want receiving view to be full screen.  for now, just target the main screen.  extend later.
    bool    m_useBlit;      // use FBO blit - sending context says it is available.
    bool    m_noBlit;       // the back buffer has already been populated by the caller (perhaps via direct MSAA resolve from multisampled RT tex)
    bool    m_onlySyncView; // react to full/windowed state change only, do not present bits
};*/

class CSDLMgr {
public:
    /*bool CreateGameWindow(const char *pTitle, bool bWindowed, int width, int height, bool unk) {
        typedef bool(*currfn)(const char*, bool, int, int, bool);
        return Internal::getvfunc<currfn>(this, 9)(pTitle, bWindowed, width, height, unk);
    }
    
    int GetEvents(CCocoaEvent *pEvents, int nMaxEventsToReturn, bool debugEvents = false) {
        typedef int(*currfn)(CCocoaEvent*, int, bool);
        return Internal::getvfunc<currfn>(this, 12)(pEvents, nMaxEventsToReturn, debugEvents);
    }
    
    void SetCursorPosition(int x, int y) {
        typedef void(*currfn)(int, int);
        Internal::getvfunc<currfn>(this, 13)(x, y);
    }
    
    void SetWindowFullScreen(bool bFullScreen, int nWidth, int nHeight) {
        typedef void(*currfn)(bool, int, int);
        Internal::getvfunc<currfn>(this, 15)(bFullScreen, nWidth, nHeight);
    }
    
    bool IsWindowFullScreen() {
        typedef bool(*currfn)(void);
        return Internal::getvfunc<currfn>(this, 16)();
    }
    
    void MoveWindow(int x, int y) {
        typedef void(*currfn)(int, int);
        Internal::getvfunc<currfn>(this, 17)(x, y);
    }
    
    void SizeWindow(int width, int tall) {
        typedef void(*currfn)(int, int);
        Internal::getvfunc<currfn>(this, 18)(width, tall);
    }
    
    int PumpWindowsMessageLoop(void* unknown) {
        typedef int(*currfn)(void*);
        return Internal::getvfunc<currfn>(this, 19)(unknown);
    }
    
    void DestroyGameWindow() {
        typedef void(*currfn)(void);
        Internal::getvfunc<currfn>(this, 20)();
    }
    
    void SetApplicationIcon(const char *pchAppIconFile) {
        typedef void(*currfn)(const char*);
        Internal::getvfunc<currfn>(this, 21)(pchAppIconFile);
    }
    
    void GetMouseDelta(int &x, int &y, bool bIgnoreNextMouseDelta = false) {
        typedef void(*currfn)(int, int, bool);
        Internal::getvfunc<currfn>(this, 22)(x, y, bIgnoreNextMouseDelta);
    }
    
    void GetNativeDisplayInfo(int nDisplay, uint &nWidth, uint &nHeight, uint &nRefreshHz) {
        typedef void(*currfn)(int, uint, uint, uint);
        Internal::getvfunc<currfn>(this, 23)(nDisplay, nWidth, nHeight, nRefreshHz);
    }
    
    void RenderedSize(uint &width, uint &height, bool set) {
        typedef void(*currfn)(uint, uint, bool);
        Internal::getvfunc<currfn>(this, 24)(width, height, set);
    }
    
    void DisplayedSize(uint &width, uint &height) {
        typedef void(*currfn)(uint, uint);
        Internal::getvfunc<currfn>(this, 25)(width, height);
    }
    
    PseudoGLContextPtr GetMainContext() {
        typedef PseudoGLContextPtr(*currfn)(void);
        return Internal::getvfunc<currfn>(this, 28)();
    }
    
    PseudoGLContextPtr GetGLContextForWindow(void* windowref) {
        typedef PseudoGLContextPtr(*currfn)(void*);
        return Internal::getvfunc<currfn>(this, 11)(windowref);
    }
    
    PseudoGLContextPtr CreateExtraContext() {
        typedef PseudoGLContextPtr(*currfn)(void);
        return Internal::getvfunc<currfn>(this, 29)();
    }
    
    void DeleteContext(PseudoGLContextPtr hContext) {
        typedef void(*currfn)(PseudoGLContextPtr);
        Internal::getvfunc<currfn>(this, 30)(hContext);
    }
    
    bool MakeContextCurrent(PseudoGLContextPtr hContext) {
        typedef bool(*currfn)(PseudoGLContextPtr);
        return Internal::getvfunc<currfn>(this, 31)(hContext);
    }
    
    void ShowPixels(CShowPixelsParams *params) {
        typedef void(*currfn)(CShowPixelsParams*);
        Internal::getvfunc<currfn>(this, 14)(params);
    }
    
    SDL_Window* GetWindowRef() {
        typedef SDL_Window*(*currfn)(void);
        return Internal::getvfunc<currfn>(this, 33)();
    }
    
    void SetMouseVisible(bool bState) {
        typedef void(*currfn)(bool);
        Internal::getvfunc<currfn>(this, 34)(bState);
    }
    
    void SetMouseCursor(SDL_Cursor* hCursor) {
        typedef void(*currfn)(SDL_Cursor*);
        Internal::getvfunc<currfn>(this, 36)(hCursor);
    }
    
    void SetForbidMouseGrab(bool bForbidMouseGrab) {
        typedef void(*currfn)(bool);
        Internal::getvfunc<currfn>(this, 37)(bForbidMouseGrab);
    }
    
    void OnFrameRendered() {
        typedef void(*currfn)(void);
        Internal::getvfunc<currfn>(this, 38)();
    }
    
    void SetGammaRamp(const uint16_t *pRed, const uint16_t *pGreen, const uint16_t *pBlue) {
        typedef void(*currfn)(const uint16_t*, const uint16_t*, const uint16_t*);
        Internal::getvfunc<currfn>(this, 46)(pRed, pGreen, pBlue);
    }
    
    double GetPrevGLSwapWindowTime() {
        typedef double(*currfn)(void);
        return Internal::getvfunc<currfn>(this, 41)();
    }
    
    void ForceSystemCursorVisible() {
        typedef void(*currfn)(void);
        Internal::getvfunc<currfn>(this, 39)();
    }
    
    void UnforceSystemCursorVisible() {
        typedef void(*currfn)(void);
        Internal::getvfunc<currfn>(this, 40)();
    }*/
};

extern CSDLMgr* SDLMgr;

#endif /** !SDK_CSDLMgr_h */
