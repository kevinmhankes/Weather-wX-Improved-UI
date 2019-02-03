/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class AppColors {

    static var primaryColorRed = 46.toColor()
    static var primaryColorGreen = 63.toColor()
    static var primaryColorBlue = 89.toColor()
    static var toolbarTextColor = UIColor.white
    static var primaryColorUIColor = UIColor(
        red: primaryColorRed,
        green: primaryColorGreen,
        blue: primaryColorBlue,
        alpha: CGFloat(1.0)
    )
    static var primaryDarkBlueUIColor = wXColor.uiColorInt(0, 17, 43)
    static var primaryBackgroundBlueUIColor = wXColor.uiColorInt(19, 36, 62)
    static var primaryColorFab = wXColor.uiColorInt(88, 121, 169)

    static func update() {
        let appColor = Utility.readPref("UI_THEME", "blue")
        switch appColor {
        case "black":
            primaryColorRed = 30.toColor()
            primaryColorGreen = 30.toColor()
            primaryColorBlue = 30.toColor()
            primaryColorUIColor =  wXColor.uiColorFloat(
                primaryColorRed,
                primaryColorGreen,
                primaryColorBlue
            )
            primaryDarkBlueUIColor = wXColor.uiColorInt(0, 0, 0)
            primaryBackgroundBlueUIColor = wXColor.uiColorInt(0, 0, 0)
            primaryColorFab = wXColor.uiColorInt(100, 100, 100)
        case "green":
            primaryColorRed = 0.toColor()
            primaryColorGreen = 71.toColor()
            primaryColorBlue = 6.toColor()
            primaryColorUIColor =  wXColor.uiColorFloat(
                primaryColorRed,
                primaryColorGreen,
                primaryColorBlue
            )
            primaryDarkBlueUIColor = wXColor.uiColorInt(0, 46, 4)
            primaryBackgroundBlueUIColor = wXColor.uiColorInt(0, 46, 4)
            primaryColorFab = wXColor.uiColorInt(70, 175, 70)
        default:
            primaryColorRed = 46.toColor()
            primaryColorGreen = 63.toColor()
            primaryColorBlue = 89.toColor()
            primaryColorUIColor =  wXColor.uiColorFloat(
                primaryColorRed,
                primaryColorGreen,
                primaryColorBlue
            )
            primaryDarkBlueUIColor = wXColor.uiColorInt(0, 17, 43)
            primaryBackgroundBlueUIColor = wXColor.uiColorInt(19, 36, 62)
            primaryColorFab = wXColor.uiColorInt(88, 121, 169)
        }
    }
}
