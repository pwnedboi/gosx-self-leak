/******************************************************/
/**                                                  **/
/**      SDK/IClientNetworkable.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientNetworkable_h
#define SDK_IClientNetworkable_h

#include "Definitions.h"

class IClientUnknown;
class ClientClass;
class bf_read;

class IClientNetworkable {
public:
    virtual IClientUnknown*  GetIClientUnknown() = 0;
    virtual void             Release() = 0;
    virtual ClientClass*     GetClientClass() = 0;
    virtual void             NotifyShouldTransmit(int state) = 0;
    virtual void             OnPreDataChanged(int updateType) = 0;
    virtual void             OnDataChanged(int updateType) = 0;
    virtual void             PreDataUpdate(int updateType) = 0;
    virtual void             PostDataUpdate(int updateType) = 0;
    virtual void             __unkn0001(void) = 0;
    virtual bool             IsDormant(void) = 0;
    virtual int              EntIndex(void) const = 0;
    virtual void             ReceiveMessage(int classID, bf_read& msg) = 0;
    virtual void*            GetDataTableBasePtr() = 0;
    virtual void             SetDestroyedOnRecreateEntities(void) = 0;
};

#endif /** !SDK_IClientNetworkable_h */
