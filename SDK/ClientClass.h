/******************************************************/
/**                                                  **/
/**      SDK/ClientClass.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_ClientClass_h
#define SDK_ClientClass_h

#include "Definitions.h"

#include "Recv.h"
#include "IClientEntity.h"

class ClientClass;

typedef IClientNetworkable*   (*CreateClientClassFn)(int entnum, int serialNum);
typedef IClientNetworkable*   (*CreateEventFn)();

class ClientClass {
public:
    CreateClientClassFn      m_pCreateFn;
    CreateEventFn            m_pCreateEventFn;
    char*                    m_pNetworkName;
    RecvTable*               m_pRecvTable;
    ClientClass*             m_pNext;
    int                      m_ClassID;
};

#endif /** !SDK_ClientClass_h */
