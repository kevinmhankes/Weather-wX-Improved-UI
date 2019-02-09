/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardHazard {

    private let sVLoc = ObjectStackView(.fill, .horizontal, .center)
    private let objLabel: ObjectTextView

    init(_ stackView: UIStackView, _ hazard: String) {
        objLabel = ObjectTextView(stackView, hazard, FontSize.extraLarge.size, UIColor.blue)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        objLabel.addGestureRecognizer(gesture)
    }
}
