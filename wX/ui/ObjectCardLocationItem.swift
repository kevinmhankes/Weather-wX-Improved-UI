/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    var tvCurrentConditions: ObjectTextView

    init(
        _ stackView: UIStackView,
        _ name: String,
        _ observation: String,
        _ middleLine: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let tvName = ObjectTextViewLarge(80.0, text: name, color: ColorCompatibility.highlightText, isUserInteractionEnabled: false)
        tvCurrentConditions = ObjectTextView(observation, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextViewSmallGray(80.0, text: middleLine, isUserInteractionEnabled: false)
        let verticalTextConainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvCurrentConditions.view, tvMiddle.view]
        )
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
