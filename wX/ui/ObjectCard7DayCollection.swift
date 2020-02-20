/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCard7DayCollection {

    private let scrollView: UIScrollView
    private var sevenDayCardList = [ObjectCard7Day]()
    var locationIndex = 0
    var objectCardSunTime: ObjectCardSunTime?

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
        let dayArr = objSevenDay.forecastList
        let dayArrShort = objSevenDay.forecastListCondensed
        dayArr.indices.forEach {
            if dayArr[$0] != "" {
                let obj = ObjectCard7Day(stackViewLocal7Day, $0, objSevenDay.icons, dayArr, dayArrShort, isUS)
                obj.addGestureRecognizer(
                    UITapGestureRecognizer(
                        target: self,
                        action: #selector(self.sevenDayAction)),
                        UITapGestureRecognizer(target: self, action: #selector(self.sevenDayAction)
                    )
                )
                numCards += 1
                sevenDayCardList.append(obj)
            }
        }
        if !isUS {
            _ = ObjectCALegal(stackViewLocal7Day)
            numCards += 1
        } else {
            objectCardSunTime = ObjectCardSunTime(
                stackViewLocal7Day,
                UITapGestureRecognizer(target: self, action: #selector(self.sevenDayAction))
            )
            numCards += 1
        }
    }
    
    /*func updateWidth() {
        sevenDayCardList.forEach {
            $0.updateWidth()
        }
    }*/

    func resetTextSize() {
        sevenDayCardList.forEach {
            $0.resetTextSize()
        }
        objectCardSunTime?.resetTextSize()
    }

    func update(_ objSevenDay: ObjectForecastPackage7Day, _ isUS: Bool = true) {
        let dayArr = objSevenDay.forecastList
        let dayArrShort = objSevenDay.forecastListCondensed
        dayArr.indices.forEach {
            if dayArr[$0] != "" {
                if sevenDayCardList.count > $0 {
                    sevenDayCardList[$0].update($0, objSevenDay.icons, dayArr, dayArrShort, isUS)
                }
            }
        }
    }

    @objc func sevenDayAction() {
        scrollView.scrollToTop()
    }
}
