/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {

    private let type: PolygonEnum
    var warningList = [ObjectWarning]()

    init(_ type: PolygonEnum) {
        self.type = type
        generateString()
    }

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
        let html = ObjectWarning.getBulkData(type)
        warningList = ObjectWarning.parseJson(html)
    }
    
    func getCount() -> String {
        var i = 0
        for  s in warningList {
            if s.isCurrent {
                i += 1
            }
        }
        return String(i)
    }
    
    func getCount() -> Int {
        var i = 0
        for s in warningList {
            if s.isCurrent {
                i += 1
            }
        }
        return i
    }
}
