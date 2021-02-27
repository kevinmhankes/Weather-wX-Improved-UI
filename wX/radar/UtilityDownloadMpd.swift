/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadMpd {

    static let timer = DownloadTimer("MPD")

    static func get() {
        if !PolygonType.MPD.display {
            clearMpd()
        } else if timer.isRefreshNeeded() {
            getMpd()
        }
    }
    
    static func getMpd() {
        let html = (GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
        if html != "" { MyApplication.severeDashboardMpd.value = html }
        var numberListString = ""
        var latLonString = ""
        let numberList = MyApplication.severeDashboardMpd.value.parseColumn(">MPD #(.*?)</a></strong>")
        numberList.forEach { number in
            let text = UtilityDownload.getTextProduct("WPCMPD" + number)
            numberListString += number + ":"
            latLonString += UtilityDownloadRadar.storeWatchMcdLatLon(text)
        }
        MyApplication.mpdLatlon.value = latLonString
        MyApplication.mpdNoList.value = numberListString
    }
    
    static func clearMpd() {
        MyApplication.mpdLatlon.value = ""
        MyApplication.mpdNoList.value = ""
    }
}
