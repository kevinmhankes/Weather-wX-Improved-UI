/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

let panSensivity: Float = 300.0

final class WXMetalSurfaceView {

    static func setModifiedZoom(_ newZoom: Float, _ oldZoom: Float, _ wxMetal: WXMetalRender) {
        let zoomDifference = newZoom / oldZoom
        wxMetal.xPos = wxMetal.xPos * zoomDifference
        wxMetal.yPos = wxMetal.yPos * zoomDifference
    }

    static func gesturePan(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == UIGestureRecognizerState.changed {
            let pointInView = panGesture.location(in: uiv.view)
            let xDelta = Float((wxMetal.lastPanLocation.x - pointInView.x)/uiv.view.bounds.width) * panSensivity
            let yDelta = Float((wxMetal.lastPanLocation.y - pointInView.y)/uiv.view.bounds.height) * panSensivity
            wxMetal.xPos -= xDelta
            wxMetal.yPos += yDelta
            wxMetal.lastPanLocation = pointInView
        } else if panGesture.state == UIGestureRecognizerState.began {
            wxMetal.lastPanLocation = panGesture.location(in: uiv.view)
        }
    }

    static func singleTap(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ gestureRecognizer: UITapGestureRecognizer) {
        //print(String(wxMetal.xPos) + " " + String(wxMetal.yPos) + " " + String(wxMetal.zoom))
        setModifiedZoom(wxMetal.zoom * 0.5, wxMetal.zoom, wxMetal)
        wxMetal.zoom *= 0.5
        wxMetal.setZoom()
        //print(String(wxMetal.xPos) + " " + String(wxMetal.yPos) + " " + String(wxMetal.zoom))
    }

    static func doubleTap(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ gestureRecognizer: UITapGestureRecognizer) {
        //print(String(wxMetal.xPos) + " " + String(wxMetal.yPos) + " " + String(wxMetal.zoom))
        let location = gestureRecognizer.location(in: uiv.view)
        let bounds = UtilityUI.getScreenBounds()
        let scaleFactor: Float = 2.0
        let fudgeFactor: Float = -(450.0 / bounds.0)

        let xMiddle = Float(uiv.view.frame.width/2.0)
        let yMiddle = Float(uiv.view.frame.height/2.0)

        wxMetal.xPos +=  (Float(location.x) - xMiddle) * fudgeFactor
        wxMetal.yPos +=  (yMiddle - Float(location.y)) * fudgeFactor

        setModifiedZoom(wxMetal.zoom * 2.0, wxMetal.zoom, wxMetal)
        wxMetal.zoom *= 2.0
        wxMetal.setZoom()
    }

    static func gestureLongPress(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ longPressCount: Int, _ fn: (CGFloat, CGFloat, Int) -> Void, _ gestureRecognizer: UILongPressGestureRecognizer) -> Int {
        let location = gestureRecognizer.location(in: uiv.view)
        var longPressCountLocal = longPressCount
        if let radarIndex = gestureRecognizer.view?.tag {
            longPressCountLocal += 1
            if longPressCountLocal % 2 != 0 {fn(location.x, location.y, radarIndex)}
        }
        return longPressCountLocal
    }

    static func gestureZoom(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ gestureRecognizer: UIPinchGestureRecognizer) {
        let slowItDown: Float = 1.0 // was 1.0
        let maxZoom: Float = 15.0
        let minZoom: Float = 0.03
        let fudge: Float = 0.01
        if gestureRecognizer.state == UIGestureRecognizerState.changed && wxMetal.zoom < maxZoom && wxMetal.zoom > minZoom {
            setModifiedZoom(wxMetal.zoom / ((1.0/Float(gestureRecognizer.scale)) * slowItDown), wxMetal.zoom, wxMetal)
            wxMetal.zoom /=  ((1.0/Float(gestureRecognizer.scale)) * slowItDown)
            if wxMetal.zoom < minZoom {
                setModifiedZoom(minZoom + fudge/10.0, wxMetal.zoom, wxMetal)
                wxMetal.zoom = minZoom + fudge/10.0
            }
            if wxMetal.zoom > maxZoom {
                setModifiedZoom(maxZoom - fudge, wxMetal.zoom, wxMetal)
                wxMetal.zoom = maxZoom - fudge
            }
        }
        wxMetal.setZoom()
    }
}
