/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    private let sV = UIStackView()

    init(_ distribution: UIStackViewDistribution, _ axis: UILayoutConstraintAxis) {
        sV.distribution = distribution
        sV.axis = axis
    }

    convenience init(_ distribution: UIStackViewDistribution, _ axis: UILayoutConstraintAxis, _ spacing: CGFloat) {
        self.init(distribution, axis)
        sV.spacing = spacing
    }

    var view: UIStackView { return sV}

}
