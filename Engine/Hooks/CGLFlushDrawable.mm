/******************************************************/
/**                                                  **/
/**      Hooks/CGLFlushDrawable.mm                   **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-06-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

#ifdef GOSX_STREAM_PROOF
CGLError HookManager::HOOKED_FlushDrawable(CGLContextObj ctx) {
    static FlushDrawableFn original_CGLFlushDrawable = reinterpret_cast<FlushDrawableFn>(flushdrawable_original);

    if (StreamProof->Active()) {
        ImGui::Render();
        ImGui_ImplOpenGL2_RenderDrawData(ImGui::GetDrawData());
    }
    
    return original_CGLFlushDrawable(ctx);
}
#endif
