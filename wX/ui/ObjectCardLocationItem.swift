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
        let sV = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvName = ObjectTextView(sV.view, name, isUserInteractionEnabled: false, isZeroSpacing: true)
        tvCurrentConditions = ObjectTextView(sV.view, observation, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextView(sV.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        tvName.font = FontSize.medium.size
        tvCurrentConditions.font = FontSize.small.size
        tvMiddle.font = FontSize.small.size
        tvName.color = ColorCompatibility.highlightText
        tvCurrentConditions.color = ColorCompatibility.label
        tvMiddle.color = ColorCompatibility.systemGray2
        stackView.addArrangedSubview(sV.view)
        sV.view.addGestureRecognizer(gesture)
        sV.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
