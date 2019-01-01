/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityModelSPCHRRRInputOutput {

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunstatus = (MyApplication.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/latestHour.php").getHtml()
        let html = htmlRunstatus
            .parse(".*?.LatestFile.: .s[0-9]{2}/R([0-9]{10})_F[0-9]{3}_V[0-9]{10}_S[0-9]{2}_.*?.gif..*?")
        runData.imageCompleteStr = htmlRunstatus
            .parse(".*?.LatestFile.: .s[0-9]{2}/R[0-9]{10}_F([0-9]{3})_V[0-9]{10}_S[0-9]{2}_.*?.gif..*?")
        runData.validTime = htmlRunstatus
            .parse(".*?.LatestFile.: .s[0-9]{2}/R[0-9]{10}_F[0-9]{3}_V([0-9]{10})_S[0-9]{2}_.*?.gif..*?")
        runData.appendListRun(html)
        runData.appendListRun(UtilityTime.genModelRuns(html, 1))
        runData.mostRecentRun = html
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let imgUrl = MyApplication.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/"
            + getSectorCode(om.sector).lowercased() + "/R" + om.run.replaceAll("Z", "") + "_F" + formatTime(om.time)
            + "_V" + getValidTime(om.run, om.time, om.runTimeData.validTime) + "_"
            + getSectorCode(om.sector) + "_" + om.param + ".gif"
        return UtilityImg.getBitmapAddWhiteBG(imgUrl)
    }

    static func getSectorCode(_ sectorName: String) -> String {
        var sectorCode = "S19"
        for index in UtilityModelSPCHRRRInterface.sectors.indices
            where sectorName == UtilityModelSPCHRRRInterface.sectors[index] {
                sectorCode = UtilityModelSPCHRRRInterface.sectorCodes[index]
                break
        }
        return sectorCode
    }

    static func getValidTime(_ run: String, _ validTimeForecast: String, _ validTime: String) -> String {
        var validTimeCurrent = ""
        if run.count==10 && validTime.count==10 {
            let runTimePrefix = run.substring(0, 8)
            let runTimeHr = run.substring(8, 10)
            let endTimePrefix = validTime.substring(0, 8)
            let runTimeHrInt = Int(runTimeHr) ?? 0
            let forecastInt = Int(validTimeForecast) ?? 0
            if (runTimeHrInt+forecastInt) > 23 {
                validTimeCurrent = endTimePrefix + String(format: "%02d", runTimeHrInt + forecastInt - 24)
            } else {
                validTimeCurrent = runTimePrefix + String(format: "%02d", runTimeHrInt + forecastInt)
            }
        }
        return validTimeCurrent
    }

    static func formatTime(_ time: String) -> String {return "0" + time}
}
