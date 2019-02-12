/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardPlayListItem {

    init(
        _ stackView: UIStackView,
        _ product: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let tvProduct = ObjectTextViewLarge(80.0, UIColor.blue, text: product)
        let tvMiddle = ObjectTextViewLarge(80.0, text: middleLine)
        let tvBottom = ObjectTextViewSmallGray(80.0, text: bottomLines)
        // TODO constructor
        tvProduct.view.isUserInteractionEnabled = false
        tvMiddle.view.isUserInteractionEnabled = false
        tvBottom.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvProduct.view, tvMiddle.view, tvBottom.view]
        )
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
