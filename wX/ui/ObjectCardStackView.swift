/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardStackView {

    // TODO  make private
    let stackView: StackView
    private let padding: CGFloat = 3.0

    init() {
        stackView = StackView()
    }

    init(arrangedSubviews: [UIView], alignment: UIStackView.Alignment = .top, axis: NSLayoutConstraint.Axis = .horizontal) {
        stackView = StackView(arrangedSubviews: arrangedSubviews)
        stackView.backgroundColor = ColorCompatibility.systemBackground
        stackView.distribution = .fill
        stackView.alignment = alignment
        stackView.axis = axis
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    var view: StackView { stackView }

    func setAxis(_ axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
    }
}
