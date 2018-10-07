/******************************************************/
/**                                                  **/
/**      SDK/IPrediction.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IPrediction_h
#define SDK_IPrediction_h

class IPrediction {
public:

    void RunCommand(C_BaseEntity *player, CUserCmd *ucmd, IMoveHelper *moveHelper) {
        typedef void (*oRunCommand)(void*, C_BaseEntity*, CUserCmd*, IMoveHelper*);
        return Interfaces::Function<oRunCommand>(this, 20)(this, player, ucmd, moveHelper);
    }

    void SetupMove(C_BaseEntity* player, CUserCmd* cmd, IMoveHelper* helper, CMoveData* move) {
        typedef void (* oSetupMove)(void*, C_BaseEntity*, CUserCmd*, IMoveHelper*, CMoveData*);
        return Interfaces::Function<oSetupMove>(this, 21)(this, player, cmd, helper, move);
    }

    void FinishMove(C_BaseEntity* player, CUserCmd* cmd, CMoveData* move) {
        typedef void (* oFinishMove)(void*, C_BaseEntity*, CUserCmd*, CMoveData*);
        return Interfaces::Function<oFinishMove>(this, 22)(this, player, cmd, move);
    }
};

extern IPrediction* Prediction;

#endif /** !SDK_IPrediction_h */
