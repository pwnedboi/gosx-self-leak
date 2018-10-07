/******************************************************/
/**                                                  **/
/**      SDK/IClientThinkable.h                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-15                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IClientThinkable_h
#define SDK_IClientThinkable_h

class IClientUnknown;
class CClientThinkHandlePtr;
typedef CClientThinkHandlePtr* ClientThinkHandle_t;

class IClientThinkable {
public:
    virtual IClientUnknown*		GetIClientUnknown() = 0;
    virtual void				ClientThink() = 0;
    virtual ClientThinkHandle_t	GetThinkHandle() = 0;
    virtual void				SetThinkHandle(ClientThinkHandle_t hThink) = 0;
    virtual void				Release() = 0;
};

#endif /** !SDK_IClientThinkable_h */
