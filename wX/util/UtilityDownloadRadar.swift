/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadRadar {

    static let urlTst = "https://api.weather.gov/alerts/active?event=Severe%20Thunderstorm%20Warning"
    static let urlFfw = "https://api.weather.gov/alerts/active?event=Flash%20Flood%20Warning"
    static let urlTor = "https://api.weather.gov/alerts/active?event=Tornado%20Warning"

    static func getPolygonVTEC () {
        MyApplication.severeDashboardTst.value = urlTst.getNwsHtml()
        MyApplication.severeDashboardFfw.value = urlFfw.getNwsHtml()
        MyApplication.severeDashboardTor.value = urlTor.getNwsHtml()
    }

    static func clearPolygonVTEC() {
        MyApplication.severeDashboardTst.value = ""
        MyApplication.severeDashboardFfw.value = ""
        MyApplication.severeDashboardTor.value = ""
    }

    static func getMCD() {
        let dataAsString = (MyApplication.nwsSPCwebsitePrefix + "/products/md/").getHtml()
        MyApplication.severeDashboardMcd.value = dataAsString
        var mcdNumberList = ""
        var mcdLatLon = ""
        let mcdList = dataAsString.parseColumn("title=.Mesoscale Discussion #(.*?).>")
        mcdList.forEach {
            let mcdNumber = String(format: "%04d", Int($0.replace(" ", "")) ?? 0)
            let mcdPre = UtilityDownload.getTextProduct("SPCMCD" + mcdNumber)
            mcdNumberList += mcdNumber + ":"
            mcdLatLon += storeWatMCDLATLON(mcdPre)
        }
        MyApplication.mcdLatlon.value = mcdLatLon
        MyApplication.mcdNoList.value = mcdNumberList
    }

    static func clearMCD() {
        MyApplication.mcdLatlon.value = ""
        MyApplication.mcdNoList.value = ""
    }

    static func getMPD() {
        let dataAsString = (MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
        MyApplication.severeDashboardMpd.value = dataAsString
        var mpdNumberList = ""
        var mpdLatLon = ""
        let mpdList = dataAsString.parseColumn(">MPD #(.*?)</a></strong>")
        mpdList.forEach {
            let mcdPre = UtilityDownload.getTextProduct("WPCMPD" + $0)
            mpdNumberList += $0 + ":"
            mpdLatLon += storeWatMCDLATLON(mcdPre)
        }
        MyApplication.mpdLatlon.value = mpdLatLon
        MyApplication.mpdNoList.value = mpdNumberList
    }

    static func getWAT() {
        let dataAsString = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
        MyApplication.severeDashboardWat.value = dataAsString
        var watchNumberList = ""
        var watchLatLon = ""
        var watchLatLonTor = ""
        let mcdList = dataAsString.parseColumn("[om] Watch #([0-9]*?)</a>")
        mcdList.forEach {
            var watchNumber = String(format: "%04d", Int($0) ?? 0)
            watchNumber = watchNumber.replace(" ", "0")
            let watPre = UtilityDownload.getTextProduct("SPCWAT" + watchNumber)
            watchNumberList += watchNumber + ":"
            var watPre2 = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/wou" + watchNumber + ".html").getHtml()
            watPre2 = UtilityString.parseLastMatch(watPre2, MyApplication.pre2Pattern)
            if watPre.contains("Severe Thunderstorm Watch") || watPre2.contains("SEVERE TSTM") {
                watchLatLon += storeWatMCDLATLON(watPre2)
            } else {
                watchLatLonTor += storeWatMCDLATLON(watPre2)
            }
        }
        MyApplication.watchLatlon.value = watchLatLon
        MyApplication.watchLatlonTor.value = watchLatLonTor
        MyApplication.watNoList.value = watchNumberList
    }

    static func clearWAT() {
        MyApplication.severeDashboardWat.value = ""
        MyApplication.watchLatlon.value = ""
        MyApplication.watchLatlonTor.value = ""
        MyApplication.watNoList.value = ""
    }

    static func clearMPD() {
        MyApplication.mpdLatlon.value = ""
        MyApplication.mpdNoList.value = ""
    }

    static func storeWatMCDLATLON(_ html: String) -> String {
        let coords = html.parseColumn("([0-9]{8}).*?")
        var retStr = ""
        coords.forEach {retStr += LatLon($0).print()}
        retStr += ":"
        return retStr.replace(" :", ":")
    }
}
