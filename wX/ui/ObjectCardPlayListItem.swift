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
        let tvProduct = ObjectTextViewLarge(80.0, text: product, color: UIColor.blue, isUserInteractionEnabled: false)
        let tvMiddle = ObjectTextViewLarge(80.0, text: middleLine, isUserInteractionEnabled: false)
        let tvBottom = ObjectTextViewSmallGray(80.0, text: bottomLines, isUserInteractionEnabled: false)
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, spacing: 0, arrangedSubviews: [tvProduct.view, tvMiddle.view, tvBottom.view]
        )
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
