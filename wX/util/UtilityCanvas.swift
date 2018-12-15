/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityCanvas {

    static let warningVtecPattern = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]"
        + "\\.[0-9]{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"
    static let warningLatLonPattern = "\"coordinates\":\\[\\[(.*?)\\]\\]\\}"

    static func addWarnings(_ provider: ProjectionType, _ bitmap: Bitmap, _ radarSite: String) {
        let isMercato = UtilityCanvasProjection.isMercator(provider)
        let paint = Paint()
        let pn = ProjectionNumbers(radarSite, provider)
        let colorList = [PolygonType.FFW.color, PolygonType.TST.color, PolygonType.TOR.color]
        let warningDataList = [MyApplication.severeDashboardFfw.value,
                               MyApplication.severeDashboardTst.value, MyApplication.severeDashboardTor.value]
        warningDataList.enumerated().forEach { index, warningData in
            paint.setColor(colorList[index])
            let warningHTML = warningData.replace("\n", "").replace(" ", "")
            var warnings = warningHTML.parseColumn(warningLatLonPattern)
            let vtecs = warningHTML.parseColumn(warningVtecPattern)
            warnings.enumerated().forEach {
                warnings[$0] = $1.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
            }
            canvasDrawWarningsNEWAPI(warnings, vtecs, bitmap, paint, isMercato, pn, false)
        }
    }

    static func drawCitiesUS(_ provider: ProjectionType, _ bitmap: Bitmap, _ radarSite: String, _ textSize: Int) {
        let isMercato = UtilityCanvasProjection.isMercator(provider)
        let paint = Paint()
        paint.setColor(GeographyType.cities.color)
        if UtilityCanvasProjection.needDarkPaint(provider) {paint.setColor(Color.rgb(0, 0, 0))}
        let pn = ProjectionNumbers(radarSite, provider)
        var tmpCoords = (0.0, 0.0)
        UtilityCities.CityObj.indices.forEach {
            if isMercato {
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(UtilityCities.CityObj[$0].latlon,
                                                                           pn, multLonNegativeOne: false)
            } else {
                tmpCoords = UtilityCanvasProjection.compute4326Numbers(UtilityCities.CityObj[$0].latlon, pn)
            }
            if textSize > 0 {
                drawCircle(bitmap, tmpCoords.0, tmpCoords.1, 2.0, paint)
            } else {
                drawCircle(bitmap, tmpCoords.0, tmpCoords.1, 2.0, paint)
            }
        }
    }

    static func addLocationDotForCurrentLocation(_ provider: ProjectionType, _ bitmap: Bitmap, _ radarSite: String) {
        let isMercato = UtilityCanvasProjection.isMercator(provider)
        let paint =  Paint()
        let pn = ProjectionNumbers(radarSite, provider)
        var tmpCoords = (0.0, 0.0)
        if isMercato {
            tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(Location.latlon, pn)
        } else {
            tmpCoords = UtilityCanvasProjection.compute4326Numbers(Location.latlon, pn)
        }
        paint.setColor(PolygonType.LOCDOT.color)
        drawCircle(bitmap, tmpCoords.0, tmpCoords.1, 2.0, paint)
    }

    static func addMCD(_ provider: ProjectionType, _ bitmap: Bitmap, _ radarSite: String, _ type: PolygonType) {
        let isMercato = UtilityCanvasProjection.isMercator(provider)
        let paint = Paint()
        paint.setColor(PolygonType.MCD.color)
        let pn = ProjectionNumbers(radarSite, provider)
        var prefToken = ""
        switch type.string {
        case "MCD":
            prefToken = MyApplication.mcdLatlon.value
            paint.setColor(PolygonType.MCD.color)
        case "MPD":
            prefToken = MyApplication.mpdLatlon.value
            paint.setColor(PolygonType.MPD.color)
        case "WATCH":
            prefToken = MyApplication.watchLatlon.value
            paint.setColor(PolygonType.WATCH.color)
        case "WATCH_TORNADO":
            prefToken = MyApplication.watchLatlonTor.value
            paint.setColor(PolygonType.WATCH_TORNADO.color)
        default: break
        }
        let tmpArr = prefToken.split(":")
        canvasDrawWarnings(tmpArr, bitmap, paint, isMercato, pn, false)
    }

    static func canvasDrawWarnings(_ warningAl: [String],
                                   _ canvas: Bitmap,
                                   _ paint: Paint,
                                   _ isMercato: Bool,
                                   _ pn: ProjectionNumbers,
                                   _ addPeriod: Bool) {
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: canvas.image.size, format: rendererFormat)
        let newImage = renderer.image {_ in
            canvas.image.draw(at: CGPoint.zero )
            let wallpath = UIBezierPath()
            var index = 0
            var x = [Double]()
            var y = [Double]()
            var pixXInit = 0.0
            var pixYInit = 0.0
            var tmpCoords = (0.0, 0.0)
            var pixX = 0.0
            var pixY = 0.0
            warningAl.forEach { warn in
                x = []
                y = []
                index = 0
                warn.split(" ").forEach { str in
                    if str != "" {
                        if (index & 1) == 0 {
                            if addPeriod {
                                x.append(Double(str.insert(str.count - 2, ".")) ?? 0.0)
                            } else {
                                x.append(Double(str) ?? 0.0)
                            }
                        } else {
                            if addPeriod {
                                y.append(Double(str.insert(str.count - 2, ".")) ?? 0.0)
                            } else {
                                y.append(Double(str) ?? 0.0)
                            }
                        }
                        index += 1
                    }
                }
                if y.count > 0 && x.count > 0 {
                    if isMercato {
                        tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], pn)
                    } else {
                        tmpCoords = UtilityCanvasProjection.compute4326Numbers(pn)
                    }
                    pixXInit = tmpCoords.0
                    pixYInit = tmpCoords.1
                    wallpath.move(to: CGPoint(x: CGFloat(pixXInit), y: CGFloat(pixYInit)))
                    if x.count == y.count {
                        ( 1..<x.count).forEach {
                            if isMercato {
                                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], pn)
                            } else {
                                tmpCoords = UtilityCanvasProjection.compute4326Numbers(pn)
                            }
                            pixX = tmpCoords.0
                            pixY = tmpCoords.1
                            wallpath.addLine(to: CGPoint(x: CGFloat(pixX), y: CGFloat(pixY)))
                        }
                        wallpath.addLine(to: CGPoint(x: CGFloat(pixXInit), y: CGFloat(pixYInit)))
                        wallpath.close()
                        paint.uicolor.setStroke()
                        wallpath.stroke()
                    }
                }
            }
        }
        canvas.image = newImage
    }

    static func canvasDrawWarningsNEWAPI(_ warningAl: [String], _ vtecAl: [String], _ canvas: Bitmap,
                                         _ paint: Paint,
                                         _ isMercato: Bool,
                                         _ pn: ProjectionNumbers,
                                         _ addPeriod: Bool) {
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: canvas.image.size, format: rendererFormat)
        let newImage = renderer.image {_ in
            canvas.image.draw(at: CGPoint.zero )
            let wallpath = UIBezierPath()
            var index = 0
            var x = [Double]()
            var y = [Double]()
            var pixXInit = 0.0
            var pixYInit = 0.0
            var tmpCoords = (0.0, 0.0)
            var pixX = 0.0
            var pixY = 0.0
            var polyCount = -1
            warningAl.forEach { warn in
                polyCount += 1
                if vtecAl.count > polyCount
                    && !vtecAl[polyCount].hasPrefix("0.EXP")
                    && !vtecAl[polyCount].hasPrefix("0.CAN") {
                    x = []
                    y = []
                    index = 0
                    warn.split(" ").forEach {
                        if $0 != "" {
                            if (index & 1) == 0 {
                                if addPeriod {
                                    y.append(Double($0.insert($0.count - 2, ".")) ?? 0.0)
                                } else {
                                    y.append(Double($0) ?? 0.0)
                                }
                            } else {
                                if addPeriod {
                                    x.append(Double($0.insert($0.count - 2, ".")) ?? 0.0)
                                } else {
                                    x.append(Double($0) ?? 0.0)
                                }
                            }
                            index += 1
                        }
                    }
                    if y.count > 0 && x.count > 0 {
                        if isMercato {
                            tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], pn)
                        } else {
                            tmpCoords = UtilityCanvasProjection.compute4326Numbers(pn)
                        }
                        pixXInit = tmpCoords.0
                        pixYInit = tmpCoords.1
                        wallpath.move(to: CGPoint(x: CGFloat(pixXInit), y: CGFloat(pixYInit)))
                        if x.count == y.count {
                            (1..<x.count).forEach {
                                if isMercato {
                                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], pn)
                                } else {
                                    tmpCoords = UtilityCanvasProjection.compute4326Numbers(pn)
                                }
                                pixX = tmpCoords.0
                                pixY = tmpCoords.1
                                wallpath.addLine(to: CGPoint(x: CGFloat(pixX), y: CGFloat(pixY)))
                            }
                            wallpath.addLine(to: CGPoint(x: CGFloat(pixXInit), y: CGFloat(pixYInit)))
                            wallpath.close()
                            paint.uicolor.setStroke()
                            wallpath.stroke()
                        }
                    }
                }
            }
        }
        canvas.image = newImage
    }

    static func drawCircle(_ canvas: Bitmap,
                           _ pixXInit: Double,
                           _ pixYInit: Double,
                           _ lineWidth: Double,
                           _ paint: Paint) {
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: canvas.image.size, format: rendererFormat)
        let newImage = renderer.image { _ in
            canvas.image.draw(at: CGPoint.zero)
            let wallpath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(pixXInit), y: CGFloat(pixYInit)),
                                        radius: CGFloat(lineWidth/2.0), startAngle: CGFloat(0.0),
                                        endAngle: CGFloat(Float.pi * 2.0), clockwise: true)
            paint.uicolor.setStroke()
            wallpath.lineWidth = 3.0
            wallpath.stroke()
        }
        canvas.image = newImage
    }
}
