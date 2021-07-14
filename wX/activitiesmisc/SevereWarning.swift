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
    
    func download() {
        switch type {
        case .TOR:
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.TOR]!.download()
        case .TST:
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.TST]!.download()
        case .FFW:
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.FFW]!.download()
        default:
            break
        }
        self.generateString()
    }
    
    func generateString() {
        // let html = ObjectWarning.getBulkData(type)
        var html = ""
        switch type {
        case .TOR:
            html = ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.TOR]!.getData()
        case .TST:
            html = ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.TST]!.getData()
        case .FFW:
            html = ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.FFW]!.getData()
        default:
            break
        }
        warningList = ObjectWarning.parseJson(html)
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
