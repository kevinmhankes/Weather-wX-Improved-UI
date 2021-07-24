/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterCard {

    init(_ uiv: UIwXViewController, _ spotter: Spotter, _ gesture: UITapGestureRecognizer) {
        var textViews = [Text]()
        let spotterLocation = UtilityMath.latLonFix(spotter.location)
        let boxV = ObjectStackView(.fill, .vertical, spacing: 0)
        let topLine = spotter.lastName + ", " + spotter.firstName + " (" + spotterLocation.latString + ", " + spotterLocation.lonString + ")"
        let middleLine = spotter.reportedAt
        textViews.append(Text(boxV, topLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(Text(boxV, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[0].color = ColorCompatibility.highlightText
        textViews[1].color = ColorCompatibility.label
        uiv.stackView.addLayout(boxV)
        textViews.forEach {
            $0.constrain(uiv.scrollView)
        }
        boxV.constrain(uiv.stackView)
        boxV.addGesture(gesture)
    }
}
