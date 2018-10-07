/******************************************************/
/**                                                  **/
/**      SDK/CommandLine.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CommandLine_h
#define SDK_CommandLine_h

#include "SDK/SDK.h"

class CCommandLine {
public:
    bool HasParam(const char* param) {
        typedef bool(*oFunc)(void*, const char*);
        return Interfaces::Function<oFunc>(this, 4)(this, param);
    }
};

extern CCommandLine* CommandLine;

#endif /** !SDK_CommandLine_h */
