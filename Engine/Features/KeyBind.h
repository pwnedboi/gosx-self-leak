/******************************************************/
/**                                                  **/
/**      Features/KeyBind.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_KeyBind_h
#define Features_KeyBind_h

#include "SDK/SDK.h"

struct KeyBind_t {
    int* toggleKey = nullptr;
    bool* option = nullptr;
    std::string configSection = "";
    std::string configKey = "";
    bool permanent = false;
};

class KeyBind {
public:
    void RegisterKeyBind(std::string identifier, int* toggleKey, bool* option);
    void RegisterKeyBind(std::string identifier, int* toggleKey, bool* option, std::string configSection, std::string configKey);
    
    void KeybindTick();
protected:
    std::map<std::string, KeyBind_t> keybindMap;
    bool keyPressed = false;
};

#endif /** !Features_KeyBind_h */
