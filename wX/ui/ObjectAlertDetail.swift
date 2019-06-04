/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertDetail {

    private var textViews = [ObjectTextView]()
    private var stackView: UIStackView = UIStackView()

    convenience init(_ stackView: UIStackView) {
        self.init()
        (0...6).forEach { _ in
            let objectTextView = ObjectTextView(stackView, "")
            objectTextView.tv.isAccessibilityElement = false
            textViews.append(objectTextView)
        }
        textViews[0].font = FontSize.extraLarge.size
        textViews[4].color = UIColor.blue
        stackView.isAccessibilityElement = true
        self.stackView = stackView
    }

    func updateContent(_ alert: CapAlert) {
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let wfo = alert.title.parse("by (.*?)$")
        self.textViews[0].text = title
        self.textViews[1].text = wfo
        self.textViews[2].text = "Issued: " + startTime
        self.textViews[3].text = "End: " + endTime
        self.textViews[4].text = alert.area.removeSingleLineBreaks()
        self.textViews[5].text = alert.summary.removeSingleLineBreaks()
        self.textViews[6].text = alert.instructions.removeSingleLineBreaks()
        stackView.accessibilityLabel = title + wfo +  "Issued: " + startTime +
            "End: " + endTime + alert.area.removeSingleLineBreaks()
            + alert.summary.removeSingleLineBreaks() + alert.instructions.removeSingleLineBreaks()
    }

    static func condenseTime(_ cap: CapAlert) -> (String, String, String) {
        let title = cap.title.parse("(.*?) issued")
        var startTime = cap.title.parse("issued (.*?) until")
        if startTime == "" {
            startTime = cap.title.parse("issued (.*?) expiring")
        }
        if startTime == "" {
            startTime = cap.title.parse("issued (.*?) by")
        }
        var endTime = cap.title.parse("until (.*?) by")
        if endTime == "" {
            endTime = cap.title.parse("expiring (.*?) by")
        }
        return(title, startTime, endTime)
    }
}
