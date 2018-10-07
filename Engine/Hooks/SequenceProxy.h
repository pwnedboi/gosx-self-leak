/******************************************************/
/**                                                  **/
/**      Hooks/SequenceProxy.h                       **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_SequenceProxy_h
#define Hooks_SequenceProxy_h

#include "SDK/Recv.h"
#include "SDK/CCSPlayer.h"

#include "Engine/Hooks/manager.h"

struct SequenceProxy_t {
    const CRecvProxyData *pDataConst;
    void *pStruct;
    void *pOut;
};

namespace FeatureManager {
    SequenceProxy_t SequenceProxy(RecvVarProxyFn squence, SequenceProxy_t squenceData);
    extern bool ButterflySequence(long* m_nSequence);
    extern bool FalchionSequence(long* m_nSequence);
    extern bool ShadowdaggersSequence(long* m_nSequence);
    extern bool BowieSequence(long* m_nSequence);
    extern bool UrsusSequence(long* m_nSequence);
    extern bool StilettoSequence(long* m_nSequence);
    extern bool WidowmakerSequence(long* m_nSequence);
#ifdef GOSX_MP7TOMP5_FIX
    extern bool MP5Sequence(long* m_nSequence);
#endif
}

#endif /** !Hooks_SequenceProxy_h */
