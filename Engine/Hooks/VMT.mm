/******************************************************/
/**                                                  **/
/**      Hooks/VMT.mm                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-09-12                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "VMT.h"

VMT::VMT(void* interface) {
    this->interface = reinterpret_cast<uintptr_t**>(interface);
    size_t method_count = 0;
    while (reinterpret_cast<uintptr_t*>(*this->interface)[method_count]) {
        method_count++;
    }
    original_vmt = *this->interface;
    vmt = new uintptr_t[sizeof(uintptr_t) * method_count];
    memcpy(vmt, original_vmt, sizeof(uintptr_t) * method_count);
}

VMT::~VMT() {
    *this->interface = original_vmt;
}

void VMT::hook(void* method, size_t methodIndex) {
    vmt[methodIndex] = reinterpret_cast<uintptr_t>(method);
}

void VMT::apply() {
    *this->interface = vmt;
}

void VMT::release() {
    *this->interface = original_vmt;
}

void VMT::dump(std::string dumpfile, int maxMethodCount) {
    FILE* log = fopen(dumpfile.c_str(), "a+");
    for (int mc = 0; mc < maxMethodCount; mc++) {
        if (!reinterpret_cast<uintptr_t*>(*this->interface)[mc]) {
            continue;
        }
        char* logBuffer = new char[256];
        sprintf(logBuffer, "%i => 0x%lx\n", mc, (uintptr_t)*reinterpret_cast<uintptr_t**>(*this->interface)[mc]);
        
        fputs(logBuffer, log);
        delete [] logBuffer;
    }
    
    fclose(log);
}
