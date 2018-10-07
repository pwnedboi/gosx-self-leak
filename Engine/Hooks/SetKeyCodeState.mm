/******************************************************/
/**                                                  **/
/**      Hooks/SetKeyCodeState.cpp                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-31                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"

void HookManager::HOOKED_SetKeyCodeState(void *thisptr, ButtonCode_t code, bool bPressed) {
    static SetKeyCodeStateFn oSetKeyCodeState = vmtInputInternal->orig<SetKeyCodeStateFn>(INDEX_SETKEYCODESTATE);
    
    if (code == KEY_ESCAPE) {
        SetKeyCodeState::shouldListen = false;
        SetKeyCodeState::keyOutput = nullptr;
        SetKeyCodeState::allowMouseLeft = true;
        SetKeyCodeState::configKey = "";
        SetKeyCodeState::configSection = "";
        SetKeyCodeState::withModifiers = false;
    }
    
    if (SetKeyCodeState::shouldListen && bPressed) {
        SetKeyCodeState::shouldListen = false;
        *SetKeyCodeState::keyOutput = (int)code;
        CSettingsManager::Instance(currentConfigName)->SetIntValue(SetKeyCodeState::configSection, SetKeyCodeState::configKey, (int)code);
        SetKeyCodeState::withModifiers = false;
        SetKeyCodeState::keyModifiers = 0;
        SetKeyCodeState::configKey = "";
        SetKeyCodeState::configSection = "";
    }
    
    oSetKeyCodeState(thisptr, code, bPressed);
}
