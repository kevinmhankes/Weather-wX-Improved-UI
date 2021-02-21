/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardHazard {

    init(_ stackView: UIStackView, _ hazard: String, _ gesture: UITapGestureRecognizer) {
        let objectTextView = ObjectTextView(stackView, hazard.uppercased(), FontSize.extraLarge.size, ColorCompatibility.highlightText)
        objectTextView.addGestureRecognizer(gesture)
        objectTextView.tv.isSelectable = false
    }
}
