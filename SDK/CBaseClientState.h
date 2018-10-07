/******************************************************/
/**                                                  **/
/**      SDK/CBaseClientState.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CBaseClientState_h
#define SDK_CBaseClientState_h

class CClientState;
typedef CClientState* (*GetLocalClientFn) (int);

class CClientState {
public:
    char _pad0[0x214];
    int m_nDeltaTick;
    bool m_bPaused;
    char _pad1[0x3];
    int m_nViewEntity;
    char _pad2[0x8];
    char m_szLevelName[260];
    char m_szLevelNameShort[40];
    
    void ForceFullUpdate() {
        m_nDeltaTick = -1;
    };
};

extern GetLocalClientFn GetLocalClient;
extern CClientState* ClientState;

#endif /** !SDK_CBaseClientState_h */
