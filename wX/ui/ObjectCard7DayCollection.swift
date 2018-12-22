/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCard7DayCollection {
    
    let scrollView: UIScrollView

    init(
        _ stackView: UIStackView,
        _ scrollView: UIScrollView,
        _ objSevenDay: ObjectForecastPackage7Day,
        _ isUS: Bool = true
        ) {
        self.scrollView = scrollView
        var numCards = 0
        let stackViewLocal7Day = ObjectStackViewHS()
        stackViewLocal7Day.setupWithPadding()
        stackView.addArrangedSubview(stackViewLocal7Day)
        let dayArr = objSevenDay.fcstList
        dayArr.indices.forEach {
            if dayArr[$0] != "" {
                let obj = ObjectCard7Day(stackViewLocal7Day, $0, objSevenDay.icons, dayArr, isUS)
                obj.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(self.sevenDayAction)),
                                         UITapGestureRecognizer(target: self, action: #selector(self.sevenDayAction)))
                numCards += 1
            }
        }
        if !isUS {
            _ = ObjectCALegal(stackViewLocal7Day)
            numCards += 1
        } else {
            _ = ObjectCardSunTime(stackViewLocal7Day)
            numCards += 1
        }
    }

    @objc func sevenDayAction() {
        scrollView.scrollToTop()
    }
}
