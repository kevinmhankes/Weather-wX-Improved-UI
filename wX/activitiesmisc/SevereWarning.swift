/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {

    var text = ""
    private var type = ""
    private var count = 0
    private var collapsed = false
    var idList = [String]()
    var areaDescList = [String]()
    var effectiveList = [String]()
    var expiresList = [String]()
    var eventList = [String]()
    var senderNameList = [String]()
    var warnings = [String]()
    var listOfWfo = [String]()

    init(_ type: String) {
        self.type = type
    }

    func getCount() -> Int { eventList.count }

    func toggleCollapsed() {
        if collapsed {
            collapsed = false
        } else {
            collapsed = true
        }
    }

    func getName() -> String {
        switch type {
        case "tor":
            return "Tornado Warning"
        case "tst":
            return "Severe Thunderstorm Warning"
        case "ffw":
            return "Flash Flood Warning"
        default:
            return ""
        }
    }

    func generateString(_ html: String) {
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
                count += 1
                text += $0
                let wfos = $0.split(".")
                if wfos.count > 1 {
                    let wfo = wfos[2].replaceAllRegexp("^[KP]", "")
                    listOfWfo.append(wfo)
                    location = Utility.getWfoSiteName(wfo)
                }
                text += "  " + location + MyApplication.newline
            }
        }
    }
}
