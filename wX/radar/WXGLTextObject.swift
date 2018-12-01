/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import OpenGLES
import GLKit

final class WXGLTextObject {

    private var glview = WXGLSurfaceView()
    private var OGLR = WXGLRender(ObjectToolbarIcon(), ObjectToolbarIcon())
    private var numPanes = 0
    private var cityextTvArrInit = false
    private var countyLabelsTvArrInit = false
    private var obsTvArrInit = false
    private var spottersLabelsTvArrInit = false
    private var spotterLat = 0.0
    private var spotterLon = 0.0
    private let cityExtZoom = 30.0
    private let cityMinZoom = 0.50
    private var cityExtLength = 0
    private var maxCitiesPerGlview = 16
    private var obsExtZoom = 6.5
    private var glviewWidth = 0.0
    private var glviewHeight = 0.0
    private var tmpCoords = (0.0, 0.0)
    private var scale = 0.0
    private var oglrZoom = 0.0
    private var textSize = 0.0
    private var context: GLKViewController
    private var screenScale = 0.0
    private var xFudge = 15.0
    private var yFudge = 25.0
    private var fudgeFactor = 375.0

    init() {context = GLKViewController()}

    init(_ context: GLKViewController, _ numPanes: Int, _  glviewWidth: Double,
         _ glviewHeight: Double, _ OGLR: WXGLRender, _ screenScale: Double) {
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

    func addTVCitiesExt() {
        if GeographyType.cities.display {
            glview.citiesExtAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.00 {oglrZoom = OGLR.zoom * 0.8}
            textSize = oglrZoom * 0.75 * Double(RadarPreferences.radarTextSize)
            if OGLR.zoom > cityMinZoom {
                cityExtLength = UtilityCitiesExtended.cities.count
                (0..<cityExtLength).forEach {
                    if glview.citiesExtAl.count <= maxCitiesPerGlview {
                        checkAndDrawText(&glview.citiesExtAl, UtilityCitiesExtended.cities[$0].latitude,
                                         UtilityCitiesExtended.cities[$0].longitude, UtilityCitiesExtended.cities[$0].name, GeographyType.cities.color)
                    }
                }
            }
        }
    }

    func checkAndDrawText(_ tvList:inout [TextView], _ lat: Double, _ lon: Double, _ text: String, _ color: Int) {
        tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(lat, lon, OGLR.pn)
        let xPos = tmpCoords.0 * OGLR.zoom - xFudge + Double(OGLR.x)
        let yPos = tmpCoords.1 * OGLR.zoom - yFudge - Double(OGLR.y)
        // FIXME prevent from obscuring bottom toolbar:  && abs(y * scale * 2) > (glviewHeight - Double(MyApplication.toolbarHeight))
        if abs(xPos) * scale * 2 < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
            tvList.append(TextView(context))
            let ii = tvList.count - 1
            tvList[ii].textColor = color
            tvList[ii].textSize = textSize
            tvList[ii].setPadding(CGFloat(glviewWidth/2) + CGFloat(xPos * scale), CGFloat(glviewHeight/2) + CGFloat(yPos * scale))
            tvList[ii].setText(text)
        }
    }

    func initTVCitiesExt() {
        if numPanes == 1 {
            if GeographyType.cities.display {
                cityextTvArrInit = true
                UtilityCitiesExtended.populateArrays()
            }
        }
    }

    func initTVCountyLabels() {
        if GeographyType.countyLabels.display {
            UtilityCountyLabels.populateArrays()
            countyLabelsTvArrInit = true
        }
    }

    func addTVCountyLabels() {
        if GeographyType.countyLabels.display {
            glview.countyLabelsAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.00 {oglrZoom = OGLR.zoom * 0.8}
            textSize = oglrZoom * 0.75 * Double(RadarPreferences.radarTextSize)
            if OGLR.zoom > 1.50 {
                UtilityCountyLabels.countyName.indices.forEach {
                    checkAndDrawText(&glview.countyLabelsAl, UtilityCountyLabels.location[$0].lat,
                                     UtilityCountyLabels.location[$0].lon, UtilityCountyLabels.countyName[$0],
                                    GeographyType.countyLabels.color)
                }
            }
        }
    }

    func initTVSpottersLabels() {
        if RadarPreferences.radarSpottersLabel {
            spottersLabelsTvArrInit = true
        }
    }

    func addTVSpottersLabels() {
        if PolygonType.SPOTTER_LABELS.display {
            spotterLat = 0.0
            spotterLon = 0.0
            glview.spottersLabelAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {oglrZoom = OGLR.zoom * 0.8}
            textSize = oglrZoom * 0.75 * Double(RadarPreferences.radarTextSize)
            if OGLR.zoom > 0.5 {
                UtilitySpotter.spotterList.indices.forEach {
                    checkAndDrawText(&glview.spottersLabelAl, UtilitySpotter.spotterList[$0].latD,
                                     UtilitySpotter.spotterList[$0].lonD, " " + UtilitySpotter.spotterList[$0].lastName.replace("0FAV ", ""),
                                     PolygonType.SPOTTER_LABELS.color)
                }
            }
        }
    }

    func initTV() {
        if numPanes == 1 {initTVCitiesExt()}
        initTVCountyLabels()
        initTVSpottersLabels()
        initTVObs()
    }

    func addTV() {
        if numPanes == 1 {
            addTVCitiesExt()
            addTVCountyLabels()
            addTVObs()
            addTVSpottersLabels()
        }
    }

    func initTVObs() {
        if (PolygonType.OBS.display||PolygonType.WIND_BARB.display) && UtilityMetar.obsArr.count>0 {
            obsTvArrInit = true
        }
    }

    func addTVObs() {
        if PolygonType.OBS.display||PolygonType.WIND_BARB.display {
            obsExtZoom = Double(RadarPreferences.radarObsExtZoom)
            spotterLat = 0.0
            spotterLon = 0.0
            let fontScaleFactorObs = 0.65
            glview.obsAl = []
            var tmpArrObs = [String]()
            var tmpArrObsExt = [String]()
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {oglrZoom = OGLR.zoom * 0.8}
            textSize = oglrZoom * fontScaleFactorObs * Double(RadarPreferences.radarTextSize)
            if OGLR.zoom > 0.5 {
                UtilityMetar.obsArr.indices.forEach {
                    if $0 < UtilityMetar.obsArr.count && $0 < UtilityMetar.obsArrExt.count {
                        tmpArrObs = UtilityMetar.obsArr[$0].split(":")
                        tmpArrObsExt = UtilityMetar.obsArrExt[$0].split(":")
                        spotterLat = Double(tmpArrObs[0]) ?? 0.0
                        spotterLon = Double(tmpArrObs[1]) ?? 0.0
                        tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(spotterLat,
                                                                                   spotterLon * -1.0, OGLR.pn)
                        if true {
                            let xPos = tmpCoords.0 * OGLR.zoom - xFudge + Double(OGLR.x)
                            let yPos = tmpCoords.1 * OGLR.zoom - yFudge - Double(OGLR.y)
                            if abs(Double(xPos) * scale * 2 ) < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
                                if OGLR.zoom > obsExtZoom {
                                    glview.obsAl.append(TextView(context, 150, 150))
                                } else {
                                    glview.obsAl.append(TextView(context))
                                }
                                let ii = glview.obsAl.count-1
                                glview.obsAl[ii].textColor = RadarGeometry.radarColorObs
                                glview.obsAl[ii].textSize = textSize
                                glview.obsAl[ii].setPadding(CGFloat(glviewWidth / 2)
                                    + CGFloat(xPos * scale), CGFloat(glviewHeight / 2) + CGFloat(yPos * scale))
                                if OGLR.zoom > obsExtZoom {
                                    glview.obsAl[ii].setText(tmpArrObsExt[2])
                                } else if PolygonType.OBS.display {
                                    glview.obsAl[ii].setText(tmpArrObs[2])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
