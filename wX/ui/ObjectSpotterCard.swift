/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterCard {

    init(_ uiv: UIwXViewController, _ spotter: Spotter, _ gesture: UITapGestureRecognizer) {
        var textViews = [ObjectTextView]()
        let spotterLocation = UtilityMath.latLonFix(spotter.location)
        let objectStackView = ObjectStackView(.fill, .vertical, spacing: 0)
        let topLine = spotter.lastName
                + ", "
                + spotter.firstName
                + " ("
                + spotterLocation.latString
                + ", "
                + spotterLocation.lonString
                + ")"
        let middleLine = spotter.reportedAt
        //let bottomLine = spotter.email + " " + spotter.phone
        textViews.append(ObjectTextView(objectStackView.view, topLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(ObjectTextView(objectStackView.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        //textViews.append(ObjectTextView(objectStackView.view, bottomLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        //textViews[2].font = FontSize.small.size
        textViews[0].color = ColorCompatibility.highlightText
        textViews[1].color = ColorCompatibility.label
        //textViews[2].color = ColorCompatibility.systemGray2
        uiv.stackView.addArrangedSubview(objectStackView.view)
        textViews.forEach { $0.tv.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true }
        objectStackView.view.widthAnchor.constraint(equalTo: uiv.stackView.widthAnchor).isActive = true
        objectStackView.view.addGestureRecognizer(gesture)
    }
}
