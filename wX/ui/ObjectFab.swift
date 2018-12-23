/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectFab {
    
    let floaty = Floaty()
    
    init(_ uiv: UIViewController, _ action: Selector) {
        floaty.sticky = true
        floaty.buttonColor = AppColors.primaryBackgroundBlueUIColor
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: "ic_flash_on_24dp")!, 0.50)
        floaty.addGestureRecognizer(UITapGestureRecognizer(target: uiv, action: action))
    }
    
    /*@objc func radarClicked(sender: UITapGestureRecognizer) {
        print("hi")
    }*/
    
    var view: Floaty {
        return floaty
    }
}
