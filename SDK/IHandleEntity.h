/******************************************************/
/**                                                  **/
/**      SDK/IHandleEntity.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IHandleEntity_h
#define SDK_IHandleEntity_h

class CBaseHandle;

class IHandleEntity {
public:
    virtual ~IHandleEntity() {}
    virtual void SetRefEHandle(const CBaseHandle &handle) = 0;
    virtual const CBaseHandle& GetRefEHandle() const = 0;
};

#endif /** !SDK_IHandleEntity_h */
