/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class WXMetalTextObject {
    
    private var glview = WXMetalSurfaceView()
    var OGLR: WXMetalRender!
    private var numPanes = 0
    private let cityExtZoom = 30.0
    #if targetEnvironment(macCatalyst)
    private let cityMinZoom: Float = 0.20
    private let obsMinZoom: Float = 0.20
    private let countyMinZoom: Float = 0.20
    #endif
    #if !targetEnvironment(macCatalyst)
    private let cityMinZoom: Float = 0.50
    private let obsMinZoom: Float = 0.50
    private let countyMinZoom: Float = 1.50
    #endif
    private var cityExtLength = 0
    private var maxCitiesPerGlview = 16
    private var obsExtZoom = 6.5
    private var glviewWidth = 0.0
    private var glviewHeight = 0.0
    private var scale = 0.0
    private var oglrZoom: Float = 0.0
    private var textSize = Double(RadarPreferences.radarTextSize)
    private var context: UIViewController
    private var screenScale = 0.0
    private var xFudge = 15.0
    private var yFudge = 25.0
    private var fudgeFactor = 375.0
    
    init() {
        context = UIViewController()
    }
    
    init(
        _ context: UIViewController,
        _ numPanes: Int,
        _ glviewWidth: Double,
        _ glviewHeight: Double,
        _ OGLR: WXMetalRender,
        _ screenScale: Double
    ) {
        self.context = context
        self.glviewWidth = glviewWidth
        self.glviewHeight = glviewHeight
        self.OGLR = OGLR
        self.numPanes = numPanes
        self.maxCitiesPerGlview = maxCitiesPerGlview / numPanes
        self.screenScale = screenScale * (glviewWidth / fudgeFactor) * 0.5
        scale = 0.76 * screenScale * 0.5 * (glviewWidth / fudgeFactor)
        xFudge = 15.0 * (fudgeFactor / glviewWidth)
        yFudge = 25.0 * (fudgeFactor / glviewWidth)
    }
    
    private func addTextLabelsCitiesExtended() {
        if GeographyType.cities.display {
            glview.citiesExtAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.00 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > cityMinZoom {
                cityExtLength = UtilityCitiesExtended.cities.count
                (0..<cityExtLength).forEach { index in
                    if glview.citiesExtAl.count <= maxCitiesPerGlview {
                        checkAndDrawText(
                            &glview.citiesExtAl,
                            UtilityCitiesExtended.cities[index].latitude,
                            UtilityCitiesExtended.cities[index].longitude,
                            UtilityCitiesExtended.cities[index].name,
                            GeographyType.cities.color
                        )
                    }
                }
            }
        }
    }
    
    func checkAndDrawText(_ tvList:inout [TextViewMetal], _ lat: Double, _ lon: Double, _ text: String, _ color: Int) {
        let latLon = UtilityCanvasProjection.computeMercatorNumbers(lat, lon, OGLR.pn)
        // changing RID resets glviewWidth
        let xPos = latLon[0] * Double(OGLR.zoom) - xFudge + Double(OGLR.xPos)
        let yPos = latLon[1] * Double(OGLR.zoom) - yFudge - Double(OGLR.yPos)
        if abs(xPos) * scale * 2 < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
            let tv = TextViewMetal(context)
            tv.textColor = color
            tv.textSize = Double(textSize)
            tv.setPadding(CGFloat(glviewWidth / 2) + CGFloat(xPos * scale), CGFloat(glviewHeight / 2) + CGFloat(yPos * scale))
            tv.setText(text)
            tvList.append(tv)
        }
    }
    
    private func initializeTextLabelsCitiesExtended() {
        if numPanes == 1 {
            if GeographyType.cities.display {
                UtilityCitiesExtended.create()
            }
        }
    }
    
    private func initializeTextLabelsCountyLabels() {
        if GeographyType.countyLabels.display {
            UtilityCountyLabels.create()
        }
    }
    
    private func addTextLabelsCountyLabels() {
        if GeographyType.countyLabels.display {
            glview.countyLabelsAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.00 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > countyMinZoom {
                UtilityCountyLabels.countyName.indices.forEach {
                    checkAndDrawText(
                        &glview.countyLabelsAl,
                        UtilityCountyLabels.location[$0].lat,
                        UtilityCountyLabels.location[$0].lon,
                        UtilityCountyLabels.countyName[$0],
                        GeographyType.countyLabels.color
                    )
                }
            }
        }
    }
    
    private func addTextLabelsSpottersLabels() {
        if PolygonType.SPOTTER_LABELS.display {
            glview.spottersLabelAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > 0.5 {
                UtilitySpotter.spotterList.indices.forEach {
                    checkAndDrawText(
                        &glview.spottersLabelAl,
                        UtilitySpotter.spotterList[$0].location.lat,
                        UtilitySpotter.spotterList[$0].location.lon * -1.0,
                        " " + UtilitySpotter.spotterList[$0].lastName.replace("0FAV ", ""),
                        PolygonType.SPOTTER_LABELS.color
                    )
                }
            }
        }
    }
    
    func initializeTextLabels() {
        if numPanes == 1 {
            initializeTextLabelsCitiesExtended()
        }
        initializeTextLabelsCountyLabels()
    }
    
    func removeTextLabels() {
        context.view.subviews.forEach { view in
            if view is UITextView {
                view.removeFromSuperview()
            }
        }
    }
    
    func refreshTextLabels() {
        removeTextLabels()
        addTextLabels()
    }
    
    func addTextLabels() {
        if numPanes == 1 && OGLR != nil {
            addTextLabelsCitiesExtended()
            addTextLabelsCountyLabels()
            addTextLabelsObservations()
            addTextLabelsSpottersLabels()
            addWpcPressureCenters()
        }
    }
    
    func addWpcPressureCenters() {
        if RadarPreferences.radarShowWpcFronts {
            glview.pressureCenterLabelAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom < WXMetalRender.zoomToHideMiscFeatures {
                UtilityWpcFronts.pressureCenters.forEach { value in
                    var color = wXColor.colorsToInt(0, 127, 255)
                    if value.type == PressureCenterTypeEnum.LOW {
                        color = wXColor.colorsToInt(255, 0, 0)
                    }
                    checkAndDrawText(&glview.pressureCenterLabelAl, value.lat, value.lon, value.pressureInMb, color)
                }
            }
        }
    }
    
    private func addTextLabelsObservations() {
        if PolygonType.OBS.display||PolygonType.WIND_BARB.display {
            obsExtZoom = Double(RadarPreferences.radarObsExtZoom)
            glview.obsAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > obsMinZoom {
                UtilityMetar.obsArr.indices.forEach { index in
                    if index < UtilityMetar.obsArr.count && index < UtilityMetar.obsArrExt.count {
                        let tmpArrObs = UtilityMetar.obsArr[index].split(":")
                        let tmpArrObsExt = UtilityMetar.obsArrExt[index].split(":")
                        let lat = Double(tmpArrObs[0]) ?? 0.0
                        let lon = Double(tmpArrObs[1]) ?? 0.0
                        let latLon = UtilityCanvasProjection.computeMercatorNumbers(lat, lon * -1.0, OGLR.pn)
                        let xPos = latLon[0] * Double(OGLR.zoom) - xFudge + Double(OGLR.xPos)
                        let yPos = latLon[1] * Double(OGLR.zoom) - yFudge - Double(OGLR.yPos)
                        if abs(Double(xPos) * scale * 2 ) < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
                            if Double(OGLR.zoom) > obsExtZoom {
                                glview.obsAl.append(TextViewMetal(context, 150, 150))
                            } else {
                                glview.obsAl.append(TextViewMetal(context))
                            }
                            glview.obsAl.last?.textColor = RadarGeometry.radarColorObs
                            glview.obsAl.last?.textSize = textSize
                            glview.obsAl.last?.setPadding(CGFloat(glviewWidth / 2) + CGFloat(xPos * scale), CGFloat(glviewHeight / 2) + CGFloat(yPos * scale))
                            if Double(OGLR.zoom) > obsExtZoom {
                                glview.obsAl.last?.setText(tmpArrObsExt[2])
                            } else if PolygonType.OBS.display {
                                glview.obsAl.last?.setText(tmpArrObs[2])
                            }
                        }
                    }
                }
            }
        }
    }
}
