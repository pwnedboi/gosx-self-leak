/******************************************************/
/**                                                  **/
/**      SDK/Color.mm                                **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "Color.h"

Color::Color() {
    *((int*)this) = 0;
}

Color::Color(uint8_t r, uint8_t g, uint8_t b) {
    SetColor(r, g, b, 255);
}

Color::Color(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    SetColor(r, g, b, a);
}

void Color::SetColor(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    _color[0] = (uint8_t)r;
    _color[1] = (uint8_t)g;
    _color[2] = (uint8_t)b;
    _color[3] = (uint8_t)a;
}

void Color::GetColor(uint8_t &r, uint8_t &g, uint8_t &b, uint8_t &a) const {
    r = _color[0];
    g = _color[1];
    b = _color[2];
    a = _color[3];
}

Color Color::FromARGB(unsigned long color) {
    int a = (color & 0xFF000000) >> 24;
    int r = (color & 0x00FF0000) >> 16;
    int g = (color & 0x0000FF00) >> 8;
    int b = (color & 0x000000FF);
    
    return Color((uint8_t)r, (uint8_t)g, (uint8_t)b, (uint8_t)a);
}

Color Color::FromHSB(float hue, float saturation, float brightness) {
    float h = hue == 1.0f ? 0 : hue * 6.0f;
    float f = h - (int)h;
    float p = brightness * (1.0f - saturation);
    float q = brightness * (1.0f - saturation * f);
    float t = brightness * (1.0f - (saturation * (1.0f - f)));
    
    if (h < 1) {
        return Color(
            (unsigned char)(brightness * 255),
            (unsigned char)(t * 255),
            (unsigned char)(p * 255)
        );
    } else if (h < 2) {
        return Color(
            (unsigned char)(q * 255),
            (unsigned char)(brightness * 255),
            (unsigned char)(p * 255)
        );
    } else if (h < 3) {
        return Color(
            (unsigned char)(p * 255),
            (unsigned char)(brightness * 255),
            (unsigned char)(t * 255)
        );
    } else if (h < 4) {
        return Color(
            (unsigned char)(p * 255),
            (unsigned char)(q * 255),
            (unsigned char)(brightness * 255)
        );
    } else if (h < 5) {
        return Color(
            (unsigned char)(t * 255),
            (unsigned char)(p * 255),
            (unsigned char)(brightness * 255)
        );
    } else {
        return Color(
            (unsigned char)(brightness * 255),
            (unsigned char)(p * 255),
            (unsigned char)(q * 255)
        );
    }
}

float Color::HueToRGB(float v1, float v2, float vH) {
    if (vH < 0) {
        vH += 1;
    }
    
    if (vH > 1) {
        vH -= 1;
    }
    
    if ((6 * vH) < 1) {
        return (v1 + (v2 - v1) * 6 * vH);
    }
    
    if ((2 * vH) < 1) {
        return v2;
    }
    
    if ((3 * vH) < 2) {
        return (v1 + (v2 - v1) * ((2.0f / 3) - vH) * 6);
    }
    
    return v1;
}

Color Color::FromHSL(float h, float s, float l) {
    return HSLToRGB(h, s, l);
}

Color Color::HSLToRGB(float h, float s, float l) {
    float Q;
    
    if (l < 0.5f)
        Q = l * (s + 1.0f);
    else
        Q = l + s - (l * s);
    
    float P = 2 * l - Q;
    
    float RGBs[3];
    
    RGBs[0] = h + (1.0f / 3.0f);
    RGBs[1] = h;
    RGBs[2] = h - (1.0f / 3.0f);
    
    for (int i = 0; i < 3; ++i) {
        if (RGBs[i] < 0)
            RGBs[i] += 1.0f;
        
        if (RGBs[i] > 1)
            RGBs[i] -= 1.0f;
        
        if (RGBs[i] < (1.0f / 6.0f))
            RGBs[i] = P + ((Q - P) * 6 * RGBs[i]);
        else if (RGBs[i] < 0.5f)
            RGBs[i] = Q;
        else if (RGBs[i] < (2.0f / 3.0f))
            RGBs[i] = P + ((Q - P) * 6 * ((2.0f / 3.0f) - RGBs[i]));
        else
            RGBs[i] = P;
    }
    
    return Color(uint8_t(RGBs[0] * 255.0f), uint8_t(RGBs[1] * 255.0f), uint8_t(RGBs[2] * 255.0f));
}

void Color::SetARGB(unsigned long color) {
    int a = (color & 0xFF000000) >> 24;
    int r = (color & 0x00FF0000) >> 16;
    int g = (color & 0x0000FF00) >> 8;
    int b = (color & 0x000000FF);
    
    SetColor((uint8_t)r, (uint8_t)g, (uint8_t)b, (uint8_t)a);
}

uint32_t Color::GetARGB() const {
    int a = (_color[3]) >> 24;
    int r = (_color[0]) >> 16;
    int g = (_color[1]) >> 8;
    int b = (_color[2]);
    
    return (uint8_t)a | (uint8_t)r | (uint8_t)g | (uint8_t)b;
}

float Color::Base() {
    float clr[3];
    
    clr[0] = _color[0] / 255.0f;
    clr[1] = _color[1] / 255.0f;
    clr[2] = _color[2] / 255.0f;
    
    return clr[0];
}

ImColor Color::ToImColor() {
    return {r(), g(), b(), a()};
}

ImVec4 Color::ToImVec4() {
    return ToImColor().Value;
}

int Color::r() {
    return _color[0];
}

int Color::g() {
    return _color[1];
}

int Color::b() {
    return _color[2];
}

int Color::a() {
    return _color[3];
}

int Color::GetR() {
    return _color[0];
}

int Color::GetG() {
    return _color[1];
}

int Color::GetB() {
    return _color[2];
}

int Color::GetA() {
    return _color[3];
}

void Color::SetR(uint8_t _i) {
    _color[0] = _i;
}

void Color::SetG(uint8_t _i) {
    _color[1] = _i;
}

void Color::SetB(uint8_t _i) {
    _color[2] = _i;
}

void Color::SetA(uint8_t _i) {
    _color[3] = _i;
}

std::string Color::ToString() {
    std::string ColorString;
    
    ColorString.append(std::to_string(r()) + ",");
    ColorString.append(std::to_string(g()) + ",");
    ColorString.append(std::to_string(b()) + ",");
    ColorString.append(std::to_string(a()));
    
    return ColorString;
}
