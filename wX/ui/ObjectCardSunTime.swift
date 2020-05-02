/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    private let objectTextView: ObjectTextView
    private var sunriseSunset: String
    private var gmtTimetext: String

    init(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomescreen()
        gmtTimetext =  UtilityTime.gmtTime()
        objectTextView = ObjectTextView(
            stackView,
            sunriseSunset + MyApplication.newline + gmtTimetext,
            FontSize.small.size,
            ColorCompatibility.label
        )
        objectTextView.tv.textAlignment = .center
        objectTextView.addGestureRecognizer(gesture)
    }

    func update() {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomescreen()
        gmtTimetext =  UtilityTime.gmtTime()
        objectTextView.text = sunriseSunset + MyApplication.newline + gmtTimetext
    }

    func resetTextSize() {
        objectTextView.tv.font = FontSize.small.size
    }
}
