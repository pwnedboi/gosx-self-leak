/******************************************************/
/**                                                  **/
/**      Hooks/SetMouseCodeState.cpp                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-31                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"

void HookManager::HOOKED_SetMouseCodeState(void *thisptr, ButtonCode_t code, MouseCodeState_t state) {
    static SetMouseCodeStateFn oSetMouseCodeState = vmtInputInternal->orig<SetMouseCodeStateFn>(INDEX_SETMOUSECODESTATE);
    
    if (code == MOUSE_LEFT && !SetKeyCodeState::allowMouseLeft) {
        SetKeyCodeState::shouldListen = false;
        SetKeyCodeState::keyOutput = nullptr;
        SetKeyCodeState::allowMouseLeft = true;
        SetKeyCodeState::configKey = "";
        SetKeyCodeState::configSection = "";
    }
    
    if (SetKeyCodeState::shouldListen && state == MouseCodeState_t::BUTTON_RELEASED) {
        SetKeyCodeState::shouldListen = false;
        *SetKeyCodeState::keyOutput = (int)code;
        CSettingsManager::Instance(currentConfigName)->SetIntValue(SetKeyCodeState::configSection, SetKeyCodeState::configKey, (int)code);
        SetKeyCodeState::configKey = "";
        SetKeyCodeState::configSection = "";
    }
    
    oSetMouseCodeState(thisptr, code, state);
}
