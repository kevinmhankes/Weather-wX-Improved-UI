/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextViewLarge {

    let tv = UILabelInset()

    init(_ textPadding: CGFloat) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: width - textPadding).isActive = true
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.adjustsFontSizeToFitWidth = true
    }

    func size(_ size: Int) {
        tv.font = UIFont.systemFont(ofSize: CGFloat(size))
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
