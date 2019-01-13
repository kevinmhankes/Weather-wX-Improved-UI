/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class UtilityUI {

    class func getScreenScale() -> Float {
        return Float(UIScreen.main.scale)
    }

    class func getNativeScreenScale() -> Float {
        return Float(UIScreen.main.nativeScale)
    }

    class func getScreenBounds() -> (Float, Float) {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        return (Float(width), Float(height))
    }

    class func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    class func getVersion() -> String {
        var vers = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            vers = version
        }
        return vers
    }

    class func sideSwipe(_ sender: UISwipeGestureRecognizer, _ currentIndex: Int, _ imageList: [String]) -> Int {
        var productIndex = currentIndex
        if sender.direction == .left {
            if currentIndex == imageList.count - 1 {
                productIndex = 0
            } else {
                productIndex += 1
            }
        }
        if sender.direction == .right {
            if currentIndex == 0 {
                productIndex = imageList.count - 1
            } else {
                productIndex -= 1
            }
        }
        return productIndex
    }
}
