/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLPolygonWarnings {
    
    // Used in SevereWarnings as well
    static let vtecPattern = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]"
        + "{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"
    
    // FIXME have TOR/FFW/TST use this
    static func addGeneric(_ projectionNumbers: ProjectionNumbers, _ type: ObjectPolygonWarning) -> [Double] {
        var warningList = [Double]()
        let prefToken = type.storage.value
        let html = prefToken.replace("\n", "").replace(" ", "")
        let polygons = html.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        let vtecs = html.parseColumn(vtecPattern)
        var polyCount = -1
        polygons.forEach { polygon in
            //var x = [Double]()
            //var y = [Double]()
            polyCount += 1
            if type.type == PolygonTypeGeneric.SPS || vtecs.count > polyCount
                && !vtecs[polyCount].hasPrefix("0.EXP")
                && !vtecs[polyCount].hasPrefix("0.CAN") {
                //let polygonTmp = poly.replace("[", "").replace("]", "").replace(",", " ").replace("-", "").split(" ")
                
                let polygonTmp = polygon.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
                let latLons = LatLon.parseStringToLatLons(polygonTmp)
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
                
                /*if polygonTmp.count > 1 {
                    y = polygonTmp.enumerated().filter {index, _ in index & 1 == 0}.map {_, value in Double(value) ?? 0.0}
                    x = polygonTmp.enumerated().filter {index, _ in index & 1 != 0}.map {_, value in Double(value) ?? 0.0}
                }
                if y.count > 0 && x.count > 0 {
                    let startCoordinates = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], projectionNumbers)
                    warningList += startCoordinates
                    if x.count == y.count {
                        (1..<x.count).forEach {
                            let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], projectionNumbers)
                            warningList += tmpCoords
                            warningList += tmpCoords
                        }
                        warningList += startCoordinates
                    }
                }*/
            }
        }
        return warningList
    }
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = MyApplication.severeDashboardFfw.value
        if type.string == "TOR" {
            prefToken = MyApplication.severeDashboardTor.value
        } else if type.string == "TST" {
            prefToken = MyApplication.severeDashboardTst.value
        }
        let html = prefToken.replace("\n", "").replace(" ", "")
        let polygons = html.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        let vtecs = html.parseColumn(vtecPattern)
        var polygonCount = -1
        polygons.forEach { polygon in
            
            //var x = [Double]()
            //var y = [Double]()
            polygonCount += 1
            if vtecs.count > polygonCount && !vtecs[polygonCount].hasPrefix("0.EXP") && !vtecs[polygonCount].hasPrefix("0.CAN") {
                
                let polygonTmp = polygon.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
                let latLons = LatLon.parseStringToLatLons(polygonTmp)
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
                
                //                let coordinates = polygon.replace("[", "").replace("]", "").replace(",", " ").replace("-", "").split(" ")
                //                if coordinates.count > 1 {
                //                    y = coordinates.enumerated().filter {index, _ in index & 1 == 0}.map {_, value in Double(value) ?? 0.0}
                //                    x = coordinates.enumerated().filter {index, _ in index & 1 != 0}.map {_, value in Double(value) ?? 0.0}
                //                }
                //                if y.count > 0 && x.count > 0 {
                //                    let startCoordinates = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], projectionNumbers)
                //                    warningList += startCoordinates
                //                    if x.count == y.count {
                //                        (1..<x.count).forEach {
                //                            let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], projectionNumbers)
                //                            warningList += tmpCoords
                //                            warningList += tmpCoords
                //                        }
                //                        warningList += startCoordinates
                //                    }
                //                }
                
            }
        }
        return warningList
    }
}
