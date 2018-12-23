/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABMISC: ViewControllerTABPARENT {

    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floaty.buttonColor = AppColors.primaryBackgroundBlueUIColor
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: "ic_flash_on_24dp")!, 0.50)
        floaty.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.radarClicked(sender:)))
        )
        self.view.addSubview(floaty)
        objTileMatrix = ObjectImageTileMatrix(self, stackView, .misc)
    }
    
    @objc func radarClicked(sender: UITapGestureRecognizer) {
        UtilityActions.radarClicked(self)
    }
}
