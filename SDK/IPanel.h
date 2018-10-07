/******************************************************/
/**                                                  **/
/**      SDK/IPanel.h                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IPanel_h
#define SDK_IPanel_h

#include "Engine/common.h"

#include "Definitions.h"
#include "Interfaces.h"

typedef const char* (* oGetName)(void*, VPANEL);
typedef const char* (* oGetClassName)(void*, VPANEL);

class IPanel {
public:
    const char *GetName(VPANEL vguiPanel) {
        return Interfaces::Function<oGetName>(this, 37)(this, vguiPanel);
    }
#ifdef GetClassName
#undef GetClassName
#endif
    const char *GetClassName(unsigned int vguiPanel) {
        return Interfaces::Function<oGetClassName>(this, 38)(this, vguiPanel);
    }
};

extern IPanel* Panel;

#endif /** !SDK_IPanel_h */
