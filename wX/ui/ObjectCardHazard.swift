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
        objLabel = ObjectTextView(sVLoc.view, hazard, UIFont.systemFont(ofSize: 20), UIColor.blue)
        stackView.addArrangedSubview(sVLoc.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        objLabel.addGestureRecognizer(gesture)
    }
}
