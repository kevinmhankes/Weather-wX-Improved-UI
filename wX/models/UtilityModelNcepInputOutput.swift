/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityModelNcepInputOutput {

    static let ncepPattern2 = "([0-9]{10}UTC selected_cell)"

    static func getRunTime(_ om: ObjectModel) -> RunTimeData {
        let runData = RunTimeData()
        let url = "https://mag.ncep.noaa.gov/model-guidance-model-parameter.php?group=Model%20Guidance&model="
            + om.model.uppercased() + "&area=" + om.sector + "&ps=area"
        let html = url.getHtml().parse(ncepPattern2).replaceAll("UTC selected_cell", "Z")
        var runCompletionDataStr = html.replaceAll("Z", " UTC")
        if runCompletionDataStr != "" {
            runCompletionDataStr = UtilityString.insert(runCompletionDataStr, 8, " ")
        }
        var runCompletionUrl = "https://mag.ncep.noaa.gov/model-guidance-model-parameter.php"
            + "?group=Model%20Guidance&model="
            + om.model.uppercased()
        runCompletionUrl += "&area=" + om.sector.lowercased()
        runCompletionUrl += "&cycle=" + runCompletionDataStr
        runCompletionUrl += "&param=" + om.param + "&fourpan=no&imageSize=M&ps=area"
        runCompletionUrl = runCompletionUrl.replace(" ", "%20")
        let ncepPattern1 = "([0-9]{2}Z)"
        let time = html.parse(ncepPattern1)
        runData.mostRecentRun = time
        runData.timeStrConv = time
        let timeCompleteUrl = "https://mag.ncep.noaa.gov/model-fhrs.php?group=Model%20Guidance&model="
            + om.model.lowercased() + "&fhr_mode=image&loop_start=-1&loop_end=-1&area="
            + om.sector + "&fourpan=no&imageSize=&preselected_formatted_cycle_date="
            + runCompletionDataStr + "&cycle=" + runCompletionDataStr + "&param=" + om.param + "&ps=area"
        let timeCompleteHtml = timeCompleteUrl.replace(" ", "%20").getHtml()
        runData.imageCompleteStr = timeCompleteHtml.parse("SubmitImageForm.(.*?).\"")
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        var imgUrl = ""
        var timeLocal = om.time
        if om.model == "HRRR" {
            timeLocal = om.time + "00"
        }
        if om.model == "GFS" {
            imgUrl = "https://mag.ncep.noaa.gov/data/" + om.model.lowercased() + "/" + om.run.replaceAll("Z", "")
                + "/" + om.sector.lowercased() + "/" + om.param + "/" + om.model.lowercased()
                + "_"+om.sector.lowercased() + "_" + timeLocal + "_" + om.param + ".gif"
        } else {
            imgUrl = "https://mag.ncep.noaa.gov/data/" + om.model.lowercased() + "/" + om.run.replaceAll("Z", "")
                + "/" + om.model.lowercased() + "_" + om.sector.lowercased() + "_" + timeLocal + "_" + om.param + ".gif"
        }
        return Bitmap(imgUrl)
    }
}
