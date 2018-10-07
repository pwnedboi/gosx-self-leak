/******************************************************/
/**                                                  **/
/**      Features/NoSky.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-10                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_NoSky_h
#define Features_NoSky_h

#include "SDK/SDK.h"
#include "SDK/Utils.h"

namespace Features {
    class CNoSky {
    public:
        void FrameStageNotify(ClientFrameStage_t stage);
    protected:
        float r1 = 0.0f;
        float g1 = 0.0f;
        float b1 = 0.0f;
        float a1 = 0.0f;
        
        std::unordered_map<MaterialHandle_t, Color> skyboxMaterials;
        std::unordered_map<MaterialHandle_t, Color> skyboxMaterials2;
    };
}

extern std::shared_ptr<Features::CNoSky> NoSky;

#endif /** !Features_NoSky_h */
