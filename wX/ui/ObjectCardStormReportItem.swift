/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardStormReportItem {

    private let cardStackView: ObjectCardStackView
    private let tvLocation = ObjectTextViewLarge(80.0)
    private let tv = ObjectTextViewLarge(80.0)
    private let tv2 = ObjectTextViewSmallGray(80.0)

    init(_ stackView: UIStackView, _ stormReport: StormReport) {
        tvLocation.text = stormReport.state + " " + stormReport.city
        tv.text = stormReport.address
        tv2.text = stormReport.damageReport
        tv.view.isUserInteractionEnabled = false
        tv2.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvLocation.view, tv.view, tv2.view]
        )
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
    }

    func makeHeader() {
        tvLocation.view.textColor = UIColor.blue
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
