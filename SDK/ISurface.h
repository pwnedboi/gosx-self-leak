/******************************************************/
/**                                                  **/
/**      SDK/ISurface.h                              **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-05                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_ISurface_h
#define SDK_ISurface_h

#include "Definitions.h"

// #include "Color.h"
#include "IAppSystem.h"

struct IntRect {
    int x0;
    int y0;
    int w;
    int h;
};

struct Vertex_t {
    Vertex_t() {}
    Vertex_t(const Vector2D &pos, const Vector2D &coord = Vector2D(0, 0)) {
        m_Position = pos;
        m_TexCoord = coord;
    }
    void Init(const Vector2D &pos, const Vector2D &coord = Vector2D(0, 0)) {
        m_Position = pos;
        m_TexCoord = coord;
    }

    Vector2D m_Position;
    Vector2D m_TexCoord;
};

enum FontDrawType_t {
    FONT_DRAW_DEFAULT = 0,
    FONT_DRAW_NONADDITIVE,
    FONT_DRAW_ADDITIVE,
    FONT_DRAW_TYPE_COUNT = 2,
};

struct CharRenderInfo {
    int             x, y;
    Vertex_t*       verts;
    int             textureId;
    int             abcA;
    int             abcB;
    int             abcC;
    int             fontTall;
    HFONT           currentFont;
    FontDrawType_t  drawType;
    wchar_t         ch;
    bool            valid;
    bool            shouldclip;
};

#ifdef CreateFont
#undef CreateFont
#endif

typedef void(*UnlockCursorFn)(void*);
typedef void(*LockCursorFn)(void*);
typedef bool(*IsCursorLockedFn)(void*);
typedef void(*PlaySoundFn)(void*, const char*);

class ISurface : public IAppSystem {
public:
    void UnlockCursor() {
        return Interfaces::Function<UnlockCursorFn>(this, 66)(this);
    }
    
    void LockCursor() {
        return Interfaces::Function<LockCursorFn>(this, 67)(this);
    }
    
    bool IsCursorLocked() {
        return Interfaces::Function<IsCursorLockedFn>(this, 107)(this);
    }
    
    void PlaySound(const char* fileName) {
        return Interfaces::Function<PlaySoundFn>(this, 82)(this, fileName);
    }
};

extern ISurface* Surface;

#endif /** !SDK_ISurface_h */
