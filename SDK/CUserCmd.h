/******************************************************/
/**                                                  **/
/**      SDK/CUserCmd.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-28                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CUserCmd_h
#define SDK_CUserCmd_h

struct CUserCmd {
    virtual ~CUserCmd() {};
    int command_number;
    int tick_count;
    QAngle viewangles;
    QAngle aimdirection;
    float forwardmove;
    float sidemove;
    float upmove;
    int buttons;
    unsigned char impulse;
    int weaponselect;
    int weaponsubtype;
    int random_seed;
    short mousedx;
    short mousedy;
    bool hasbeenpredicted;
    QAngle headangles;
    Vector headoffset;
};

#endif /** !SDK_CUserCmd_h */
