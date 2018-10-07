/******************************************************/
/**                                                  **/
/**      SDK/NetworkableReader.h                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-16                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_NetworkableReader_h
#define SDK_NetworkableReader_h

#include <memory>

class NetworkableReader {
public:
    template<class T>
    inline T GetFieldValue(uintptr_t offset) {
        return *(T*)((uintptr_t)this + offset);
    }
    
    template<class T>
    T* GetFieldPointer(uintptr_t offset) {
        return (T*)((uintptr_t)this + offset);
    }
};

#endif /** !SDK_NetworkableReader_h */
