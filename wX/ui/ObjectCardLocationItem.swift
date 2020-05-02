/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    let tvCurrentConditions: ObjectTextView

    init(
        _ uiv: UIwXViewController,
        _ name: String,
        _ observation: String,
        _ middleLine: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let objectStackView = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvName = ObjectTextView(objectStackView.view, name, isUserInteractionEnabled: false, isZeroSpacing: false)
        tvCurrentConditions = ObjectTextView(objectStackView.view, observation, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextView(objectStackView.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        tvName.font = FontSize.large.size
        tvCurrentConditions.font = FontSize.small.size
        tvMiddle.font = FontSize.small.size
        tvName.color = ColorCompatibility.highlightText
        tvCurrentConditions.color = ColorCompatibility.label
        tvMiddle.color = ColorCompatibility.systemGray2
        uiv.stackView.addArrangedSubview(objectStackView.view)
        [tvName, tvName, tvCurrentConditions].forEach { $0.tv.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true }
        objectStackView.view.addGestureRecognizer(gesture)
        objectStackView.view.widthAnchor.constraint(equalTo: uiv.stackView.widthAnchor).isActive = true
    }
}
