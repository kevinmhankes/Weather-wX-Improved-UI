/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityModelSpcHrrrInputOutput {

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunStatus = (GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/latestHour.php").getHtml()
        let html = htmlRunStatus.parse(".*?.LatestFile.: .s[0-9]{2}/R([0-9]{10})_F[0-9]{3}_V[0-9]{10}_S[0-9]{2}_.*?.gif..*?")
        runData.imageCompleteStr = htmlRunStatus.parse(".*?.LatestFile.: .s[0-9]{2}/R[0-9]{10}_F([0-9]{3})_V[0-9]{10}_S[0-9]{2}_.*?.gif..*?")
        runData.validTime = htmlRunStatus.parse(".*?.LatestFile.: .s[0-9]{2}/R[0-9]{10}_F[0-9]{3}_V([0-9]{10})_S[0-9]{2}_.*?.gif..*?")
        runData.appendListRun(html)
        runData.appendListRun(UtilityTime.genModelRuns(html, 1))
        runData.mostRecentRun = html
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/"
            + getSectorCode(om.sector).lowercased() + "/R" + om.run.replaceAll("Z", "") + "_F" + formatTime(om.time)
            + "_V" + getValidTime(om.run, om.time, om.runTimeData.validTime) + "_"
            + getSectorCode(om.sector) + "_" + om.param + ".gif"
        return UtilityImg.getBitmapAddWhiteBackground(imgUrl)
    }

    static func getSectorCode(_ sectorName: String) -> String {
        var sectorCode = "S19"
        for index in UtilityModelSpcHrrrInterface.sectors.indices
            where sectorName == UtilityModelSpcHrrrInterface.sectors[index] {
                sectorCode = UtilityModelSpcHrrrInterface.sectorCodes[index]
                break
        }
        return sectorCode
    }

    static func getValidTime(_ run: String, _ validTimeForecast: String, _ validTime: String) -> String {
        var validTimeCurrent = ""
        if run.count == 10 && validTime.count == 10 {
            let runTimePrefix = run.substring(0, 8)
            let runTimeHr = run.substring(8, 10)
            let endTimePrefix = validTime.substring(0, 8)
            let runTimeHrInt = to.Int(runTimeHr)
            let forecastInt = to.Int(validTimeForecast)
            if (runTimeHrInt+forecastInt) > 23 {
                validTimeCurrent = endTimePrefix + String(format: "%02d", runTimeHrInt + forecastInt - 24)
            } else {
                validTimeCurrent = runTimePrefix + String(format: "%02d", runTimeHrInt + forecastInt)
            }
        }
        return validTimeCurrent
    }

    static func formatTime(_ time: String) -> String {
        "0" + time
    }
}
