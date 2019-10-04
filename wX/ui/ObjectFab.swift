/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectFab {

    let floaty = Floaty(frame: UIScreen.main.bounds, size: 56)

    init(_ uiv: UIViewController, _ action: Selector, imageString: String = "ic_flash_on_24dp") {
        floaty.sticky = true
        floaty.friendlyTap = false
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
        setColor()
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: imageString)!, 0.50)
        floaty.addGestureRecognizer(UITapGestureRecognizer(target: uiv, action: action))
    }
    
    func setColor() {
        floaty.buttonColor = AppColors.primaryColorFab
    }

    func resize() {
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
    }

    func setToTheLeft() {
        floaty.paddingX = 76.0
    }

    func close() {
        floaty.close()
    }

    var view: Floaty {
        return floaty
    }
}
