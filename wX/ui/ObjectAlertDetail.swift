/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertDetail {

    private var textViews = [ObjectTextView]()

    convenience init(_ stackView: UIStackView) {
        self.init()
        (0...6).forEach {
            let objText = ObjectTextView(stackView, "")
            textViews.append(objText)
            if $0 == 4 {
                textViews[$0].color = UIColor.blue
            }
            if $0 == 0 {
                textViews[$0].font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 2)
            }
        }
    }

    func updateContent(_ cap: CAPAlert) {
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
        let wfo = cap.title.parse("by (.*?)$")
        self.textViews[0].text = title
        self.textViews[1].text = "Issued: " + startTime
        self.textViews[2].text = "End: " + endTime
        self.textViews[3].text = wfo
        self.textViews[4].text = cap.area.removeSingleLineBreaks()
        self.textViews[5].text = cap.summary.removeSingleLineBreaks()
        self.textViews[6].text = cap.instructions.removeSingleLineBreaks()
    }
}
