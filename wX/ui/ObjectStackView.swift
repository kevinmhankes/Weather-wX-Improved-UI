/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    let uiStackView = UIStackView()

    init(
        _ distribution: UIStackView.Distribution,
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView] = []
    ) {
        uiStackView.distribution = distribution
        uiStackView.axis = axis
        uiStackView.spacing = spacing
        if !arrangedSubviews.isEmpty {
            arrangedSubviews.forEach { uiStackView.addArrangedSubview($0) }
        }
    }

    var view: UIStackView {
        return uiStackView
    }
}
