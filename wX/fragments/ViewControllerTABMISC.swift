/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABMISC: ViewControllerTABPARENT {

    override func viewDidLoad() {
        super.viewDidLoad()
        objTileMatrix = ObjectImageTileMatrix(self, stackView, .misc)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                } else {
                    AppColors.update()
                }
                updateColors()
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override func updateColors() {
        objTileMatrix.toolbar.setColorToTheme()
        super.updateColors()
    }
}
