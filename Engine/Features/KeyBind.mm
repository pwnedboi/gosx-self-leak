/******************************************************/
/**                                                  **/
/**      Features/KeyBind.mm                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-03                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "KeyBind.h"

void KeyBind::RegisterKeyBind(std::string identifier, int* toggleKey, bool* option) {
    KeyBind_t key = { toggleKey, option, "", "" };
    this->keybindMap[identifier] = key;
}

void KeyBind::RegisterKeyBind(std::string identifier, int* toggleKey, bool* option, std::string configSection, std::string configKey) {
    KeyBind_t key = { toggleKey, option, configSection, configKey, true };
    this->keybindMap[identifier] = key;
}

void KeyBind::KeybindTick() {
    if (this->keybindMap.empty()) {
        return;
    }
    
    for (auto keyBind : this->keybindMap) {
        KeyBind_t bind = keyBind.second;
        
        if (InputSystem->IsButtonDown((ButtonCode_t)*bind.toggleKey)) {
            if (!this->keyPressed) {
                *bind.option = !*bind.option;
                if (bind.permanent) {
                    CSettingsManager::Instance(currentConfigName)->SetBoolValue(bind.configSection, bind.configKey, *bind.option);
                }
            }
            this->keyPressed = true;
        } else {
            this->keyPressed = false;
        }
    }
}
