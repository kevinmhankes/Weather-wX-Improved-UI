/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

class GlobalVariables {
    static let flexBarButton = UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
        target: nil,
        action: nil
    )
    static let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    static let preferences = Preferences()
    static let editor = Editor()
    static let appName = "wXL23"
}
