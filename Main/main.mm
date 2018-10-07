/******************************************************/
/**                                                  **/
/**      Main/main.cpp                               **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-23                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "main.h"
#include "SDK/CommandLine.h"

void  Main() {
    while (!PatternScanner->GetModule(XorStr("serverbrowser.dylib"), XorStr("./bin/osx64/serverbrowser.dylib"))) {
        usleep(50000);
    }

    HookManager::Initialize();
}

int __attribute__((constructor)) Load() {
    std::thread MainThread(Main);
    
    MainThread.join();

    return 0;
}

void __attribute__((destructor)) Unload() {
    HookManager::Unhook();
}
