/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    init(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let sunriseSunset = UtilityTime.getSunTimesForHomescreen()
        let moonriseSet = UtilityTime.getMoonTimesForHomescreen()
        let text =  UtilityTime.gmtTime()
        let objLabel = ObjectTextView(
            stackView,
            sunriseSunset +
                MyApplication.newline +
                moonriseSet +
                MyApplication.newline + text,
            FontSize.small.size,
            UIColor.black
        )
        objLabel.tv.textAlignment = .center
        objLabel.addGestureRecognizer(gesture)
    }
}
