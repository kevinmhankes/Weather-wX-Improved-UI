/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

// 16 is medium

enum FontSize {
    case extraSmall
    case hourly
    case sunMoon
    case small
    case medium
    case large
    case extraLarge
    var size: UIFont {
        switch self {
        case .extraSmall: // 11
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize - 5.0)
        case .hourly: // 14
            return UIFont(name: "Courier", size: UIPreferences.textviewFontSize - 2.0)!
        case .sunMoon:
            return UIFont(name: "Courier", size: UIPreferences.textviewFontSize)!
        case .small: // 15
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize - 1.0)
        case .medium: // 16
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .large: // 18 TBD
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 2.0)
        case .extraLarge: // 20
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 4.0)
        }
    }
}
