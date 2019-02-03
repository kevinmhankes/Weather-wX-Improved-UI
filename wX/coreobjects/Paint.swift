/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class Paint {

    private var colorR8: UInt8 = 0
    private var colorG8: UInt8 = 0
    private var colorB8: UInt8 = 0

    func setColor(_ color: Int) {
        colorR8 = Color.red(color)
        colorG8 = Color.green(color)
        colorB8 = Color.blue(color)
    }

    var uicolor: UIColor {
        return UIColor(
            red: colorR8.toColor(),
            green: colorG8.toColor(),
            blue: colorB8.toColor(),
            alpha: CGFloat(1.0)
        )
    }
}
