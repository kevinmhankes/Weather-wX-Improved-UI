/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardNhcStormReportItem {

    private let cardStackView: ObjectCardStackView

    init(_ stormData: ObjectNhcStormDetails, _ gesture: GestureData) {
        let textViewTop = TextLarge(
            80.0,
            text: stormData.name + " (" + stormData.classification + ") " + stormData.center,
            color: ColorCompatibility.highlightText
        )
        let textViewTime = Text(stormData.dateTime.replaceAll("T", " ").replaceAll(":00.000Z", "Z"), isUserInteractionEnabled: false, isZeroSpacing: true)
        let textViewMovement = Text(
            "Moving: " + stormData.movement,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewPressure = Text(
            "Min pressure: " + stormData.pressure + " mb",
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewWindSpeed = Text(
            "Max sustained: " + stormData.intensity + " mph",
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewBottom = TextSmallGray(
            text: stormData.status + " " + stormData.binNumber + " " + stormData.id.uppercased(),
            isUserInteractionEnabled: false
        )
        [textViewTime, textViewMovement, textViewPressure, textViewWindSpeed].forEach {
            $0.isAccessibilityElement = false
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
        cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        cardStackView.view.addGestureRecognizer(gesture)
    }

    func get() -> UIView {
        cardStackView.view
    }
}
