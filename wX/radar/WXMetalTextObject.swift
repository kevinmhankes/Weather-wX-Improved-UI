/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class WXMetalTextObject {

    private var glview = WXMetalSurfaceView()
    var OGLR: WXMetalRender!
    private var numPanes = 0
    private var spotterLat = 0.0
    private var spotterLon = 0.0
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
    private var tmpCoords = (0.0, 0.0)
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

    func addTVCitiesExt() {
        if GeographyType.cities.display {
            glview.citiesExtAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.00 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > cityMinZoom {
                cityExtLength = UtilityCitiesExtended.cities.count
                (0..<cityExtLength).forEach {
                    if glview.citiesExtAl.count <= maxCitiesPerGlview {
                        checkAndDrawText(
                            &glview.citiesExtAl,
                            UtilityCitiesExtended.cities[$0].latitude,
                            UtilityCitiesExtended.cities[$0].longitude,
                            UtilityCitiesExtended.cities[$0].name,
                            GeographyType.cities.color
                        )
                    }
                }
            }
        }
    }

    func checkAndDrawText(_ tvList:inout [TextViewMetal], _ lat: Double, _ lon: Double, _ text: String, _ color: Int) {
        tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(lat, lon, OGLR.pn)
        // changing RID resets glviewWidth
        let xPos = tmpCoords.0 * Double(OGLR.zoom) - xFudge + Double(OGLR.xPos)
        let yPos = tmpCoords.1 * Double(OGLR.zoom) - yFudge - Double(OGLR.yPos)
        if abs(xPos) * scale * 2 < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
            tvList.append(TextViewMetal(context))
            let ii = tvList.count - 1
            tvList[ii].textColor = color
            tvList[ii].textSize = Double(textSize)
            tvList[ii].setPadding(
                CGFloat(glviewWidth / 2) + CGFloat(xPos * scale),
                CGFloat(glviewHeight / 2) + CGFloat(yPos * scale)
            )
            tvList[ii].setText(text)
        }
    }

    func initTVCitiesExt() {
        if numPanes == 1 {
            if GeographyType.cities.display {
                UtilityCitiesExtended.populateArrays()
            }
        }
    }

    func initTVCountyLabels() {
        if GeographyType.countyLabels.display {
            UtilityCountyLabels.populateArrays()
        }
    }

    func addTVCountyLabels() {
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

    func addTVSpottersLabels() {
        if PolygonType.SPOTTER_LABELS.display {
            spotterLat = 0.0
            spotterLon = 0.0
            glview.spottersLabelAl = []
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > 0.5 {
                UtilitySpotter.spotterList.indices.forEach {
                    checkAndDrawText(
                        &glview.spottersLabelAl,
                        UtilitySpotter.spotterList[$0].latD,
                        UtilitySpotter.spotterList[$0].lonD,
                        " " + UtilitySpotter.spotterList[$0].lastName.replace("0FAV ", ""),
                        PolygonType.SPOTTER_LABELS.color
                    )
                }
            }
        }
    }

    func initializeTextLabels() {
        if numPanes == 1 {
            initTVCitiesExt()
        }
        initTVCountyLabels()
    }

    func removeTextLabels() {
      context.view.subviews.forEach {
          if $0 is UITextView {
              $0.removeFromSuperview()
          }
      }
    }

    func refreshTextLabels() {
        removeTextLabels()
        addTextLabels()
    }

    func addTextLabels() {
        if numPanes == 1 && OGLR != nil {
            addTVCitiesExt()
            addTVCountyLabels()
            addTVObs()
            addTVSpottersLabels()
        }
    }

    // TODO use better method names, more verbose
    func addTVObs() {
        if PolygonType.OBS.display||PolygonType.WIND_BARB.display {
            obsExtZoom = Double(RadarPreferences.radarObsExtZoom)
            spotterLat = 0.0
            spotterLon = 0.0
            glview.obsAl = []
            var tmpArrObs = [String]()
            var tmpArrObsExt = [String]()
            oglrZoom = 1.0
            if OGLR.zoom < 1.0 {
                oglrZoom = OGLR.zoom * 0.8
            }
            if OGLR.zoom > obsMinZoom {
                UtilityMetar.obsArr.indices.forEach {
                    if $0 < UtilityMetar.obsArr.count && $0 < UtilityMetar.obsArrExt.count {
                        tmpArrObs = UtilityMetar.obsArr[$0].split(":")
                        tmpArrObsExt = UtilityMetar.obsArrExt[$0].split(":")
                        spotterLat = Double(tmpArrObs[0]) ?? 0.0
                        spotterLon = Double(tmpArrObs[1]) ?? 0.0
                        tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(
                            spotterLat,
                            spotterLon * -1.0,
                            OGLR.pn
                        )
                        if true {
                            let xPos = tmpCoords.0 * Double(OGLR.zoom) - xFudge + Double(OGLR.xPos)
                            let yPos = tmpCoords.1 * Double(OGLR.zoom) - yFudge - Double(OGLR.yPos)
                            if abs(Double(xPos) * scale * 2 ) < glviewWidth && abs(yPos * scale * 2) < glviewHeight {
                                if Double(OGLR.zoom) > obsExtZoom {
                                    glview.obsAl.append(TextViewMetal(context, 150, 150))
                                } else {
                                    glview.obsAl.append(TextViewMetal(context))
                                }
                                let ii = glview.obsAl.count - 1
                                glview.obsAl[ii].textColor = RadarGeometry.radarColorObs
                                glview.obsAl[ii].textSize = textSize
                                glview.obsAl[ii].setPadding(
                                    CGFloat(glviewWidth / 2) + CGFloat(xPos * scale),
                                    CGFloat(glviewHeight / 2) + CGFloat(yPos * scale)
                                )
                                if Double(OGLR.zoom) > obsExtZoom {
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
