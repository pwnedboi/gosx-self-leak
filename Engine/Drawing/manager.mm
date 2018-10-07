/******************************************************/
/**                                                  **/
/**      Drawing/manager.cpp                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-18                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "manager.h"
#include "SDK/Utils.h"

#define MAX_TEXT_SIZE 96

enum FontSize {
    SMALL = 0,
    BIG = 1,
    EXTRASMALL = 2
};

void Helper::CImDrawings::DrawString(ImFont* drawFont, int x, int y, int font_flags, Color textColor, const char* textString, bool bCenter) {
    DrawString(drawFont, x, y, font_flags, textColor, bCenter, textString);
}

void Helper::CImDrawings::DrawString(ImFont* drawFont, int x, int y, int font_flags, Color clrColor, bool bCenter, const char* szText, ...) {
    if (!szText) {
        return;
    }
    
    if (strlen(szText) > MAX_TEXT_SIZE) {
        return;
    }
    
    va_list va_alist;
    char szBuffer[MAX_TEXT_SIZE];
    
    va_start(va_alist, szText);
    vsprintf(szBuffer, szText, va_alist);
    va_end(va_alist);
    
    std::string stringBuffer;
    stringBuffer.append(szBuffer);
    
    if (!drawFont) {
        drawFont = ImGui::GetFont();
    }
    
    if (bCenter) {
        Vector2D textSize = GetTextSize(stringBuffer.c_str(), drawFont);
        
        x -= (int)textSize.x / 2;
        y -= (int)textSize.y / 2;
    }
    
    if (font_flags & FONTFLAG_DROPSHADOW) {
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x + 1), (float)(y + 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
    }
    
    if (font_flags & FONTFLAG_OUTLINE) {
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x - 1), (float)y), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x - 1), (float)(y - 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)x, (float)(y - 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x + 1), (float)(y - 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x + 1), (float)y), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x + 1), (float)(y + 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)x, (float)(y + 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
        ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)(x - 1), (float)(y + 1)), Color(0, 0, 0, this->dropshadow_alpha).ToImColor(), stringBuffer.c_str());
    }
    
    ImGui::GetWindowDrawList()->AddText(drawFont, (drawFont->FontSize * drawFont->Scale), ImVec2((float)x, (float)y), clrColor.ToImColor(), stringBuffer.c_str());
}

void Helper::CImDrawings::DrawRect(int x, int y, int w, int h, Color clrColor, float rounding) {
    ImGui::GetWindowDrawList()->AddRectFilled(ImVec2((float)(x), (float)(y)), ImVec2((float)(x + w), (float)(y + h)), clrColor.ToImColor(), rounding);
}

void Helper::CImDrawings::DrawOutlineRect(int x, int y, int w, int h, Color clrColor, float rounding, float thickness) {
    ImGui::GetWindowDrawList()->AddRect(ImVec2((float)(x), (float)(y)), ImVec2((float)(x + w), (float)(y + h)), clrColor.ToImColor(), rounding, thickness);
}

void Helper::CImDrawings::DrawLine(int x, int y, int x1, int y1, Color clrColor, float thickness) {
    ImGui::GetWindowDrawList()->AddLine(ImVec2((float)(x), (float)(y)), ImVec2((float)(x1), (float)(y1)), clrColor.ToImColor(), thickness);
}

void Helper::CImDrawings::Circle(Vector2D position, float points, float radius, Color color, float thickness) {
    ImGui::GetWindowDrawList()->AddCircle(ImVec2(position.x, position.y), radius, color.ToImColor(), (int)points, thickness);
}

void Helper::CImDrawings::DrawTriangle(int width, int height, Color clrColor, int x, int y, TriangleDirections direction, bool centered) {
    Vertex_t triangleShape[3];
    int startX, startY;
    if (centered) {
        startX = x - (width / 2);
        startY = y - (height / 2);
    } else {
        startX = x;
        startY = y;
    }
    if (
        direction == TriangleDirections::TRI_DOWNRIGHT ||
        direction == TriangleDirections::TRI_DOWNLEFT ||
        direction == TriangleDirections::TRI_UPRIGHT ||
        direction == TriangleDirections::TRI_UPLEFT
    ) {
        height = width;
    }
    
    if (direction == TriangleDirections::TRI_LEFT || direction == TriangleDirections::TRI_RIGHT) {
        int tmpWidth = width;
        int tmpHeight = height;
        width = tmpHeight;
        height = tmpWidth;
    }
    
    ImVec2 a, b, c;
    switch (direction) {
        case TriangleDirections::TRI_RIGHT:
            a = ImVec2((float)(startX), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY + (height / 2)));
            c = ImVec2((float)(startX), (float)(startY + height));
            break;
        case TriangleDirections::TRI_UP:
            a = ImVec2((float)(startX + (width / 2)), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY + height));
            c = ImVec2((float)(startX), (float)(startY + height));
            break;
        case TriangleDirections::TRI_LEFT:
            a = ImVec2((float)(startX), (float)(startY + (height / 2)));
            b = ImVec2((float)(startX + width), (float)(startY));
            c = ImVec2((float)(startX + width), (float)(startY + height));
            break;
        case TriangleDirections::TRI_DOWN:
            a = ImVec2((float)(startX), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY));
            c = ImVec2((float)(startX + (width / 2)), (float)(startY + height));
            break;
        case TriangleDirections::TRI_UPLEFT:
            a = ImVec2((float)(startX), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY));
            c = ImVec2((float)(startX), (float)(startY + height));
            break;
        case TriangleDirections::TRI_UPRIGHT:
            a = ImVec2((float)(startX), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY));
            c = ImVec2((float)(startX + width), (float)(startY + height));
            break;
        case TriangleDirections::TRI_DOWNLEFT:
            a = ImVec2((float)(startX), (float)(startY));
            b = ImVec2((float)(startX + width), (float)(startY + height));
            c = ImVec2((float)(startX), (float)(startY + height));
            break;
        case TriangleDirections::TRI_DOWNRIGHT:
            a = ImVec2((float)(startX), (float)(startY + height));
            b = ImVec2((float)(startX + width), (float)(startY));
            c = ImVec2((float)(startX + width), (float)(startY + height));
            break;
    }
    
    ImGui::GetWindowDrawList()->AddTriangleFilled(a, b, c, clrColor.ToImColor());
}

void Helper::CImDrawings::FilledCircle(Vector2D position, float points, float radius, Color color) {
    ImGui::GetWindowDrawList()->AddCircleFilled(ImVec2(position.x, position.y), radius, color.ToImColor(), (int)points);
}

Vector2D Helper::CImDrawings::GetTextSize(const char* text, ImFont* font) {
    if (!font) {
        font = ImGui::GetFont();
    }
    
    ImGui::PushFont(font);
    ImVec2 textSize = ImGui::CalcTextSize(text);
    ImGui::PopFont();
    
    return Vector2D(textSize.x, textSize.y);
}

Vector2D Helper::CImDrawings::GetMiddle(float x, float y, float xOffset, float yOffset) {
    float yMiddle = (y / 2) + yOffset;
    float xMiddle = x + xOffset;
    
    return Vector2D(xMiddle, yMiddle);
}

void Helper::CImDrawings::SetDropShadowAlpha(float value) {
    this->dropshadow_alpha = (int)(value * 255.0f);
}

void Helper::CImDrawings::SetDropShadowAlpha(int value) {
    this->dropshadow_alpha = value;
}

std::shared_ptr<Helper::CImDrawings> DrawManager = std::make_unique<Helper::CImDrawings>();
