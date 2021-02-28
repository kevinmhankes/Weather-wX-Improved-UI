/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextViewLarge {

    let tv = UILabelInset()

    init(
        _ textPadding: CGFloat,
        text: String = "",
        color: UIColor = ColorCompatibility.label,
        isUserInteractionEnabled: Bool = true
    ) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        // FIXME use new constraint
        tv.widthAnchor.constraint(equalToConstant: width - textPadding).isActive = true
        tv.font = FontSize.medium.size
        tv.adjustsFontSizeToFitWidth = true
        tv.textColor = color
        self.text = text
        tv.isUserInteractionEnabled = isUserInteractionEnabled
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    var text: String {
        get { tv.text! }
        set { tv.text = newValue }
    }

    var view: UILabelInset { tv }
}
