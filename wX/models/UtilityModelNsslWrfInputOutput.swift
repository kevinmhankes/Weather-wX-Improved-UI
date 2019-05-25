/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class UtilityModelNsslWrfInputOutput {

    static let ncarEnsPattern2 = "([0-9]{2})$"
    static let baseUrl = "https://cams.nssl.noaa.gov"

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunstatus = (baseUrl).getHtml()
        let html = htmlRunstatus.parse("\\{model: \"fv3_nssl\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",)")
        let day = html.parse("rd:.(.*?),.*?").replaceAll("\"", "")
        let time = html.parse("rt:.(.*?)00.,.*?").replaceAll("\"", "")
        let mostRecentRun = day + time
        runData.appendListRun(mostRecentRun)
        runData.appendListRun(UtilityTime.genModelRuns(mostRecentRun, 12, "yyyyMMddHH"))
        runData.mostRecentRun = mostRecentRun
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let sectorIndex = UtilityModelNsslWrfInterface.sectorsLong.firstIndex(of: om.sector) ?? 0
        let sector = UtilityModelNsslWrfInterface.sectors[sectorIndex]
        let baseLayerUrl = "https://cams.nssl.noaa.gov/graphics/blank_maps/spc_" + sector + ".png"
        var modelPostfix = "_nssl"
        var model = om.model.lowercased()
        if om.model == "HRRRV3" {
            modelPostfix = ""
        }
        if om.model == "WRF_3KM" {
            model = "wrf_nssl_3km"
            modelPostfix = ""
        }
        let year = om.run.substring(0, 4)
        let month = om.run.substring(4, 6)
        let day = om.run.substring(6, 8)
        let hour = om.run.substring(8, 10)
        let url = baseUrl + "/graphics/models/" + model + modelPostfix + "/" + year + "/" + month
            + "/" + day + "/" + hour + "00/f0" + om.time + "00/" + om.param + ".spc_"
            + sector.lowercased() + ".f0" + om.time + "00.png"
        let baseLayer = Bitmap(baseLayerUrl)
        let prodLayer = Bitmap(url)
        let consolidatedImage = UtilityImg.addColorBG(
            UtilityImg.mergeImages(prodLayer.image, baseLayer.image),
            UIColor.white
        )
        return Bitmap(consolidatedImage)
    }
}
