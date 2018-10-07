/******************************************************/
/**                                                  **/
/**      Hooks/DrawModelExecute.cpp                  **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Engine/Hooks/manager.h"
#include "Engine/Features/Chams.h"
#ifdef GOSX_STREAM_PROOF
#include "Engine/Features/StreamProof.h"
#endif

DrawModelExecuteFn oDrawModelExecute = NULL;

void HookManager::HOOKED_DrawModelExecute(void* thisptr, IMatRenderContext* context, const DrawModelState_t &state, const ModelRenderInfo_t &pInfo, matrix3x4_t *pCustomBoneToWorld) {
    if (!oDrawModelExecute) {
        oDrawModelExecute = vmtModelRender->orig<DrawModelExecuteFn>(INDEX_DRAWMODELEXECUTE);
    }
    
    if (
        !ModelRender->IsForcedMaterialOverride() &&
        (!Engine->IsInGame() && !Engine->IsConnected())
#ifdef GOSX_STREAM_PROOF
        && !StreamProof->Active()
#endif
    ) {
        Chams->DrawModelExecute(thisptr, context, state, pInfo, pCustomBoneToWorld);
    }
    
    oDrawModelExecute(thisptr, context, state, pInfo, pCustomBoneToWorld);
    ModelRender->ForcedMaterialOverride(nullptr);
}
