/******************************************************/
/**                                                  **/
/**      Hooks/Events.cpp                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-02-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Events.h"

bool* Glob::IsWeaponSwitched = nullptr;

CEventListener::CEventListener() {
    std::vector<const char*> events = {
        "player_hurt",
        "player_death",
        "item_equip"
#ifdef GOSX_RAGE_MODE
        , "player_connect_full",
        "cs_game_disconnected"
#endif
    };

    for (auto& it : events) {
        GameEventManager->AddListener(this, it, false);
    }
}

CEventListener::CEventListener(std::vector<const char*> events) {
    for (auto& it : events) {
        GameEventManager->AddListener(this, it, false);
    }
}

CEventListener::~CEventListener() {
    GameEventManager->RemoveListener(this);
}

void CEventListener::FireGameEvent(IGameEvent* event) {
    if (std::string(event->GetName()) == "item_equip") {
        if (Engine->GetLocalPlayer() != Engine->GetPlayerForUserID(event->GetInt("userid"))) {
            return;
        }
        
        *Glob::IsWeaponSwitched = true;
        
        return;
    }
    
#ifdef GOSX_RAGE_MODE
    Features::CResolver::FireEvent(event);
#endif
    SkinChanger->FireEvent(event);
    HitMarker->FireEvent(event);
}

int CEventListener::GetEventDebugID() {
    return EVENT_DEBUG_ID_INIT;
}
