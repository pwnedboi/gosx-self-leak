/******************************************************/
/**                                                  **/
/**      Patterns/manager.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"
#include "SDK/SDK.h"
#include <mach-o/dyld.h>

#define INRANGE(x, a, b)  (x >= a && x <= b)
#define getBits(x)        (INRANGE((x & (~0x20)), 'A', 'F') ? ((x & (~0x20)) - 'A' + 0xA) : (INRANGE(x, '0', '9') ? x - '0' : 0))
#define getByte(x)        (getBits(x[0]) << 4 | getBits(x[1]))

Helper::CPatternScanner::CPatternScanner() {
    LoadModules({
        {"engine.dylib", "./bin/osx64/engine.dylib"},
        {"launcher.dylib", "./bin/osx64/launcher.dylib"},
        {"client_panorama.dylib", "./csgo/bin/osx64/client_panorama.dylib"}
    });
}

void Helper::CPatternScanner::LoadModules(std::map<std::string, std::string> modules, bool logModules) {
    FILE* logFile = nullptr;
    bool shouldLog = modules.size() > 0 && logModules;
    if (shouldLog && !logFile) {
        logFile = fopen("loaded_modules.txt", "a+");
    }
    
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char* imageName = _dyld_get_image_name(i);
        std::string baseName = Functions::Basename(imageName);
        
        if (logFile && shouldLog) {
            std::string LogLine = std::string(imageName);
            LogLine.append("\n");
            
            fputs(LogLine.c_str(), logFile);
        }
        
        if (modules.find(baseName) == modules.end()) {
            continue;
        }
        
        struct stat st;
        stat(imageName, &st);
        
        loaded_modules[baseName] = std::make_unique<MemoryModule>(
            st.st_size,
            (uintptr_t)_dyld_get_image_vmaddr_slide(i),
            std::string(imageName),
            std::string(imageName)
        );
    }
    
    if (logFile && shouldLog) {
        fclose(logFile);
    }
}

uintptr_t Helper::CPatternScanner::FindSignature(uintptr_t rangeStart, off_t dwLen, std::string szSignature) {
    const char* pat = szSignature.c_str();
    uintptr_t firstMatch = 0;
    uintptr_t rangeEnd = rangeStart + dwLen;

    for (DWORD pCur = rangeStart; pCur < rangeEnd; pCur++) {
        if (!*pat) {
            return firstMatch;
        }

        if (*(PBYTE)pat == '\?' || *(BYTE*)pCur == getByte(pat)) {
            if (!firstMatch) {
                firstMatch = pCur;
            }

            if (!pat[2]) {
                return firstMatch;
            }

            if (*(PBYTE)pat != '\?') {
                pat += 3;
            } else {
                pat += 2;
            }
        } else {
            pat = szSignature.c_str();
            firstMatch = 0;
        }
    }

    return NULL;
}

uintptr_t Helper::CPatternScanner::GetPointer(std::string imageName, std::string signature, uint32_t start, bool IsCall) {
    std::shared_ptr<MemoryModule> module = GetModule(imageName);
    if (!module) {
        return 0x0;
    }

    uintptr_t dwAddress = module->GetAddress();
    off_t dwLen = module->GetLength();
    
    uintptr_t signatureAddress = FindSignature(dwAddress, dwLen, signature) + start;
    uintptr_t fileOffset = signatureAddress - dwAddress;
    uintptr_t offset = *reinterpret_cast<uint32_t*>(signatureAddress);
    
    if (IsCall) {
        return offset + fileOffset;
    } else {
        return dwAddress + (offset + fileOffset);
    }
}

uintptr_t Helper::CPatternScanner::GetProcedure(std::string imageName, std::string signature) {
    std::shared_ptr<MemoryModule> module = GetModule(imageName);
    if (!module) {
        return 0x0;
    }
    
    uintptr_t dwAddress = module->GetAddress();
    off_t dwLen = module->GetLength();
    
    return FindSignature(dwAddress, dwLen, signature);
}

uintptr_t Helper::CPatternScanner::GetAbsoluteAddress(uintptr_t InstructionPtr, int Offset, int Size) {
    return InstructionPtr + *reinterpret_cast<uint32_t*>(InstructionPtr + Offset) + Size;
}

std::shared_ptr<MemoryModule> Helper::CPatternScanner::GetModule(std::string imageName, std::string path) {
    if (loaded_modules.find(imageName) == loaded_modules.end()) {
        LoadModules({{imageName, path}});
    }
    
    if (loaded_modules.find(imageName) == loaded_modules.end()) {
        return nullptr;
    }
    
    std::shared_ptr<MemoryModule> module = loaded_modules.at(imageName);
    
    if (!module->IsValid()) {
        return nullptr;
    }
    
    return module;
}

std::shared_ptr<Helper::CPatternScanner> PatternScanner = std::make_unique<Helper::CPatternScanner>();
