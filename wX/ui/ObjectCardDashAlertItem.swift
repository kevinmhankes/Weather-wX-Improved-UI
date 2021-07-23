/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardDashAlertItem {

    let cardStackView: ObjectCardStackView

    init(
        _ warning: ObjectWarning,
        _ gesture: GestureData,
        _ gestureRadar: GestureData,
        _ gestureRadarText: GestureData
    ) {
        let tvName = TextLarge(80.0, text: warning.sender, color: ColorCompatibility.highlightText)
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        tvName.tv.widthAnchor.constraint(equalToConstant: bounds.0).isActive = true
        let tvTitle = Text(
            warning.event,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let tvStart = Text(
            "Start: " + warning.effective.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""),
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let tvEnd = Text(
            "End: " + warning.expires.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""),
            isUserInteractionEnabled: false, isZeroSpacing: true
        )
        let tvArea = TextSmallGray(text: warning.area, isUserInteractionEnabled: false)
        tvName.isAccessibilityElement = false
        tvTitle.isAccessibilityElement = false
        tvStart.isAccessibilityElement = false
        tvEnd.isAccessibilityElement = false
        tvArea.isAccessibilityElement = false
        // icons
        let radarIcon = ToolbarIcon(iconType: .radar, gesture: gestureRadar)
        let radarText = Text("Radar")
        radarText.addGestureRecognizer(gestureRadarText)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let horizontalContainer = ObjectStackView(
            .fill,
            .horizontal,
            spacing: 10,
            arrangedSubviews: [radarIcon.button, radarText.view, spacerView]
        )
        // horizontalContainer.uiStackView.alignment = .leading
        // horizontalContainer.uiStackView.distribution = .equalSpacing
        // end icons
        let verticalTextContainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view, horizontalContainer.view]
        )
        if warning.sender == "" {
            tvName.isHidden = true
        }
        if warning.expires == "" {
            tvEnd.isHidden = true
        }
        verticalTextContainer.view.isAccessibilityElement = true
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        cardStackView.view.addGestureRecognizer(gesture)
    }

    func get() -> UIView {
        cardStackView.view
    }

    @objc func showRadar() {}
}
