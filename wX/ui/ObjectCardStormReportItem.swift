// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectCardStormReportItem {

    init(_ box: ObjectStackView, _ stormReport: StormReport, _ gesture: GestureData) {
        var card = ObjectCardStackView()
        let tvLocation = TextLarge(80.0, color: ColorCompatibility.highlightText, isUserInteractionEnabled: false)
        let tvAddress = TextLarge(80.0, isUserInteractionEnabled: false)
        let tvDescription = TextSmallGray(isUserInteractionEnabled: false)
        if stormReport.damageHeader == "" && stormReport.time != "" {
            tvLocation.text = stormReport.state + ", " + stormReport.city + " " + stormReport.time
            tvAddress.text = stormReport.address
            tvDescription.text = stormReport.magnitude + " - " + stormReport.damageReport
            let boxV = ObjectStackView(
                .fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view, tvAddress.view, tvDescription.view]
            )
            card = ObjectCardStackView(boxV)
            box.addLayout(card)
            card.addGesture(gesture)
        }
    }
}
