/******************************************************/
/**                                                  **/
/**      SDK/KeyStroke.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_KeyStroke_h
#define SDK_KeyStroke_h

#include "ButtonCode.h"
#include <string>

struct KeyStroke_t {
    char    m_szDefinition[12];
    char    m_szShiftDefinition[12];
    char    m_szAltDefinition[12];
};

extern KeyStroke_t m_KeyStroke[MOUSE_COUNT + KEY_COUNT];

namespace Keys {
    extern std::string Get(int key, bool shift = false, bool alt = false);
};

#endif /** !SDK_KeyStroke_h */
