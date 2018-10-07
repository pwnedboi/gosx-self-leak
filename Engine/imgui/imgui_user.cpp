//
//  imgui_user.cpp
//  gosxv2
//
//  Created by Andre Kalisch on 20.09.18.
//  Copyright © 2018 Andre Kalisch. All rights reserved.
//

#include <stdio.h>

#include "imgui.h"
#include "imgui_internal.h"

    // Visual Studio warnings
#ifdef _MSC_VER
#pragma warning (disable: 4127) // condition expression is constant
#pragma warning (disable: 4996) // 'This function or variable may be unsafe': strcpy, strdup, sprintf, vsnprintf, sscanf, fopen
#endif

    // Clang/GCC warnings with -Weverything
#ifdef __clang__
#pragma clang diagnostic ignored "-Wunknown-pragmas"        // warning : unknown warning group '-Wformat-pedantic *'        // not all warnings are known by all clang versions.. so ignoring warnings triggers new warnings on some configuration. great!
#pragma clang diagnostic ignored "-Wold-style-cast"         // warning : use of old-style cast                              // yes, they are more terse.
#pragma clang diagnostic ignored "-Wfloat-equal"            // warning : comparing floating point with == or != is unsafe   // storing and comparing against same constants (typically 0.0f) is ok.
#pragma clang diagnostic ignored "-Wformat-nonliteral"      // warning : format string is not a string literal              // passing non-literal to vsnformat(). yes, user passing incorrect format strings can crash the code.
#pragma clang diagnostic ignored "-Wexit-time-destructors"  // warning : declaration requires an exit-time destructor       // exit-time destruction order is undefined. if MemFree() leads to users code that has been disabled before exit it might cause problems. ImGui coding style welcomes static/globals.
#pragma clang diagnostic ignored "-Wglobal-constructors"    // warning : declaration requires a global destructor           // similar to above, not sure what the exact difference it.
#pragma clang diagnostic ignored "-Wsign-conversion"        // warning : implicit conversion changes signedness             //
#pragma clang diagnostic ignored "-Wformat-pedantic"        // warning : format specifies type 'void *' but the argument has type 'xxxx *' // unreasonable, would lead to casting every %p arg to void*. probably enabled by -pedantic.
#pragma clang diagnostic ignored "-Wint-to-void-pointer-cast" // warning : cast to 'void *' from smaller integer type 'int'
#elif defined(__GNUC__)
#pragma GCC diagnostic ignored "-Wunused-function"          // warning: 'xxxx' defined but not used
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"      // warning: cast to pointer from integer of different size
#pragma GCC diagnostic ignored "-Wformat"                   // warning: format '%p' expects argument of type 'void*', but argument 6 has type 'ImGuiWindow*'
#pragma GCC diagnostic ignored "-Wdouble-promotion"         // warning: implicit conversion from 'float' to 'double' when passing argument to function
#pragma GCC diagnostic ignored "-Wconversion"               // warning: conversion to 'xxxx' from 'xxxx' may alter its value
#pragma GCC diagnostic ignored "-Wformat-nonliteral"        // warning: format not a string literal, format string not checked
#pragma GCC diagnostic ignored "-Wstrict-overflow"          // warning: assuming signed overflow does not occur when assuming that (X - c) > X is always false
#if __GNUC__ >= 8
#pragma GCC diagnostic ignored "-Wclass-memaccess"          // warning: 'memset/memcpy' clearing/writing an object of type 'xxxx' with no trivial copy-assignment; use assignment or value-initialization instead
#endif
#endif

static float CalcMaxPopupHeightFromItemCount(int items_count) {
    ImGuiContext& g = *GImGui;
    if (items_count <= 0)
        return FLT_MAX;
    return (g.FontSize + g.Style.ItemSpacing.y) * items_count - g.Style.ItemSpacing.y + (g.Style.WindowPadding.y * 2);
}

bool ImGui::Checkbox(const char* label, bool* v)
{
    ImGuiWindow* window = GetCurrentWindow();
    if (window->SkipItems) {
        return false;
    }
    
    float CheckboxSize = 16.0f;
    float radius = CheckboxSize / 2;
    
    ImGuiContext& g = *GImGui;
    const ImGuiStyle& style = g.Style;
    const ImGuiID id = window->GetID(label);
    const ImVec2 label_size = CalcTextSize(label, NULL, true);
    
    float size = label_size.y + (style.FramePadding.y * 2);
    ImVec2 MaxRect = {window->DC.CursorPos.x + size, window->DC.CursorPos.y + size};
    const ImRect check_bb(window->DC.CursorPos, MaxRect);
    
    ImVec2 position = check_bb.Min;
    position.x += radius;
    position.y += radius;
    ImRect boundingBox(check_bb.Min.x, check_bb.Min.y, check_bb.Min.x + (radius * 4), check_bb.Min.y + (radius * 2));
    
    ItemSize(boundingBox, 0.0f);
    
    ImRect total_bb = check_bb;
    if (label_size.x > 0) {
        SameLine(0, style.ItemInnerSpacing.x);
    }
    
    size = style.FramePadding.y;
    ImVec2 MinRect = {window->DC.CursorPos.x, window->DC.CursorPos.y + size};
    MaxRect = {window->DC.CursorPos.x + label_size.x, window->DC.CursorPos.y + size + label_size.y};
    const ImRect text_bb(MinRect, MaxRect);
    if (label_size.x > 0) {
        ItemSize(ImVec2(text_bb.GetWidth(), check_bb.GetHeight()), style.FramePadding.y);
        total_bb = ImRect(ImMin(check_bb.Min, text_bb.Min), ImMax(check_bb.Max, text_bb.Max));
    }
    
    if (!ItemAdd(boundingBox, id)) {
        return false;
    }
    
    bool hovered, held;
    bool pressed = ButtonBehavior(boundingBox, id, &hovered, &held);
    if (pressed) {
        *v = !(*v);
    }
    
    RenderFrame(boundingBox.Min, boundingBox.Max, GetColorU32(ImGuiCol_FrameBg), true, CheckboxSize);
    float markerRadius = radius - 1;
    ImVec2 markerPosition = ImVec2(position.x, position.y);
    ImColor CheckmarkColor = ImColor(0.55f, 0.55f, 0.55f, 1.0f);
    if (*v) {
        markerPosition = ImVec2(position.x + CheckboxSize, position.y);
        CheckmarkColor = style.Colors[ImGuiCol_CheckMark];
    }
    window->DrawList->AddCircleFilled(markerPosition, markerRadius, CheckmarkColor);

    if (label_size.x > 0.0f)
        RenderText(text_bb.GetTL(), label);
    
    return pressed;
}

bool ImGui::BeginCombo(const char* label, const char* preview_value, ImGuiComboFlags flags)
{
    // Always consume the SetNextWindowSizeConstraint() call in our early return paths
    ImGuiContext& g = *GImGui;
    ImGuiCond backup_next_window_size_constraint = g.NextWindowData.SizeConstraintCond;
    g.NextWindowData.SizeConstraintCond = 0;
    
    ImGuiWindow* window = GetCurrentWindow();
    if (window->SkipItems)
        return false;
    
    IM_ASSERT((flags & (ImGuiComboFlags_NoArrowButton | ImGuiComboFlags_NoPreview)) != (ImGuiComboFlags_NoArrowButton | ImGuiComboFlags_NoPreview)); // Can't use both flags together
    
    const ImGuiStyle& style = g.Style;
    const ImGuiID id = window->GetID(label);
    
    const float arrow_size = (flags & ImGuiComboFlags_NoArrowButton) ? 0.0f : GetFrameHeight();
    const ImVec2 label_size = CalcTextSize(label, NULL, true);
    const float w = (flags & ImGuiComboFlags_NoPreview) ? arrow_size : CalcItemWidth();
    
    ImVec2 lab1(w, label_size.y + style.FramePadding.y*2.0f);
    ImVec2 lab2(label_size.x > 0.0f ? style.ItemInnerSpacing.x + label_size.x : 0.0f, 0.0f);
    ImVec2 all1(window->DC.CursorPos.x + lab1.x, window->DC.CursorPos.y + lab1.y);
    const ImRect frame_bb(window->DC.CursorPos, all1);
    ImVec2 all2(frame_bb.Max.x + lab2.x, frame_bb.Max.y + lab2.y);
    const ImRect total_bb(frame_bb.Min, all2);
    ItemSize(total_bb, style.FramePadding.y);
    if (!ItemAdd(total_bb, id, &frame_bb))
        return false;
    
    bool hovered, held;
    bool pressed = ButtonBehavior(frame_bb, id, &hovered, &held);
    bool popup_open = IsPopupOpen(id);
    
    ImVec2 lab3(frame_bb.Max.x - arrow_size, frame_bb.Max.y);
    const ImRect value_bb(frame_bb.Min, lab3);
    const ImU32 frame_col = GetColorU32(hovered ? ImGuiCol_FrameBgHovered : ImGuiCol_FrameBg);
    RenderNavHighlight(frame_bb, id);

    if (!(flags & ImGuiComboFlags_NoPreview)) {
        window->DrawList->AddRectFilled(frame_bb.Min, ImVec2(frame_bb.Max.x - arrow_size, frame_bb.Max.y), frame_col, style.FrameRounding, ImDrawCornerFlags_Left);
    }
    if (!(flags & ImGuiComboFlags_NoArrowButton)) {
        window->DrawList->AddRectFilled(ImVec2(frame_bb.Max.x - arrow_size, frame_bb.Min.y), frame_bb.Max, GetColorU32((popup_open || hovered) ? ImGuiCol_ButtonHovered : ImGuiCol_Button), style.FrameRounding, (w <= arrow_size) ? ImDrawCornerFlags_All : ImDrawCornerFlags_Right);
        float top_padding = (arrow_size * 0.50f) * 0.50f;
        RenderArrow(ImVec2(frame_bb.Max.x - arrow_size + style.FramePadding.y, frame_bb.Min.y + style.FramePadding.y + top_padding), popup_open ? ImGuiDir_Down : ImGuiDir_Right, 0.50f);
    }
    RenderFrameBorder(frame_bb.Min, frame_bb.Max, style.FrameRounding);
    if (preview_value != NULL && !(flags & ImGuiComboFlags_NoPreview)) {
        ImVec2 all4(frame_bb.Min.x + style.FramePadding.x, frame_bb.Min.y + style.FramePadding.y);
        RenderTextClipped(all4, value_bb.Max, preview_value, NULL, NULL, ImVec2(0.0f,0.0f));
    }
    if (label_size.x > 0) {
        RenderText(ImVec2(frame_bb.Max.x + style.ItemInnerSpacing.x, frame_bb.Min.y + style.FramePadding.y), label);
    }
    
    if ((pressed || g.NavActivateId == id) && !popup_open) {
        if (window->DC.NavLayerCurrent == 0)
            window->NavLastIds[0] = id;
        OpenPopupEx(id);
        popup_open = true;
    }
    
    if (!popup_open)
        return false;
    
    if (backup_next_window_size_constraint) {
        g.NextWindowData.SizeConstraintCond = backup_next_window_size_constraint;
        g.NextWindowData.SizeConstraintRect.Min.x = ImMax(g.NextWindowData.SizeConstraintRect.Min.x, w);
    } else {
        if ((flags & ImGuiComboFlags_HeightMask_) == 0)
            flags |= ImGuiComboFlags_HeightRegular;
        IM_ASSERT(ImIsPowerOfTwo(flags & ImGuiComboFlags_HeightMask_));    // Only one
        int popup_max_height_in_items = -1;
        if (flags & ImGuiComboFlags_HeightRegular)     popup_max_height_in_items = 8;
        else if (flags & ImGuiComboFlags_HeightSmall)  popup_max_height_in_items = 4;
        else if (flags & ImGuiComboFlags_HeightLarge)  popup_max_height_in_items = 20;
        SetNextWindowSizeConstraints(ImVec2(w, 0.0f), ImVec2(FLT_MAX, CalcMaxPopupHeightFromItemCount(popup_max_height_in_items)));
    }
    
    char name[16];
    ImFormatString(name, IM_ARRAYSIZE(name), "##Combo_%02d", g.CurrentPopupStack.Size); // Recycle windows based on depth
    
    // Peak into expected window size so we can position it
    if (ImGuiWindow* popup_window = FindWindowByName(name)) {
        if (popup_window->WasActive) {
            ImVec2 size_expected = CalcWindowExpectedSize(popup_window);
            if (flags & ImGuiComboFlags_PopupAlignLeft)
                popup_window->AutoPosLastDirection = ImGuiDir_Left;
            ImRect r_outer = GetWindowAllowedExtentRect(popup_window);
            ImVec2 pos = FindBestWindowPosForPopupEx(frame_bb.GetBL(), size_expected, &popup_window->AutoPosLastDirection, r_outer, frame_bb, ImGuiPopupPositionPolicy_ComboBox);
            SetNextWindowPos(pos);
        }
    }
    
    // Horizontally align ourselves with the framed text
    ImGuiWindowFlags window_flags = ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_Popup | ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoSavedSettings;
    PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(style.FramePadding.x, style.WindowPadding.y));
    bool ret = Begin(name, NULL, window_flags);
    PopStyleVar();
    if (!ret) {
        EndPopup();
        IM_ASSERT(0);   // This should never happen as we tested for IsPopupOpen() above
        return false;
    }
    return true;
}

ImGuiWindowSettings* ImGui::GetSettings(std::string windowName) {
    return ImGui::FindWindowSettings(ImHash(windowName.c_str(), 0));
}

ImGuiWindowSettings* ImGui::CreateSettings(std::string windowName) {
    return ImGui::CreateNewWindowSettings(windowName.c_str());
}

void ImGui::SaveSettings() {
    ImGuiIO& io = ImGui::GetIO();
    
    SaveIniSettingsToDisk(io.IniFilename);
}
