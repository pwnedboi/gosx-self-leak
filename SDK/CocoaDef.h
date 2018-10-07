/******************************************************/
/**                                                  **/
/**      SDK/CocoaDef.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CocoaDef_h
#define SDK_CocoaDef_h

enum CocoaEventType_t {
    CocoaEvent_KeyDown,
    CocoaEvent_KeyUp,
    CocoaEvent_MouseButtonDown,
    CocoaEvent_MouseMove,
    CocoaEvent_MouseButtonUp,
    CocoaEvent_AppActivate,
    CocoaEvent_MouseScroll,
    CocoaEvent_AppQuit,
    CocoaEvent_Deleted, // Event was one of the above, but has been handled and should be ignored now.
};

// enum values need to match bit-shifting logic in CInputSystem::UpdateMouseButtonState and
// the codes from NSEvent pressedMouseButtons, turns out the two are in agreement right now
enum CocoaMouseButton_t {
    COCOABUTTON_LEFT = 1 << 0,
    COCOABUTTON_RIGHT = 1 << 1,
    COCOABUTTON_MIDDLE = 1 << 2,
    COCOABUTTON_4 = 1 << 3,
    COCOABUTTON_5 = 1 << 4,
};

enum ECocoaKeyModifier {
    eCapsLockKey,
    eShiftKey,
    eControlKey,
    eAltKey,        // aka option
    eCommandKey
};

class CCocoaEvent {
public:
    CocoaEventType_t m_EventType;
    int m_VirtualKeyCode;
    wchar_t m_UnicodeKey;
    wchar_t m_UnicodeKeyUnmodified;
    uint m_ModifierKeyMask;        //
    int m_MousePos[2];
    int m_MouseButtonFlags;    // Current state of the mouse buttons. See COCOABUTTON_xxxx.
    uint m_nMouseClickCount;
    int m_MouseButton; // which of the CocoaMouseButton_t buttons this is for from above
};

#endif /** !SDK_CocoaDef_h */
