/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import GLKit

final class WXGLSurfaceView {

    var citiesExtAl = [TextView]()
    var countyLabelsAl = [TextView]()
    var obsAl = [TextView]()
    var spottersLabelAl = [TextView]()

    static func singleTap(_ uiv: GLKViewController,
                          _ oglrArr: [WXGLRender],
                          _ textObj: WXGLTextObject,
                          _ gestureRecognizer: UITapGestureRecognizer) {
        if RadarPreferences.dualpaneshareposn {
            oglrArr.forEach {
                $0.setView(0.5)
                $0.setZoom()
            }
        } else {
            let radarIndex = gestureRecognizer.view!.tag
            oglrArr[radarIndex].setView(0.5)
            oglrArr[radarIndex].setZoom()
        }
        uiv.view.setNeedsDisplay()
        uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        textObj.addTV()
    }

    static func doubleTap(_ uiv: GLKViewController,
                          _ oglrArr: [WXGLRender],
                          _ textObj: WXGLTextObject,
                          _ numberOfPanes: Int,
                          _ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: uiv.view)
        let bounds = UtilityUI.getScreenBounds()
        let scaleFactor: Float = 2.0
        let fudgeFactor: Float = -(1024.0 / bounds.0)
        if RadarPreferences.dualpaneshareposn {
            oglrArr.forEach {
                let xMiddle = Float(uiv.view.frame.width / 2.0)
                let yMiddle = Float(uiv.view.frame.height / 2.0)
                if numberOfPanes == 1 {
                    $0.setViewInitial($0.zoom * Double(scaleFactor),
                                      scaleFactor * $0.x + (Float(location.x) - xMiddle) * fudgeFactor,
                                      (scaleFactor * $0.y + (yMiddle - Float(location.y)) * fudgeFactor))
                } else {
                    $0.setView(Double(scaleFactor))
                }
                $0.setZoom()
            }
        } else {
            if let radarIndex = gestureRecognizer.view?.tag {
                let xMiddle = Float(uiv.view.frame.width / 2.0)
                let yMiddle = Float(uiv.view.frame.height / 2.0)
                if numberOfPanes == 1 {
                    oglrArr[radarIndex].setViewInitial(oglrArr[radarIndex].zoom * Double(scaleFactor),
                                                       oglrArr[radarIndex].x * scaleFactor
                                                        + (Float(location.x) - xMiddle) * fudgeFactor,
                                                       oglrArr[radarIndex].y * scaleFactor
                                                        + (yMiddle - Float(location.y)) * fudgeFactor)
                } else {
                    oglrArr[radarIndex].setView(Double(scaleFactor))
                }
                oglrArr[radarIndex].setZoom()
            }
        }
        uiv.view.setNeedsDisplay()
        uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        textObj.addTV()
    }

    static func gesturePan(_ uiv: GLKViewController,
                           _ oglrArr: [WXGLRender],
                           _ textObj: WXGLTextObject,
                           _ gestureRecognizer: UIPanGestureRecognizer) {
        if RadarPreferences.dualpaneshareposn {
            let translation = gestureRecognizer.translation(in: uiv.view)
            oglrArr.forEach {
                $0.setView($0.x + Float(translation.x), $0.y - Float(translation.y))
                $0.gl.setNeedsDisplay()
            }
        } else {
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            if let view = gestureRecognizer.view {
                oglrArr[view.tag].setView(oglrArr[view.tag].x + Float(translation.x),
                                          oglrArr[view.tag].y - Float(translation.y))
                oglrArr[view.tag].gl.setNeedsDisplay()
            }
        }
        uiv.view.setNeedsDisplay()
        gestureRecognizer.setTranslation(CGPoint.zero, in: uiv.view)
        switch gestureRecognizer.state {
        case .began: uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        case .ended: textObj.addTV()
        default: break
        }
    }

    static func gestureZoom(_ uiv: GLKViewController,
                            _ oglrArr: [WXGLRender],
                            _ textObj: WXGLTextObject,
                            _ gestureRecognizer: UIPinchGestureRecognizer) {
        if RadarPreferences.dualpaneshareposn {
            oglrArr.forEach {
                $0.oldZoom = $0.zoom
                $0.zoom = $0.zoom * Double(gestureRecognizer.scale)
                $0.x = Float(Double($0.x) * Double($0.zoom/$0.oldZoom))
                $0.y = Float(Double($0.y) * Double($0.zoom/$0.oldZoom))
                $0.setZoom()
            }
        } else {
            if let radarIndex = gestureRecognizer.view?.tag {
                oglrArr[radarIndex].oldZoom = oglrArr[radarIndex].zoom
                oglrArr[radarIndex].zoom = oglrArr[radarIndex].zoom * Double(gestureRecognizer.scale)
                oglrArr[radarIndex].x = Float(Double(oglrArr[radarIndex].x)
                    * Double(oglrArr[radarIndex].zoom/oglrArr[radarIndex].oldZoom))
                oglrArr[radarIndex].y = Float(Double(oglrArr[radarIndex].y)
                    * Double(oglrArr[radarIndex].zoom/oglrArr[radarIndex].oldZoom))
                oglrArr[radarIndex].setZoom()
            }
        }
        uiv.view.setNeedsDisplay()
        gestureRecognizer.scale = 1
        switch gestureRecognizer.state {
        case .began: uiv.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        case .ended: textObj.addTV()
        default: break
        }
    }

    static func gestureLongPress(_ uiv: GLKViewController,
                                 _ longPressCount: Int,
                                 _ fn: (CGFloat, CGFloat, Int) -> Void,
                                 _ gestureRecognizer: UILongPressGestureRecognizer) -> Int {
        let location = gestureRecognizer.location(in: uiv.view)
        var longPressCountLocal = longPressCount
        if let radarIndex = gestureRecognizer.view?.tag {
            longPressCountLocal += 1
            if longPressCountLocal % 2 != 0 {fn(location.x, location.y, radarIndex)}
        }
        return longPressCountLocal
    }
}
