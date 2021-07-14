/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadWatch {

//    static let timer = DownloadTimer("WATCH")
//
//    static func get() {
//        if !PolygonType.MCD.display {
//            clearWatch()
//        } else if timer.isRefreshNeeded() {
//            getWatch()
//        }
//    }
//
//    static func getWatch() {
//        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
//        if html != "" { MyApplication.severeDashboardWat.value = html }
//        var numberListString = ""
//        var latLongString = ""
//        var latLonTorString = ""
//        var latLonCombinedString = ""
//        let numberList = html.parseColumn("[om] Watch #([0-9]*?)</a>").map { String(format: "%04d", Int($0) ?? 0).replace(" ", "0") }
//        numberList.forEach { number in
//            numberListString += number + ":"
//            let text = (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
//            let preText = UtilityString.parseLastMatch(text, GlobalVariables.pre2Pattern)
//            if preText.contains("SEVERE TSTM") {
//                latLongString += LatLon.storeWatchMcdLatLon(preText)
//            } else {
//                latLonTorString += LatLon.storeWatchMcdLatLon(preText)
//            }
//            latLonCombinedString += LatLon.storeWatchMcdLatLon(preText)
//        }
//        MyApplication.watchLatlon.value = latLongString
//        MyApplication.watchLatlonTor.value = latLonTorString
//        MyApplication.watchLatlonCombined.value = latLonCombinedString
//        MyApplication.watNoList.value = numberListString
//    }
//
//    static func clearWatch() {
//        MyApplication.severeDashboardWat.value = ""
//        MyApplication.watchLatlon.value = ""
//        MyApplication.watchLatlonTor.value = ""
//        MyApplication.watchLatlonCombined.value = ""
//        MyApplication.watNoList.value = ""
//    }
}
