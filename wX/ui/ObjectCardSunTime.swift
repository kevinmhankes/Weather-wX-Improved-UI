/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSunTime {

    let sVLoc: UIStackView
    let objLabel: ObjectTextView

    init(_ stackView: UIStackView) {
        sVLoc = UIStackView()
        sVLoc.distribution = .fill
        sVLoc.axis = .horizontal
        sVLoc.alignment = .center
        let sunriseSunset = UtilityTime.getSunriseSunset()
        let text =  UtilityTime.gmtTime()
        objLabel = ObjectTextView(
            sVLoc,
            sunriseSunset + MyApplication.newline + text,
            UIFont.systemFont(ofSize: 15),
            UIColor.gray
        )
        objLabel.tv.textAlignment = .center
        stackView.addArrangedSubview(sVLoc)
    }
}
