/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    private let sV = UIStackView()

    init(_ distribution: UIStackView.Distribution, _ axis: NSLayoutConstraint.Axis) {
        sV.distribution = distribution
        sV.axis = axis
    }

    convenience init(_ distribution: UIStackView.Distribution, _ axis: NSLayoutConstraint.Axis, _ spacing: CGFloat) {
        self.init(distribution, axis)
        sV.spacing = spacing
    }

    convenience init(
        _ distribution: UIStackView.Distribution,
        _ axis: NSLayoutConstraint.Axis,
        _ spacing: CGFloat,
        arrangedSubviews: [UIView]
    ) {
        self.init(distribution, axis, spacing)
        arrangedSubviews.forEach { sV.addArrangedSubview($0) }
    }

    var view: UIStackView {
        return sV
    }
}
