/******************************************************/
/**                                                  **/
/**      SDK/Interfaces.mm                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Interfaces.h"

void**& Interfaces::Table(void* inst, size_t offset) {
    return *reinterpret_cast<void***>((size_t)inst + offset);
}

const void** Interfaces::Table(const void* inst, size_t offset) {
    return *reinterpret_cast<const void***>((size_t)inst + offset);
}
