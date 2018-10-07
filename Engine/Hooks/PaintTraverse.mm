/******************************************************/
/**                                                  **/
/**      Hooks/PaintTraverse.cpp                     **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2017-12-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "PaintTraverse.h"
#include "Engine/Fonts/fontawesome_icons.h"

std::string FeatureManager::PaintTraverseFeature::Watermark = "";
std::string FeatureManager::PaintTraverseFeature::VersionString = "";
Vector2D FeatureManager::PaintTraverseFeature::VersionTextSize = Vector2D();
int FeatureManager::PaintTraverseFeature::VersionPosX = 0;
int FeatureManager::PaintTraverseFeature::VersionPosY = 0;

bool FeatureManager::PaintTraverseFeature::PrePaintTraverse(VPANEL vguiPanel) {
    if (
        !Options::Main::enabled
        || !Options::Improvements::no_scope
#ifdef GOSX_STREAM_PROOF
        || StreamProof->Active()
#endif
    ) {
        return true;
    }

    C_CSPlayer* LocalPlayer = (C_CSPlayer*)EntList->GetClientEntity(Engine->GetLocalPlayer());
    if (!LocalPlayer || !LocalPlayer->IsScoped()) {
        return true;
    }
    
    std::string szPanelName = Panel->GetName(vguiPanel);
    if (szPanelName.find("HudZoom") != std::string::npos) {
        return false;
    }
    
    return true;
}

void FeatureManager::PaintTraverseFeature::ImPaintTraverse() {
    if (!Options::Main::enabled) {
        return;
    }
    
    if (!GUI::IsVisible && !Engine->IsConnected() && !Engine->IsInGame()) {
        if (Watermark == "") {
            Watermark = XorStr("GO:SX");
#ifdef IS_BETA_VERSION
            Watermark.append(XorStr(" (beta)"));
#endif
#ifdef IS_ALPHA_VERSION
            Watermark.append(XorStr(" (ALPHA)"));
#endif
#ifdef GOSX_RAGE_MODE
            Watermark.append(XorStr(" (Rage-Build)"));
#endif
        }
        
        if (VersionString == "") {
            VersionString = Functions::GetBuildVersion();
            VersionTextSize = DrawManager->GetTextSize(VersionString.c_str(), GUI::Fonts::Label);
        }
        
        VersionPosX = (int)(*Glob::SDLResW - (int)(VersionTextSize.x + 13));
        VersionPosY = (int)(*Glob::SDLResH - (int)(VersionTextSize.y + 13));
        
        DrawManager->DrawString(GUI::Fonts::Section, 25, 15, FONTFLAG_NONE, Color(255, 255, 255), false, Watermark.c_str());
        DrawManager->DrawString(GUI::Fonts::Label, VersionPosX, VersionPosY, FONTFLAG_DROPSHADOW, Color(155, 155, 155), false, VersionString.c_str());
        
        std::string OpenHint = XorStr("FN + BACKSPACE or ALT + BACKSPACE\nTO OPEN MENU");
        Vector2D OpenHintSize = DrawManager->GetTextSize(OpenHint.c_str(), GUI::Fonts::Header);
        int OpenPosX = (int)(*Glob::SDLResW / 2);
        int OpenPosY = (int)(*Glob::SDLResH - (int)((OpenHintSize.y / 2) + 13));
        
        int OpenOuterBoxX = (int)(OpenPosX - ((OpenHintSize.x / 2) + 10.0f));
        int OpenOuterBoxY = (int)(OpenPosY - ((OpenHintSize.y / 2) + 10.0f));
        
        DrawManager->DrawRect(OpenOuterBoxX, OpenOuterBoxY, (int)(OpenHintSize.x + 20.0f), (int)(OpenHintSize.y + 20.0f), Color(0, 0, 0, 180), 5.0f);
        
        DrawManager->DrawString(GUI::Fonts::Header, OpenPosX, OpenPosY, FONTFLAG_OUTLINE, Color(255, 255, 255), true, OpenHint.c_str());
    }
    
    if (GUI::IsVisible) {
        std::string CloseHint = XorStr("FN + BACKSPACE or ALT + BACKSPACE\nTO CLOSE MENU");
        Vector2D CloseHintSize = DrawManager->GetTextSize(CloseHint.c_str(), GUI::Fonts::Header);
        int ClosePosX = (int)(*Glob::SDLResW / 2);
        int ClosePosY = (int)(*Glob::SDLResH - (int)((CloseHintSize.y / 2) + 13));
        
        int OuterBoxX = (int)(ClosePosX - ((CloseHintSize.x / 2) + 10.0f));
        int OuterBoxY = (int)(ClosePosY - ((CloseHintSize.y / 2) + 10.0f));
        
        DrawManager->DrawRect(OuterBoxX, OuterBoxY, (int)(CloseHintSize.x + 20.0f), (int)(CloseHintSize.y + 20.0f), Color(0, 0, 0, 180), 5.0f);
        
        DrawManager->DrawString(GUI::Fonts::Header, ClosePosX, ClosePosY, FONTFLAG_OUTLINE, Color(255, 255, 255), true, CloseHint.c_str());
    }
    
#ifdef GOSX_STREAM_PROOF
    if (StreamProof->Active()) {
        static std::string StreamProofWaterMark = std::string(ICON_FA_EYE_SLASH).append(XorStr(" Stream Proof mode"));
        static Vector2D spTextSize = DrawManager->GetTextSize(StreamProofWaterMark.c_str(), GUI::Fonts::Main);
        static int spPosY = (int)(*Glob::SDLResH - (int)(spTextSize.y + 13));
        DrawManager->DrawString(GUI::Fonts::Main, 13, spPosY, FONTFLAG_DROPSHADOW, Color(255, 255, 255), false, StreamProofWaterMark.c_str());
    }
#endif
    
    if (
        !Options::Drawing::crosshair &&
        ESP->GetCrosshairCvar()->GetInt() == 0
    ) {
        ESP->GetCrosshairCvar()->SetValue(1);
    }
    
    GrenadeHelper->PaintTraverse();
    GrenadePrediction->PaintTraverse();
    Radar->PaintTraverse();
    
    ESP->ImDrawPlayerVisuals();
    ESP->DrawFOVCircle();
    ESP->DrawCrossHair();
    ESP->DrawScope();
    
    BombTimer->PaintTraverse();
    SpecList->PaintTraverse();
    HitMarker->PaintTraverse();
    
#ifdef GOSX_BACKTRACKING
    Backtracking->PaintTraverse();
#endif
}

void HookManager::HOOKED_PaintTraverse(void* thisptr, VPANEL vguiPanel, bool forceRepaint, bool allowForce) {
    static PaintTraverseFn oPaintTraverse = vmtPanel->orig<PaintTraverseFn>(INDEX_PAINTTRAVERSE);
    
    std::memcpy(&GetThreadSafeViewMatrix(), &Engine->WorldToScreenMatrix(), sizeof(VMatrix));
    
    std::string szPanelName = Panel->GetName(vguiPanel);
    if (!FeatureManager::PaintTraverseFeature::PrePaintTraverse(vguiPanel)) {
        return;
    }
    
    oPaintTraverse(thisptr, vguiPanel, forceRepaint, allowForce);
}
