/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityPref {

    static func prefInitTwitterCA() {
        var value = Utility.readPref("STATE_TW_ID_bcstorm", "")
        if value == "" {
            Utility.writePref("STATE_TW_ID_bcstorm", "489578049524879360")
            Utility.writePref("STATE_TW_ID_abstorm", "489578415377231872")
            Utility.writePref("STATE_TW_ID_skstorm", "489578619665014784")
            Utility.writePref("STATE_TW_ID_mbstorm", "489578784731848704")
            Utility.writePref("STATE_TW_ID_onstorm", "489710428696481795")
            Utility.writePref("STATE_TW_ID_nbstorm", "489711021922066432")
            Utility.writePref("STATE_TW_ID_pestorm", "489710770200932352")
            Utility.writePref("STATE_TW_ID_nsstorm", "489711312742522882")
            Utility.writePref("STATE_TW_ID_nlwx", "489711657912782848")
            Utility.writePref("STATE_TW_ID_ntstorm", "489754447413641217")
            Utility.writePref("STATE_TW_ID_meteoqc", "489754142907170816")
        }
        value = Utility.readPref("STATE_TW_ID_st", "")
        if value == "" {
            Utility.writePref("STATE_TW_ID_st", "611565983380164608")
        }
    }
}
