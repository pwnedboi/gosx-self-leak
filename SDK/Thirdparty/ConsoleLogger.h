/******************************************************/
/**                                                  **/
/**      Thirdparty/ConsoleLogger.h                  **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Thirdparty_ConsoleLogger_h
#define Thirdparty_ConsoleLogger_h

#include "SDK/SDK.h"

namespace Tools {
    namespace ConsoleLogger {
        extern void Default(std::string LogMessage, bool WithPrefix = true, bool clear = false);
        extern void Warning(std::string LogMessage, bool WithPrefix = true, bool clear = false);
        extern void Error(std::string LogMessage, bool WithPrefix = true, bool clear = false);
        extern void Critical(std::string LogMessage, bool WithPrefix = true, bool clear = false);
        
        extern void Prefix(bool clear = false);
        
        extern ColorRGBA GosxMain;
        extern ColorRGBA GosxSecondary;
        extern ColorRGBA InformationColor;
        extern ColorRGBA WarningColor;
        extern ColorRGBA ErrorColor;
        extern ColorRGBA CriticalColor;
    }
}

#endif /** !Thirdparty_ConsoleLogger_h */
