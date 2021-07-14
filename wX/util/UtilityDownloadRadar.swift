/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadRadar {

    private static let urlTst = GlobalVariables.nwsApiUrl + "/alerts/active?event=Severe%20Thunderstorm%20Warning"
    private static let urlFfw = GlobalVariables.nwsApiUrl + "/alerts/active?event=Flash%20Flood%20Warning"
    private static let urlTor = GlobalVariables.nwsApiUrl + "/alerts/active?event=Tornado%20Warning"

    static func getAllRadarData() {
        getPolygonVtec()
        // getPolygonVtecByType(ObjectPolygonWarning(.))
        
//        UtilityDownloadMpd.getMpd()
//        UtilityDownloadMcd.getMcd()
//        UtilityDownloadWatch.getWatch()
//        for t in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
//            ObjectPolygonWatch.polygonDataByType[t]?.download()
//        }
        
        if PolygonType.MCD.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCMCD]?.download()
        }
        
        if PolygonType.WATCH.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT]?.download()
        }
        
        if PolygonType.MPD.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.WPCMPD]?.download()
        }
    }

    static func getPolygonVtecByType(_ type: ObjectPolygonWarning) {
        type.storage.value = type.url.getNwsHtml()
    }

    static func getPolygonVtecByTypeClear(_ type: ObjectPolygonWarning) {
        type.storage.value = ""
    }

    static func getPolygonVtec() {
        // TODO FIXME , should there really still be a check for "" ?
        
        ObjectPolygonWarning.polygonDataByType[.TST]!.download()
        ObjectPolygonWarning.polygonDataByType[.FFW]!.download()
        ObjectPolygonWarning.polygonDataByType[.TOR]!.download()
        
//        let tstHtml = urlTst.getNwsHtml()
//        if tstHtml != "" {
//            MyApplication.severeDashboardTst.value = tstHtml
//        }
//        let ffwHtml = urlFfw.getNwsHtml()
//        if ffwHtml != "" {
//            MyApplication.severeDashboardFfw.value = ffwHtml
//        }
//        let torHtml = urlTor.getNwsHtml()
//        if torHtml != "" {
//            MyApplication.severeDashboardTor.value = torHtml
//        }
    }
    
//    static func getPolygonVtecTst() {
//        // TODO FIXME , should there really still be a check for "" ?
//        let tstHtml = urlTst.getNwsHtml()
//        if tstHtml != "" {
//            MyApplication.severeDashboardTst.value = tstHtml
//        }
//    }
//
//    static func getPolygonVtecFfw() {
//        let ffwHtml = urlFfw.getNwsHtml()
//        if ffwHtml != "" {
//            MyApplication.severeDashboardFfw.value = ffwHtml
//        }
//    }
//
//    static func getPolygonVtecTor() {
//        let torHtml = urlTor.getNwsHtml()
//        if torHtml != "" {
//            MyApplication.severeDashboardTor.value = torHtml
//        }
//    }

//    static func clearPolygonVtec() {
//        MyApplication.severeDashboardTst.value = ""
//        MyApplication.severeDashboardFfw.value = ""
//        MyApplication.severeDashboardTor.value = ""
//    }

    static func getLatLon(_ number: String) -> String {
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
        return UtilityString.parseLastMatch(html, GlobalVariables.pre2Pattern)
    }
}
