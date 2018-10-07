/******************************************************/
/**                                                  **/
/**      SDK/CInput.h                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-06                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CInput_h
#define SDK_CInput_h

#ifdef GOSX_THIRDPERSON
class CInput {
public:
    char _pad0[0xAC];
    bool m_fCameraInterceptingMouse;
    bool m_fCameraInThirdPerson;
    bool m_fCameraMovingWithMouse;
    Vector m_vecCameraOffset;
    bool m_fCameraDistanceMove;
    int m_nCameraOldX;
    int m_nCameraOldY;
    int m_nCameraX;
    int m_nCameraY;
    bool m_CameraIsOrthographic;
};

extern CInput* Input;

#endif

#endif /** !SDK_CInput_h */
