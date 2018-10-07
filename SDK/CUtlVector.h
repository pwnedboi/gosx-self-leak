/******************************************************/
/**                                                  **/
/**      SDK/CUtlVector.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CUtlVector_h
#define SDK_CUtlVector_h

template <class T, class A = CUtlMemory<T>> class CUtlVector {
    typedef A CAllocator;

public:
    T& operator[](int i) {
        return m_Memory[i];
    }

    int Count() const {
        return m_Size;
    }
protected:
    CAllocator m_Memory;
    int m_Size;
    T* m_pElements;
};

#endif /** !SDK_CUtlVector_h */
