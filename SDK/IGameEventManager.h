/******************************************************/
/**                                                  **/
/**      SDK/IGameEventManager.h                    **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/


#ifndef SDK_IGameEventManager_h
#define SDK_IGameEventManager_h

struct bf_read;
struct bf_write;

class IGameEvent;
class KeyValues;

#define EVENT_DEBUG_ID_INIT 42
#define EVENT_DEBUG_ID_SHUTDOWN 13

class IGameEventListener {
public:
    virtual ~IGameEventListener(void) {};
    virtual void FireGameEvent(IGameEvent* event) = 0;
    virtual int GetEventDebugID(void) = 0;
};

class IGameEventManager {
public:
    virtual ~IGameEventManager(void) {};
    virtual int LoadEventsFromFile(const char* filename) = 0;
    virtual void Reset() = 0;
    virtual bool AddListener(IGameEventListener* listener, const char* name, bool serverside) = 0;
    virtual bool FindListener(IGameEventListener* listener, const char* name) = 0;
    virtual void RemoveListener(IGameEventListener* listener) = 0;
    virtual void AddListenerGlobal(IGameEventListener* listener, bool serverside) = 0;
    virtual IGameEvent* CreateEvent(const char* name, bool force = false, int* cookie = nullptr) = 0;
    virtual bool FireEvent(IGameEvent* event, bool bDontBroadcast = false) = 0;
    virtual bool FireEventClientSide(IGameEvent* event) = 0;
    virtual IGameEvent* DuplicateEvent(IGameEvent* event) = 0;
    virtual void FreeEvent(IGameEvent* event) = 0;
    virtual bool SerializeEvent(IGameEvent* event, bf_write* buffer) = 0;
    virtual IGameEvent* UnserializeEvent(bf_read* buffer) = 0;
    virtual KeyValues* GetEventDataTypes(IGameEvent* event) = 0;
};

extern IGameEventManager* GameEventManager;

#endif /** !SDK_IGameEventManager_h */
