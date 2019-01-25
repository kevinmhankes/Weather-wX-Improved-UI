/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterCard {

    let sV: ObjectCardStackView

    init(_ stackView: UIStackView, _ spotter: Spotter) {
        var textViews = [ObjectTextView]()
        let spotterLocation = UtilityMath.latLonFix(spotter.location)
        let sV2 = ObjectStackView(.fill, .vertical, 0)
        [spotter.lastName + ", " + spotter.firstName + " (" + spotterLocation.latString + ", "
            + spotterLocation.lonString + ")", spotter.reportedAt, spotter.email
                + " " + spotter.phone].forEach {
                    textViews.append(ObjectTextView(sV2.view, $0))
        }
        textViews.forEach {
            $0.view.isUserInteractionEnabled = false
        }
        [17, 15, 15].enumerated().forEach {textViews[$0].font = UIFont.systemFont(ofSize: $1)}
        [.blue, .black, .gray].enumerated().forEach {textViews[$0].color = $1}
        textViews.forEach {$0.setZeroSpacing()}
        sV = ObjectCardStackView(arrangedSubviews: [sV2.view])
        stackView.addArrangedSubview(sV.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        sV.view.addGestureRecognizer(gesture)
    }
}
