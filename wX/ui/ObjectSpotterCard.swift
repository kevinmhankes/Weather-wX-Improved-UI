/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterCard {

    private let sV = StackView()

    init(_ stackView: UIStackView, _ spotter: Spotter) {
        UtilityUI.setupStackViewForCard(sV)
        var textViews = [ObjectTextView]()
        let spotterLocation = UtilityMath.latLonFix(spotter.location)
        [spotter.lastName + ", " + spotter.firstName + " (" + spotterLocation.latString + ","
            + spotterLocation.lonString + ")", spotter.reportedAt, spotter.email
                + " " + spotter.phone].forEach {textViews.append(ObjectTextView(sV, $0))}
        [17, 15, 15].enumerated().forEach {
            textViews[$0].font = UIFont.systemFont(ofSize: $1)
        }
        [.blue, .black, .gray].enumerated().forEach {
            textViews[$0].color = $1
        }
        textViews.forEach {
            $0.setZeroSpacing()
        }
        stackView.addArrangedSubview(sV)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        sV.addGestureRecognizer(gesture)
    }
}
