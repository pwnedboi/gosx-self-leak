/******************************************************/
/**                                                  **/
/**      Hooks/INKeyEvent.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-03-31                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"

int HookManager::HOOKED_INKeyEvent(void* thisptr, int eventcode, int keynum, const char* currentbinding) {
    static KeyEventFn oINKeyEvent = vmtClient->orig<KeyEventFn>(INDEX_INKEYEVENT);

    if (GUI::IsVisible) {
        return 0;
    }
    
    return oINKeyEvent(thisptr, eventcode, keynum, currentbinding);
}
