/******************************************************/
/**                                                  **/
/**      SDK/IClientUnknown.h                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientUnknown_h
#define SDK_IClientUnknown_h

#include "IHandleEntity.h"


class ICollideable
{
public:
    virtual void pad0( );
    virtual const Vector& OBBMins( ) const;
    virtual const Vector& OBBMaxs( ) const;
};

class IClientNetworkable;
class IClientRenderable;
class IClientEntity;
class C_BaseEntity;
class IClientThinkable;
class IClientAlphaProperty;

class IClientUnknown : public IHandleEntity {
public:
    virtual ICollideable*              GetCollideable() = 0;
    virtual IClientNetworkable*        GetClientNetworkable() = 0;
    virtual IClientRenderable*         GetClientRenderable() = 0;
    virtual IClientEntity*             GetIClientEntity() = 0;
    virtual C_BaseEntity*              GetBaseEntity() = 0;
    virtual IClientThinkable*          GetClientThinkable() = 0;
    // virtual IClientModelRenderable* GetClientModelRenderable() = 0;
    virtual IClientAlphaProperty*      GetClientAlphaProperty() = 0;
};

#endif /** !SDK_IClientUnknown_h */
