/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABSPC: ViewControllerTABPARENT {

    override func viewDidLoad() {
        super.viewDidLoad()
        objTileMatrix = ObjectImageTileMatrix(self, stackView, .spc)
    }
}
