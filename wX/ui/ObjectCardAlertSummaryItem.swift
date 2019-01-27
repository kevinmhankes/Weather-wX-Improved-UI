/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    private let cardStackView: ObjectCardStackView
    private let tvName = ObjectTextViewLarge(80.0)
    private let tv = ObjectTextView()
    private let tv2 = ObjectTextViewSmallGray(80.0)

    init(_ stackView: UIStackView, _ office: String, _ location: String, _ title: String, _ area: String) {
        tvName.text = office + " " + location
        tvName.view.textColor = UIColor.blue
        tv.text = title
        tv.setZeroSpacing()
        tv2.text = area
        tv.view.isUserInteractionEnabled = false
        tv2.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvName.view, tv.view, tv2.view]
        )
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
