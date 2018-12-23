/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABMISC: ViewControllerTABPARENT {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(ObjectFab(self, #selector(radarClicked(sender:))).view)
        objTileMatrix = ObjectImageTileMatrix(self, stackView, .misc)
    }
    
    @objc func radarClicked(sender: UITapGestureRecognizer) {
        UtilityActions.radarClicked(self)
    }
}
