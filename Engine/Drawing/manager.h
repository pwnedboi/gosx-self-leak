/******************************************************/
/**                                                  **/
/**      Drawing/manager.h                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-20                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef Drawing_manager_h
#define Drawing_manager_h

#include "SDK/SDK.h"
#include "SDK/CCSPlayer.h"
#include "SDK/ItemDefinitionIndex.h"
#include "triangles.h"

namespace Helper {
    class CImDrawings {
    public:
        void        DrawString(ImFont* font, int x, int y, int font_flags, Color textColor, const char* textString, bool bCenter);
        void        DrawString(ImFont* font, int x, int y, int font_flags, Color clrColor, bool bCenter, const char* szText, ...);
        void        DrawRect(int x, int y, int w, int h, Color clrColor, float rounding = 0.0f);
        void        DrawOutlineRect(int x, int y, int w, int h, Color clrColor, float rounding = 0.0f, float thickness = 1.0f);
        void        DrawLine(int x0, int y0, int x1, int y1, Color clrColor, float thickness = 1.0f);
        void        Circle(Vector2D position, float points, float radius, Color color, float thickness = 1.0f);
        void        FilledCircle(Vector2D position, float points, float radius, Color color);
        void        DrawTriangle(int width, int height, Color clrColor, int x = 0, int y = 0, TriangleDirections direction = TriangleDirections::TRI_UP, bool centered = false);
        void        DrawPolygon(int count, Vertex_t* Vertexs, Color color);
        Vector2D    GetTextSize(const char* text, ImFont* font = nullptr);
        Vector2D    GetMiddle(float x, float y, float xOffset = 0.0f, float yOffset = 0.0f);
        void        SetDropShadowAlpha(float value);
        void        SetDropShadowAlpha(int value);
    protected:
        int dropshadow_alpha = 255;
    };
}

extern std::shared_ptr<Helper::CImDrawings> DrawManager;

#endif /** !Drawing_manager_h */
