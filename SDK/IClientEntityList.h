/******************************************************/
/**                                                  **/
/**      SDK/IClientEntityList.h                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientEntityList_h
#define SDK_IClientEntityList_h

#include "Definitions.h"
#include "CHandle.h"

class IClientNetworkable;
class IClientEntity;

class IClientEntityList {
public:
    virtual IClientNetworkable*   GetClientNetworkable(int entnum) = 0;
    virtual IClientNetworkable*   GetClientNetworkableFromHandle(CBaseHandle hEnt) = 0;
    virtual IClientUnknown*       GetClientUnknownFromHandle(CBaseHandle hEnt) = 0;
    virtual IClientEntity*        GetClientEntity(int entNum) = 0;
    virtual IClientEntity*        GetClientEntityFromHandle(CBaseHandle hEnt) = 0;
    virtual int                   NumberOfEntities(bool bIncludeNonNetworkable) = 0;
    virtual int                   GetHighestEntityIndex(void) = 0;
    virtual void                  SetMaxEntities(int maxEnts) = 0;
    virtual int                   GetMaxEntities(void) = 0;
};

extern IClientEntityList* EntList;

#endif /** !SDK_IClientEntityList_h */
