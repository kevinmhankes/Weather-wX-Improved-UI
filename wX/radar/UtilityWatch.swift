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
    
    static func showProducts(_ latLon: LatLon, _ type: PolygonType) -> String {
        var lat = latLon.lat
        var lon = latLon.lon
        var text = ""
        var textWatNoList = ""
        var mcdNoArr = [String]()
        var watchLatLon: String
        switch type.string {
        case "WATCH":
            textWatNoList = MyApplication.watNoList.value;
            mcdNoArr = textWatNoList.split(":");
            watchLatLon = MyApplication.watchLatlon.value
            break;
        case "MCD":
            textWatNoList = MyApplication.mcdNoList.value
            mcdNoArr = textWatNoList.split(":");
            watchLatLon = MyApplication.mcdLatlon.value
            break;
        case "MPD":
            textWatNoList = MyApplication.mpdNoList.value
            mcdNoArr = textWatNoList.split(":");
            watchLatLon = MyApplication.watchLatlon.value
            break;
        default:
            textWatNoList = MyApplication.watNoList.value
            mcdNoArr = textWatNoList.split(":");
            watchLatLon = MyApplication.watchLatlon.value
            break;
        }
        var latlonArr = watchLatLon.split(":")
        var x = [Double]()
        var y = [Double]()
        var i: Int
        var testArr = [String]()
        var z = 0
        var notFound = true
        while (z < latlonArr.count) {
            testArr = latlonArr[z].split(" ")
            x = []
            y = []
            i = 0
            while (i < testArr.count) {
                if (i & 1 == 0) {
                    x.append(Double(testArr[i]) ?? 0.0)
                } else {
                    y.append((Double(testArr[i]) ?? 0.0) * -1.0)
                }
                i += 1
            }
            if (y.count > 3 && x.count > 3 && x.count == y.count) {
                let poly2 = ExternalPolygon.Builder()
                x.indices.forEach {
                    _ = poly2.addVertex(point: ExternalPoint(Float(x[$0]), Float(y[$0])))
                }
                let polygon2 = poly2.build()
                let contains = polygon2.contains(point: ExternalPoint(Float(lat), Float(lon)))
                if (contains && notFound) {
                    text = mcdNoArr[z]
                    notFound = false
                }
            }
            z += 1
        }
        return text
    }
}
