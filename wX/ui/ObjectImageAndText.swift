/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageAndText {

    //
    // Used in SPC Swo(below), SPC Fireoutlook, and WPC Excessive Rain image/text combo
    //

    init(_ uiv: UIwXViewControllerWithAudio, _ bitmap: Bitmap, _ html: String) {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape()
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = true
        #endif
        if tabletInLandscape {
            uiv.stackView.axis = .horizontal
            uiv.stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        let objectImage: ObjectImage
        if tabletInLandscape {
            objectImage = ObjectImage(
                uiv.stackView,
                bitmap,
                GestureData(0, uiv, #selector(imageClicked)),
                widthDivider: 2
            )
        } else {
            objectImage = ObjectImage(
                uiv.stackView,
                bitmap,
                GestureData(0, uiv, #selector(imageClicked))
            )
        }
        objectImage.accessibilityLabel = html
        objectImage.isAccessibilityElement = true
        views.append(objectImage.img)
        if tabletInLandscape {
            uiv.objectTextView = Text(uiv.stackView, html, widthDivider: 2)
        } else {
            uiv.objectTextView = Text(uiv.stackView, html)
        }
        uiv.objectTextView.isAccessibilityElement = true
        views.append(uiv.objectTextView.view)
        uiv.scrollView.accessibilityElements = views
    }

    // SPC SWO
    init(_ uiv: UIwXViewControllerWithAudio, _ bitmaps: [Bitmap], _ html: String) {
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 4
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 4
        #endif
        if bitmaps.count == 2 { imagesPerRow = 2 }
        bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: ObjectStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(.fillEqually, .horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView
                uiv.stackView.addLayout(stackView)
            } else {
                stackView = imageStackViewList.last!
            }
            _ = ObjectImage(
                    stackView,
                    image,
                    GestureData(imageIndex, uiv, #selector(imageClickedWithIndex)),
                    widthDivider: imagesPerRow)
            imageCount += 1
        }
        var views = [UIView]()
        uiv.objectTextView = Text(uiv.stackView, html)
        uiv.objectTextView.constrain(uiv.scrollView)
        uiv.objectTextView.isAccessibilityElement = true
        views.append(uiv.objectTextView.view)
        uiv.scrollView.accessibilityElements = views
    }

    @objc func imageClickedWithIndex(sender: GestureData) {}

    @objc func imageClicked() {}
}
