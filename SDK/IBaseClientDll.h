/******************************************************/
/**                                                  **/
/**      SDK/IBaseClientDll.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IBaseClientDll_h
#define SDK_IBaseClientDll_h

#include "Definitions.h"

#include "CGlobalVarsBase.h"
#include "ClientClass.h"

class IBaseClientDLL {
public:
    virtual int              Connect(CreateInterfaceFn appSystemFactory, CGlobalVarsBase *pGlobals) = 0;
    virtual int              Disconnect(void) = 0;
    virtual int              Init(CreateInterfaceFn appSystemFactory, CGlobalVarsBase *pGlobals) = 0;
    virtual void             PostInit() = 0;
    virtual void             Shutdown(void) = 0;
    virtual void             LevelInitPreEntity(char const* pMapName) = 0;
    virtual void             LevelInitPostEntity() = 0;
    virtual void             LevelShutdown(void) = 0;
    virtual ClientClass*     GetAllClasses(void) = 0;
};

extern IBaseClientDLL* Client;

#endif /** !SDK_IBaseClientDll_h */
