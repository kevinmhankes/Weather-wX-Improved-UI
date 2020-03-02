/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageAndText {
    
    let uiv: UIwXViewController
    
    init(
        _ uiv: UIwXViewController,
        _ bitmap: Bitmap,
        _ objectTextView: inout ObjectTextView,
        _ html: String
    ) {
        self.uiv = uiv
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
                UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked)),
                widthDivider: 2
            )
        } else {
            objectImage = ObjectImage(
                uiv.stackView,
                bitmap,
                UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked))
            )
        }
        objectImage.img.accessibilityLabel = html
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        if tabletInLandscape {
            objectTextView = ObjectTextView(uiv.stackView, html, widthDivider: 2)
        } else {
            objectTextView = ObjectTextView(uiv.stackView, html)
        }
        objectTextView.tv.isAccessibilityElement = true
        views.append(objectTextView.tv)
        //self.view.bringSubviewToFront(self.toolbar)
        uiv.scrollView.accessibilityElements = views
    }
    
    @objc func imageClicked() {}
}
