/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    private var cardStackView = ObjectCardStackView()
    private let tvName = ObjectTextViewLarge(80.0)
    private let tvTitle = ObjectTextView()
    private let tvStart = ObjectTextView()
    private let tvEnd = ObjectTextView()
    private let tvArea = ObjectTextViewSmallGray(80.0)
    var title = ""
    var startTime = ""
    var endTime = ""

    init(_ stackView: UIStackView, _ office: String, _ location: String, _ alert: CAPAlert) {
        self.condenseTime(alert)
        tvName.text = office + " (" + location + ")"
        tvName.view.textColor = UIColor.blue
        tvTitle.text = title
        tvTitle.setZeroSpacing()
        tvStart.text = "Start: " + startTime
        tvStart.setZeroSpacing()
        tvEnd.text = "End: " + endTime
        tvEnd.setZeroSpacing()
        tvArea.text = alert.area
        tvTitle.view.isUserInteractionEnabled = false
        tvStart.view.isUserInteractionEnabled = false
        tvEnd.view.isUserInteractionEnabled = false
        tvArea.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view]
        )
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
    }

    // TODO make this in common with ObjectAlertDetail
    func condenseTime(_ cap: CAPAlert) {
        title = cap.title.parse("(.*?) issued")
        startTime = cap.title.parse("issued (.*?) until")
        if startTime == "" {
            startTime = cap.title.parse("issued (.*?) expiring")
        }
        if startTime == "" {
            startTime = cap.title.parse("issued (.*?) by")
        }
        endTime = cap.title.parse("until (.*?) by")
        if endTime == "" {
            endTime = cap.title.parse("expiring (.*?) by")
        }
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
