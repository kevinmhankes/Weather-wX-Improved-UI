/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageSummary {
    
    //
    // To be used in image based summary for SPC SWO, SPC Tstorm, SPC Fire Outlook, WPC Excessive Rain
    //
    
    init(_ uiv: UIwXViewController, _ bitmaps: [Bitmap], imagersPerRowWide: Int = 3) {
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() {
            imagesPerRow = imagersPerRowWide
        }
        bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: UIStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView.view
                uiv.stackView.addArrangedSubview(stackView)
            } else {
                stackView = imageStackViewList.last!.view
            }
            _ = ObjectImage(
                stackView,
                image,
                UITapGestureRecognizerWithData(imageIndex, uiv, #selector(imageClicked(sender:))),
                widthDivider: imagesPerRow
            )
            imageCount += 1
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {}
}
