/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardStackView {

    private var stackView: StackView
    let padding: CGFloat = 3

    init() {
        stackView = StackView()
    }

    init(arrangedSubviews: [UIView], alignment: UIStackView.Alignment = .top) {
        stackView = StackView(arrangedSubviews: arrangedSubviews)
        stackView.backgroundColor = UIColor.white
        stackView.distribution = .fill
        stackView.alignment = alignment
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    var view: StackView {
        return stackView
    }
}
