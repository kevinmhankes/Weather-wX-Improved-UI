/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardHazard {

    private let objLabel: ObjectTextView

    init(_ stackView: UIStackView, _ hazard: String, _ gesture: UITapGestureRecognizer) {
        objLabel = ObjectTextView(stackView, hazard, FontSize.extraLarge.size, UIColor.blue)
        addGestureRecognizer(gesture)
    }

    private func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        objLabel.addGestureRecognizer(gesture)
    }
}
