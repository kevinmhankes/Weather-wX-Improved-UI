/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityModelWPCGEFSInputOutput {

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let currentHour = UtilityTime.getCurrentHourInUTC()
        runData.mostRecentRun = "00"
        if currentHour >= 12 && currentHour < 18 {
            runData.mostRecentRun = "06"
        }
        if currentHour >= 18 {
            runData.mostRecentRun = "12"
        }
        if currentHour < 6 {
            runData.mostRecentRun = "18"
        }
        runData.listRun = ["00", "06", "12", "18"]
        runData.timeStrConv = runData.mostRecentRun
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        var sectorAdd = ""
        if om.sector=="AK" {
            sectorAdd = "_ak"
        }
        let url = MyApplication.nwsWPCwebsitePrefix + "/exper/gefs/"
            + om.run + "/GEFS_" + om.param + "_" + om.run + "Z_f" + om.time + sectorAdd +  ".gif"
        return Bitmap(url)
    }
}
