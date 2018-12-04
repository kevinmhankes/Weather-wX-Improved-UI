/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

let panSensivity: Float = 300.0

final class WXMetalSurfaceView {
    
    var citiesExtAl = [TextViewMetal]()
    var countyLabelsAl = [TextViewMetal]()
    var obsAl = [TextViewMetal]()
    var spottersLabelAl = [TextViewMetal]()

    static func setModifiedZoom(_ newZoom: Float, _ oldZoom: Float, _ wxMetal: WXMetalRender) {
        let zoomDifference = newZoom / oldZoom
        wxMetal.xPos = wxMetal.xPos * zoomDifference
        wxMetal.yPos = wxMetal.yPos * zoomDifference
    }

    // fixme
    static func gesturePan(_ uiv: UIViewController, _ wxMetal: [WXMetalRender?], _ textObj: WXMetalTextObject, _ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.changed {
            let pointInView = gestureRecognizer.location(in: uiv.view)
            let xDelta = Float((wxMetal[0]!.lastPanLocation.x - pointInView.x)/uiv.view.bounds.width) * panSensivity
            let yDelta = Float((wxMetal[0]!.lastPanLocation.y - pointInView.y)/uiv.view.bounds.height) * panSensivity
            wxMetal[0]!.xPos -= xDelta
            wxMetal[0]!.yPos += yDelta
            wxMetal[0]!.lastPanLocation = pointInView
        } else if gestureRecognizer.state == UIGestureRecognizerState.began {
            wxMetal[0]!.lastPanLocation = gestureRecognizer.location(in: uiv.view)
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: uiv.view)
        switch gestureRecognizer.state {
        case .began: uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        case .ended: textObj.addTV()
        default: break
        }
    }
    
    // bottom left 0,600
    // bottom right 350,600
    // top left 0,0
    // top right 350,0
    
    static func tapInPane(_ location: CGPoint, _ uiv: UIViewController, _ wxMetal: WXMetalRender) -> Int {
        if wxMetal.numberOfPanes == 1 {
            return 0
        } else if wxMetal.numberOfPanes == 2 {
            if location.y < uiv.view.frame.height/2.0 {
                return 0
            } else {
                return 1
            }
        } else { // 4 pane
            if location.y < uiv.view.frame.height/2.0 {
                if location.x < uiv.view.frame.width/2.0 {
                    return 0  // top left
                } else {
                    return 1  // top right
                }
            } else {
                if location.x < uiv.view.frame.width/2.0 {
                    return 2  // bottom left
                } else {
                    return 3  // bottom right
                }
            }
        }
    }

    static func singleTap(_ uiv: UIViewController, _ wxMetal: [WXMetalRender?], _ textObj: WXMetalTextObject, _ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        print(radarIndex)
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                setModifiedZoom($0!.zoom * 0.5, $0!.zoom, $0!)
                $0!.zoom *= 0.5
                $0!.setZoom()
            }
        } else {
            //let radarIndex = gestureRecognizer.view!.tag
            setModifiedZoom(wxMetal[radarIndex]!.zoom * 0.5, wxMetal[radarIndex]!.zoom, wxMetal[radarIndex]!)
            wxMetal[radarIndex]!.zoom *= 0.5
            wxMetal[radarIndex]!.setZoom()
        }
        uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        textObj.addTV()
        //print(location.x)
        //print(location.y)
        //print(String(wxMetal[0]!.zoom) + " " + String(wxMetal[1]!.zoom))
    }

    static func doubleTap(_ uiv: UIViewController, _ wxMetal: [WXMetalRender?], _ textObj: WXMetalTextObject, _ gestureRecognizer: UITapGestureRecognizer) {
        //print(String(wxMetal.xPos) + " " + String(wxMetal.yPos) + " " + String(wxMetal.zoom))
        let location = gestureRecognizer.location(in: uiv.view)
        let bounds = UtilityUI.getScreenBounds()
        let scaleFactor: Float = 2.0
        let fudgeFactor: Float = -(450.0 / bounds.0)

        let xMiddle = Float(uiv.view.frame.width/2.0)
        let yMiddle = Float(uiv.view.frame.height/2.0)

        wxMetal.forEach { $0!.xPos +=  (Float(location.x) - xMiddle) * fudgeFactor }
        wxMetal.forEach { $0!.yPos +=  (yMiddle - Float(location.y)) * fudgeFactor }

        //setModifiedZoom(wxMetal.zoom * 2.0, wxMetal.zoom, wxMetal)
        wxMetal.forEach { setModifiedZoom($0!.zoom * 2.0, $0!.zoom, $0!)}
        wxMetal.forEach { $0!.zoom *= 2.0 }
        wxMetal.forEach { $0!.setZoom() }
        uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        textObj.addTV()
    }

    static func gestureLongPress(_ uiv: UIViewController, _ wxMetal: [WXMetalRender?], _ textObj: WXMetalTextObject, _ longPressCount: Int, _ fn: (CGFloat, CGFloat, Int) -> Void, _ gestureRecognizer: UILongPressGestureRecognizer) -> Int {
        let location = gestureRecognizer.location(in: uiv.view)
        var longPressCountLocal = longPressCount
        if let radarIndex = gestureRecognizer.view?.tag {
            longPressCountLocal += 1
            if longPressCountLocal % 2 != 0 {fn(location.x, location.y, radarIndex)}
        }
        return longPressCountLocal
    }

    // fixme
    static func gestureZoom(_ uiv: UIViewController, _ wxMetal: [WXMetalRender?], _ textObj: WXMetalTextObject, _ gestureRecognizer: UIPinchGestureRecognizer) {
        let slowItDown: Float = 1.0 // was 1.0
        let maxZoom: Float = 15.0
        let minZoom: Float = 0.03
        let fudge: Float = 0.01
        if gestureRecognizer.state == UIGestureRecognizerState.changed && wxMetal[0]!.zoom < maxZoom && wxMetal[0]!.zoom > minZoom {
            // setModifiedZoom(wxMetal.zoom / ((1.0/Float(gestureRecognizer.scale)) * slowItDown), wxMetal.zoom, wxMetal)
            wxMetal.forEach { setModifiedZoom($0!.zoom / ((1.0/Float(gestureRecognizer.scale)) * slowItDown), $0!.zoom, $0!)}
            wxMetal[0]!.zoom /=  ((1.0/Float(gestureRecognizer.scale)) * slowItDown)
            if wxMetal[0]!.zoom < minZoom {
                //setModifiedZoom(minZoom + fudge/10.0, wxMetal.zoom, wxMetal)
                wxMetal.forEach { setModifiedZoom(minZoom + fudge/10.0, $0!.zoom, $0!)}
                wxMetal[0]!.zoom = minZoom + fudge/10.0
            }
            if wxMetal[0]!.zoom > maxZoom {
                //setModifiedZoom(maxZoom - fudge, wxMetal.zoom, wxMetal)
                wxMetal.forEach { setModifiedZoom(maxZoom - fudge, $0!.zoom, $0!)}
                wxMetal[0]!.zoom = maxZoom - fudge
            }
        }
        wxMetal.forEach { $0!.setZoom() }
        gestureRecognizer.scale = 1
        switch gestureRecognizer.state {
        case .began: uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        case .ended: textObj.addTV()
        default: break
        }
    }
}
