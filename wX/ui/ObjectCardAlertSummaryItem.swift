/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    init(
        _ stackView: ObjectStackView,
        _ wfo: String,
        _ wfoName: String,
        _ alert: CapAlert,
        _ radarSite: String,
        _ gesture: GestureData,
        _ gestureRadar: GestureData,
        _ gestureRadarText: GestureData
    ) {
        // start icons
        let radarIcon = ToolbarIcon(iconType: .radar, gesture: gestureRadar)
        let radarText = Text("Radar")
        radarText.addGesture(gestureRadarText)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let boxH = ObjectStackView(
            .fillProportionally,
            .horizontal,
            spacing: 10,
            arrangedSubviews: [radarIcon.button, radarText.view, spacerView]
        )
        // horizontalContainer.uiStackView.distribution = .equalSpacing
        // end icons
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let tvName = TextLarge(0.0, text: wfo + " (" + wfoName + ")", color: ColorCompatibility.highlightText)
        let tvTitle = Text(title, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvStart = Text("Start: " + startTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvEnd = Text("End: " + endTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvArea = TextSmallGray(text: alert.area, isUserInteractionEnabled: false)
        tvName.isAccessibilityElement = false
        tvTitle.isAccessibilityElement = false
        tvStart.isAccessibilityElement = false
        tvEnd.isAccessibilityElement = false
        tvArea.isAccessibilityElement = false
        let boxV = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view, boxH.view]
        )
        if wfoName == "" {
            tvName.view.isHidden = true
        }
        if endTime == "" {
            tvEnd.view.isHidden = true
        }
        if radarSite == "" {
//            radarIcon.button.isHidden = true
//            radarText.isHidden = true
            boxH.isHidden = true
        }
        boxV.isAccessibilityElement = true
        boxV.accessibilityLabel = title + "Start: " + startTime + "End: " + endTime + alert.area
        let cardStackView = ObjectCardStackView(boxV)
        stackView.addLayout(cardStackView.view)
        cardStackView.addGesture(gesture)
        boxV.constrain(stackView)
    }
}
