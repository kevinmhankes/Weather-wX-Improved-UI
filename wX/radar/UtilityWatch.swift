/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWatch {

    static func add(_ pn: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = ""
        switch type.string {
        case "MCD":
            prefToken = MyApplication.mcdLatlon.value
        case "WATCH":
            prefToken = MyApplication.watchLatlon.value
        case "WATCH_TORNADO":
            prefToken = MyApplication.watchLatlonTor.value
        case "MPD":
            prefToken = MyApplication.mpdLatlon.value
        default:
            break
        }
        if prefToken != "" {
            let polygons = prefToken.split(":")
            polygons.forEach { polygon in
                let numbers = polygon.split(" ")
                var x = [Double]()
                var y = [Double]()
                if numbers.count > 1 {
                    x = numbers.enumerated().filter {idx, _ in idx & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                    y = numbers.enumerated().filter {idx, _ in idx & 1 != 0}.map { _, value in Double(value) ?? 0.0}
                }
                if y.count > 0 && x.count > 0 {
                    let coordinates = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], pn)
                    let xStart = coordinates.lat
                    let yStart = coordinates.lon
                    warningList += [xStart, yStart]
                    if x.count == y.count {
                        (1..<x.count).forEach {
                            let coordinates = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], pn)
                            warningList += [coordinates.lat, coordinates.lon, coordinates.lat, coordinates.lon]
                        }
                        warningList += [xStart, yStart]
                    }
                }
            }
        }
        return warningList
    }

    static func showProducts(_ latLon: LatLon, _ type: PolygonType) -> String {
        var text = ""
        var numberList = [String]()
        var watchLatLon: String
        switch type.string {
        case "WATCH":
            numberList = MyApplication.watNoList.value.split(":")
            watchLatLon = MyApplication.watchLatlonCombined.value
        case "MCD":
            numberList = MyApplication.mcdNoList.value.split(":")
            watchLatLon = MyApplication.mcdLatlon.value
        case "MPD":
            numberList = MyApplication.mpdNoList.value.split(":")
            watchLatLon = MyApplication.mpdLatlon.value
        default:
            numberList = MyApplication.watNoList.value.split(":")
            watchLatLon = MyApplication.watchLatlon.value
        }
        let latLons = watchLatLon.split(":")
        var z = 0
        var notFound = true
        while z < latLons.count {
            let numbers = latLons[z].split(" ")
            var x = [Double]()
            var y = [Double]()
            var index = 0
            while index < numbers.count {
                if index & 1 == 0 {
                    x.append(Double(numbers[index]) ?? 0.0)
                } else {
                    y.append((Double(numbers[index]) ?? 0.0) * -1.0)
                }
                index += 1
            }
            if y.count > 3 && x.count > 3 && x.count == y.count {
                let poly2 = ExternalPolygon.Builder()
                x.indices.forEach {
                    _ = poly2.addVertex(point: ExternalPoint(Float(x[$0]), Float(y[$0])))
                }
                let polygon2 = poly2.build()
                let contains = polygon2.contains(point: ExternalPoint(Float(latLon.lat), Float(latLon.lon)))
                if contains && notFound {
                    text = numberList[z]
                    notFound = false
                }
            }
            z += 1
        }
        return text
    }
}
