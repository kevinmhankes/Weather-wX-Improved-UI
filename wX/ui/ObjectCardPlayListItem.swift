/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardPlayListItem {

    init(
        _ uiv: UIwXViewController,
        _ product: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let objectStackView = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvProduct = ObjectTextView(objectStackView.view, product, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextView(objectStackView.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvBottom = ObjectTextView(objectStackView.view, bottomLines.replaceAll(GlobalVariables.newline, " "), isUserInteractionEnabled: false, isZeroSpacing: true)
        tvProduct.font = FontSize.medium.size
        tvMiddle.font = FontSize.small.size
        tvBottom.font = FontSize.small.size
        tvProduct.color = ColorCompatibility.highlightText
        tvMiddle.color = ColorCompatibility.label
        tvBottom.color = ColorCompatibility.systemGray2
        uiv.stackView.addArrangedSubview(objectStackView.view)
        [tvProduct, tvMiddle, tvBottom].forEach {
            $0.tv.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
        }
        objectStackView.view.addGestureRecognizer(gesture)
        objectStackView.view.widthAnchor.constraint(equalTo: uiv.stackView.widthAnchor).isActive = true
    }
}
