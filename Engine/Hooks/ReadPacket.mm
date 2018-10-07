/******************************************************/
/**                                                  **/
/**      Hooks/ReadPacket.mm                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-07-01                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"

#ifdef GOSX_OVERWATCH_REVEAL
void* HookManager::HOOKED_ReadPacket(void *thisptr) {
    static ReadPacketFn original_ReadPacket = vmtDemoPlayer->orig<ReadPacketFn>(INDEX_READPACKET);
    
    if (!Options::Main::enabled || !Options::OverwatchReveal::enabled) {
        return original_ReadPacket(thisptr);
    }
    
    DemoPlayer->SetOverwatchState(true);
    
    void* ret = original_ReadPacket(thisptr);
    
    DemoPlayer->SetOverwatchState(false);
    
    return ret;
}
#endif
