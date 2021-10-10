// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectSpotterReportCard {

    init(_ uiv: UIwXViewController, _ spotterReport: SpotterReports, _ gesture: UITapGestureRecognizer) {
        let boxV = ObjectStackView(.fill, .vertical, spacing: 0)
        var textViews = [Text]()
        let topLine = spotterReport.type + " " + spotterReport.time
        let middleLine = spotterReport.city
        let bottomLine = spotterReport.lastName + ", " + spotterReport.firstName
        textViews.append(Text(boxV, topLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(Text(boxV, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(Text(boxV, bottomLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[2].font = FontSize.small.size
        textViews[0].color = ColorCompatibility.highlightText
        textViews[1].color = ColorCompatibility.label
        textViews[2].color = ColorCompatibility.systemGray2
        uiv.stackView.addLayout(boxV)
        textViews.forEach {
            $0.constrain(uiv.scrollView)
        }
        boxV.addGesture(gesture)
    }
}
