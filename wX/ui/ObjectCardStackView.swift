/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardStackView {

    private var sV: StackView

    init(arrangedSubviews: [UIView]) {
        sV = StackView(arrangedSubviews: arrangedSubviews)
        sV.backgroundColor = UIColor.white
        sV.distribution = .fill
        sV.alignment = .top
        sV.axis = .horizontal
        sV.layoutMargins = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        sV.isLayoutMarginsRelativeArrangement = true
    }

    var view: StackView {
        return sV
    }
}
