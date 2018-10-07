/******************************************************/
/**                                                  **/
/**      Hooks/VMT.h                                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-16                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_VMT_h
#define Hooks_VMT_h

#include <memory>
#include <string>

class VMT {
private:
    uintptr_t* vmt;
public:
    uintptr_t** interface = nullptr;
    uintptr_t* original_vmt = nullptr;
    unsigned int methodCount = 0;
    
    VMT(void* interface);
    ~VMT();
    void hook(void* method, size_t methodIndex);
    
    template<typename Fn>
    Fn orig(size_t methodIndex) {
        return reinterpret_cast<Fn>(original_vmt[methodIndex]);
    }
    
    void apply();
    void release();
    void dump(std::string dumpfile, int maxMethodCount);
};

#endif /** !Hooks_VMT_h */
