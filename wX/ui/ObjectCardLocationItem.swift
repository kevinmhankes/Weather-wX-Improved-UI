/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    let tvCurrentConditions: Text
    init(
        _ uiv: UIwXViewController,
        _ name: String,
        _ observation: String,
        _ middleLine: String,
        _ gesture: GestureData
    ) {
        let objectStackView = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvName = Text(objectStackView, name, isUserInteractionEnabled: false, isZeroSpacing: false)
        tvCurrentConditions = Text(objectStackView, observation, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = Text(objectStackView, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        tvName.font = FontSize.large.size
        tvCurrentConditions.font = FontSize.small.size
        tvMiddle.font = FontSize.small.size
        tvName.color = ColorCompatibility.highlightText
        tvCurrentConditions.color = ColorCompatibility.label
        tvMiddle.color = ColorCompatibility.systemGray2
        uiv.stackView.addLayout(objectStackView.view)
        [tvName, tvName, tvCurrentConditions].forEach {
            // $0.tv.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
            $0.constrain(uiv.scrollView)
        }
        objectStackView.view.addGestureRecognizer(gesture)
        objectStackView.constrain(uiv.stackView)
    }
}
