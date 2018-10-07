//
//  keyCodeState.cpp
//  GOSX Pro
//
//  Created by Andre Kalisch on 07.03.18.
//  Copyright © 2018 Andre Kalisch. All rights reserved.
//

#include "keyCodeState.h"

bool        SetKeyCodeState::shouldListen = false;
int*        SetKeyCodeState::keyOutput = nullptr;
bool        SetKeyCodeState::allowMouseLeft = true;
bool        SetKeyCodeState::withModifiers = false;
int         SetKeyCodeState::keyModifiers = 0;
std::string SetKeyCodeState::configSection = "";
std::string SetKeyCodeState::configKey = "";
