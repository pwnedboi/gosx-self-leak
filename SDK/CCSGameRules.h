/******************************************************/
/**                                                  **/
/**      SDK/CCSGameRules.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CCSGameRules_h
#define SDK_CCSGameRules_h

#include "NetworkableReader.h"
#include "Engine/Netvars/offsets.h"

class C_CSGameRules : public NetworkableReader {
public:
    bool IsValveDS();
    bool IsBombPlanted();
    bool IsBombDropped();
    bool IsBombDefuseMap();
};

extern C_CSGameRules** GameRules;

#endif /** !SDK_CCSGameRules_h */
