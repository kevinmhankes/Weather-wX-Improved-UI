/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadRadar {

    static let urlTst = MyApplication.nwsApiUrl + "/alerts/active?event=Severe%20Thunderstorm%20Warning"
    static let urlFfw = MyApplication.nwsApiUrl + "/alerts/active?event=Flash%20Flood%20Warning"
    static let urlTor = MyApplication.nwsApiUrl + "/alerts/active?event=Tornado%20Warning"

    static func getAllRadarData() {
        getPolygonVtec()
        //getPolygonVtecByType(ObjectPolygonWarning(.))
        getMpd()
        getMcd()
        getWatch()
    }

    static func getPolygonVtecByType(_ type: ObjectPolygonWarning) {
        type.storage.value = type.url.getNwsHtml()
    }

    static func getPolygonVtecByTypeClear(_ type: ObjectPolygonWarning) {
        type.storage.value = ""
    }

    static func getPolygonVtec() {
        let tstHtml = urlTst.getNwsHtml()
        if tstHtml != "" {
            MyApplication.severeDashboardTst.value = tstHtml
        } else {
            print("TST FAILURE")
        }
        let ffwHtml = urlFfw.getNwsHtml()
        if ffwHtml != "" {
            MyApplication.severeDashboardFfw.value = ffwHtml
        } else {
            print("FFW FAILURE")
        }
        let torHtml = urlTor.getNwsHtml()
        if torHtml != "" {
            MyApplication.severeDashboardTor.value = torHtml
        } else {
            print("TOR FAILURE")
        }
    }

    static func clearPolygonVtec() {
        MyApplication.severeDashboardTst.value = ""
        MyApplication.severeDashboardFfw.value = ""
        MyApplication.severeDashboardTor.value = ""
    }

    static func getMcd() {
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/md/").getHtml()
        if html != "" {
            MyApplication.severeDashboardMcd.value = html
        }
        var mcdNumberList = ""
        var mcdLatLon = ""
        let mcdList = MyApplication.severeDashboardMcd.value.parseColumn("title=.Mesoscale Discussion #(.*?).>")
        mcdList.forEach {
            let mcdNumber = String(format: "%04d", Int($0.replace(" ", "")) ?? 0)
            let mcdPre = UtilityDownload.getTextProduct("SPCMCD" + mcdNumber)
            mcdNumberList += mcdNumber + ":"
            mcdLatLon += storeWatchMcdLatLon(mcdPre)
        }
        MyApplication.mcdLatlon.value = mcdLatLon
        MyApplication.mcdNoList.value = mcdNumberList
    }

    static func clearMcd() {
        MyApplication.mcdLatlon.value = ""
        MyApplication.mcdNoList.value = ""
    }

    static func getMpd() {
        let html = (MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
        if html != "" {
            MyApplication.severeDashboardMpd.value = html
        }
        var mpdNumberList = ""
        var mpdLatLon = ""
        let mpdList = MyApplication.severeDashboardMpd.value.parseColumn(">MPD #(.*?)</a></strong>")
        mpdList.forEach {
            let mcdPre = UtilityDownload.getTextProduct("WPCMPD" + $0)
            mpdNumberList += $0 + ":"
            mpdLatLon += storeWatchMcdLatLon(mcdPre)
        }
        MyApplication.mpdLatlon.value = mpdLatLon
        MyApplication.mpdNoList.value = mpdNumberList
    }

    static func getWatch() {
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
        if html != "" {
            MyApplication.severeDashboardWat.value = html
        }
        var watchNumberList = ""
        var watchLatLon = ""
        var watchLatLonTor = ""
        var watchLatLonCombined = ""
        let mcdList = html.parseColumn("[om] Watch #([0-9]*?)</a>")
        mcdList.forEach {
            var watchNumber = String(format: "%04d", Int($0) ?? 0)
            watchNumber = watchNumber.replace(" ", "0")
            let watPre = UtilityDownload.getTextProduct("SPCWAT" + watchNumber)
            watchNumberList += watchNumber + ":"
            var watPre2 = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/wou" + watchNumber + ".html").getHtml()
            watPre2 = UtilityString.parseLastMatch(watPre2, MyApplication.pre2Pattern)
            if watPre.contains("Severe Thunderstorm Watch") || watPre2.contains("SEVERE TSTM") {
                watchLatLon += storeWatchMcdLatLon(watPre2)
            } else {
                watchLatLonTor += storeWatchMcdLatLon(watPre2)
            }
            watchLatLonCombined += storeWatchMcdLatLon(watPre2)
        }
        MyApplication.watchLatlon.value = watchLatLon
        MyApplication.watchLatlonTor.value = watchLatLonTor
        MyApplication.watchLatlonCombined.value = watchLatLonCombined
        MyApplication.watNoList.value = watchNumberList
    }

    static func clearWatch() {
        MyApplication.severeDashboardWat.value = ""
        MyApplication.watchLatlon.value = ""
        MyApplication.watchLatlonTor.value = ""
        MyApplication.watchLatlonCombined.value = ""
        MyApplication.watNoList.value = ""
    }

    static func clearMpd() {
        MyApplication.mpdLatlon.value = ""
        MyApplication.mpdNoList.value = ""
    }

    private static func storeWatchMcdLatLon(_ html: String) -> String {
        let coords = html.parseColumn("([0-9]{8}).*?")
        var retStr = ""
        coords.forEach {retStr += LatLon($0).print()}
        retStr += ":"
        return retStr.replace(" :", ":")
    }
}
