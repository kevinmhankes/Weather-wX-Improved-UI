/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class AppColors {

    static var primaryColorRed = CGFloat(46.0/255.0)
    static var primaryColorGreen = CGFloat(63.0/255.0)
    static var primaryColorBlue = CGFloat(89.0/255.0)
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
        let appColor = preferences.getString("UI_THEME", "blue")
        switch appColor {
        case "black":
            primaryColorRed = CGFloat(30.0 / 255.0)
            primaryColorGreen = CGFloat(30.0 / 255.0)
            primaryColorBlue = CGFloat(30.0 / 255.0)
            primaryColorUIColor =  wXColor.uiColorFloat(
                primaryColorRed,
                primaryColorGreen,
                primaryColorBlue
            )
            primaryDarkBlueUIColor = wXColor.uiColorInt(0, 0, 0)
            primaryBackgroundBlueUIColor = wXColor.uiColorInt(0, 0, 0)
            primaryColorFab = wXColor.uiColorInt(100, 100, 100)
        case "green":
            primaryColorRed = CGFloat(0.0 / 255.0)
            primaryColorGreen = CGFloat(71.0 / 255.0)
            primaryColorBlue = CGFloat(6.0 / 255.0)
            primaryColorUIColor =  wXColor.uiColorFloat(
                primaryColorRed,
                primaryColorGreen,
                primaryColorBlue
            )
            primaryDarkBlueUIColor = wXColor.uiColorInt(0, 46, 4)
            primaryBackgroundBlueUIColor = wXColor.uiColorInt(0, 46, 4)
            primaryColorFab = wXColor.uiColorInt(70, 175, 70)
        default:
            primaryColorRed = CGFloat(46.0 / 255.0)
            primaryColorGreen = CGFloat(63.0 / 255.0)
            primaryColorBlue = CGFloat(89.0 / 255.0)
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
