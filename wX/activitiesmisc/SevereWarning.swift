/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {
    
    var text = ""
    var count = 0
    private let type: PolygonEnum
    var idList = [String]()
    var areaDescList = [String]()
    var effectiveList = [String]()
    var expiresList = [String]()
    var eventList = [String]()
    var senderNameList = [String]()
    var warnings = [String]()
    var listOfWfo = [String]()
    
    init(_ type: PolygonEnum) {
        self.type = type
        generateString()
    }
    
    func getCount() -> Int { count }
    
    func getName() -> String {
        switch type {
        case .TOR:
            return "Tornado Warning"
        case .TST:
            return "Severe Thunderstorm Warning"
        case .FFW:
            return "Flash Flood Warning"
        default:
            return ""
        }
    }
    
    func generateString() {
        let html: String
        switch type {
        case .TOR:
            html = MyApplication.severeDashboardTor.value
        case .TST:
            html = MyApplication.severeDashboardTst.value
        case .FFW:
            html = MyApplication.severeDashboardFfw.value
        default:
            html = ""
        }
        text = ""
        count = 0
        idList = html.parseColumn("\"id\": \"(NWS.*?)\"")
        areaDescList = html.parseColumn("\"areaDesc\": \"(.*?)\"")
        effectiveList = html.parseColumn("\"effective\": \"(.*?)\"")
        expiresList = html.parseColumn("\"expires\": \"(.*?)\"")
        eventList = html.parseColumn("\"event\": \"(.*?)\"")
        senderNameList = html.parseColumn("\"senderName\": \"(.*?)\"")
        warnings = html.parseColumn(WXGLPolygonWarnings.vtecPattern)
        warnings.forEach {
            //let vtecIsCurrent = UtilityTime.isVtecCurrent($0)
            if !$0.hasPrefix("O.EXP") {
                var location = ""
                text += $0
                count += 1
                let wfos = $0.split(".")
                if wfos.count > 1 {
                    let wfo = wfos[2].replaceAllRegexp("^[KP]", "")
                    listOfWfo.append(wfo)
                    location = Utility.getWfoSiteName(wfo)
                }
                text += "  " + location + MyApplication.newline
            } else {
                listOfWfo.append("")
            }
        }
    }
}
