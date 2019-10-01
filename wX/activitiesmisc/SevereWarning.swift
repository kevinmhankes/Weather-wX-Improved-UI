/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {

    var text = ""
    private var type = ""
    private var count = 0
    // gen2 add
    var collapsed = false
    var idList = [String]()
    var areaDescList = [String]()
    var effectiveList = [String]()
    var expiresList = [String]()
    var eventList = [String]()
    var senderNameList = [String]()
    var warnings = [String]()
    //

    init(_ type: String) {
        self.type = type
    }

    func getCount() -> Int {
        //print(eventList)
        return eventList.count
    }

    // gen2 add
    func toggleCollapsed() {
        if collapsed {
            collapsed = false
        } else {
            collapsed = true
        }
    }
    
    func getName() -> String {
        var name = ""
        switch type {
        case "tor":
            name = "Tornado Warning"
        case "tst":
            name = "Severe Thunderstorm Warning"
        case "ffw":
            name = "Flash Flood Warning"
        default:
            break
        }
        return name
    }
    //

    func generateString(_ html: String) {
        var wfos = [String]()
        var wfo = ""
        var location = ""
        // gen2 add
        idList = html.parseColumn("\"id\": \"(NWS.*?)\"")
        areaDescList = html.parseColumn("\"areaDesc\": \"(.*?)\"")
        effectiveList = html.parseColumn("\"effective\": \"(.*?)\"")
        expiresList = html.parseColumn("\"expires\": \"(.*?)\"")
        eventList = html.parseColumn("\"event\": \"(.*?)\"")
        senderNameList = html.parseColumn("\"senderName\": \"(.*?)\"")
        //
        warnings = html.parseColumn(WXGLPolygonWarnings.vtecPattern)
        warnings.forEach {
            //let vtecIsCurrent = UtilityTime.isVtecCurrent($0)
            if !$0.hasPrefix("O.EXP") {
                count += 1
                text += $0
                wfos = $0.split(".")
                if wfos.count > 1 {
                    wfo = wfos[2]
                    wfo = wfo.replaceAllRegexp("^[KP]", "")
                    location = Utility.readPref("NWS_LOCATION_" + wfo, "")
                }
                text += "  " + location + MyApplication.newline
            }
        }
    }
}
