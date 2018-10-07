/******************************************************/
/**                                                  **/
/**      Thirdparty/ConsoleLogger.mm                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "ConsoleLogger.h"

ColorRGBA Tools::ConsoleLogger::GosxMain = ColorRGBA(95, 185, 255, 255);
ColorRGBA Tools::ConsoleLogger::GosxSecondary = ColorRGBA(155, 255, 155, 255);
ColorRGBA Tools::ConsoleLogger::InformationColor = ColorRGBA(95, 185, 255, 255);
ColorRGBA Tools::ConsoleLogger::WarningColor = ColorRGBA(155, 255, 155, 255);
ColorRGBA Tools::ConsoleLogger::ErrorColor = ColorRGBA(255, 155, 100, 255);
ColorRGBA Tools::ConsoleLogger::CriticalColor = ColorRGBA(255, 135, 135, 255);

void Tools::ConsoleLogger::Prefix(bool clear) {
    if (clear) {
        Cvar->ConsolePrintf("\n\n\n\n\n\n\n\n");
    }
    Cvar->ConsoleColorPrintf(GosxMain, "[");
    Cvar->ConsoleColorPrintf(GosxSecondary, "GO:SX");
    Cvar->ConsoleColorPrintf(GosxMain, "] ");
}

void Tools::ConsoleLogger::Default(std::string LogMessage, bool WithPrefix, bool clear) {
    if (WithPrefix) {
        Prefix(clear);
    }
    
    Cvar->ConsoleColorPrintf(InformationColor, std::string("Info: ").append(LogMessage).append("\n").c_str());
}

void Tools::ConsoleLogger::Warning(std::string LogMessage, bool WithPrefix, bool clear) {
    if (WithPrefix) {
        Prefix(clear);
    }
    
    Cvar->ConsoleColorPrintf(WarningColor, std::string("Warning: ").append(LogMessage).append("\n").c_str());
}

void Tools::ConsoleLogger::Error(std::string LogMessage, bool WithPrefix, bool clear) {
    if (WithPrefix) {
        Prefix(clear);
    }
    
    Cvar->ConsoleColorPrintf(ErrorColor, std::string("Error: ").append(LogMessage).append("\n").c_str());
}

void Tools::ConsoleLogger::Critical(std::string LogMessage, bool WithPrefix, bool clear) {
    if (WithPrefix) {
        Prefix(clear);
    }
    
    Cvar->ConsoleColorPrintf(CriticalColor, std::string("Critical: ").append(LogMessage).append("\n").c_str());
}
