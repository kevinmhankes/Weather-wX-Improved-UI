/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

enum FontSize {
    case small
    case medium
    case large
    var size: UIFont {
        switch self {
        case .small:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .medium:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        case .large:
            return UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        }
    }
}
