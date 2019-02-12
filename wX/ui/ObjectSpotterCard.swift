/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterCard {

    init(_ stackView: UIStackView, _ spotter: Spotter, _ gesture: UITapGestureRecognizer) {
        var textViews = [ObjectTextView]()
        let spotterLocation = UtilityMath.latLonFix(spotter.location)
        let sV2 = ObjectStackView(.fill, .vertical, 0)
        [
            spotter.lastName
                + ", "
                + spotter.firstName
                + " ("
                + spotterLocation.latString
                + ", "
                + spotterLocation.lonString
                + ")",
            spotter.reportedAt, spotter.email + " " + spotter.phone
            ].forEach {
                textViews.append(ObjectTextView(sV2.view, $0, isUserInteractionEnabled: false, isZeroSpacing: true))
        }
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[2].font = FontSize.small.size
        [.blue, .black, .gray].enumerated().forEach { textViews[$0].color = $1 }
        let sV = ObjectCardStackView(arrangedSubviews: [sV2.view])
        stackView.addArrangedSubview(sV.view)
        sV.view.addGestureRecognizer(gesture)
    }
}
