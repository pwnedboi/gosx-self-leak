/******************************************************/
/**                                                  **/
/**      Hooks/Events.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-02-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Hooks_Events_h
#define Hooks_Events_h

#include "SDK/SDK.h"
#include "Engine/Features/SkinChanger.h"
#include "Engine/Features/HitMarker.h"
#ifdef GOSX_RAGE_MODE
#include "Engine/Features/Rage/Resolver.h"
#endif

enum EventWeaponType {
    WEAPONTYPE_UNKNOWN          = -1,
    WEAPONTYPE_KNIFE            = 0,
    WEAPONTYPE_PISTOL           = 1,
    WEAPONTYPE_SUBMACHINEGUN    = 2,
    WEAPONTYPE_RIFLE            = 3,
    WEAPONTYPE_SHOTGUN          = 4,
    WEAPONTYPE_SNIPER_RIFLE     = 5,
    WEAPONTYPE_MACHINEGUN       = 6,
    WEAPONTYPE_C4               = 7,
    WEAPONTYPE_TASER            = 8,
    WEAPONTYPE_GRENADE          = 9,
    WEAPONTYPE_HEALTHSHOT       = 11
};

class CEventListener : public IGameEventListener {
public:
    CEventListener();
    CEventListener(std::vector<const char*> events);
    ~CEventListener();
    void FireGameEvent(IGameEvent* event) override;
    int GetEventDebugID() override;
    void Release(std::vector<const char*> events);
};

#endif /** !Hooks_Events_h */
