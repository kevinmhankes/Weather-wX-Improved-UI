/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class ObjectPolygonWarning {

    var storage: DataStorage
    var isEnabled = false;
    var type: PolygonTypeGeneric

    init(_ type: PolygonTypeGeneric) {
        self.type = type
        isEnabled = Utility.readPref("RADAR_SHOW_\(type)", "false").hasPrefix("t")
        storage = DataStorage("SEVERE_DASHBOARD_\(type)")
        storage.update()
    }

    var color: Int {return Utility.readPref(prefTokenColor, defaultColors[type]!)}
    var name: String {return longName[type]!.replaceAll("%20", " ")}
    var prefTokenEnabled: String {return "RADAR_SHOW_" + typeName}
    var prefTokenColor: String {return "RADAR_COLOR_" + typeName}
    var prefTokenStorage: String {return "SEVERE_DASHBOARD_" + typeName}
    var typeName: String {return "\(type)".replaceAll("PolygonType.", "")}
    var urlToken: String {return longName[type]!}
    var url: String {return baseUrl + urlToken}
    
    let defaultColors: [PolygonTypeGeneric: Int] = [
        .SMW: wXColor.colorsToInt(255, 165, 0),
        .SQW: wXColor.colorsToInt(199, 21, 133),
        .DSW: wXColor.colorsToInt(255, 228, 196),
        .SPS: wXColor.colorsToInt(255, 228, 181),
        //PolygonType.TOR: wXColor.colorsToInt(243, 85, 243),
        //PolygonType.TST: wXColor.colorsToInt(255, 255, 0),
        //PolygonType.FFW: wXColor.colorsToInt(0, 255, 0),
        ]
    
    let longName: [PolygonTypeGeneric: String] = [
        .SMW: "Special%20Marine%20Warning",
        .SQW: "Snow%20Squall%20Warning",
        .DSW: "Dust%20Storm%20Warning",
        .SPS: "Special%20Weather%20Statement",
        //PolygonType.TOR: "Tornado%20Warning",
        //PolygonType.TST: "Severe%20Thunderstorm%20Warning",
        //PolygonType.FFW: "Flash%20Flood%20Warning",
        //PolygonType.SPS: "Flood%20Warning"
    ]
    
    static let polygonList = [
        //PolygonTypeGeneric.TOR,
        //PolygonTypeGeneric.TST,
        //PolygonTypeGeneric.FFW,
        PolygonTypeGeneric.SMW,
        PolygonTypeGeneric.SQW,
        PolygonTypeGeneric.DSW,
        PolygonTypeGeneric.SPS
    ]
    
    static var polygonDataByType: [PolygonTypeGeneric: ObjectPolygonWarning] = [:]
    
    static func load() {
        polygonList.forEach{
            polygonDataByType[$0] = ObjectPolygonWarning($0);
        }
    }
    
    let baseUrl = "https://api.weather.gov/alerts/active?event="
}
