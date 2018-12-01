/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class UtilityUI {

    class func getScreenScale() -> Float {return Float(UIScreen.main.scale)}

    class func getNativeScreenScale() -> Float {return Float(UIScreen.main.nativeScale)}

    class func getScreenBounds() -> (Float, Float) {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        return (Float(width), Float(height))
    }

    class func statusBarHeight() -> CGFloat {return UIApplication.shared.statusBarFrame.size.height}

    class func setupStackView (_ sV: UIStackView) {
        sV.axis = .vertical
        sV.spacing = 0
    }

    class func getVersion() -> String {
        var vers = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {vers = version}
        return vers
    }

    class func setImageAnchors(_ image: UIImageView, _ bitmap: Bitmap, _ width: CGFloat) {
        image.widthAnchor.constraint(equalToConstant: width).isActive = true
        image.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
    }

    class func setupStackViewForCard(_ sV: UIStackView) {
        sV.backgroundColor = UIColor.white
        sV.distribution = .fill
        sV.alignment = .top
        sV.axis = .vertical
        sV.spacing = 0
    }

    class func sideSwipe(_ sender: UISwipeGestureRecognizer, _ currentIndex: Int, _ imageList: [String]) -> Int {
        var productIndex = currentIndex
        if sender.direction == .left {
            if currentIndex==imageList.count - 1 {
                productIndex = 0
            } else {productIndex += 1}
        }
        if sender.direction == .right {
            if currentIndex==0 {
                productIndex = imageList.count - 1
            } else {productIndex -= 1}
        }
        return productIndex
    }
}
