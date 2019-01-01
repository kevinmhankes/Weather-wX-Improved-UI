/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextViewSmallGray {

    let tv = UITextView()

    init(_ textPadding: CGFloat) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - textPadding).isActive = true
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textColor = UIColor.gray
    }

    var text: String {
        get {return tv.text}
        set {tv.text = newValue}
    }

    var view: UITextView {return tv}
}
