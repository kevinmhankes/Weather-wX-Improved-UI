/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    let objLabel: ObjectTextView

    init(_ stackView: UIStackView) {
        let sunriseSunset = UtilityTime.getSunriseSunset()
        let text =  UtilityTime.gmtTime()
        objLabel = ObjectTextView(
            stackView,
            sunriseSunset + MyApplication.newline + text,
            UIFont.systemFont(ofSize: 15),
            UIColor.black
        )
        objLabel.tv.textAlignment = .center
    }
}
