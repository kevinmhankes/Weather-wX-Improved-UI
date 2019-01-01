/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardHazard {

    let sVLoc: UIStackView
    let objLabel: ObjectTextView

    init(_ stackView: UIStackView, _ hazard: String) {
        sVLoc = UIStackView()
        sVLoc.distribution = .fill
        sVLoc.axis = .horizontal
        sVLoc.alignment = .center
        objLabel = ObjectTextView(sVLoc, hazard, UIFont.systemFont(ofSize: 20), UIColor.blue)
        stackView.addArrangedSubview(sVLoc)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        objLabel.addGestureRecognizer(gesture)
    }
}
