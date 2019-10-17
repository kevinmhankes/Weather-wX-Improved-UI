/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class UtilityUI {

    static func getScreenScale() -> Float {
        return Float(UIScreen.main.scale)
    }

    static func getNativeScreenScale() -> Float {
        return Float(UIScreen.main.nativeScale)
    }

    static func getScreenBoundsNoCatalyst() -> (Float, Float) {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        return (Float(width), Float(height))
    }

    static func getScreenBounds() -> (Float, Float) {
        let bounds = UIScreen.main.bounds
        var width = bounds.width
        var height = bounds.height
        #if targetEnvironment(macCatalyst)
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                if windowScene.windows.count > 0 {
                    width = windowScene.windows[0].bounds.width
                    height = windowScene.windows[0].bounds.height
                }
            }
        #endif
        return (Float(width), Float(height))
    }

    static func getScreenBoundsCGFloat() -> (CGFloat, CGFloat) {
        let bounds = UIScreen.main.bounds
        var width = bounds.width
        var height = bounds.height
        #if targetEnvironment(macCatalyst)
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                if windowScene.windows.count > 0 {
                    width = windowScene.windows[0].bounds.width
                    height = windowScene.windows[0].bounds.height
                }
            }
        #endif
        //print(height)
        return (width, height)
    }

    static func getScreenBoundsCGSize() -> CGSize {
        let bounds = UIScreen.main.bounds
        var width = bounds.width
        var height = bounds.height
        #if targetEnvironment(macCatalyst)
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                if windowScene.windows.count > 0 {
                    width = windowScene.windows[0].bounds.width
                    height = windowScene.windows[0].bounds.height
                }
            }
        #endif
        var cgsize = CGSize()
        cgsize.width = width
        cgsize.height = height
        return cgsize
    }

    static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    static func getVersion() -> String {
        var vers = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            vers = version
        }
        return vers
    }

    static func sideSwipe(_ sender: UISwipeGestureRecognizer, _ currentIndex: Int, _ imageList: [String]) -> Int {
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

    // https://developer.apple.com/documentation/uikit/uiview/2891103-safeareainsets
    // https://developer.apple.com/documentation/uikit/uiview/2891104-safeareainsetsdidchange
    // https://stackoverflow.com/questions/46317061/use-safe-area-layout-programmatically
    // https://stackoverflow.com/questions/46239960/extra-bottom-space-padding-on-iphone-x/46240554
    static func getBottomPadding() -> CGFloat {
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        }
        return bottomPadding
    }

    static func getTopPadding() -> CGFloat {
        var topPadding: CGFloat = UIPreferences.statusBarHeight
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? UIPreferences.statusBarHeight
        }
        return topPadding
    }

    static func effectiveHeight(_ toolbar: ObjectToolbar) -> CGFloat {
        let (_, height) = UtilityUI.getScreenBoundsCGFloat()
        return height - toolbar.height - UtilityUI.getTopPadding() - UtilityUI.getBottomPadding()
    }

    static func effectiveHeight(_ toolbar: UIToolbar) -> CGFloat {
        let (_, height) = UtilityUI.getScreenBoundsCGFloat()
        return height - toolbar.frame.height - UtilityUI.getTopPadding() - UtilityUI.getBottomPadding()
    }

    static func determineDeviceType() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            print("device type: iphone")
        case .pad:
            print("device type: ipad")
        case .unspecified:
            print("device type: unknown")
        default:
            print("device type: unknown")
        }
    }

    static func printBounds() {
        _ = UIScreen.main.nativeBounds   // 1125x2436
        _ = UIScreen.main.bounds         // 375x812
        //print(nativeBounds)
        //print(bounds)
    }

    static func isLandscape() -> Bool {
        var landscape = false
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            //print("Landscape Left")
            landscape = true
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            //print("Landscape Right")
            landscape = true
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            //print("Portrait Upside Down")
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            //print("Portrait")
        }
        return landscape
    }
}
