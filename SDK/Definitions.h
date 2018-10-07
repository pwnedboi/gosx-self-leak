/******************************************************/
/**                                                  **/
/**      SDK/Definitions.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-28                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Definitions_h
#define SDK_Definitions_h

#include "Engine/common.h"

typedef void* (*CreateInterfaceFn)(const char *pName, int *pReturnCode);
typedef void* (*InstantiateInterfaceFn)();

typedef unsigned long long VPANEL;
typedef unsigned long long ULONG;

#define TEXTURE_GROUP_SKYBOX		"SkyBox textures"

#define BONE_USED_MASK				0x0007FF00
#define BONE_USED_BY_ANYTHING		0x0007FF00
#define BONE_USED_BY_HITBOX			0x00000100	// bone (or child) is used by a hit box
#define BONE_USED_BY_ATTACHMENT		0x00000200	// bone (or child) is used by an attachment point
#define BONE_USED_BY_VERTEX_MASK	0x0003FC00
#define BONE_USED_BY_VERTEX_LOD0	0x00000400	// bone (or child) is used by the toplevel model via skinned vertex
#define BONE_USED_BY_VERTEX_LOD1	0x00000800
#define BONE_USED_BY_VERTEX_LOD2	0x00001000
#define BONE_USED_BY_VERTEX_LOD3	0x00002000
#define BONE_USED_BY_VERTEX_LOD4	0x00004000
#define BONE_USED_BY_VERTEX_LOD5	0x00008000
#define BONE_USED_BY_VERTEX_LOD6	0x00010000
#define BONE_USED_BY_VERTEX_LOD7	0x00020000
#define BONE_USED_BY_BONE_MERGE		0x00040000

#define SEQUENCE_DEFAULT_DRAW 0
#define SEQUENCE_DEFAULT_IDLE1 1
#define SEQUENCE_DEFAULT_IDLE2 2
#define SEQUENCE_DEFAULT_LIGHT_MISS1 3
#define SEQUENCE_DEFAULT_LIGHT_MISS2 4
#define SEQUENCE_DEFAULT_HEAVY_MISS1 9
#define SEQUENCE_DEFAULT_HEAVY_HIT1 10
#define SEQUENCE_DEFAULT_HEAVY_BACKSTAB 11
#define SEQUENCE_DEFAULT_LOOKAT01 12
#define SEQUENCE_BUTTERFLY_DRAW 0
#define SEQUENCE_BUTTERFLY_DRAW2 1
#define SEQUENCE_BUTTERFLY_LOOKAT01 13
#define SEQUENCE_BUTTERFLY_LOOKAT02 14
#define SEQUENCE_BUTTERFLY_LOOKAT03 15
#define SEQUENCE_FALCHION_IDLE1 1
#define SEQUENCE_FALCHION_HEAVY_MISS1 8
#define SEQUENCE_FALCHION_HEAVY_MISS1_NOFLIP 9
#define SEQUENCE_FALCHION_LOOKAT01 12
#define SEQUENCE_FALCHION_LOOKAT02 13
#define SEQUENCE_DAGGERS_IDLE1 1
#define SEQUENCE_DAGGERS_LIGHT_MISS1 2
#define SEQUENCE_DAGGERS_LIGHT_MISS5 6
#define SEQUENCE_DAGGERS_HEAVY_MISS2 11
#define SEQUENCE_DAGGERS_HEAVY_MISS1 12
#define SEQUENCE_BOWIE_IDLE1 1

#define SEQUENCE_MP7_IDLE 0
#define SEQUENCE_MP7_RELOAD 1
#define SEQUENCE_MP7_DRAW 2
#define SEQUENCE_MP7_SHOOT 3
#define SEQUENCE_MP7_LOOKAT 4

#define SEQUENCE_MP5SD_IDLE 0
#define SEQUENCE_MP5SD_RELOAD 1
#define SEQUENCE_MP5SD_SHOOT 2
#define SEQUENCE_MP5SD_DRAW01 3
#define SEQUENCE_MP5SD_DRAW02 4
#define SEQUENCE_MP5SD_LOOKAT 5


#define IN_ATTACK        (1 << 0)
#define IN_JUMP          (1 << 1)
#define IN_DUCK          (1 << 2)
#define IN_FORWARD       (1 << 3)
#define IN_BACK          (1 << 4)
#define IN_USE           (1 << 5)
#define IN_CANCEL        (1 << 6)
#define IN_LEFT          (1 << 7)
#define IN_RIGHT         (1 << 8)
#define IN_MOVELEFT      (1 << 9)
#define IN_MOVERIGHT     (1 << 10)
#define IN_ATTACK2       (1 << 11)
#define IN_RUN           (1 << 12)
#define IN_RELOAD        (1 << 13)
#define IN_ALT1          (1 << 14)
#define IN_ALT2          (1 << 15)
#define IN_SCORE         (1 << 16)   // Used by client.dll for when scoreboard is held down
#define IN_SPEED         (1 << 17) // Player is holding the speed key
#define IN_WALK          (1 << 18) // Player holding walk key
#define IN_ZOOM          (1 << 19) // Zoom key for HUD zoom
#define IN_WEAPON1       (1 << 20) // weapon defines these bits
#define IN_WEAPON2       (1 << 21) // weapon defines these bits
#define IN_BULLRUSH      (1 << 22)
#define IN_GRENADE1      (1 << 23) // grenade 1
#define IN_GRENADE2      (1 << 24) // grenade 2
#define IN_LOOKSPIN      (1 << 25)

#define TICK_INTERVAL       ((*GlobalVars)->interval_per_tick)
#define TIME_TO_TICKS(dt)   ((int)(0.5f + (float)(dt) / TICK_INTERVAL))

#define STUDIO_NONE                     0x00000000
#define STUDIO_RENDER                   0x00000001
#define STUDIO_VIEWXFORMATTACHMENTS     0x00000002
#define STUDIO_DRAWTRANSLUCENTSUBMODELS 0x00000004
#define STUDIO_TWOPASS                  0x00000008
#define STUDIO_STATIC_LIGHTING          0x00000010
#define STUDIO_WIREFRAME                0x00000020
#define STUDIO_ITEM_BLINK               0x00000040
#define STUDIO_NOSHADOWS                0x00000080
#define STUDIO_WIREFRAME_VCOLLIDE       0x00000100
#define STUDIO_NOLIGHTING_OR_CUBEMAP    0x00000200
#define STUDIO_SKIP_FLEXES              0x00000400
#define STUDIO_DONOTMODIFYSTENCILSTATE  0x00000800
#define STUDIO_TRANSPARENCY             0x80000000
#define STUDIO_SHADOWDEPTHTEXTURE       0x40000000
#define STUDIO_SHADOWTEXTURE            0x20000000
#define STUDIO_SKIP_DECALS              0x10000000

enum FontFlags {
    FONTFLAG_NONE,
    FONTFLAG_ITALIC = 0x001,
    FONTFLAG_UNDERLINE = 0x002,
    FONTFLAG_STRIKEOUT = 0x004,
    FONTFLAG_SYMBOL = 0x008,
    FONTFLAG_ANTIALIAS = 0x010,
    FONTFLAG_GAUSSIANBLUR = 0x020,
    FONTFLAG_ROTARY = 0x040,
    FONTFLAG_DROPSHADOW = 0x080,
    FONTFLAG_ADDITIVE = 0x100,
    FONTFLAG_OUTLINE = 0x200,
    FONTFLAG_CUSTOM = 0x400,
    FONTFLAG_BITMAP = 0x800,
};

enum class EntityFlags {
    FL_ONGROUND = (1 << 0),
    FL_DUCKING = (1 << 1),
    FL_WATERJUMP = (1 << 2),
    FL_ONTRAIN = (1 << 3),
    FL_INRAIN = (1 << 4),
    FL_FROZEN = (1 << 5),
    FL_ATCONTROLS = (1 << 6),
    FL_CLIENT = (1 << 7),
    FL_FAKECLIENT = (1 << 8)
};

enum EntityTeam {
    TEAM_NONE   = 0,
    TEAM_SPEC   = 1,
    TEAM_T      = 2,
    TEAM_CT     = 3
};

enum class ClientFrameStage_t {
    FRAME_UNDEFINED = -1,
    FRAME_START,
    FRAME_NET_UPDATE_START,
    FRAME_NET_UPDATE_POSTDATAUPDATE_START,
    FRAME_NET_UPDATE_POSTDATAUPDATE_END,
    FRAME_NET_UPDATE_END,
    FRAME_RENDER_START,
    FRAME_RENDER_END
};

enum class LifeState {
    LIFE_ALIVE = 0,// alive
    LIFE_DYING = 1, // playing death animation or still falling off of a ledge waiting to hit ground
    LIFE_DEAD = 2 // dead. lying still.
};

enum EItemDefinitionIndex {
    weapon_none = 0,
    weapon_deagle = 1,
    weapon_elite = 2,
    weapon_fiveseven = 3,
    weapon_glock = 4,
    weapon_ak47 = 7,
    weapon_aug = 8,
    weapon_awp = 9,
    weapon_famas = 10,
    weapon_g3sg1 = 11,
    weapon_galilar = 13,
    weapon_m249 = 14,
    weapon_m4a1 = 16,
    weapon_mac10 = 17,
    weapon_p90 = 19,
    weapon_mp5sd = 23,
    weapon_ump45 = 24,
    weapon_xm1014 = 25,
    weapon_bizon = 26,
    weapon_mag7 = 27,
    weapon_negev = 28,
    weapon_sawedoff = 29,
    weapon_tec9 = 30,
    weapon_taser = 31,
    weapon_hkp2000 = 32,
    weapon_mp7 = 33,
    weapon_mp9 = 34,
    weapon_nova = 35,
    weapon_p250 = 36,
    weapon_scar20 = 38,
    weapon_sg556 = 39,
    weapon_ssg08 = 40,
    weapon_knife = 42,
    weapon_flashbang = 43,
    weapon_hegrenade = 44,
    weapon_smokegrenade = 45,
    weapon_molotov = 46,
    weapon_decoy = 47,
    weapon_incgrenade = 48,
    weapon_c4 = 49,
    // weapon_defkit = 55,
    weapon_knife_t = 59,
    weapon_m4a1_silencer = 60,
    weapon_usp_silencer = 61,
    weapon_cz75a = 63,
    weapon_revolver = 64,
    weapon_knife_bayonet = 500,
    weapon_knife_flip = 505,
    weapon_knife_gut = 506,
    weapon_knife_karambit = 507,
    weapon_knife_m9_bayonet = 508,
    weapon_knife_tactical = 509,
    weapon_knife_falchion = 512,
    weapon_knife_survival_bowie = 514,
    weapon_knife_butterfly = 515,
    weapon_knife_push = 516,
    weapon_knife_ursus = 519,
    weapon_knife_gypsy_jackknife = 520,
    weapon_knife_stiletto = 522,
    weapon_knife_widowmaker = 523,
    weapon_max = 524,
    studded_bloodhound_gloves = 5027,
    glove_t = 5028,
    glove_ct = 5029,
    sporty_gloves = 5030,
    slick_gloves = 5031,
    leather_handwraps = 5032,
    motorcycle_gloves = 5033,
    specialist_gloves = 5034,
    studded_hydra_gloves = 5035,
    glove_max = 5036
};

enum EClassIds {
    CAI_BaseNPC = 0,
    CAK47,
    CBaseAnimating,
    CBaseAnimatingOverlay,
    CBaseAttributableItem,
    CBaseButton,
    CBaseCombatCharacter,
    CBaseCombatWeapon,
    CBaseCSGrenade,
    CBaseCSGrenadeProjectile,
    CBaseDoor,
    CBaseEntity,
    CBaseFlex,
    CBaseGrenade,
    CBaseParticleEntity,
    CBasePlayer,
    CBasePropDoor,
    CBaseTeamObjectiveResource,
    CBaseTempEntity,
    CBaseToggle,
    CBaseTrigger,
    CBaseViewModel,
    CBaseVPhysicsTrigger,
    CBaseWeaponWorldModel,
    CBeam,
    CBeamSpotlight,
    CBoneFollower,
    CBreakableProp,
    CBreakableSurface,
    CC4,
    CCascadeLight,
    CChicken,
    CColorCorrection,
    CColorCorrectionVolume,
    CCSGameRulesProxy,
    CCSPlayer,
    CCSPlayerResource,
    CCSRagdoll,
    CCSTeam,
    CDEagle,
    CDecoyGrenade,
    CDecoyProjectile,
    CDynamicLight,
    CDynamicProp,
    CEconEntity,
    CEconWearable,
    CEmbers,
    CEntityDissolve,
    CEntityFlame,
    CEntityFreezing,
    CEntityParticleTrail,
    CEnvAmbientLight,
    CEnvDetailController,
    CEnvDOFController,
    CEnvParticleScript,
    CEnvProjectedTexture,
    CEnvQuadraticBeam,
    CEnvScreenEffect,
    CEnvScreenOverlay,
    CEnvTonemapController,
    CEnvWind,
    CFEPlayerDecal,
    CFireCrackerBlast,
    CFireSmoke,
    CFireTrail,
    CFish,
    CFlashbang, // correct
    CFogController,
    CFootstepControl,
    CFunc_Dust,
    CFunc_LOD,
    CFuncAreaPortalWindow,
    CFuncBrush,
    CFuncConveyor,
    CFuncLadder,
    CFuncMonitor,
    CFuncMoveLinear,
    CFuncOccluder,
    CFuncReflectiveGlass,
    CFuncRotating,
    CFuncSmokeVolume,
    CFuncTrackTrain,
    CGameRulesProxy,
    CHandleTest,
    CHEGrenade, // correct
    CHostage,
    CHostageCarriableProp,
    CIncendiaryGrenade,
    CInferno,
    CInfoLadderDismount,
    CInfoOverlayAccessor,
    CItem_Healthshot,
    CItemDogtags,
    CKnife,
    CKnifeGG,
    CLightGlow,
    CMaterialModifyControl,
    CMolotovGrenade,
    CMolotovProjectile,
    CMovieDisplay,
    CParticleFire,
    CParticlePerformanceMonitor,
    CParticleSystem,
    CPhysBox,
    CPhysBoxMultiplayer,
    CPhysicsProp,
    CPhysicsPropMultiplayer,
    CPhysMagnet,
    CPlantedC4,
    CPlasma,
    CPlayerResource,
    CPointCamera,
    CPointCommentaryNode,
    CPointWorldText,
    CPoseController,
    CPostProcessController,
    CPrecipitation,
    CPrecipitationBlocker,
    CPredictedViewModel,
    CProp_Hallucination,
    CPropDoorRotating,
    CPropJeep,
    CPropVehicleDriveable,
    CRagdollManager,
    CRagdollProp,
    CRagdollPropAttached,
    CRopeKeyframe,
    CSCAR17,
    CSceneEntity,
    CSensorGrenade,
    CSensorGrenadeProjectile,
    CShadowControl,
    CSlideshowDisplay,
    CSmokeGrenade,
    CSmokeGrenadeProjectile,
    CSmokeStack,
    CSpatialEntity,
    CSpotlightEnd,
    CSprite,
    CSpriteOriented,
    CSpriteTrail,
    CStatueProp,
    CSteamJet,
    CSun,
    CSunlightShadowControl,
    CTeam,
    CTeamplayRoundBasedRulesProxy,
    CTEArmorRicochet,
    CTEBaseBeam,
    CTEBeamEntPoint,
    CTEBeamEnts,
    CTEBeamFollow,
    CTEBeamLaser,
    CTEBeamPoints,
    CTEBeamRing,
    CTEBeamRingPoint,
    CTEBeamSpline,
    CTEBloodSprite,
    CTEBloodStream,
    CTEBreakModel,
    CTEBSPDecal,
    CTEBubbles,
    CTEBubbleTrail,
    CTEClientProjectile,
    CTEDecal,
    CTEDust,
    CTEDynamicLight,
    CTEEffectDispatch,
    CTEEnergySplash,
    CTEExplosion,
    CTEFireBullets,
    CTEFizz,
    CTEFootprintDecal,
    CTEFoundryHelpers,
    CTEGaussExplosion,
    CTEGlowSprite,
    CTEImpact,
    CTEKillPlayerAttachments,
    CTELargeFunnel,
    CTEMetalSparks,
    CTEMuzzleFlash,
    CTEParticleSystem,
    CTEPhysicsProp,
    CTEPlantBomb,
    CTEPlayerAnimEvent,
    CTEPlayerDecal,
    CTEProjectedDecal,
    CTERadioIcon,
    CTEShatterSurface,
    CTEShowLine,
    CTesla,
    CTESmoke,
    CTESparks,
    CTESprite,
    CTESpriteSpray,
    CTest_ProxyToggle_Networkable,
    CTestTraceline,
    CTEWorldDecal,
    CTriggerPlayerMovement,
    CTriggerSoundOperator,
    CVGuiScreen,
    CVoteController,
    CWaterBullet,
    CWaterLODControl,
    CWeaponAug,
    CWeaponAWP,
    CWeaponBaseItem,
    CWeaponBizon,
    CWeaponCSBase,
    CWeaponCSBaseGun,
    CWeaponCycler,
    CWeaponElite,
    CWeaponFamas,
    CWeaponFiveSeven,
    CWeaponG3SG1,
    CWeaponGalil,
    CWeaponGalilAR,
    CWeaponGlock,
    CWeaponHKP2000,
    CWeaponM249,
    CWeaponM3,
    CWeaponM4A1,
    CWeaponMAC10,
    CWeaponMag7,
    CWeaponMP5Navy,
    CWeaponMP7,
    CWeaponMP9,
    CWeaponNegev,
    CWeaponNOVA,
    CWeaponP228,
    CWeaponP250,
    CWeaponP90,
    CWeaponSawedoff,
    CWeaponSCAR20,
    CWeaponScout,
    CWeaponSG550,
    CWeaponSG552,
    CWeaponSG556,
    CWeaponSSG08,
    CWeaponTaser,
    CWeaponTec9,
    CWeaponTMP,
    CWeaponUMP45,
    CWeaponUSP,
    CWeaponXM1014,
    CWorld,
    DustTrail,
    MovieExplosion,
    ParticleSmokeGrenade,
    RocketTrail,
    SmokeTrail,
    SporeExplosion,
    SporeTrail
};

enum ECSPlayerBones {
    pelvis = 0,
    spine_0,
    spine_1,
    spine_2,
    spine_3,
    neck_0,
    head_0,
    clavicle_L,
    arm_upper_L,
    arm_lower_L,
    hand_L
};

enum class PlayerBones {
    None = -1,
    Head = 0,
    Neck = 1,
    Neck_Lower = 2,
    Pelvis = 3,
    Stomach = 4,
    Lower_Chest = 5,
    Chest = 6,
    Upper_Chest = 7,
    Right_Thigh = 8,
    Left_Thigh = 9,
    Right_Shin = 10,
    Left_Shin = 11,
    Right_Foot = 12,
    Left_Foot = 13
};

enum HitGroups: int {
    HITGROUP_GENERIC = 0,
    HITGROUP_HEAD,
    HITGROUP_CHEST,
    HITGROUP_STOMACH,
    HITGROUP_LEFTARM,
    HITGROUP_RIGHTARM,
    HITGROUP_LEFTLEG,
    HITGROUP_RIGHTLEG,
    HITGROUP_GEAR
};

struct Item_t {
    Item_t(
        const char* display_name,
        const char* entity_name,
        const char* model,
        const char* killicon = nullptr,
        const char* world_model = nullptr,
        const char* world_dropped_model = nullptr
    ) {
        this->display_name = display_name;
        this->entity_name = entity_name;
        this->model = model;
        this->killicon = killicon;
        this->world_model = world_model;
        this->world_dropped_model = world_dropped_model;
    }
    const char* display_name = nullptr;
    const char* entity_name = nullptr;
    const char* model = nullptr;
    const char* killicon = nullptr;
    const char* world_model = nullptr;
    const char* world_dropped_model = nullptr;
};

enum DataUpdateType_t {
    DATA_UPDATE_CREATED = 0,
    DATA_UPDATE_DATATABLE_CHANGED,
};

enum {
    OBS_MODE_NONE = 0,  // not in spectator mode
    OBS_MODE_DEATHCAM,  // special mode for death cam animation
    OBS_MODE_FREEZECAM, // zooms to a target, and freeze-frames on them
    OBS_MODE_FIXED,     // view from a fixed camera position
    OBS_MODE_IN_EYE,    // follow a player in first person view
    OBS_MODE_CHASE,     // follow a player in third person view
    OBS_MODE_POI,       // PASSTIME point of interest - game objective, big fight, anything interesting; added in the middle of the enum due to tons of hard-coded "<ROAMING" enum compares
    OBS_MODE_ROAMING,   // free roaming

    NUM_OBSERVER_MODES,
};

enum MoveType_t {
    MOVETYPE_NONE = 0,
    MOVETYPE_ISOMETRIC,
    MOVETYPE_WALK,
    MOVETYPE_STEP,
    MOVETYPE_FLY,
    MOVETYPE_FLYGRAVITY,
    MOVETYPE_VPHYSICS,
    MOVETYPE_PUSH,
    MOVETYPE_NOCLIP,
    MOVETYPE_LADDER,
    MOVETYPE_OBSERVER,
    MOVETYPE_CUSTOM,
    MOVETYPE_LAST = MOVETYPE_CUSTOM,
    MOVETYPE_MAX_BITS = 4
};

#ifdef GOSX_RAGE_MODE
enum ResolverMode {
    OFF = 0,
    FORCE,
    DELTA,
    STEADY,
    TICKMODULO,
    POSEPARAM,
    ALL,
};

enum class AutostrafeType : int {
    AS_FORWARDS = 0,
    AS_BACKWARDS,
    AS_LEFTSIDEWAYS,
    AS_RIGHTSIDEWAYS,
    AS_RAGE,
};
#endif

#define MAX_STUDIO_SKINS 32
#define MAX_STUDIO_BONES 128
#define MAX_PLAYER_NAME_LENGTH 32
#define SIGNED_GUID_LEN 32

#endif /** !SDK_Definitions_h */
