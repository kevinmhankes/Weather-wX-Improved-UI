// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectAlertDetail {

    private var textViews = [Text]()
    private let uiStackView: ObjectStackView

    init(_ uiStackView: ObjectStackView) {
        self.uiStackView = uiStackView
        (0...6).forEach { _ in
            textViews.append(Text(uiStackView, ""))
            textViews.last!.isAccessibilityElement = false
        }
        textViews[0].font = FontSize.extraLarge.size
        textViews[4].color = ColorCompatibility.highlightText
        uiStackView.isAccessibilityElement = true
    }

    func updateContent(_ uiScrollView: UIScrollView, _ alert: CapAlert) {
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let wfo = alert.title.parse("by (.*?)$")
        textViews[0].text = title
        textViews[1].text = wfo
        textViews[2].text = "Issued: " + startTime
        if endTime == "" {
            textViews[3].text = ""
            textViews[3].view.isHidden = true
        } else {
            textViews[3].text = "End: " + endTime
        }
        textViews[4].text = alert.area.removeSingleLineBreaks()
        
        if alert.nwsHeadLine != "" {
            textViews[5].text = "..." + alert.nwsHeadLine + "..." + GlobalVariables.newline + GlobalVariables.newline
        }
        textViews[5].text += alert.summary
        
        if alert.instructions != "" {
            textViews[6].text = "PRECAUTIONARY/PREPAREDNESS ACTIONS..." + GlobalVariables.newline + GlobalVariables.newline
            textViews[6].text += alert.instructions.removeSingleLineBreaks()
        }
        
        textViews[6].text += GlobalVariables.newline
        textViews[6].text += GlobalVariables.newline
        
        if alert.windThreat != "" {
            textViews[6].text += "WIND THREAT..." + alert.windThreat
            textViews[6].text += GlobalVariables.newline
        }
        
        if alert.maxWindGust != "" &&  alert.maxWindGust != "0" {
            textViews[6].text += "MAX WIND GUST..." + alert.maxWindGust
            textViews[6].text += GlobalVariables.newline
        }

        if alert.hailThreat != "" {
            textViews[6].text += "HAIL THREAT..." + alert.hailThreat
            textViews[6].text += GlobalVariables.newline

            textViews[6].text += "MAX HAIL SIZE..." + alert.maxHailSize + " in"
            textViews[6].text += GlobalVariables.newline
        }

        if alert.tornadoThreat != "" {
            textViews[6].text += "TORNADO THREAT..." + alert.tornadoThreat
            textViews[6].text += GlobalVariables.newline
        }
        textViews[6].text += alert.motion + GlobalVariables.newline
        textViews[6].text += alert.vtec + GlobalVariables.newline

        // statusButton.title = cap.windThreat.replace("RADAR INDICATED", "") + " " + cap.maxWindGust + " " + cap.hailThreat.replace("RADAR INDICATED", "") + " " + cap.maxHailSize + hailUnit + " " + cap.tornadoThreat
        
        uiStackView.accessibilityLabel = title + wfo + "Issued: " + startTime +
            "End: " + endTime + alert.area.removeSingleLineBreaks()
            + alert.summary.removeSingleLineBreaks() + alert.instructions.removeSingleLineBreaks()
        textViews.forEach {
            $0.constrain(uiScrollView)
        }
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
        return (title, startTime, endTime)
    }
}
