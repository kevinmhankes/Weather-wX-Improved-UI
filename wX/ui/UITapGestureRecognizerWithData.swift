/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UITapGestureRecognizerWithData: UITapGestureRecognizer {

    var data = 0
    var strData = ""

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    init(strData: String, target: Any?, action: Selector?) {
        self.strData = strData
        super.init(target: target, action: action)
    }

    init(data: Int, strData: String, target: Any?, action: Selector?) {
        self.data = data
        self.strData = strData
        super.init(target: target, action: action)
    }

    init(data: Int, target: Any?, action: Selector?) {
        self.data = data
        super.init(target: target, action: action)
    }
}
