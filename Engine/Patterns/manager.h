/******************************************************/
/**                                                  **/
/**      Patterns/manager.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Patterns_manager_h
#define Patterns_manager_h

#include "Engine/common.h"

class MemoryModule {
protected:
    off_t           length = 0;
    uintptr_t       address = 0x0;
    std::string     path = "";
    std::string     fullpath = "";
    unsigned char*  buffer = nullptr;
public:
    MemoryModule() {
        this->length = 0;
        this->address = 0x0;
        this->path = "";
        this->fullpath = "";
    }
    
    MemoryModule(off_t length_, uintptr_t address_, std::string path_, std::string fullpath_) {
        this->length = length_;
        this->address = address_;
        this->path = path_;
        this->fullpath = fullpath_;
    }
    
    ~MemoryModule() {
        delete [] this->buffer;
    }

    bool IsValid() {
        return this->length > 0 &&
               this->address > 0 &&
               this->path.length() > 0 &&
               this->fullpath.length() > 0;
    }
    
    off_t GetLength() {
        return this->length;
    }
    
    uintptr_t GetAddress() {
        return this->address;
    }
    
    std::string GetPath() {
        return this->path;
    }
    
    std::string GetFullpath() {
        return this->fullpath;
    }
    
    unsigned char* GetBuffer() {
        return this->buffer;
    }
};

namespace Helper {
    class CPatternScanner {
    public:
        CPatternScanner();
        uintptr_t FindSignature(uintptr_t rangeStart, off_t dwLen, std::string szSignature);
        uintptr_t GetPointer(std::string imageName, std::string signature, uint32_t start, bool IsCall = false);
        uintptr_t GetProcedure(std::string imageName, std::string signature);
        uintptr_t GetAbsoluteAddress(uintptr_t InstructionPtr, int Offset, int Size);
        std::shared_ptr<MemoryModule> GetModule(std::string imageName, std::string path = "");
    private:
        void LoadModules(std::map<std::string, std::string> modules, bool logModules = false);
        std::map<std::string, std::shared_ptr<MemoryModule>> loaded_modules;
    };
}

extern std::shared_ptr<Helper::CPatternScanner> PatternScanner;

#endif /** !Patterns_manager_h */
