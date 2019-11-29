/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    var objLabel = ObjectTextView()
    var sunriseSunset = ""
    var gmtTimetext = ""

    init(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomescreen()
        gmtTimetext =  UtilityTime.gmtTime()
        objLabel = ObjectTextView(
            stackView,
            sunriseSunset + MyApplication.newline + gmtTimetext,
            FontSize.small.size,
            ColorCompatibility.label
        )
        objLabel.tv.textAlignment = .center
        objLabel.addGestureRecognizer(gesture)
    }

    func update() {
        sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomescreen()
        gmtTimetext =  UtilityTime.gmtTime()
        objLabel.text = sunriseSunset + MyApplication.newline + gmtTimetext
    }
}
