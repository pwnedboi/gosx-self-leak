/******************************************************/
/**                                                  **/
/**      Rage/ClantagChanger.mm                      **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "ClantagChanger.h"

#ifdef GOSX_RAGE_MODE
void Features::CClantagChanger::BeginFrame() {
    if (!Options::Main::enabled || !Options::ClantagChanger::enabled) {
        this->Reset();
        
        return;
    }
    
    LocalPlayer = C_CSPlayer::GetLocalPlayer();
    if (!LocalPlayer) {
        return;
    }
    
    std::string NewClanTag = Options::ClantagChanger::tag;
    if (NewClanTag == "") {
        return;
    }
    
    int nameSuffix = 0;
    if (Options::ClantagChanger::animated) {
        NewClanTag = AnimateClantag(NewClanTag);
        nameSuffix = this->PositionInTag;
    }
    
    if (Options::ClantagChanger::hide_name) {
        NewClanTag.append("\n");
    }
    
    Utils::SetClantag(NewClanTag, nameSuffix);
}

std::string Features::CClantagChanger::AnimateClantag(std::string tag) {
    if (!LocalPlayer) {
        return tag;
    }
    
    if (!Options::ClantagChanger::animated) {
        return tag;
    }

    int TagLength = (int)tag.size();
    std::string ReturnTag = Utils::StrPad(tag, TagLength * 2, " ", STR_PAD_LEFT);
    int PreparedTagSize = (int)ReturnTag.size();
    float curtime = LocalPlayer->GetTickBase() * (*GlobalVars)->interval_per_tick;
    if (curtime > this->nextAnimationTick) {
        switch (Options::ClantagChanger::animation_type) {
            case ANIMATE_RTL: {
                if (PositionInTag == -1) {
                    PositionInTag = 0;
                }
                ReturnTag = this->AnimateRTL(ReturnTag, TagLength, PreparedTagSize);
                break;
            }
            case ANIMATE_LTR: {
                if (PositionInTag == -1) {
                    PositionInTag = PreparedTagSize;
                }
                ReturnTag = this->AnimateLTR(ReturnTag, TagLength, PreparedTagSize);
                break;
            }
            default: {
                ReturnTag = tag;
                
                break;
            }
        }
        
        LastTagName = ReturnTag;
        this->nextAnimationTick = curtime + Options::ClantagChanger::animation_speed;
    }
    
    return LastTagName;
}

std::string Features::CClantagChanger::AnimateLTR(std::string tag, int tagSize, int preparedTagSize) {
    if (PositionInTag == 0) {
        PositionInTag = preparedTagSize;
    }
    std::string ReturnTag = tag;
    int EndPosition = preparedTagSize - PositionInTag;
    std::string PrependString = ReturnTag.substr(PositionInTag, EndPosition);
    PositionInTag--;
    ReturnTag = PrependString + ReturnTag;
    ReturnTag = ReturnTag.substr(0, tagSize);
    
    return ReturnTag;
}

std::string Features::CClantagChanger::AnimateRTL(std::string tag, int tagSize, int preparedTagSize) {
    if (PositionInTag == preparedTagSize) {
        PositionInTag = 0;
    }
    std::string ReturnTag = tag;
    std::string AppendString = ReturnTag.substr(0, PositionInTag);
    PositionInTag++;
    ReturnTag = ReturnTag.substr(PositionInTag, tagSize);
    ReturnTag.append(AppendString);
    ReturnTag = ReturnTag.substr(0, tagSize);
    
    return ReturnTag;
}

void Features::CClantagChanger::Reset() {
    PositionInTag = -1;
    nextAnimationTick = 0.0f;
    LastTagName = "";
}

std::shared_ptr<Features::CClantagChanger> ClantagChanger = std::make_unique<Features::CClantagChanger>();
#endif
