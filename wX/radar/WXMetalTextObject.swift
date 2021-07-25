/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class WXMetalTextObject {
    
    private var glView = WXMetalSurfaceView()
    var wxMetalRender: WXMetalRender!
    private let numPanes: Int
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
    private let maxCitiesPerGlview: Int
    private let glViewWidth: Double
    private let glViewHeight: Double
    private let scale: Double
    private let textSize = Double(RadarPreferences.textSize)
    private let context: UIViewController
    private let xFudge: Double
    private let yFudge: Double
    private var fileStorage = FileStorage()
    
    init() {
        numPanes = 0
        glViewWidth = 0.0
        glViewHeight = 0.0
        scale = 0.0
        xFudge = 15.0
        yFudge = 25.0
        maxCitiesPerGlview = 16
        context = UIViewController()
    }
    
    init(
        _ context: UIViewController,
        _ numPanes: Int,
        _ glViewWidth: Double,
        _ glViewHeight: Double,
        _ wxMetalRender: WXMetalRender,
        _ screenScale: Double
    ) {
        self.context = context
        self.glViewWidth = glViewWidth
        self.glViewHeight = glViewHeight
        self.wxMetalRender = wxMetalRender
        self.numPanes = numPanes
        self.fileStorage = wxMetalRender.fileStorage
        maxCitiesPerGlview = 16 / numPanes
        let fudgeFactor = 375.0
        scale = 0.76 * screenScale * 0.5 * (glViewWidth / fudgeFactor)
        xFudge = 15.0 * (fudgeFactor / glViewWidth)
        yFudge = 25.0 * (fudgeFactor / glViewWidth)
    }
    
    private func addTextLabelsCitiesExtended() {
        if GeographyType.cities.display {
            glView.cities.removeAll()
            if wxMetalRender.zoom > cityMinZoom {
                let cityExtLength = UtilityCitiesExtended.cities.count
                (0..<cityExtLength).forEach { index in
                    if glView.cities.count <= maxCitiesPerGlview {
                        checkAndDrawText(
                            &glView.cities,
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
    
    func checkAndDrawText(_ tvList: inout [TextViewMetal], _ lat: Double, _ lon: Double, _ text: String, _ color: Int) {
        let latLon = UtilityCanvasProjection.computeMercatorNumbers(lat, lon, wxMetalRender.projectionNumbers)
        // changing RID resets glviewWidth
        let xPos = latLon[0] * Double(wxMetalRender.zoom) - xFudge + Double(wxMetalRender.xPos)
        let yPos = latLon[1] * Double(wxMetalRender.zoom) - yFudge - Double(wxMetalRender.yPos)
        if abs(xPos) * scale * 2 < glViewWidth && abs(yPos * scale * 2) < glViewHeight {
            let tv = TextViewMetal(context)
            tv.textColor = color
            tv.textSize = Double(textSize)
            tv.setPadding(CGFloat(glViewWidth / 2) + CGFloat(xPos * scale), CGFloat(glViewHeight / 2) + CGFloat(yPos * scale))
            tv.setText(text)
            tvList.append(tv)
        }
    }
    
    private func initializeTextLabelsCitiesExtended() {
        if numPanes == 1 && GeographyType.cities.display {
            UtilityCitiesExtended.create()
        }
    }
    
    private func initializeTextLabelsCountyLabels() {
        if GeographyType.countyLabels.display {
            UtilityCountyLabels.create()
        }
    }
    
    private func addTextLabelsCountyLabels() {
        if GeographyType.countyLabels.display {
            glView.countyLabels.removeAll()
            if wxMetalRender.zoom > countyMinZoom {
                UtilityCountyLabels.countyName.indices.forEach {
                    checkAndDrawText(
                        &glView.countyLabels,
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
            glView.spottersLabels.removeAll()
            if wxMetalRender.zoom > 0.5 {
                UtilitySpotter.spotterList.indices.forEach {
                    checkAndDrawText(
                        &glView.spottersLabels,
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
        if numPanes == 1 && wxMetalRender != nil {
            addTextLabelsCitiesExtended()
            addTextLabelsCountyLabels()
            addTextLabelsObservations()
            addTextLabelsSpottersLabels()
            addWpcPressureCenters()
        }
    }
    
    func addWpcPressureCenters() {
        if RadarPreferences.radarShowWpcFronts {
            glView.pressureCenterLabels.removeAll()
            if wxMetalRender.zoom < WXMetalRender.zoomToHideMiscFeatures {
                UtilityWpcFronts.pressureCenters.forEach { value in
                    var color = wXColor.colorsToInt(0, 127, 255)
                    if value.type == PressureCenterTypeEnum.LOW {
                        color = wXColor.colorsToInt(255, 0, 0)
                    }
                    checkAndDrawText(&glView.pressureCenterLabels, value.lat, value.lon, value.pressureInMb, color)
                }
            }
        }
    }
    
    private func addTextLabelsObservations() {
        if PolygonType.OBS.display||PolygonType.WIND_BARB.display {
            let obsExtZoom = Double(RadarPreferences.obsExtZoom)
            glView.observations.removeAll()
            if wxMetalRender.zoom > obsMinZoom {
                fileStorage.obsArr.indices.forEach { index in
                    if index < fileStorage.obsArr.count && index < fileStorage.obsArrExt.count {
                        let tmpArrObs = fileStorage.obsArr[index].split(":")
                        let tmpArrObsExt = fileStorage.obsArrExt[index].split(":")
                        let lat = to.Double(tmpArrObs[0])
                        let lon = to.Double(tmpArrObs[1])
                        let latLon = UtilityCanvasProjection.computeMercatorNumbers(lat, lon * -1.0, wxMetalRender.projectionNumbers)
                        let xPos = latLon[0] * Double(wxMetalRender.zoom) - xFudge + Double(wxMetalRender.xPos)
                        let yPos = latLon[1] * Double(wxMetalRender.zoom) - yFudge - Double(wxMetalRender.yPos)
                        if abs(Double(xPos) * scale * 2 ) < glViewWidth && abs(yPos * scale * 2) < glViewHeight {
                            if Double(wxMetalRender.zoom) > obsExtZoom {
                                glView.observations.append(TextViewMetal(context, 150, 150))
                            } else {
                                glView.observations.append(TextViewMetal(context))
                            }
                            glView.observations.last?.textColor = RadarGeometry.radarColorObs
                            glView.observations.last?.textSize = textSize
                            glView.observations.last?.setPadding(CGFloat(glViewWidth / 2) + CGFloat(xPos * scale), CGFloat(glViewHeight / 2) + CGFloat(yPos * scale))
                            if Double(wxMetalRender.zoom) > obsExtZoom {
                                glView.observations.last?.setText(tmpArrObsExt[2])
                            } else if PolygonType.OBS.display {
                                glView.observations.last?.setText(tmpArrObs[2])
                            }
                        }
                    }
                }
            }
        }
    }
}
