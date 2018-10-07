/******************************************************/
/**                                                  **/
/**      SDK/CCSGameRules.mm                         **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-13                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "CCSGameRules.h"

bool C_CSGameRules::IsValveDS() {
    return GetFieldValue<bool>(Offsets::DT_CSGameRulesProxy::m_bIsValveDS);
}

bool C_CSGameRules::IsBombPlanted() {
    return GetFieldValue<bool>(Offsets::DT_CSGameRulesProxy::m_bBombPlanted);
}

bool C_CSGameRules::IsBombDropped() {
    return GetFieldValue<bool>(Offsets::DT_CSGameRulesProxy::m_bBombDropped);
}

bool C_CSGameRules::IsBombDefuseMap() {
    return GetFieldValue<bool>(Offsets::DT_CSGameRulesProxy::m_bMapHasBombTarget);
}
