/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWatch {
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonType) -> [Double] {
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
                
                let latLons = LatLon.parseStringToLatLons(polygon, 1.0, false)
                if latLons.count > 0 {
                    let startCoordinates = UtilityCanvasProjection.computeMercatorNumbers(latLons[0], projectionNumbers)
                    warningList += startCoordinates
                    (1..<latLons.count).forEach { index in
                        let coordinates = UtilityCanvasProjection.computeMercatorNumbers(latLons[index], projectionNumbers)
                        warningList += coordinates
                        warningList += coordinates
                    }
                    warningList += startCoordinates
                }
                
                /*let numbers = polygon.split(" ")
                 var x = [Double]()
                 var y = [Double]()
                 if numbers.count > 1 {
                 x = numbers.enumerated().filter {index, _ in index & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                 y = numbers.enumerated().filter {index, _ in index & 1 != 0}.map { _, value in Double(value) ?? 0.0}
                 }
                 if y.count > 0 && x.count > 0 {
                 let startCoordinates = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], projectionNumbers)
                 warningList += startCoordinates
                 if x.count == y.count {
                 (1..<x.count).forEach {
                 let coordinates = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], projectionNumbers)
                 warningList += coordinates
                 warningList += coordinates
                 }
                 warningList += startCoordinates
                 }
                 }*/
            }
        }
        return warningList
    }
    
    static func show(_ latLon: LatLon, _ type: PolygonType) -> String {
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
        var notFound = true
        var text = ""
        latLons.indices.forEach { z in
            
            let latLons = LatLon.parseStringToLatLons(latLons[z], -1.0, false)
            //if (y.size > 3 && x.size > 3 && x.size == y.size) {
            if latLons.count > 3 {
                let polygonFrame = ExternalPolygon.Builder()
                latLons.forEach {
                    _ = polygonFrame.addVertex(point: ExternalPoint($0))
                }
                let polygonShape = polygonFrame.build()
                let contains = polygonShape.contains(point: latLon.asPoint())
                if contains && notFound {
                    text = numberList[z]
                    notFound = false
                }
            }
            
            /*let numbers = latLons[z].split(" ")
             var x = [Double]()
             var y = [Double]()
             numbers.indices.forEach { index in
             if index & 1 == 0 {
             x.append(Double(numbers[index]) ?? 0.0)
             } else {
             y.append((Double(numbers[index]) ?? 0.0) * -1.0)
             }
             }
             if y.count > 3 && x.count > 3 && x.count == y.count {
             let polygonFrame = ExternalPolygon.Builder()
             x.indices.forEach {
             _ = polygonFrame.addVertex(point: ExternalPoint(x[$0], y[$0]))
             }
             let polygonShape = polygonFrame.build()
             let contains = polygonShape.contains(point: ExternalPoint(latLon))
             if contains && notFound {
             text = numberList[z]
             notFound = false
             }
             }*/
            
            
        }
        return text
    }
}
