/******************************************************/
/**                                                  **/
/**      SDK/Interfaces.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Interfaces_h
#define SDK_Interfaces_h

#include "Engine/common.h"

typedef void* (*InstantiateInterfaceFn) ();
struct InterfaceReg {
    InstantiateInterfaceFn m_CreateFn;
    const char *m_pName;
    InterfaceReg *m_pNext;
};

namespace Interfaces {
    extern void**& Table(void* inst, size_t offset = 0);
    extern const void** Table(const void* inst, size_t offset = 0);
    
    template<typename Fn>
    Fn Function(void* inst, size_t index, size_t offset = 0) {
        return reinterpret_cast<Fn>(Table(inst, offset)[index]);
    }
    
    template <typename interface>
    interface* Get(const char* filename, const char* version, bool exact = false) {
        void* library = dlopen(filename, RTLD_NOLOAD | RTLD_NOW);
        if (!library) {
            return nullptr;
        }
        
        void* interfaces_sym = dlsym(library, "s_pInterfaceRegs");
        dlclose(library);
        
        if (!interfaces_sym) {
            return nullptr;
        }
        
        InterfaceReg* interfaces = *reinterpret_cast<InterfaceReg**>(interfaces_sym);
        InterfaceReg* cur_interface;
        
        for (cur_interface = interfaces; cur_interface; cur_interface = cur_interface->m_pNext) {
            if (exact) {
                if (strcmp(cur_interface->m_pName, version) == 0) {
                    return reinterpret_cast<interface*>(cur_interface->m_CreateFn());
                }
            } else {
                std::string versionString;
                versionString.append(version);
                
                std::string interfaceNameString;
                interfaceNameString.append(cur_interface->m_pName);
                
                if (strstr(cur_interface->m_pName, version) && (interfaceNameString.length() - 3) == versionString.length()) {
                    return reinterpret_cast<interface*>(cur_interface->m_CreateFn());
                }
            }
        }
        
        return nullptr;
    }
}

#endif /** !SDK_Interfaces_h */
