/******************************************************/
/**                                                  **/
/**      Features/SpectatorList.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_SpectatorList_h
#define Features_SpectatorList_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "Engine/Drawing/manager.h"

namespace Features {
    struct EntitySpectator_t {
        std::string name = "";
        std::string mode = "";
        C_CSPlayer* PlayerEntity = nullptr;
    };

    class CSpectatorList {
    public:
        void PaintTraverse();
    protected:
        std::map<int, EntitySpectator_t> spectatorList = {};
    };
}

extern std::shared_ptr<Features::CSpectatorList> SpecList;

#endif /** !Features_SpectatorList_h */
