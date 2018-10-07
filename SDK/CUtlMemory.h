/******************************************************/
/**                                                  **/
/**      SDK/CUtlMemory.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CUtlMemory_h
#define SDK_CUtlMemory_h

template <class T, class I = int> class CUtlMemory {
public:
    T& operator[](I i) {
        return m_pMemory[i];
    }
protected:
    T* m_pMemory;
    int m_nAllocationCount;
    int m_nGrowSize;
};

#endif /** !SDK_CUtlMemory_h */