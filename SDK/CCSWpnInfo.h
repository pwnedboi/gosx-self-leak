/******************************************************/
/**                                                  **/
/**      SDK/CCSWpnInfo.h                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-11                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_CCSWpnInfo_h
#define SDK_CCSWpnInfo_h

#define MAX_SHOOT_SOUNDS 16
#define MAX_WEAPON_STRING 80
#define MAX_WEAPON_PREFIX 16
#define MAX_WEAPON_AMMO_NAME 32

class Color;

typedef struct wrect_s {
    int left;
    int right;
    int top;
    int bottom;
} wrect_t;

class CHudTexture {
public:
    CHudTexture();
    CHudTexture& operator =( const CHudTexture& src );
    virtual ~CHudTexture();
    
    int Width() const {
        return rc.right - rc.left;
    }
    
    int Height() const {
        return rc.bottom - rc.top;
    }

    void Precache(void);

    int EffectiveWidth(float flScale) const;
    int EffectiveHeight(float flScale) const;
    
    void DrawSelf( int x, int y, const Color& clr ) const;
    void DrawSelf( int x, int y, int w, int h, const Color& clr ) const;
    void DrawSelfCropped( int x, int y, int cropx, int cropy, int cropw, int croph, Color clr ) const;
    void DrawSelfCropped( int x, int y, int cropx, int cropy, int cropw, int croph, int finalWidth, int finalHeight, Color clr ) const;
    
    char        szShortName[ 64 ];
    char        szTextureFile[ 64 ];
    
    bool        bRenderUsingFont;
    bool        bPrecached;
    char        cCharacterInFont;
    HFONT       hFont;

    int            textureId;
    float        texCoords[ 4 ];

    wrect_t        rc;
};

enum class CSWeaponType : int {
    WEAPONTYPE_KNIFE = 0,
    WEAPONTYPE_PISTOL,
    WEAPONTYPE_SUBMACHINEGUN,
    WEAPONTYPE_RIFLE,
    WEAPONTYPE_SHOTGUN,
    WEAPONTYPE_SNIPER_RIFLE,
    WEAPONTYPE_MACHINEGUN,
    WEAPONTYPE_C4,
    WEAPONTYPE_PLACEHOLDER,
    WEAPONTYPE_GRENADE,
    WEAPONTYPE_UNKNOWN
};
    
struct WeaponCSInfo_t {
    char gap0[8];
    char *m_szConsoleName;
    char gap1C[232];
    char *m_szHUDName;
    char gap100[64];
    CSWeaponType m_WeaponType;
    char pad144[36];
    bool m_bIsFullAuto;
    char gap169[3];
    int m_iDamage;
    float m_flArmorRatio;
    int m_iBulletsPerShot;
    float m_flPenetration;
    char pad17C[8];
    float m_flRange;
    float m_flRangeModifier;
    float m_flThrowVelocity;
    char pad190[12];
    bool m_bHasSilencer;
    char pad19D[163];
    int m_iZoomLevels;
    int m_iZoomFOV1;
    int m_iZoomFOV2;
    float m_flZoomTime[3];
    char pad258[152];
    bool m_bHasBurstMode;
    bool m_bIsRevolver;
    bool m_bCanShootUnderwater;
};

#endif /** !SDK_CCSWpnInfo_h */
