/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterReportCard {

    private let sV = StackView()

    init(_ stackView: UIStackView, _ spotterReport: SpotterReports) {
        UtilityUI.setupStackViewForCard(sV)
        var textViews = [ObjectTextView]()
        [spotterReport.type + " " + spotterReport.time,
         spotterReport.city, spotterReport.lastName + ", "
            + spotterReport.firstName].forEach {textViews.append(ObjectTextView(sV, $0))}
        [17, 15, 15].enumerated().forEach {
            textViews[$0].font = UIFont.systemFont(ofSize: $1)
        }
        [.blue, .black, .gray].enumerated().forEach {textViews[$0].color = $1}
        textViews.forEach {$0.setZeroSpacing()}
        stackView.addArrangedSubview(sV)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        sV.addGestureRecognizer(gesture)
    }
}
