/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWatch {

    static func add(_ pn: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = ""
        switch type.string {
        case "MCD":           prefToken = MyApplication.mcdLatlon.value
        case "WATCH":         prefToken = MyApplication.watchLatlon.value
        case "WATCH_TORNADO": prefToken = MyApplication.watchLatlonTor.value
        case "MPD":           prefToken = MyApplication.mpdLatlon.value
        default: break
        }
        var x = [Double]()
        var y = [Double]()
        var pixXInit = 0.0
        var pixYInit = 0.0
        if prefToken != "" {
            var tmpArr = prefToken.split(":")
            tmpArr.indices.forEach {
                let test = tmpArr[$0].split(" ")
                if test.count > 1 {
                    x = test.enumerated().filter {idx, _ in idx & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                    y = test.enumerated().filter {idx, _ in idx & 1 != 0}.map { _, value in Double(value) ?? 0.0}
                }
                if y.count > 0 && x.count > 0 {
                    let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], pn)
                    pixXInit = tmpCoords.lat
                    pixYInit = tmpCoords.lon
                    warningList += [tmpCoords.lat, tmpCoords.lon]
                    //warningList.append(tmpCoords.lat)
                    //warningList.append(tmpCoords.lon)
                    if x.count == y.count {
                        (1..<x.count).forEach {
                            let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], pn)
                            warningList += [tmpCoords.lat, tmpCoords.lon, tmpCoords.lat, tmpCoords.lon]
                            //warningList.append(tmpCoords.lat)
                            //warningList.append(tmpCoords.lon)
                            //warningList.append(tmpCoords.lat)
                            //warningList.append(tmpCoords.lon)
                        }
                        warningList += [pixXInit, pixYInit]
                        //warningList.append(pixXInit)
                        //warningList.append(pixYInit)
                    }
                }
            }
        }
        return warningList
    }
}
