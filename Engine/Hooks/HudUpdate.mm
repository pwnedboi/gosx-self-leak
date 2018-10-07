/******************************************************/
/**                                                  **/
/**      Hooks/HudUpdate.mm                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"

#ifdef GOSX_OVERWATCH_REVEAL
void HookManager::HOOKED_HudUpdate(void* thisptr, bool active) {
    static HudUpdateFn original_HudUpdate = vmtClient->orig<HudUpdateFn>(INDEX_HUDUPDATE);
    
    if (!Options::Main::enabled || !Options::OverwatchReveal::enabled || !DemoPlayer->IsPlayingDemo()) {
        original_HudUpdate(thisptr, active);
        
        return;
    }

    DemoPlayer->SetOverwatchState(true);
    
    original_HudUpdate(thisptr, active);
    
    DemoPlayer->SetOverwatchState(false);
}
#endif
