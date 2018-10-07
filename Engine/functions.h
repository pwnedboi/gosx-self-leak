/******************************************************/
/**                                                  **/
/**      Engine/functions.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-04                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Engine_functions_h
#define Engine_functions_h

#include "Engine/common.h"
#include "Engine/Patterns/manager.h"
#include "SDK/base.h"

#define IDOK       1
#define IDCANCEL   2

namespace Functions {
    struct MatchPathSeparator {
        bool operator()(char ch) const {
            return ch == '\\' || ch == '/';
        }
    };
    
    extern std::string Basename(std::string const& pathname);
    extern std::string GetModulePath();

    template<typename T>
    extern std::vector<T> split(const T & str, const T & delimiters) {
        std::vector<T> v;
        size_t start = 0;
        auto pos = str.find_first_of(delimiters, start);
        while (pos != T::npos) {
            if (pos != start) {
                v.emplace_back(str, start, pos - start);
            }
            start = pos + 1;
            pos = str.find_first_of(delimiters, start);
        }
        if (start < str.length()) {
            v.emplace_back(str, start, str.length() - start);
        }
        return v;
    }

    template <class FloatType>
    extern int SafeFloatToInt(const FloatType &num) {
        if (std::numeric_limits<int>::digits < std::numeric_limits<FloatType>::digits) {
            if ((num < static_cast<FloatType>(std::numeric_limits<int>::max())) &&
               (num > static_cast<FloatType>(std::numeric_limits<int>::min()))) {
                return static_cast<int>(num);
            } else {
                return std::numeric_limits<int>::max();
            }
        } else {
            return static_cast<int>(num);
        }
    }

    extern bool FileExist(std::string fileName);
    extern bool DirExists(std::string dirName);
    extern bool DirWritable(std::string dirPath);
    extern bool CreateDir(std::string dirPath);
    
    template<typename string_t>
    extern string_t DirName(string_t source) {
        if (source.size() <= 1) {
            return source;
        }
        if (*(source.rbegin() + 1) == '/') {
            source.pop_back();
        }
        source.erase(std::find(source.rbegin(), source.rend(), '/').base(), source.end());
        return source;
    }
    
    extern void* GetSelfHandle();
    
    extern long GetTimeStamp();
    extern std::string GetSettingsDir();
    extern std::string GetWorkingPath();
    extern nlohmann::json GetSignatureData(const char* signatureKey);

    template <typename T>
    extern T GetJsonData(const nlohmann::json data, std::string arg0) {
        if (data.find(arg0.c_str()) != data.end()) {
            return data.at(arg0.c_str()).get<T>();
        }

        return (T)NULL;
    }

    template <typename T>
    extern T GetJsonData(const nlohmann::json data, std::string arg0, std::string arg1) {
        if (data.find(arg0.c_str()) != data.end()) {
            const nlohmann::json arg0json = data.at(arg0.c_str());
            if (arg0json.find(arg1.c_str()) != arg0json.end()) {
                return arg0json.at(arg1.c_str()).get<T>();
            }
        }

        return (T)NULL;
    }

    template <typename T>
    extern T GetJsonData(const nlohmann::json data, std::string arg0, std::string arg1, std::string arg2) {
        if (data.find(arg0.c_str()) != data.end()) {
            const nlohmann::json arg0json = data.at(arg0.c_str());
            if (arg0json.find(arg1.c_str()) != arg0json.end()) {
                const nlohmann::json arg1json = arg0json.at(arg1.c_str());
                if (arg1json.find(arg2.c_str()) != arg1json.end()) {
                    return arg1json.at(arg2.c_str()).get<T>();
                }
            }
        }

        return (T)NULL;
    }

    template <typename T>
    extern T GetJsonData(const nlohmann::json data, std::string arg0, std::string arg1, std::string arg2, std::string arg3) {
        if (data.find(arg0.c_str()) != data.end()) {
            const nlohmann::json arg0json = data.at(arg0.c_str());
            if (arg0json.find(arg1.c_str()) != arg0json.end()) {
                const nlohmann::json arg1json = arg0json.at(arg1.c_str());
                if (arg1json.find(arg2.c_str()) != arg1json.end()) {
                    const nlohmann::json arg2json = arg0json.at(arg2.c_str());
                    if (arg2json.find(arg3.c_str()) != arg2json.end()) {
                        return arg2json.at(arg3.c_str()).get<T>();
                    }
                }
            }
        }

        return (T)NULL;
    }

    extern void RemoveFilesRec(std::string directory);
    
    extern std::string WorkingPath;
    extern std::string GetBuildVersion();
};

#endif /** !Engine_functions_h */
