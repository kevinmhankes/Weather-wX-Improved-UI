/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardDashAlertItem {

    let cardStackView: ObjectCardStackView

    init(
        _ uiv: UIwXViewController,
        _ warning: ObjectWarning,
        _ gesture: UITapGestureRecognizerWithData,
        _ gestureRadar: UITapGestureRecognizerWithData,
        _ gestureRadarText: UITapGestureRecognizerWithData
    ) {
        let tvName = ObjectTextViewLarge(80.0, text: warning.sender, color: ColorCompatibility.highlightText)
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        tvName.tv.widthAnchor.constraint(equalToConstant: bounds.0).isActive = true
        let tvTitle = ObjectTextView(
            warning.event,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let tvStart = ObjectTextView(
            "Start: " + warning.effective.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""),
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let tvEnd = ObjectTextView(
            "End: " + warning.expires.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""),
            isUserInteractionEnabled: false, isZeroSpacing: true
        )
        let tvArea = ObjectTextViewSmallGray(text: warning.area, isUserInteractionEnabled: false)
        tvName.tv.isAccessibilityElement = false
        tvTitle.tv.isAccessibilityElement = false
        tvStart.tv.isAccessibilityElement = false
        tvEnd.tv.isAccessibilityElement = false
        tvArea.tv.isAccessibilityElement = false
        // icons
        let radarIcon = ObjectToolbarIcon(iconType: .radar, gesture: gestureRadar)
        let radarText = ObjectTextView("Radar")
        radarText.addGestureRecognizer(gestureRadarText)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let horizontalContainer = ObjectStackView(
            .fillProportionally,
            .horizontal,
            spacing: 10,
            arrangedSubviews: [radarIcon.button, radarText.tv, spacerView]
        )
        horizontalContainer.uiStackView.distribution = .equalSpacing
        // end icons
        let verticalTextContainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view, horizontalContainer.view]
        )
        if warning.sender == "" {
            tvName.view.isHidden = true
        }
        if warning.expires == "" {
            tvEnd.view.isHidden = true
        }
        verticalTextContainer.view.isAccessibilityElement = true
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        uiv.stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
        uiv.stackView.addArrangedSubview(cardStackView.view)
        verticalTextContainer.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }
    
    @objc func showRadar() {}
}
