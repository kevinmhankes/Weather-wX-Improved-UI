/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectFab {

    private let floaty = Floaty(frame: UIScreen.main.bounds, size: 56)
    let positionLeft: CGFloat = 76.0

    init(_ uiv: UIViewController, _ action: Selector) {
        floaty.sticky = true
        floaty.friendlyTap = false
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
        floaty.buttonColor = AppColors.primaryColorFab
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: "ic_flash_on_24dp")!, 0.50)
        floaty.addGestureRecognizer(UITapGestureRecognizer(target: uiv, action: action))
    }

    convenience init (_ uiv: UIViewController, _ imageString: String, _ action: Selector) {
        self.init(uiv, action)
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: imageString)!, 0.50)
    }

    func resize() {
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
    }

    func setToTheLeft() {
        floaty.paddingX = positionLeft
    }

    func close() {
        floaty.close()
    }

    var view: Floaty {
        return floaty
    }
}
