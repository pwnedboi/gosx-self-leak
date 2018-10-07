/******************************************************/
/**                                                  **/
/**      SDK/IAppSystem.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IAppSystem_h
#define SDK_IAppSystem_h

#include "Definitions.h"

class IAppSystem {
public:
    virtual bool            Connect(CreateInterfaceFn factory) = 0;
    virtual void            Disconnect() = 0;
    virtual void*           QueryInterface(const char *pInterfaceName) = 0;
    virtual int             Init() = 0;
    virtual void            Shutdown() = 0;
    virtual const void*     GetDependencies() = 0;
    virtual int             GetTier() = 0;
    virtual void            Reconnect(CreateInterfaceFn factory, const char *pInterfaceName) = 0;
    virtual void            UnkFunc() = 0;
};

#endif /** !SDK_IAppSystem_h */
