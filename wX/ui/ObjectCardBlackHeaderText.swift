/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardBlackHeaderText {

    private let objectCardStackView: ObjectCardStackView

    init(_ uiv: UIwXViewController, _ text: String) {
        let tvLocation = ObjectTextViewLarge(80.0, color: UIColor.blue, isUserInteractionEnabled: false)
        tvLocation.text = text
        tvLocation.view.textColor = UIColor.white
        tvLocation.view.backgroundColor = UIColor.black
        tvLocation.tv.font = FontSize.extraLarge.size
        let verticalTextContainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view])
        objectCardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        objectCardStackView.view.backgroundColor = UIColor.black
        uiv.stackView.addArrangedSubview(objectCardStackView.view)
        verticalTextContainer.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }

    var view: StackView { objectCardStackView.view }
}
