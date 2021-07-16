/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageSummary {
    
    //
    // To be used in image based summary for SPC SWO, SPC Tstorm, SPC Fire Outlook, WPC Excessive Rain
    //
    var objectImages = [ObjectImage]()
    var imageStackViewList = [ObjectStackView]()

    init(_ uiv: UIwXViewController, _ bitmaps: [Bitmap], imagesPerRowWide: Int = 3) {
        var imageCount = 0
        var imagesPerRow = 2
        imageStackViewList.removeAll()
        objectImages.removeAll()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = imagesPerRowWide
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = imagesPerRowWide
        #endif
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
            objectImages.append(ObjectImage(
                    stackView,
                    image,
                    UITapGestureRecognizerWithData(imageIndex, uiv, #selector(imageClicked(sender:))),
                    widthDivider: imagesPerRow
            ))
            imageCount += 1
        }
    }
      
    //
    // NHC, add stack
    //
    init(_ uiv: UIwXViewController, _ parentBox: ObjectStackView, _ bitmaps: [Bitmap], imagesPerRowWide: Int = 3) {
        var imageCount = 0
        var imagesPerRow = 2
        imageStackViewList.removeAll()
        objectImages.removeAll()
        if UtilityUI.isTablet() { // && UtilityUI.isLandscape()
            imagesPerRow = imagesPerRowWide
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = imagesPerRowWide
        #endif
        bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: ObjectStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(.fillEqually, .horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView
                parentBox.addLayout(stackView)
            } else {
                stackView = imageStackViewList.last!
            }
            objectImages.append(ObjectImage(
                stackView.get(),
                image,
                UITapGestureRecognizerWithData(imageIndex, uiv, #selector(imageClicked(sender:))),
                widthDivider: imagesPerRow
            ))
            imageCount += 1
        }
    }
    
    func changeWidth() {
        for o in objectImages {
            o.changeWidth()
        }
    }
    
    func removeChildren() {
        for layout in imageStackViewList {
            layout.removeAllChildren()
//            layout.get().removeViews()
//            layout.get().removeFromSuperview()
        }
    }
    
    func setBitmap(_ index: Int, _ bitmap: Bitmap) {
        objectImages[index].setBitmap(bitmap)
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {}
}
