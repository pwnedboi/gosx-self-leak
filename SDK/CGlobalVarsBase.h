/******************************************************/
/**                                                  **/
/**      SDK/CGlobalVarsBase.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CGlobalVarsBase_h
#define SDK_CGlobalVarsBase_h

#include "Definitions.h"

class CGlobalVarsBase {
public:
    float realtime; // 0x00
    int framecount; // 0x04
    float absoluteframetime; // 0x08
    float absoluteframestarttimestddev; // 0x0C
    float curtime; // 0x10
    float frametime; // 0x14
    int maxClients; // 0x18
    int tickcount; // 0x1C
    float interval_per_tick; // 0x20
    float interpolation_amount;
    int simTicksThisFrame;
    int network_protocol;
    void* pSaveData;
    bool m_bClient;
    bool m_bRemoteClient;
private:
    int nTimestampNetworkingBase;
    int nTimestampRandomizeWindow;
};

extern CGlobalVarsBase** GlobalVars;

#endif /** !SDK_CGlobalVarsBase_h */
