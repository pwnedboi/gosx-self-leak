/******************************************************/
/**                                                  **/
/**      SDK/IClientMode.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientMode_h
#define SDK_IClientMode_h

#include "Definitions.h"
#include "VMatrix.h"

class IPanel;

struct CViewSetup {
    int x;
    int m_nUnscaledX;
    int y;
    int m_nUnscaledY;
    int width;
    int m_nUnscaledWidth;
    int height;
    char pad_0x0020[0x9C];
    float fov;
    float fovViewmodel;
};

class IClientMode {
public:
    virtual             ~IClientMode() {}
    virtual int         ClientModeCSNormal(void *) = 0;
    virtual void        Init() = 0;
    virtual void        InitViewport() = 0;
    virtual void        Shutdown() = 0;
    virtual void        Enable() = 0;
    virtual void        Disable() = 0;
    virtual void        Layout() = 0;
    virtual IPanel*     GetViewport() = 0;
    virtual void*       GetViewportAnimationController() = 0;
    virtual void        ProcessInput(bool bActive) = 0;
    virtual bool        ShouldDrawDetailObjects() = 0;
    virtual bool        ShouldDrawEntity(IClientEntity *pEnt) = 0;
    virtual bool        ShouldDrawLocalPlayer(IClientEntity *pPlayer) = 0;
    virtual bool        ShouldDrawParticles() = 0;
    virtual bool        ShouldDrawFog(void) = 0;
    virtual void        OverrideView(CViewSetup *pSetup) = 0; // 16
    virtual int         KeyInput(int down, int keynum, const char *pszCurrentBinding) = 0; // 17
    virtual void        StartMessageMode(int iMessageModeType) = 0; //18
    virtual IPanel*     GetMessagePanel() = 0; //19
    virtual void        OverrideMouseInput(float *x, float *y) = 0; //20
    virtual bool        CreateMove(float flInputSampleTime, void* usercmd) = 0; // 21
    virtual void        LevelInit(const char *newmap) = 0;
    virtual void        LevelShutdown(void) = 0;
};

extern IClientMode* ClientMode;

#endif /** !SDK_IClientMode_h */
