/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    let objLabel: ObjectTextView

    init(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let sunriseSunset = UtilityTime.getSunriseSunset()
        let text =  UtilityTime.gmtTime()
        objLabel = ObjectTextView(
            stackView,
            sunriseSunset + MyApplication.newline + text,
            FontSize.small.size,
            UIColor.black
        )
        objLabel.tv.textAlignment = .center
        addGestureRecognizer(gesture)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        self.objLabel.addGestureRecognizer(gesture)
    }
}
