/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    private let text: Text

    init(_ stackView: ObjectStackViewHS, _ gesture: UITapGestureRecognizer) {
        text = Text(stackView, "", FontSize.small.size, ColorCompatibility.label)
        text.textAlignment = .center
        text.addGesture(gesture)
        update()
    }

    func update() {
        let sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomeScreen()
        let gmtTimeText = UtilityTime.gmtTime()
        text.text = sunriseSunset + GlobalVariables.newline + gmtTimeText
    }

    func resetTextSize() {
        text.font = FontSize.small.size
    }
}
