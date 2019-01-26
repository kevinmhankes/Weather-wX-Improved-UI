/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardPlayListItem {

    private let cardStackView: ObjectCardStackView
    private let tvProduct = ObjectTextViewLarge(80.0)
    private let tv = ObjectTextViewLarge(80.0)
    private let tv2 = ObjectTextViewSmallGray(80.0)

    init(_ stackView: UIStackView, _ product: String, _ middleLine: String, _ bottomLines: String) {
        tvProduct.text = product
        tvProduct.view.textColor = UIColor.blue
        tv.text = middleLine
        tv2.text = bottomLines
        tv.view.isUserInteractionEnabled = false
        tv2.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvProduct.view, tv.view, tv2.view]
        )
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
