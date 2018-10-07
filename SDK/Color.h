/******************************************************/
/**                                                  **/
/**      SDK/Color.h                                 **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-01-17                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_Color_h
#define SDK_Color_h

#include "Definitions.h"

class Color {
public:
    Color();
    Color(uint8_t r, uint8_t g, uint8_t b);
    Color(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    void SetColor(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    void GetColor(uint8_t &r, uint8_t &g, uint8_t &b, uint8_t &a) const;
    static Color FromARGB(unsigned long color);
    Color FromHSB(float hue, float saturation, float brightness);
    float HueToRGB(float v1, float v2, float vH);
    Color FromHSL(float h, float s, float l);
    Color HSLToRGB(float h, float s, float l);
    void SetARGB(unsigned long color);
    uint32_t GetARGB() const;
    float Base();
    ImColor ToImColor();
    ImVec4 ToImVec4();
    int r();
    int g();
    int b();
    int a();
    int GetR();
    int GetG();
    int GetB();
    int GetA();
    void SetR(uint8_t _i);
    void SetG(uint8_t _i);
    void SetB(uint8_t _i);
    void SetA(uint8_t _i);
    std::string ToString();
    
public:
    uint8_t &operator[](int index) {
        return _color[index];
    }
    
    const uint8_t &operator[](int index) const {
        return _color[index];
    }
    
    bool operator == (const Color &rhs) const {
        return (*((int *)this) == *((int *)&rhs));
    }
    
    bool operator != (const Color &rhs) const {
        return !(operator==(rhs));
    }
    
    Color &operator=(const Color &rhs) {
        *(int*)(&_color[0]) = *(int*)&rhs._color[0];
        return *this;
    }
    
    Color operator+(const Color &rhs) const {
        int red = _color[0] + rhs._color[0];
        int green = _color[1] + rhs._color[1];
        int blue = _color[2] + rhs._color[2];
        int alpha = _color[3] + rhs._color[3];
        
        red = red > 255 ? 255 : red;
        green = green > 255 ? 255 : green;
        blue = blue > 255 ? 255 : blue;
        alpha = alpha > 255 ? 255 : alpha;
        
        return Color((uint8_t)red, (uint8_t)green, (uint8_t)blue, (uint8_t)alpha);
    }
    
    Color operator-(const Color &rhs) const {
        int red = _color[0] - rhs._color[0];
        int green = _color[1] - rhs._color[1];
        int blue = _color[2] - rhs._color[2];
        int alpha = _color[3] - rhs._color[3];
        
        red = red < 0 ? 0 : red;
        green = green < 0 ? 0 : green;
        blue = blue < 0 ? 0 : blue;
        alpha = alpha < 0 ? 0 : alpha;
        return Color((uint8_t)red, (uint8_t)green, (uint8_t)blue, (uint8_t)alpha);
    }
    
    operator const uint8_t*() {
        return (uint8_t*)(&_color[0]);
    }
private:
    uint8_t _color[4] = {0, 0, 0, 0};
};

#endif /** !SDK_Color_h */
