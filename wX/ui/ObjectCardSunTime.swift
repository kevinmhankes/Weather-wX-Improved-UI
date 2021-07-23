/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    private let text: Text
    private var sunriseSunset: String
    private var gmtTimeText: String

    init(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomeScreen()
        gmtTimeText = UtilityTime.gmtTime()
        text = Text(
            stackView,
            sunriseSunset + GlobalVariables.newline + gmtTimeText,
            FontSize.small.size,
            ColorCompatibility.label
        )
        text.textAlignment = .center
        text.addGesture(gesture)
    }

    func update() {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomeScreen()
        gmtTimeText = UtilityTime.gmtTime()
        text.text = sunriseSunset + GlobalVariables.newline + gmtTimeText
    }

    func resetTextSize() {
        text.font = FontSize.small.size
    }
}
