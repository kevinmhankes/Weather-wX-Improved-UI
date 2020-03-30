/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardBlackHeaderText {

    private var cardStackView = ObjectCardStackView()

    init(_ uiv: UIwXViewController, _ text: String) {
        let tvLocation = ObjectTextViewLarge(80.0, color: UIColor.blue, isUserInteractionEnabled: false)
        tvLocation.text = text
        tvLocation.view.textColor = UIColor.white
        tvLocation.view.backgroundColor = UIColor.black
        tvLocation.tv.font = FontSize.extraLarge.size
        let verticalTextConainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view])
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        cardStackView.stackView.backgroundColor = UIColor.black
        uiv.stackView.addArrangedSubview(cardStackView.view)
        verticalTextConainer.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }

    var view: StackView { cardStackView.view }
}
