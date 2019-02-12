/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    init(
        _ stackView: UIStackView,
        _ office: String,
        _ location: String,
        _ alert: CAPAlert,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let tvName = ObjectTextViewLarge(80.0, UIColor.blue, text: office + " (" + location + ")")
        let tvTitle = ObjectTextView(title)
        let tvStart = ObjectTextView("Start: " + startTime)
        let tvEnd = ObjectTextView("End: " + endTime)
        let tvArea = ObjectTextViewSmallGray(80.0, text: alert.area)
        // TODO for setzerospacing and interactionenabled add to constructor
        tvTitle.setZeroSpacing()
        tvStart.setZeroSpacing()
        tvEnd.setZeroSpacing()
        tvTitle.view.isUserInteractionEnabled = false
        tvStart.view.isUserInteractionEnabled = false
        tvEnd.view.isUserInteractionEnabled = false
        tvArea.view.isUserInteractionEnabled = false
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, 0, arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view]
        )
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
