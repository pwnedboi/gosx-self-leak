/******************************************************/
/**                                                  **/
/**      SDK/IGameMovement.h                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-05-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IGameMovement_h
#define SDK_IGameMovement_h

class CMoveData {
public:
    bool            m_bFirstRunOfFunctions : 1;
    bool            m_bGameCodeMovedPlayer : 1;
    int             m_nPlayerHandle;
    int             m_nImpulseCommand;
    Vector          m_vecViewAngles;
    Vector          m_vecAbsViewAngles;
    int             m_nButtons;
    int             m_nOldButtons;
    float           m_flForwardMove;
    float           m_flSideMove;
    float           m_flUpMove;
    float           m_flMaxSpeed;
    float           m_flClientMaxSpeed;
    Vector          m_vecVelocity;
    Vector          m_vecAngles;
    Vector          m_vecOldAngles;
    float           m_outStepHeight;
    Vector          m_outWishVel;
    Vector          m_outJumpVel;
    Vector          m_vecConstraintCenter;
    float           m_flConstraintRadius;
    float           m_flConstraintWidth;
    float           m_flConstraintSpeedFactor;
    float           m_flUnknown[5];
    Vector          m_vecAbsOrigin;
};

class IGameMovement {
public:
    void ProcessMovement(C_BaseEntity* player, CMoveData* move) {
        typedef void (* oProcessMovement)(void*, C_BaseEntity*, CMoveData*);
        return Interfaces::Function<oProcessMovement>(this, 2)(this, player, move);
    }

    void StartTrackPredictionErrors(C_BaseEntity* player) {
        typedef void (* oStartTrackPredictionErrors)(void*, C_BaseEntity*);
        return Interfaces::Function<oStartTrackPredictionErrors>(this, 4)(this, player);
    }

    void FinishTrackPredictionErrors(C_BaseEntity* player) {
        typedef void (* oFinishTrackPredictionErrors)(void*, C_BaseEntity*);
        return Interfaces::Function<oFinishTrackPredictionErrors>(this, 5)(this, player);
    }
};

extern IGameMovement* GameMovement;

#endif /** !SDK_IGameMovement_h */
