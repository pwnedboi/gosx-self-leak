/******************************************************/
/**                                                  **/
/**      SDK/IMoveHelper.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-20                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IMoveHelper_h
#define SDK_IMoveHelper_h

class IMoveHelper
{
public:
    void SetHost(C_BaseEntity* host) {
        typedef void (* oSetHost)(void*, C_BaseEntity*);
        return Interfaces::Function<oSetHost>(this, 1)(this, host);
    }
};

extern IMoveHelper* MoveHelper;

#endif /** !SDK_IMoveHelper_h */
