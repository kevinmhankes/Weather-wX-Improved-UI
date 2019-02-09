/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/


// 16 is medium

enum FontSize {
    case small
    case medium
    case large
    case extraLarge
    var size: UIFont {
        switch self {
        case .small:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .medium:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .large:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .extraLarge:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 4.0)
        }
    }
}
