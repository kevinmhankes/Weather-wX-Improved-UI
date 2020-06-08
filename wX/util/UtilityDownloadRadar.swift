/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadRadar {
    
    private static let urlTst = MyApplication.nwsApiUrl + "/alerts/active?event=Severe%20Thunderstorm%20Warning"
    private static let urlFfw = MyApplication.nwsApiUrl + "/alerts/active?event=Flash%20Flood%20Warning"
    private static let urlTor = MyApplication.nwsApiUrl + "/alerts/active?event=Tornado%20Warning"
    
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
        if tstHtml != "" { MyApplication.severeDashboardTst.value = tstHtml }
        let ffwHtml = urlFfw.getNwsHtml()
        if ffwHtml != "" { MyApplication.severeDashboardFfw.value = ffwHtml }
        let torHtml = urlTor.getNwsHtml()
        if torHtml != "" { MyApplication.severeDashboardTor.value = torHtml }
    }
    
    static func clearPolygonVtec() {
        MyApplication.severeDashboardTst.value = ""
        MyApplication.severeDashboardFfw.value = ""
        MyApplication.severeDashboardTor.value = ""
    }
    
    static func getMcd() {
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/md/").getHtml()
        if html != "" { MyApplication.severeDashboardMcd.value = html }
        var numberListString = ""
        var mcdLatLon = ""
        let numberList = html.parseColumn("title=.Mesoscale Discussion #(.*?).>").map { String(format: "%04d", Int($0.replace(" ", "")) ?? 0) }
        numberList.forEach { number in
            let text = UtilityDownload.getTextProduct("SPCMCD" + number)
            numberListString += number + ":"
            mcdLatLon += storeWatchMcdLatLon(text)
        }
        MyApplication.mcdLatlon.value = mcdLatLon
        MyApplication.mcdNoList.value = numberListString
    }
    
    static func clearMcd() {
        MyApplication.mcdLatlon.value = ""
        MyApplication.mcdNoList.value = ""
    }
    
    static func getMpd() {
        let html = (MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
        if html != "" { MyApplication.severeDashboardMpd.value = html }
        var numberListString = ""
        var mpdLatLon = ""
        let numberList = MyApplication.severeDashboardMpd.value.parseColumn(">MPD #(.*?)</a></strong>")
        numberList.forEach { number in
            let text = UtilityDownload.getTextProduct("WPCMPD" + number)
            numberListString += number + ":"
            mpdLatLon += storeWatchMcdLatLon(text)
        }
        MyApplication.mpdLatlon.value = mpdLatLon
        MyApplication.mpdNoList.value = numberListString
    }
    
    static func getWatch() {
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
        if html != "" { MyApplication.severeDashboardWat.value = html }
        var numberListString = ""
        var watchLatLon = ""
        var watchLatLonTor = ""
        var watchLatLonCombined = ""
        let numberList = html.parseColumn("[om] Watch #([0-9]*?)</a>").map { String(format: "%04d", Int($0) ?? 0).replace(" ", "0") }
        numberList.forEach { number in
            let text1 = UtilityDownload.getTextProduct("SPCWAT" + number)
            numberListString += number + ":"
            var text2 = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
            text2 = UtilityString.parseLastMatch(text2, MyApplication.pre2Pattern)
            if text1.contains("Severe Thunderstorm Watch") || text2.contains("SEVERE TSTM") {
                watchLatLon += storeWatchMcdLatLon(text2)
            } else {
                watchLatLonTor += storeWatchMcdLatLon(text2)
            }
            watchLatLonCombined += storeWatchMcdLatLon(text2)
        }
        MyApplication.watchLatlon.value = watchLatLon
        MyApplication.watchLatlonTor.value = watchLatLonTor
        MyApplication.watchLatlonCombined.value = watchLatLonCombined
        MyApplication.watNoList.value = numberListString
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
    
    static func storeWatchMcdLatLon(_ html: String) -> String {
        let coordinates = html.parseColumn("([0-9]{8}).*?")
        var string = ""
        coordinates.forEach { string += LatLon($0).printSpaceSeparated() }
        string += ":"
        return string.replace(" :", ":")
    }
    
    static func getLatLon(_ number: String) -> String {
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
        return UtilityString.parseLastMatch(html, MyApplication.pre2Pattern)
    }
}
