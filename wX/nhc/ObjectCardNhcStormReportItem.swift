/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectCardNhcStormReportItem {

    init(
        _ stackView: UIStackView,
        _ stormData: ObjectNhcStormDetails,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let textViewTop = ObjectTextViewLarge(
            80.0,
            text: stormData.name + " (" + stormData.type + ") " + stormData.center,
            color: UIColor.blue
        )
        let textViewTime = ObjectTextView(stormData.dateTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let textViewMovement = ObjectTextView(
            "Moving: " + stormData.movement,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewPressure = ObjectTextView(
            "Min pressure: " + stormData.pressure,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewWindSpeed = ObjectTextView(
            "Max sustained: " + stormData.wind,
            isUserInteractionEnabled: false,
            isZeroSpacing: true
        )
        let textViewBottom = ObjectTextViewSmallGray(
            80.0,
            text: stormData.headline + " " + stormData.wallet + " " + stormData.atcf,
            isUserInteractionEnabled: false
        )
        textViewTop.tv.isAccessibilityElement = false
        textViewTime.tv.isAccessibilityElement = false
        textViewMovement.tv.isAccessibilityElement = false
        textViewPressure.tv.isAccessibilityElement = false
        textViewWindSpeed.tv.isAccessibilityElement = false
        textViewBottom.tv.isAccessibilityElement = false
        let verticalTextConainer = ObjectStackView(
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
        verticalTextConainer.view.isAccessibilityElement = true
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
