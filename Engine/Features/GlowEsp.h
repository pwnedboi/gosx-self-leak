/******************************************************/
/**                                                  **/
/**      Features/GlowEsp.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_GlowEsp_h
#define Features_GlowEsp_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"

namespace Features {
    class CGlowESP {
    public:
        void DoPostScreenSpaceEffects();
        void ApplyExtraGlow();
    protected:
        Color _bombColor(int classId, bool* goOn);
        Color _grenadeColor(C_BaseEntity* entity, bool* goOn);
    private:
        std::map<int, int> custom_glow_entities = {};
    };
}

extern std::shared_ptr<Features::CGlowESP> Glow;

#endif /** !Features_GlowEsp_h */
