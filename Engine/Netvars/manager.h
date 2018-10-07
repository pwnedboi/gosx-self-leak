/******************************************************/
/**                                                  **/
/**      Netvars/manager.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-21                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Netvars_manager_h
#define Netvars_manager_h

#include "SDK/Recv.h"
#include "offsets.h"

namespace NetvarManager {
    extern std::vector<RecvTable*> GetTables();
    extern RecvTable* GetTable(std::vector<RecvTable*> tables, std::string tableName);
    extern int GetOffset(std::vector<RecvTable*> tables, std::string tableName, std::string propName);
    extern int GetProp(std::vector<RecvTable*> tables, std::string tableName, std::string propName, RecvProp** prop = 0);
    extern int GetProp(std::vector<RecvTable*> tables, RecvTable* recvTable, std::string propName, RecvProp** prop = 0);
    extern std::string DumpTable(RecvTable* table, int depth = 0);
    extern uintptr_t HookProp(std::string tableName, std::string propName, RecvVarProxyFn function);
    extern void SetStaticOffsets();
};

#endif /** !Netvars_manager_h */

