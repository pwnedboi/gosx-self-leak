/******************************************************/
/**                                                  **/
/**      SDK/IClientEntity.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientEntity_h
#define SDK_IClientEntity_h

#include "Definitions.h"
#include "Engine/Netvars/manager.h"

#include "IClientNetworkable.h"
#include "IClientRenderable.h"
#include "IClientUnknown.h"
#include "IClientThinkable.h"
#include "SDK.h"

struct SpatializationInfo_t;

class IClientEntity : public IClientUnknown, public IClientRenderable, public IClientNetworkable, public IClientThinkable {
public:
    virtual void             Release(void) = 0;
    virtual const Vector     GetAbsOrigin(void) const = 0;
    virtual const QAngle     GetAbsAngles(void) const = 0;
    virtual void*            GetMouth(void) = 0;
    virtual bool             GetSoundSpatialization(SpatializationInfo_t info) = 0;
    virtual bool             IsBlurred(void) = 0;
};

#endif /** !SDK_IClientEntity_h */
