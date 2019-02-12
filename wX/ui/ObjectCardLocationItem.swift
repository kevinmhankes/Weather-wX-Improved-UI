/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    init(
        _ stackView: UIStackView,
        _ name: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let tvName = ObjectTextViewLarge(80.0, UIColor.blue, text: name)
        let tvMiddle = ObjectTextView(middleLine)
        let tvBottom = ObjectTextViewSmallGray(80.0, text: bottomLines)
        tvMiddle.setZeroSpacing()
        tvMiddle.view.isUserInteractionEnabled = false
        tvBottom.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvName.view, tvMiddle.view, tvBottom.view]
        )
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
