/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class WXMetalSurfaceView {

    var citiesExtAl = [TextViewMetal]()
    var countyLabelsAl = [TextViewMetal]()
    var obsAl = [TextViewMetal]()
    var spottersLabelAl = [TextViewMetal]()
    var pressureCenterLabelAl = [TextViewMetal]()
    static private let maxZoom: Float = 45.0
    static private let minZoom: Float = 0.03

    static func setModifiedZoom(
        _ newZoom: Float,
        _ oldZoom: Float,
        _ wxMetal: WXMetalRender
    ) {
        let zoomDifference = newZoom / oldZoom
        wxMetal.xPos *= zoomDifference
        wxMetal.yPos *= zoomDifference
    }

    static func gesturePan(
        _ uiv: UIViewController,
        _ wxMetal: [WXMetalRender?],
        _ textObj: WXMetalTextObject,
        _ gestureRecognizer: UIPanGestureRecognizer
    ) {
        var panSensivity: Float = 500.0
        if wxMetal[0]!.numberOfPanes == 4 {
            panSensivity *= 2
        }
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if gestureRecognizer.state == UIGestureRecognizer.State.changed {
                    let pointInView = gestureRecognizer.location(in: uiv.view)
                    let xDelta = Float(($0!.lastPanLocation.x - pointInView.x) / uiv.view.bounds.width) * panSensivity
                    let yDelta = Float(($0!.lastPanLocation.y - pointInView.y) / uiv.view.bounds.height) * panSensivity
                    $0!.xPos -= xDelta
                    $0!.yPos += yDelta
                    $0!.lastPanLocation = pointInView
                } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
                    $0!.lastPanLocation = gestureRecognizer.location(in: uiv.view)
                }
            }
        } else {
            if gestureRecognizer.state == UIGestureRecognizer.State.changed {
                let pointInView = gestureRecognizer.location(in: uiv.view)
                let xDelta = Float((wxMetal[radarIndex]!.lastPanLocation.x
                    - pointInView.x) / uiv.view.bounds.width) * panSensivity
                let yDelta = Float((wxMetal[radarIndex]!.lastPanLocation.y
                    - pointInView.y) / uiv.view.bounds.height) * panSensivity
                wxMetal[radarIndex]!.xPos -= xDelta
                wxMetal[radarIndex]!.yPos += yDelta
                wxMetal[radarIndex]!.lastPanLocation = pointInView
            } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
                wxMetal[radarIndex]!.lastPanLocation = gestureRecognizer.location(in: uiv.view)
            }
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: uiv.view)
        switch gestureRecognizer.state {
        case .began:
            textObj.removeTextLabels()
            wxMetal.forEach {$0!.displayHold = true}
        case .ended:
            textObj.addTextLabels()
            wxMetal.forEach {$0!.displayHold = false}
        default:
            break
        }
        wxMetal.forEach {$0!.demandRender()}
    }

    // bottom left 0,600
    // bottom right 350,600
    // top left 0,0
    // top right 350,0

    static func tapInPane(_ location: CGPoint, _ uiv: UIViewController, _ wxMetal: WXMetalRender) -> Int {
        if wxMetal.numberOfPanes == 1 {
            return 0
        } else if wxMetal.numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                if location.y < uiv.view.frame.height / 2.0 {
                    return 0
                } else {
                    return 1
                }
            } else {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 0
                } else {
                    return 1
                }
            }
        } else { // 4 pane
            if location.y < uiv.view.frame.height / 2.0 {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 0  // top left
                } else {
                    return 1  // top right
                }
            } else {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 2  // bottom left
                } else {
                    return 3  // bottom right
                }
            }
        }
    }

    static func singleTap(
        _ uiv: UIViewController,
        _ wxMetal: [WXMetalRender?],
        _ textObj: WXMetalTextObject,
        _ gestureRecognizer: UITapGestureRecognizer
    ) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if $0!.zoom * 0.5 > minZoom {
                    setModifiedZoom($0!.zoom * 0.5, $0!.zoom, $0!)
                    $0!.zoom *= 0.5
                    $0!.setZoom()
                }
            }
        } else {
            if wxMetal[radarIndex]!.zoom * 0.5 > minZoom {
                setModifiedZoom(wxMetal[radarIndex]!.zoom * 0.5, wxMetal[radarIndex]!.zoom, wxMetal[radarIndex]!)
                wxMetal[radarIndex]!.zoom *= 0.5
                wxMetal[radarIndex]!.setZoom()
            }
        }
        textObj.refreshTextLabels()
    }

    static func doubleTap(
        _ uiv: UIViewController,
        _ wxMetal: [WXMetalRender?],
        _ textObj: WXMetalTextObject,
        _ numberOfPanes: Int,
        _ ortInt: Float,
        _ gestureRecognizer: UITapGestureRecognizer
    ) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        let bounds = UtilityUI.getScreenBoundsNoCatalyst()
        var width = Float(uiv.view.bounds.size.width)
        var density: Float = -(width / bounds.0)
        #if targetEnvironment(macCatalyst)
        let boundsOrig = UtilityUI.getScreenBounds()
        width = boundsOrig.0
        density *= 0.25
        #endif
        if numberOfPanes == 4 {
            density *= 2.0
        }
        density /= Float(UIScreen.main.scale)
        var xMiddle = Float(uiv.view.frame.width / 2.0)
        var yMiddle = Float(uiv.view.frame.height / 2.0)
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() {
                if radarIndex == 0 {
                    yMiddle *= 0.5
                } else {
                    yMiddle *= 1.5
                }
            } else {
                if radarIndex == 0 {
                    xMiddle *= 0.5
                } else {
                    xMiddle *= 1.5
                }
            }
        }
        if numberOfPanes == 4 {
            if radarIndex == 0 {
                xMiddle *= 0.5
                yMiddle *= 0.5
            } else if radarIndex == 1 {
                xMiddle *= 1.5
                yMiddle *= 0.5
            } else if radarIndex == 2 {
                xMiddle *= 0.5
                yMiddle *= 1.5
            } else if radarIndex == 3 {
                xMiddle *= 1.5
                yMiddle *= 1.5
            }
        }
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if $0!.zoom * 2.0 < maxZoom {
                    $0!.xPos +=  ((Float(location.x) - xMiddle) * density)
                    $0!.yPos +=  ((yMiddle - Float(location.y)) * density)
                    setModifiedZoom($0!.zoom * 2.0, $0!.zoom, $0!)
                    $0!.zoom *= 2.0
                    $0!.setZoom()
                }
            }
        } else {
            if wxMetal[radarIndex]!.zoom * 2.0 < maxZoom {
                wxMetal[radarIndex]!.xPos += (Float(location.x) - xMiddle) * density
                wxMetal[radarIndex]!.yPos += (yMiddle - Float(location.y)) * density
                setModifiedZoom(wxMetal[radarIndex]!.zoom * 2.0, wxMetal[radarIndex]!.zoom, wxMetal[radarIndex]!)
                wxMetal[radarIndex]!.zoom *= 2.0
                wxMetal[radarIndex]!.setZoom()
            }
        }
        textObj.refreshTextLabels()
    }

    static func gestureLongPress(
        _ uiv: UIViewController,
        _ wxMetal: [WXMetalRender?],
        _ textObj: WXMetalTextObject,
        _ longPressCount: Int,
        _ fn: (CGFloat, CGFloat, Int) -> Void,
        _ gestureRecognizer: UILongPressGestureRecognizer
    ) -> Int {
        let location = gestureRecognizer.location(in: uiv.view)
        var longPressCountLocal = longPressCount
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        longPressCountLocal += 1
        if longPressCountLocal % 2 != 0 {
            fn(location.x, location.y, radarIndex)
        }
        return longPressCountLocal
    }

    static func gestureZoom(
        _ uiv: UIViewController,
        _ wxMetal: [WXMetalRender?],
        _ textObj: WXMetalTextObject,
        _ gestureRecognizer: UIPinchGestureRecognizer
    ) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        let slowItDown: Float = 1.0
        let fudge: Float = 0.01
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if gestureRecognizer.state == UIGestureRecognizer.State.changed
                    && $0!.zoom < maxZoom
                    && $0!.zoom > minZoom {
                    setModifiedZoom($0!.zoom / ((1.0 / Float(gestureRecognizer.scale)) * slowItDown), $0!.zoom, $0!)
                    $0!.zoom /=  ((1.0 / Float(gestureRecognizer.scale)) * slowItDown)
                    if $0!.zoom < minZoom {
                        setModifiedZoom(minZoom + fudge / 10.0, $0!.zoom, $0!)
                        $0!.zoom = minZoom + fudge / 10.0
                    }
                    if $0!.zoom > maxZoom {
                        setModifiedZoom(maxZoom - fudge, $0!.zoom, $0!)
                        $0!.zoom = maxZoom - fudge
                    }
                }
                $0!.setZoom()
            }
        } else {
            if gestureRecognizer.state == UIGestureRecognizer.State.changed
                && wxMetal[radarIndex]!.zoom < maxZoom
                && wxMetal[radarIndex]!.zoom > minZoom {
                setModifiedZoom(
                    wxMetal[radarIndex]!.zoom / ((1.0 / Float(gestureRecognizer.scale)) * slowItDown),
                    wxMetal[radarIndex]!.zoom,
                    wxMetal[radarIndex]!
                )
                wxMetal[radarIndex]!.zoom /=  ((1.0 / Float(gestureRecognizer.scale)) * slowItDown)
                if wxMetal[radarIndex]!.zoom < minZoom {
                    setModifiedZoom(minZoom + fudge / 10.0, wxMetal[radarIndex]!.zoom, wxMetal[radarIndex]!)
                    wxMetal[radarIndex]!.zoom = minZoom + fudge / 10.0
                }
                if wxMetal[radarIndex]!.zoom > maxZoom {
                    setModifiedZoom(maxZoom - fudge, wxMetal[radarIndex]!.zoom, wxMetal[radarIndex]!)
                    wxMetal[radarIndex]!.zoom = maxZoom - fudge
                }
            }
            wxMetal[radarIndex]!.setZoom()
        }
        gestureRecognizer.scale = 1
        switch gestureRecognizer.state {
        case .began:
            textObj.removeTextLabels()
            wxMetal.forEach {$0!.displayHold = true}
        case .ended:
            textObj.addTextLabels()
            wxMetal.forEach {$0!.displayHold = false}
        default:
            break
        }
        wxMetal.forEach {$0!.demandRender()}
    }
}
