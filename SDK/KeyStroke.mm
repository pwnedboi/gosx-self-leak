/******************************************************/
/**                                                  **/
/**      SDK/KeyStroke.cpp                           **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "KeyStroke.h"

KeyStroke_t m_KeyStroke[MOUSE_COUNT + KEY_COUNT] = {
    { "", "", "" },
    { "0", "=", "}" },
    { "1", "!", "" },
    { "2", "\"", "" },
    { "3", "§", "" },
    { "4", "$", "" },
    { "5", "%", "" },
    { "6", "&", "\\" },
    { "7", "/", "{" },
    { "8", "(", "[" },
    { "9", ")", "]" },
    { "a", "A", "" },
    { "b", "B", "" },
    { "c", "C", "" },
    { "d", "D", "" },
    { "e", "E", "" },
    { "f", "F", "" },
    { "g", "G", "" },
    { "h", "H", "" },
    { "i", "I", "" },
    { "j", "J", "" },
    { "k", "K", "" },
    { "l", "L", "" },
    { "m", "M", "" },
    { "n", "N", "" },
    { "o", "O", "" },
    { "p", "P", "" },
    { "q", "Q", "" },
    { "r", "R", "" },
    { "s", "S", "" },
    { "t", "T", "" },
    { "u", "U", "" },
    { "v", "V", "" },
    { "w", "W", "" },
    { "x", "X", "" },
    { "y", "Y", "" },
    { "z", "Z", "" },
    { "0", "0", "" },
    { "1", "1", "" },
    { "2", "2", "" },
    { "3", "3", "" },
    { "4", "4", "" },
    { "5", "5", "" },
    { "6", "6", "" },
    { "7", "7", "" },
    { "8", "8", "" },
    { "9", "9", "" },
    { "/", "/", "" },
    { "*", "*", "" },
    { "-", "-", "" },
    { "+", "+", "" },
    { "Enter", "enter", "" },
    { ".", ">", "" },
    { "[", "{", "" },
    { "]", "}", "" },
    { ";", ":", "" },
    { "'", "@", "" },
    { "`", "", "" },
    { ",", "<", "" },
    { ".", ">", "" },
    { "/", "?", "" },
    { "\\", "|", "" },
    { "-", "_", "" },
    { "=", "+", "" },
    { "Enter", "enter", "" },
    { "Space", "space", "" },
    { "Backspace", "backspace", "" },
    { "Tab", "tab", "" },
    { "Capslock", "caps", "" },
    { "Numlock", "numlock", "" },
    { "ESC", "escape", "" },
    { "scrlock", "scrlock", "" },
    { "Insert", "insert", "" },
    { "DEL", "delete", "" },
    { "Home", "home", "" },
    { "End", "end", "" },
    { "Pageup", "pageup", "" },
    { "Pagedown", "pagedown", "" },
    { "break", "break", "" },
    { "Left Shift", "lshift", "" },
    { "Right Shift", "rshift", "" },
    { "Left Alt", "lalt", "" },
    { "Right Alt", "ralt", "" },
    { "Left CTRL", "lctrl", "" },
    { "Right CTRL", "rctrl", "" },
    { "Left Win", "lwin", "" },
    { "Right Win", "rwin", "" },
    { "app", "app", "" },
    { "Up", "up", "" },
    { "Left", "left", "" },
    { "Down", "down", "" },
    { "Right", "right", "" },
    { "f1", "f1", "" },
    { "f2", "f2", "" },
    { "f3", "f3", "" },
    { "f4", "f4", "" },
    { "f5", "f5", "" },
    { "f6", "f6", "" },
    { "f7", "f7", "" },
    { "f8", "f8", "" },
    { "f9", "f9", "" },
    { "f10", "f10", "" },
    { "f11", "f11", "" },
    { "f12", "f12", "" },
    { "caps", "capstoggle", "" },
    { "numlock", "numlock", "" },
    { "scrlock", "scrlock", "" },
    { "Left Mouse", "mouse1", "" },
    { "Right Mouse", "mouse2", "" },
    { "Mouse 3", "mouse3", "" },
    { "Mouse 4", "mouse4", "" },
    { "Mouse 5", "mouse5", "" },
    { "mwheelup", "mwheelup", "" },
    { "mwheeldown", "mwheeldown", "" },
};

std::string Keys::Get(int key, bool shift, bool alt) {
    if (shift) {
        return std::string(m_KeyStroke[key].m_szShiftDefinition);
    }
    
    if (alt) {
        return std::string(m_KeyStroke[key].m_szAltDefinition);
    }
    
    return std::string(m_KeyStroke[key].m_szDefinition);
}
