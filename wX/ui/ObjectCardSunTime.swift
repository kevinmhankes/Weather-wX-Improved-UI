/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    private let sVLoc = ObjectStackView(.fill, .horizontal, .center)
    private let objLabel: ObjectTextView

    init(_ stackView: UIStackView) {
        let sunriseSunset = UtilityTime.getSunriseSunset()
        let text =  UtilityTime.gmtTime()
        objLabel = ObjectTextView(
            sVLoc.view,
            sunriseSunset + MyApplication.newline + text,
            UIFont.systemFont(ofSize: 15),
            UIColor.gray
        )
        objLabel.tv.textAlignment = .center
        stackView.addArrangedSubview(sVLoc.view)
    }
}
