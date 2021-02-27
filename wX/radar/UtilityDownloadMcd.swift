/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadMcd {

    static let timer = DownloadTimer("MPD")

    static func get() {
        if !PolygonType.MCD.display {
            clearMcd()
        } else if timer.isRefreshNeeded() {
            getMcd()
        }
    }
    
    static func getMcd() {
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/md/").getHtml()
        if html != "" { MyApplication.severeDashboardMcd.value = html }
        var numberListString = ""
        var latLonString = ""
        // let numberList = html.parseColumn("title=.Mesoscale Discussion #(.*?).>").map { String(format: "%04d", Int($0.replace(" ", "")) ?? 0) }
        let numberList = html.parseColumn("<strong><a href=./products/md/md.....html.>Mesoscale Discussion #(.*?)</a></strong>").map { String(format: "%04d", Int($0.replace(" ", "")) ?? 0) }
        numberList.forEach { number in
            let text = UtilityDownload.getTextProduct("SPCMCD" + number)
            numberListString += number + ":"
            latLonString += UtilityDownloadRadar.storeWatchMcdLatLon(text)
        }
        MyApplication.mcdLatlon.value = latLonString
        MyApplication.mcdNoList.value = numberListString
    }

    static func clearMcd() {
        MyApplication.mcdLatlon.value = ""
        MyApplication.mcdNoList.value = ""
    }
}
