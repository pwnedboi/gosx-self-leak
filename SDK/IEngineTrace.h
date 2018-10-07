/******************************************************/
/**                                                  **/
/**      SDK/IEngineTrace.h                          **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-19                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_IEngineTrace_h
#define SDK_IEngineTrace_h

#include "CUtlMemory.h"
#include "CUtlVector.h"

#define   DISPSURF_FLAG_SURFACE           (1<<0)
#define   DISPSURF_FLAG_WALKABLE          (1<<1)
#define   DISPSURF_FLAG_BUILDABLE         (1<<2)
#define   DISPSURF_FLAG_SURFPROP1         (1<<3)
#define   DISPSURF_FLAG_SURFPROP2         (1<<4)
#define   CONTENTS_EMPTY                0
#define   CONTENTS_SOLID                0x1
#define   CONTENTS_WINDOW               0x2
#define   CONTENTS_AUX                  0x4
#define   CONTENTS_GRATE                0x8
#define   CONTENTS_SLIME                0x10
#define   CONTENTS_WATER                0x20
#define   CONTENTS_BLOCKLOS             0x40
#define   CONTENTS_OPAQUE               0x80
#define   LAST_VISIBLE_CONTENTS         CONTENTS_OPAQUE
#define   ALL_VISIBLE_CONTENTS            (LAST_VISIBLE_CONTENTS | (LAST_VISIBLE_CONTENTS-1))
#define   CONTENTS_TESTFOGVOLUME        0x100
#define   CONTENTS_UNUSED               0x200
#define   CONTENTS_BLOCKLIGHT           0x400
#define   CONTENTS_TEAM1                0x800
#define   CONTENTS_TEAM2                0x1000
#define   CONTENTS_IGNORE_NODRAW_OPAQUE 0x2000
#define   CONTENTS_MOVEABLE             0x4000
#define   CONTENTS_AREAPORTAL           0x8000
#define   CONTENTS_PLAYERCLIP           0x10000
#define   CONTENTS_MONSTERCLIP          0x20000
#define   CONTENTS_CURRENT_0            0x40000
#define   CONTENTS_CURRENT_90           0x80000
#define   CONTENTS_CURRENT_180          0x100000
#define   CONTENTS_CURRENT_270          0x200000
#define   CONTENTS_CURRENT_UP           0x400000
#define   CONTENTS_CURRENT_DOWN         0x800000
#define   CONTENTS_ORIGIN               0x1000000
#define   CONTENTS_MONSTER              0x2000000
#define   CONTENTS_DEBRIS               0x4000000
#define   CONTENTS_DETAIL               0x8000000
#define   CONTENTS_TRANSLUCENT          0x10000000
#define   CONTENTS_LADDER               0x20000000
#define   CONTENTS_HITBOX               0x40000000
#define   SURF_LIGHT                    0x0001
#define   SURF_SKY2D                    0x0002
#define   SURF_SKY                      0x0004
#define   SURF_WARP                     0x0008
#define   SURF_TRANS                    0x0010
#define   SURF_NOPORTAL                 0x0020
#define   SURF_TRIGGER                  0x0040
#define   SURF_NODRAW                   0x0080
#define   SURF_HINT                     0x0100
#define   SURF_SKIP                     0x0200
#define   SURF_NOLIGHT                  0x0400
#define   SURF_BUMPLIGHT                0x0800
#define   SURF_NOSHADOWS                0x1000
#define   SURF_NODECALS                 0x2000
#define   SURF_NOPAINT                  SURF_NODECALS
#define   SURF_NOCHOP                   0x4000
#define   SURF_HITBOX                   0x8000

// -----------------------------------------------------
// spatial content masks - used for spatial queries (traceline,etc.)
// -----------------------------------------------------

#define   MASK_ALL                      (0xFFFFFFFF)
#define   MASK_SOLID                    (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
#define   MASK_PLAYERSOLID              (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_PLAYERCLIP|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
#define   MASK_NPCSOLID                 (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTERCLIP|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
#define   MASK_NPCFLUID                 (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTERCLIP|CONTENTS_WINDOW|CONTENTS_MONSTER)
#define   MASK_WATER                    (CONTENTS_WATER|CONTENTS_MOVEABLE|CONTENTS_SLIME)
#define   MASK_OPAQUE                   (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_OPAQUE)
#define   MASK_OPAQUE_AND_NPCS          (MASK_OPAQUE|CONTENTS_MONSTER)
#define   MASK_BLOCKLOS                 (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_BLOCKLOS)
#define   MASK_BLOCKLOS_AND_NPCS        (MASK_BLOCKLOS|CONTENTS_MONSTER)
#define   MASK_VISIBLE                  (MASK_OPAQUE|CONTENTS_IGNORE_NODRAW_OPAQUE)
#define   MASK_VISIBLE_AND_NPCS         (MASK_OPAQUE_AND_NPCS|CONTENTS_IGNORE_NODRAW_OPAQUE)
#define   MASK_SHOT                     (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_HITBOX)
#define   MASK_SHOT_BRUSHONLY           (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_DEBRIS)
#define   MASK_SHOT_HULL                (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE)
#define   MASK_SHOT_PORTAL              (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_MONSTER)
#define   MASK_SOLID_BRUSHONLY          (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_GRATE)
#define   MASK_PLAYERSOLID_BRUSHONLY    (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_PLAYERCLIP|CONTENTS_GRATE)
#define   MASK_NPCSOLID_BRUSHONLY       (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_MONSTERCLIP|CONTENTS_GRATE)
#define   MASK_NPCWORLDSTATIC           (CONTENTS_SOLID|CONTENTS_WINDOW|CONTENTS_MONSTERCLIP|CONTENTS_GRATE)
#define   MASK_NPCWORLDSTATIC_FLUID     (CONTENTS_SOLID|CONTENTS_WINDOW|CONTENTS_MONSTERCLIP)
#define   MASK_SPLITAREAPORTAL          (CONTENTS_WATER|CONTENTS_SLIME)
#define   MASK_CURRENT                  (CONTENTS_CURRENT_0|CONTENTS_CURRENT_90|CONTENTS_CURRENT_180|CONTENTS_CURRENT_270|CONTENTS_CURRENT_UP|CONTENTS_CURRENT_DOWN)
#define   MASK_DEADSOLID                (CONTENTS_SOLID|CONTENTS_PLAYERCLIP|CONTENTS_WINDOW|CONTENTS_GRATE)

class CTraceListData;
class CPhysCollide;
class Vector4D;
class ITraceListData;
struct virtualmeshlist_t;
struct BrushSideInfo_t;

enum TraceType_t {
    TRACE_EVERYTHING = 0,
    TRACE_WORLD_ONLY,
    TRACE_ENTITIES_ONLY,
    TRACE_EVERYTHING_FILTER_PROPS,
};

enum DebugTraceCounterBehavior_t {
    kTRACE_COUNTER_SET = 0,
    kTRACE_COUNTER_INC,
};

struct csurface_t {
    const char* name;
    short surfaceProps;
    unsigned short flags;
};

class C_CSPlayer;

class CBaseTrace {
public:
    Vector                  startpos;
    Vector                  endpos;
    cplane_t                plane;
    float                   fraction;
    int                     contents;
    unsigned short          dispFlags;
    bool                    allsolid;
    bool                    startsolid;
};

class CGameTrace : public CBaseTrace {
public:
    bool                    DidHitWorld() const;
    bool                    DidHitNonWorldEntity() const;
    int                     GetEntityIndex() const;
    bool                    DidHit() const;
public:
    float                   fractionleftsolid;
    csurface_t              surface;
    int                     hitgroup;
    short                   physicsbone;
    unsigned short          worldSurfaceIndex;
    C_CSPlayer*             m_pEntityHit;
    int                     hitbox;
    char                    shit[0x24];
};

inline bool CGameTrace::DidHit() const {
    return fraction < 1.0f || allsolid || startsolid;
}

typedef CGameTrace trace_t;

struct Ray_t {
    VectorAligned m_Start;
    VectorAligned m_Delta;
    VectorAligned m_StartOffset;
    VectorAligned m_Extents;

    const matrix3x4_t* m_pWorldAxisTransform;

    bool m_IsRay;
    bool m_IsSwept;

    Ray_t() : m_pWorldAxisTransform(NULL) { }

    void Init(Vector vecStart, Vector vecEnd) {
        m_Delta = vecEnd - vecStart;
        m_IsSwept = (m_Delta.LengthSqr() != 0);
        m_Extents.x = m_Extents.y = m_Extents.z = 0.0f;
        m_pWorldAxisTransform = NULL;
        m_IsRay = true;
        m_StartOffset.x = m_StartOffset.y = m_StartOffset.z = 0.0f;
        m_Start = vecStart;
    }

    void Init(Vector const& start, Vector const& end, Vector const& mins, Vector const& maxs) {
        m_Delta = end - start;

        m_pWorldAxisTransform = NULL;
        m_IsSwept = (m_Delta.LengthSqr() != 0);
        m_Extents = maxs - mins;
        m_Extents *= 0.5f;
        m_IsRay = (m_Extents.LengthSqr() < 1e-6);

        // Offset m_Start to be in the center of the box...
        m_StartOffset = maxs + mins;
        m_StartOffset *= 0.5f;
        m_Start = start + m_StartOffset;
        m_StartOffset *= -1.0f;
    }
};

class ITraceFilter {
public:
    virtual bool ShouldHitEntity(C_BaseEntity* pEntity) = 0;
    virtual TraceType_t GetTraceType() const = 0;
};

class CTraceFilter : public ITraceFilter {
public:
    bool ShouldHitEntity(C_BaseEntity* pEntityHandle) {
        return !(pEntityHandle == pSkip);
    }

    virtual TraceType_t GetTraceType() const {
        return TRACE_EVERYTHING;
    }

    void* pSkip;
};

class CTraceFilterEntitiesOnly : public ITraceFilter {
public:
    bool ShouldHitEntity(C_BaseEntity* pEntityHandle) {
        return !(pEntityHandle == pSkip);
    }

    virtual TraceType_t GetTraceType() const {
        return TRACE_ENTITIES_ONLY;
    }

    void* pSkip;
};

class CTraceFilterWorldAndPropsOnly : public ITraceFilter {
public:
    bool ShouldHitEntity(C_BaseEntity* pServerEntity) {
        return false;
    }
    
    virtual TraceType_t GetTraceType() const {
        return TRACE_WORLD_ONLY;
    }
};

class IEntityEnumerator {
public:
    // This gets called with each handle
    virtual bool EnumEntity(IHandleEntity* pHandleEntity) = 0;
};

class IEngineTrace {
public:
    // Returns the contents mask + entity at a particular world-space position
    virtual int GetPointContents(const Vector &vecAbsPosition, int contentsMask = (int)MASK_ALL, IHandleEntity** ppEntity = NULL) = 0;

    // Returns the contents mask of the world only @ the world-space position (static props are ignored)
    virtual int GetPointContents_WorldOnly(const Vector &vecAbsPosition, int contentsMask = (int)MASK_ALL) = 0;

    // Get the point contents, but only test the specific entity. This works
    // on static props and brush models.
    //
    // If the entity isn't a static prop or a brush model, it returns CONTENTS_EMPTY and sets
    // bFailed to true if bFailed is non-null.
    virtual int GetPointContents_Collideable(ICollideable *pCollide, const Vector &vecAbsPosition) = 0;

    // Traces a ray against a particular entity
    virtual void ClipRayToEntity(const Ray_t &ray, unsigned int fMask, IHandleEntity *pEnt, trace_t *pTrace) = 0;

    // Traces a ray against a particular entity
    virtual void ClipRayToCollideable(const Ray_t &ray, unsigned int fMask, ICollideable *pCollide, trace_t *pTrace) = 0;

    // A version that simply accepts a ray (can work as a traceline or tracehull)
    virtual void TraceRay(const Ray_t &ray, unsigned int fMask, ITraceFilter *pTraceFilter, trace_t *pTrace) = 0;

    // A version that sets up the leaf and entity lists and allows you to pass those in for collision.
    virtual void SetupLeafAndEntityListRay(const Ray_t &ray, ITraceListData *pTraceData) = 0;
    virtual void SetupLeafAndEntityListBox(const Vector &vecBoxMin, const Vector &vecBoxMax, ITraceListData *pTraceData) = 0;
    virtual void TraceRayAgainstLeafAndEntityList(const Ray_t &ray, ITraceListData *pTraceData, unsigned int fMask, ITraceFilter *pTraceFilter, trace_t *pTrace) = 0;

    // A version that sweeps a collideable through the world
    // abs start + abs end represents the collision origins you want to sweep the collideable through
    // vecAngles represents the collision angles of the collideable during the sweep
    virtual void SweepCollideable(ICollideable *pCollide, const Vector &vecAbsStart, const Vector &vecAbsEnd, const QAngle &vecAngles, unsigned int fMask, ITraceFilter *pTraceFilter, trace_t *pTrace) = 0;

    // Enumerates over all entities along a ray
    // If triggers == true, it enumerates all triggers along a ray
    virtual void EnumerateEntities(const Ray_t &ray, bool triggers, IEntityEnumerator *pEnumerator) = 0;

    // Same thing, but enumerate entitys within a box
    virtual void EnumerateEntities(const Vector &vecAbsMins, const Vector &vecAbsMaxs, IEntityEnumerator *pEnumerator) = 0;

    // Convert a handle entity to a collideable.  Useful inside enumer
    virtual ICollideable *GetCollideable(IHandleEntity *pEntity) = 0;

    // HACKHACK: Temp for performance measurments
    virtual int GetStatByIndex(int index, bool bClear) = 0;


    //finds brushes in an AABB, prone to some false positives
    virtual void GetBrushesInAABB(const Vector &vMins, const Vector &vMaxs, CUtlVector<int> *pOutput, int iContentsMask = 0xFFFFFFFF) = 0;

    //Creates a CPhysCollide out of all displacements wholly or partially contained in the specified AABB
    virtual CPhysCollide* GetCollidableFromDisplacementsInAABB(const Vector& vMins, const Vector& vMaxs) = 0;

    // gets the number of displacements in the world
    virtual int GetNumDisplacements() = 0;

    // gets a specific diplacement mesh
    virtual void GetDisplacementMesh(int nIndex, virtualmeshlist_t *pMeshTriList) = 0;

    //retrieve brush planes and contents, returns true if data is being returned in the output pointers, false if the brush doesn't exist
    virtual bool GetBrushInfo(int iBrush, CUtlVector<BrushSideInfo_t> *pBrushSideInfoOut, int *pContentsOut) = 0;

    virtual bool PointOutsideWorld(const Vector &ptTest) = 0; //Tests a point to see if it's outside any playable area
    
    // Walks bsp to find the leaf containing the specified point
    virtual int GetLeafContainingPoint(const Vector &ptTest) = 0;
    
    virtual ITraceListData *AllocTraceListData() = 0;
    virtual void FreeTraceListData(ITraceListData *) = 0;
    
    /// Used only in debugging: get/set/clear/increment the trace debug counter. See comment below for details.
    virtual int GetSetDebugTraceCounter(int value, DebugTraceCounterBehavior_t behavior) = 0;
};

extern IEngineTrace* Trace;

#endif /** !SDK_IEngineTrace_h */
