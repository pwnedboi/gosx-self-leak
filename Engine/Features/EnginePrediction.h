/******************************************************/
/**                                                  **/
/**      Features/EnginePrediction.h                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Features_EnginePrediction_h
#define Features_EnginePrediction_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/Utils.h"

extern float m_flOldCurtime;
extern float m_flOldFrametime;

class CEnginePrediction {
public:
    CEnginePrediction();
    void Start(CUserCmd* cmd);
    void End();
private:
    float m_flOldCurtime = 0.f;
    float m_flOldFrametime = 0.f;
    int oldPFlags;
    C_CSPlayer* LocalPlayer = nullptr;
};

extern std::shared_ptr<CEnginePrediction> EnginePrediction;

#endif /** !Features_EnginePrediction_h */
