//
//  keyCodeState.hpp
//  GOSX Pro
//
//  Created by Andre Kalisch on 07.03.18.
//  Copyright © 2018 Andre Kalisch. All rights reserved.
//

#ifndef keyCodeState_hpp
#define keyCodeState_hpp

#include "SDK/ButtonCode.h"
#include <string>

namespace SetKeyCodeState {
    extern bool         shouldListen;
    extern int*         keyOutput;
    extern bool         withModifiers;
    extern int          keyModifiers;
    extern bool         allowMouseLeft;
    extern std::string  configSection;
    extern std::string  configKey;
}

#endif /* keyCodeState_hpp */
