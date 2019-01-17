/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardLocationItem {

    private let sV: ObjectCardStackView
    private let tvProduct = ObjectTextViewLarge(80.0)
    private let tv = ObjectTextView()
    private let tv2 = ObjectTextViewSmallGray(80.0)

    init(_ stackView: UIStackView, _ product: String, _ topLine: String, _ bottomLines: String) {
        tvProduct.text = product
        tvProduct.view.textColor = UIColor.blue
        tv.text = topLine
        tv.setZeroSpacing()
        tv2.text = bottomLines
        tv.view.isUserInteractionEnabled = false
        tv2.view.isUserInteractionEnabled = false
        let sV2 = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tvProduct.view, tv.view, tv2.view])
        sV = ObjectCardStackView(arrangedSubviews: [sV2.view])
        stackView.addArrangedSubview(sV.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        sV.view.addGestureRecognizer(gesture)
    }
}
