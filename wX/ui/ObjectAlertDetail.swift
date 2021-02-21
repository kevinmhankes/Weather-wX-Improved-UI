/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertDetail {

    private var textViews = [ObjectTextView]()
    private let uiStackView: UIStackView

    init(_ uiStackView: UIStackView) {
        self.uiStackView = uiStackView
        (0...6).forEach { _ in
            let objectTextView = ObjectTextView(uiStackView, "")
            objectTextView.tv.isAccessibilityElement = false
            textViews.append(objectTextView)
        }
        textViews[0].font = FontSize.extraLarge.size
        textViews[4].color = ColorCompatibility.highlightText
        uiStackView.isAccessibilityElement = true
    }

    func updateContent(_ uiScrollView: UIScrollView, _ alert: CapAlert) {
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let wfo = alert.title.parse("by (.*?)$")
        self.textViews[0].text = title
        self.textViews[1].text = wfo
        self.textViews[2].text = "Issued: " + startTime
        if endTime == "" {
            self.textViews[3].text = ""
            self.textViews[3].view.isHidden = true
        } else {
            self.textViews[3].text = "End: " + endTime
        }
        self.textViews[4].text = alert.area.removeSingleLineBreaks()
        //self.textViews[5].text = alert.summary.removeSingleLineBreaks()
        self.textViews[5].text = alert.summary
        self.textViews[6].text = alert.instructions.removeSingleLineBreaks()
        uiStackView.accessibilityLabel = title + wfo +  "Issued: " + startTime +
            "End: " + endTime + alert.area.removeSingleLineBreaks()
            + alert.summary.removeSingleLineBreaks() + alert.instructions.removeSingleLineBreaks()
        textViews.forEach { $0.tv.widthAnchor.constraint(equalTo: uiScrollView.widthAnchor).isActive = true }
    }

    static func condenseTime(_ cap: CapAlert) -> (String, String, String) {
        let title = cap.title.parse("(.*?) issued")
        var startTime = cap.title.parse("issued (.*?) until")
        if startTime == "" { startTime = cap.title.parse("issued (.*?) expiring") }
        if startTime == "" { startTime = cap.title.parse("issued (.*?) by") }
        var endTime = cap.title.parse("until (.*?) by")
        if endTime == "" { endTime = cap.title.parse("expiring (.*?) by") }
        return(title, startTime, endTime)
    }
}
