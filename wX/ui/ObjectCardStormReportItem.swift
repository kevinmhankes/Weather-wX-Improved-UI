/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardStormReportItem {

    init(_ stackView: UIStackView, _ stormReport: StormReport, _ gesture: UITapGestureRecognizerWithData) {
        var cardStackView = ObjectCardStackView()
        let tvLocation = ObjectTextViewLarge(80.0, color: UIColor.blue, isUserInteractionEnabled: false)
        let tvAddress = ObjectTextViewLarge(80.0, isUserInteractionEnabled: false)
        let tvDescription = ObjectTextViewSmallGray(80.0, isUserInteractionEnabled: false)
        if stormReport.damageHeader == "" && stormReport.time != "" {
            tvLocation.text = stormReport.state + ", " + stormReport.city + " " + stormReport.time
            tvAddress.text = stormReport.address
            tvDescription.text = stormReport.magnitude + " - " + stormReport.damageReport
            let verticalTextConainer = ObjectStackView(
                .fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view, tvAddress.view, tvDescription.view]
            )
            cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
            stackView.addArrangedSubview(cardStackView.view)
            cardStackView.view.addGestureRecognizer(gesture)
        } else if stormReport.damageHeader != "" {
            tvLocation.text = stormReport.damageHeader
            tvLocation.view.textColor = UIColor.white
            tvLocation.view.backgroundColor = UIColor.black
            tvLocation.tv.font = FontSize.extraLarge.size
            let verticalTextConainer = ObjectStackView(
                .fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view]
            )
            cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
            stackView.addArrangedSubview(cardStackView.view)
        }
    }
}
