/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityModelSPCHREFInputOutput {

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunstatus = (MyApplication.nwsSPCwebsitePrefix + "/exper/href/").getHtml()
        let html = htmlRunstatus.parse("\\{model: \"href\",product: \"500mb_mean\",sector: \"conus\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",\\})")
        let day = html.parse("rd:.(.*?),.*?").replaceAll("\"", "")
        let time = html.parse("rt:.(.*?)00.,.*?").replaceAll("\"", "")
        let mostRecentRun = day + time
        runData.appendListRun(mostRecentRun)
        runData.appendListRun(UtilityTime.genModelRuns(mostRecentRun, 12, "yyyyMMddHH"))
        runData.mostRecentRun = mostRecentRun
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let year = om.run.substring(0, 4)
        let month = om.run.substring(4, 6)
        let day = om.run.substring(6, 8)
        let hour = om.run.substring(8, 10)
        let products = om.param.split(",")
        var urlArr = [String]()
        urlArr.append(MyApplication.nwsSPCwebsitePrefix + "/exper/href/graphics/spc_white_1050px.png")
        urlArr.append(MyApplication.nwsSPCwebsitePrefix + "/exper/href/graphics/noaa_overlay_1050px.png")
        let sectorIndex = UtilityModelSPCHREFInterface.sectorsLong.index(of: om.sector) ?? 0
        let sector = UtilityModelSPCHREFInterface.sectors[sectorIndex]
        products.forEach {
            var url = ""
            if $0.contains("cref_members") {
                let paramArr = $0.split(" ")
                url = MyApplication.nwsSPCwebsitePrefix + "/exper/href/graphics/models/href/" + year + "/"
                    + month + "/" + day + "/" + hour + "00/f0" + om.time + "00/" + paramArr[0]
                    + "." + sector + ".f0" + om.time + "00." + paramArr[1] + ".tl00.png"
            } else {
                url = MyApplication.nwsSPCwebsitePrefix + "/exper/href/graphics/models/href/" + year + "/" + month
                    + "/" + day + "/" + hour + "00/f0" + om.time
                    + "00/" + $0 + "." + sector + ".f0" + om.time + "00.png"
            }
            urlArr.append(url)
        }
        urlArr.append(MyApplication.nwsSPCwebsitePrefix + "/exper/href/graphics/blank_maps/" + sector + ".png")
        let bitmapArr = urlArr.map {Bitmap($0)}
        let layers = bitmapArr.map {Drawable($0)}
        return Bitmap(UtilityImg.addColorBG(UtilityImg.layerDrawableToUIImage(layers), UIColor.white))
    }
}
