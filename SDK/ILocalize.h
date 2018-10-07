/******************************************************/
/**                                                  **/
/**      SDK/ILocalize.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_ILocalize_h
#define SDK_ILocalize_h

class ILocalize {
public:
    const wchar_t* Find(const char* tokenName) {
        typedef const wchar_t*(*oFunc)(void*, const char*);
        return Interfaces::Function<oFunc>(this, 11)(this, tokenName);
    }
    
    const wchar_t* FindSafe(const char* tokenName) {
        typedef const wchar_t*(*oFunc)(void*, const char*);
        return Interfaces::Function<oFunc>(this, 12)(this, tokenName);
    }
    
    const char* FindAsUTF8(const char* pchTokenName) {
        typedef const char*(*oFunc)(void*, const char*);
        return Interfaces::Function<oFunc>(this, 33)(this, pchTokenName);
    }
};

extern ILocalize* Localize;

#endif /** !SDK_ILocalize_h */
