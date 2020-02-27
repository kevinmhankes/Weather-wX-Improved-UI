/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardPlayListItem {

    init(
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ product: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let sV = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvProduct = ObjectTextView(sV.view, product, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextView(sV.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvBottom = ObjectTextView(sV.view, bottomLines.replaceAll(MyApplication.newline, " "), isUserInteractionEnabled: false, isZeroSpacing: true)
        tvProduct.font = FontSize.medium.size
        tvMiddle.font = FontSize.small.size
        tvBottom.font = FontSize.small.size
        tvProduct.color = ColorCompatibility.highlightText
        tvMiddle.color = ColorCompatibility.label
        tvBottom.color = ColorCompatibility.systemGray2
        stackView.addArrangedSubview(sV.view)
        [tvProduct, tvMiddle, tvBottom].forEach {
            $0.tv.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        sV.view.addGestureRecognizer(gesture)
        sV.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
