/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    let sV = UIStackView()

    init(
        _ distribution: UIStackView.Distribution,
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView] = []
    ) {
        sV.distribution = distribution
        sV.axis = axis
        sV.spacing = spacing
        if !arrangedSubviews.isEmpty {
            arrangedSubviews.forEach { sV.addArrangedSubview($0) }
        }
    }

    var view: UIStackView {
        return sV
    }
}
