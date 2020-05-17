/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardNhcStormReportItem {

    init(_ uiStackView: UIStackView, _ stormData: ObjectNhcStormDetails, _ gesture: UITapGestureRecognizerWithData) {
        let textViewTop = ObjectTextViewLarge(
            80.0,
            text: stormData.name + " (" + stormData.classification + ") " + stormData.center,
            color: ColorCompatibility.highlightText
        )
        let textViewTime = ObjectTextView(stormData.dateTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let textViewMovement = ObjectTextView(
            "Moving: " + stormData.movement,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewPressure = ObjectTextView(
            "Min pressure: " + stormData.pressure + " mb",
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewWindSpeed = ObjectTextView(
            "Max sustained: " + stormData.intensity + " mph",
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewBottom = ObjectTextViewSmallGray(
            text: stormData.status + " " + stormData.binNumber + " " + stormData.id.uppercased(),
            isUserInteractionEnabled: false
        )
        [textViewTime, textViewMovement, textViewPressure, textViewWindSpeed].forEach {
            $0.tv.isAccessibilityElement = false
        }
        textViewTop.tv.isAccessibilityElement = false
        textViewBottom.tv.isAccessibilityElement = false
        let verticalTextContainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [
                textViewTop.view,
                textViewTime.view,
                textViewMovement.view,
                textViewPressure.view,
                textViewWindSpeed.view,
                textViewBottom.view
            ]
        )
        verticalTextContainer.view.isAccessibilityElement = true
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        uiStackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
