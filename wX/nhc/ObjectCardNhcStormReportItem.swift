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
        //let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let textViewTop = ObjectTextViewLarge(80.0, text: stormData.name + " (" + stormData.type + ") " + stormData.center, color: UIColor.blue)
        let textViewTime = ObjectTextView(stormData.dateTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let textViewTitle = ObjectTextView(stormData.movement + ", " + stormData.wind + ", " + stormData.pressure, isUserInteractionEnabled: false, isZeroSpacing: true)
        let textViewBottom = ObjectTextViewSmallGray(80.0, text: stormData.headline + " " + stormData.wallet + " " + stormData.atcf, isUserInteractionEnabled: false)
        //let tvArea = ObjectTextViewSmallGray(80.0, text: alert.area, isUserInteractionEnabled: false)
        textViewTop.tv.isAccessibilityElement = false
        textViewTime.tv.isAccessibilityElement = false
        textViewTitle.tv.isAccessibilityElement = false
        textViewBottom.tv.isAccessibilityElement = false
        let verticalTextConainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [textViewTop.view, textViewTime.view, textViewTitle.view, textViewBottom.view]
        )
        verticalTextConainer.view.isAccessibilityElement = true
        //verticalTextConainer.view.accessibilityLabel = title + "Start: " + startTime + "End: " + endTime + alert.area
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
    }
}
