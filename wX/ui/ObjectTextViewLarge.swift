/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextViewLarge {

    let tv = UILabelInset()

    init(_ textPadding: CGFloat, text: String = "", isUserInteractionEnabled: Bool = true) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: width - textPadding).isActive = true
        tv.font = FontSize.medium.size
        tv.adjustsFontSizeToFitWidth = true
        self.text = text
        self.tv.isUserInteractionEnabled = isUserInteractionEnabled
    }

    convenience init(
        _ textPadding: CGFloat,
        _ color: UIColor,
        text: String = "",
        isUserInteractionEnabled: Bool = true
    ) {
        self.init(textPadding, text: text, isUserInteractionEnabled: isUserInteractionEnabled)
        tv.textColor = color
    }

    var text: String {
        get {
            return tv.text!
        }
        set {
            tv.text = newValue
        }
    }

    var view: UILabelInset {
        return tv
    }
}
