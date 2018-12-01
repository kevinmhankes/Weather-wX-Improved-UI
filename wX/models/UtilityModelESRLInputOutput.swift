/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityModelESRLInputOutput {

    static let eslHrrrPattern1 = "<option selected>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>"
    static let eslHrrrPattern2 = "<option>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>"
    static let eslHrrrPattern3 = "[0-9]{2} \\w{3} ([0-9]{4}) - [0-9]{2}Z"
    static let eslHrrrPattern4 = "([0-9]{2}) \\w{3} [0-9]{4} - [0-9]{2}Z"
    static let eslHrrrPattern5 = "[0-9]{2} \\w{3} [0-9]{4} - ([0-9]{2})Z"
    static let eslHrrrPattern6 = "[0-9]{2} (\\w{3}) [0-9]{4} - [0-9]{2}Z"

    static func getRunTime(_ om: ObjectModel) -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunstatus: String
        switch om.model {
        case "HRRR_AK":   htmlRunstatus = ("http://rapidrefresh.noaa.gov/alaska/").getHtml()
        case "RAP_NCEP":  htmlRunstatus = ("http://rapidrefresh.noaa.gov/RAP/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtml()
        case "RAP":       htmlRunstatus = ("https://rapidrefresh.noaa.gov/RAP/").getHtml()
        case "HRRR_NCEP": htmlRunstatus = ("http://rapidrefresh.noaa.gov/hrrr/HRRR/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtml()
        default:          htmlRunstatus = ("http://rapidrefresh.noaa.gov/" + om.model.lowercased() + "/" + om.model + "/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtml()
        }
        var html = htmlRunstatus.parse(eslHrrrPattern1)
        var oldRunTimes = htmlRunstatus.parseColumn(eslHrrrPattern2)
        let year = html.parse(eslHrrrPattern3)
        let day = html.parse(eslHrrrPattern4)
        let hour = html.parse(eslHrrrPattern5)
        let monthStr = UtilityTime.monthWordToNumber(html.parse(eslHrrrPattern6))
        html = year + monthStr + day + hour
        runData.appendListRun(html)
        runData.mostRecentRun = html
        runData.imageCompleteInt = UtilityString.parseAndCount(htmlRunstatus, ".(allfields).")-1
        runData.imageCompleteStr = String(runData.imageCompleteInt)
        if html != "" {
            (0...12).forEach { i in
                let year = oldRunTimes[i].parse(eslHrrrPattern3)
                let day = oldRunTimes[i].parse(eslHrrrPattern4)
                let hour = oldRunTimes[i].parse(eslHrrrPattern5)
                let monthStr = UtilityTime.monthWordToNumber(oldRunTimes[i].parse(eslHrrrPattern6))
                runData.appendListRun(year + monthStr + day + hour)
            }
            runData.timeStrConv = html.parse("([0-9]{2})$")
        }
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let zipStr = "TZA"
        let paramTmp = om.param
        var paramTmpLocal = paramTmp
        var sectorLocal = om.sector
        let sectorInt = UtilityModelESRLInterface.sectorsHrrr.index(of: sectorLocal) ?? 0
        switch om.model {
        case "HRRR":
            if sectorInt == 0 {
            } else if sectorInt < 9 {
                sectorLocal = "t" + String(sectorInt)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else {
                sectorLocal = "z" + String(sectorInt - 9)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            }
        case "HRRR_NCEP":
            if sectorInt == 0 {
            } else if sectorInt < 9 {
                sectorLocal = "t" + String(sectorInt)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else {
                sectorLocal = "z" + String(sectorInt - 9)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            }
        case "HRRR_AK": break
        case "RAP":
            if sectorInt == 0 || sectorInt == 1 {
            } else if sectorInt == 9 {
                sectorLocal = "alaska"
            } else if sectorInt == 10 {
                sectorLocal = "a1"
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else if sectorInt == 11 {
                sectorLocal = "r1"
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else if sectorInt < 9 {
                sectorLocal = "t" + String(sectorInt)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            }
        case "RAP_NCEP":
            if sectorInt == 0 || sectorInt == 1 {
            } else if sectorInt == 9 {
                sectorLocal = "alaska"
            } else if sectorInt == 10 {
                sectorLocal = "a1"
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else if sectorInt == 11 {
                sectorLocal = "r1"
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            } else if sectorInt < 9 {
                sectorLocal = "t" + String(sectorInt)
                paramTmpLocal = paramTmp.replaceAll("_", "_" + sectorLocal)
            }
        default: break
        }
        let param = paramTmpLocal
        var parentModel = om.model.replaceAll("HRRR_AK", "alaska")
        switch om.model {
        case "RAP_NCEP":  parentModel = "RAP"
        case "HRRR_NCEP": parentModel = "HRRR"
        default: break
        }
        var imgUrl = ""
        var ondemandUrl = ""
        if parentModel.contains("RAP") {
            imgUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/for_web/" + om.model.lowercased() + "_jet/" + om.run.replaceAll("Z", "")+"/"+sectorLocal.lowercased()+"/"+param+"_f"+om.time+".png"
            ondemandUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/" + "displayMapLocalDiskDateDomainZip" + zipStr + ".cgi?keys=" + om.model.lowercased() + "_jet:&runtime=" + om.run.replaceAll("Z", "")+"&plot_type=" + param + "&fcst=" + om.time + "&time_inc=60&num_times=16&model=" + om.model.lowercased() + "&ptitle=" + om.model + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain=" + sectorLocal.lowercased() + "&adtfn=1"
        } else {
            imgUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.uppercased() + "/for_web/" + om.model.lowercased() + "_jet/" + om.run.replaceAll("Z", "") + "/" + sectorLocal.lowercased() + "/" + param + "_f" + om.time + ".png"
            ondemandUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.uppercased() + "/" + "displayMapLocalDiskDateDomainZip" + zipStr + ".cgi?keys=" + om.model.lowercased()+"_jet:&runtime=" + om.run.replaceAll("Z", "") + "&plot_type=" + param + "&fcst=" + om.time + "&time_inc=60&num_times=16&model=" + om.model.lowercased() + "&ptitle=" + om.model + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain=" + sectorLocal.lowercased() + "&adtfn=1"
        }
        _ = ondemandUrl.getHtml()
        return Bitmap(imgUrl)
    }
}
