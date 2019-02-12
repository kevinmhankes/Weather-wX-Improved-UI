/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    private let cardStackView: ObjectCardStackView
    private let tvName = ObjectTextViewLarge(80.0, UIColor.blue)
    private let tvMiddle = ObjectTextView()
    private let tvBottom = ObjectTextViewSmallGray(80.0)

    init(
        _ stackView: UIStackView,
        _ name: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        tvName.text = name
        tvMiddle.text = middleLine
        tvMiddle.setZeroSpacing()
        tvBottom.text = bottomLines
        tvMiddle.view.isUserInteractionEnabled = false
        tvBottom.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvName.view, tvMiddle.view, tvBottom.view]
        )
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        addGestureRecognizer(gesture)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
