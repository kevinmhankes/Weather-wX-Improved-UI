/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardDashAlertItem {

    let cardStackView: ObjectCardStackView

    init(
        _ stackView: UIStackView,
        _ senderName: String,
        _ eventType: String,
        _ effectiveTime: String,
        _ expiresTime: String,
        _ areaDescription: String,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let tvName = ObjectTextViewLarge(80.0, text: senderName, color: ColorCompatibility.highlightText)
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        tvName.tv.widthAnchor.constraint(equalToConstant: bounds.0).isActive = true
        let tvTitle = ObjectTextView(eventType, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvStart = ObjectTextView("Start: " + effectiveTime.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""), isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvEnd = ObjectTextView("End: " + expiresTime.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""), isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvArea = ObjectTextViewSmallGray(80.0, text: areaDescription, isUserInteractionEnabled: false)
        tvName.tv.isAccessibilityElement = false
        tvTitle.tv.isAccessibilityElement = false
        tvStart.tv.isAccessibilityElement = false
        tvEnd.tv.isAccessibilityElement = false
        tvArea.tv.isAccessibilityElement = false
        let verticalTextConainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view]
        )
        if senderName == "" {
            tvName.view.isHidden = true
        }
        if expiresTime == "" {
            tvEnd.view.isHidden = true
        }
        verticalTextConainer.view.isAccessibilityElement = true
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
