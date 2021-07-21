/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectPolygonWarning {

    let storage: DataStorage
    let timer: DownloadTimer
    let isEnabled: Bool
    let type: PolygonTypeGeneric
    private let baseUrl = "https://api.weather.gov/alerts/active?event="

    init(_ type: PolygonTypeGeneric) {
        self.type = type
        isEnabled = Utility.readPref("RADAR_SHOW_\(type)", "false").hasPrefix("t")
        storage = DataStorage("SEVEREDASHBOARD\(type)")
        timer = DownloadTimer("WARNINGS_\(type)")
        storage.update()
    }
    
    func download() {
        if timer.isRefreshNeeded() {
            let html = getUrl().getNwsHtml()
            if html != "" {
                storage.value = html
            } else {
                timer.resetTimer()
            }
        }
    }

    func getData() -> String {
        storage.value
    }

    var color: Int { Utility.readPref(prefTokenColor, defaultColors[type]!) }
    
    var name: String { longName[type]!.replaceAll("%20", " ") }
    
    var prefTokenEnabled: String { "RADAR_SHOW_" + typeName }
    
    var prefTokenColor: String { "RADAR_COLOR_" + typeName }
    
    var prefTokenStorage: String { "SEVERE_DASHBOARD_" + typeName }
    
    var typeName: String { "\(type)".replaceAll("PolygonType.", "") }
    
    var urlToken: String { longName[type]! }
    
    func getUrlToken() -> String {
        longName[type]!
    }
    
    var url: String { baseUrl + urlToken }
    
    func getUrl() -> String {
        baseUrl + getUrlToken()
    }
    
    static func getCount(_ data: String) -> String {
        let vtecAl = data.parseColumn(ObjectPolygonWarning.pVtec)
        var count = 0
        vtecAl.forEach {
            if !$0.hasPrefix("O.EXP") && !$0.hasPrefix("O.CAN") && UtilityTime.isVtecCurrent($0) { // UtilityTime.isVtecCurrent($0)
                count += 1
            }
        }
        return String(count)
    }

    let defaultColors: [PolygonTypeGeneric: Int] = [
        .SMW: wXColor.colorsToInt(255, 165, 0),
        .SQW: wXColor.colorsToInt(199, 21, 133),
        .DSW: wXColor.colorsToInt(255, 228, 196),
        .SPS: wXColor.colorsToInt(255, 228, 181),
        .TOR: wXColor.colorsToInt(243, 85, 243),
        .TST: wXColor.colorsToInt(255, 255, 0),
        .FFW: wXColor.colorsToInt(0, 255, 0)
    ]

    let longName: [PolygonTypeGeneric: String] = [
        .SMW: "Special%20Marine%20Warning",
        .SQW: "Snow%20Squall%20Warning",
        .DSW: "Dust%20Storm%20Warning",
        .SPS: "Special%20Weather%20Statement",
        .TOR: "Tornado%20Warning",
        .TST: "Severe%20Thunderstorm%20Warning",
        .FFW: "Flash%20Flood%20Warning"
    ]

    static let polygonList = [
        PolygonTypeGeneric.TOR,
        PolygonTypeGeneric.TST,
        PolygonTypeGeneric.FFW,
        PolygonTypeGeneric.SMW,
        PolygonTypeGeneric.SQW,
        PolygonTypeGeneric.DSW,
        PolygonTypeGeneric.SPS
    ]

    static func areAnyEnabled() -> Bool {
        var anyEnabled = false
        polygonList.forEach {
            if ObjectPolygonWarning.polygonDataByType[$0]!.isEnabled {
                anyEnabled = true
            }
        }
        return anyEnabled
    }
    
    static func resetTimers() {
        polygonList.forEach {
            ObjectPolygonWarning.polygonDataByType[$0]!.timer.resetTimer()
        }
    }

    static let pVtec = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]" +
    "{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"

    static var polygonDataByType: [PolygonTypeGeneric: ObjectPolygonWarning] = [:]

    static func load() {
        polygonList.forEach { polygonDataByType[$0] = ObjectPolygonWarning($0) }
    }
}
