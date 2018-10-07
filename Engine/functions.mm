/******************************************************/
/**                                                  **/
/**      Engine/functions.cpp                        **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "functions.h"
#include <mach-o/dyld.h>

std::string Functions::WorkingPath = "";

std::string Functions::Basename(std::string const& pathname) {
    return std::string(
        std::find_if(pathname.rbegin(), pathname.rend(), MatchPathSeparator()).base(), pathname.end()
    );
}

std::string Functions::GetModulePath() {
    Dl_info info;
    if (dladdr(__builtin_return_address(0), &info)) {
        return info.dli_fname;
    }

    return "";
}

void* Functions::GetSelfHandle() {
    return dlopen(GetModulePath().c_str(), RTLD_NOW | RTLD_NOLOAD);
}

bool Functions::FileExist(std::string fileName) {
    if (FILE *file = fopen(fileName.c_str(), "r")) {
        fclose(file);
        return true;
    } else {
        return false;
    }
}

bool Functions::DirExists(std::string dirName) {
    struct stat info;

    if (stat(dirName.c_str(), &info) != 0) {
        return false;
    } else if (info.st_mode & S_IFDIR) {
        return true;
    }

    return false;
}

bool Functions::CreateDir(std::string dirPath) {
    if (DirExists(dirPath)) {
        return true;
    }
    
    int mkdirResult = mkdir(dirPath.c_str(), S_IRWXU | S_IRWXG | S_IRWXO);
    if (mkdirResult == 0) {
        return true;
    }

    return false;
}

long Functions::GetTimeStamp() {
    timeval time;
    gettimeofday(&time, NULL);
    long millis = (time.tv_sec * 1000) + (time.tv_usec / 1000);

    return millis;
}

std::string Functions::GetSettingsDir() {
    std::string returnPath = "./";
    returnPath.append("hack-settings/");
    
    Functions::CreateDir(returnPath);

    return returnPath;
}

std::string Functions::GetWorkingPath() {
    if (WorkingPath != "") {
        return WorkingPath;
    }
    
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char* imageName = _dyld_get_image_name(i);
        std::string baseName = Functions::Basename(imageName);
        if (baseName == "csgo_osx64") {
            WorkingPath = Functions::DirName(std::string(imageName));
            
            return WorkingPath;
        }
    }
    
    return "";
}

void Functions::RemoveFilesRec(std::string directory) {
    DIR* dir = opendir(directory.c_str());
    if (!dir) {
        return;
    }
    
    int count = 0;
    while (dirent* file = readdir(dir)) {
        if (!strcmp(file->d_name, ".") || !strcmp(file->d_name, "..")) {
            continue;
        }
        
        if (!strcmp(file->d_name, "grenade_configs")) {
            continue;
        }
        
        std::string FilePath = directory;
        FilePath.append(file->d_name);
        
        if (file->d_type == DT_DIR) {
            RemoveFilesRec(FilePath + "/");
        } else {
            if (std::string(file->d_name).find(".ini") != std::string::npos || std::string(file->d_name).find("installed") != std::string::npos) {
                std::remove(FilePath.c_str());
            }
        }
        count++;
    }
    closedir(dir);
}

bool Functions::DirWritable(std::string dirPath) {
    return access(dirPath.c_str(), W_OK) == 0;
}

std::string Functions::GetBuildVersion() {
    std::string version = std::to_string(GOSX_CLIENT_VERSION_MAJOR);
    version.append(".");
    version.append(std::to_string(GOSX_CLIENT_VERSION_MINOR));
    version.append(".");
    version.append(std::to_string(GOSX_CLIENT_VERSION_BUGFIX));
    
    if (GOSX_CLIENT_VERSION_NOTICE != "") {
        version.append("-");
        version.append(GOSX_CLIENT_VERSION_NOTICE);
    }
    
    return version;
}
