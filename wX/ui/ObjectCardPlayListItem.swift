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
        //let tvProduct = ObjectTextViewLarge(80.0, text: product, color: ColorCompatibility.highlightText, isUserInteractionEnabled: false)
        //let tvMiddle = ObjectTextViewLarge(80.0, text: middleLine, isUserInteractionEnabled: false)
        //let tvBottom = ObjectTextViewSmallGray(80.0, text: bottomLines, isUserInteractionEnabled: false)
        //let verticalTextConainer = ObjectStackView(
        //    .fill, .vertical, spacing: 0, arrangedSubviews: [tvProduct.view, tvMiddle.view, tvBottom.view]
        //)
        let sV = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvProduct = ObjectTextView(sV.view, product, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = ObjectTextView(sV.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvBottom = ObjectTextView(sV.view, bottomLines, isUserInteractionEnabled: false, isZeroSpacing: true)
        tvProduct.font = FontSize.medium.size
        tvMiddle.font = FontSize.small.size
        tvBottom.font = FontSize.small.size
        tvProduct.color = ColorCompatibility.highlightText
        tvMiddle.color = ColorCompatibility.label
        tvBottom.color = ColorCompatibility.systemGray2
        /*let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
        cardStackView.stackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true*/
        //let sV = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(sV.view)
        sV.view.addGestureRecognizer(gesture)
        sV.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
