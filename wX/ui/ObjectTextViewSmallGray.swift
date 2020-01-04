/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextViewSmallGray {

    let tv = UITextView()

    init(_ textPadding: CGFloat, text: String = "", isUserInteractionEnabled: Bool = true) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: width - textPadding).isActive = true
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = FontSize.small.size
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textColor = ColorCompatibility.secondaryLabel
        self.text = text
        self.tv.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    var text: String {
        get {
            return tv.text
        }
        set {
            tv.text = newValue
        }
    }

    var view: UITextView {
        return tv
    }
}
