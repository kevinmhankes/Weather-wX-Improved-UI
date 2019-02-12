/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterReportCard {

    init(_ stackView: UIStackView, _ spotterReport: SpotterReports, _ gesture: UITapGestureRecognizer) {
        let sV = StackView()
        var textViews = [ObjectTextView]()
        [
            spotterReport.type + " " + spotterReport.time,
            spotterReport.city,
            spotterReport.lastName + ", " + spotterReport.firstName
        ].forEach {textViews.append(ObjectTextView(sV, $0, isZeroSpacing: true))}
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[2].font = FontSize.small.size
        [.blue, .black, .gray].enumerated().forEach {textViews[$0].color = $1}
        stackView.addArrangedSubview(sV)
        sV.addGestureRecognizer(gesture)
    }
}
