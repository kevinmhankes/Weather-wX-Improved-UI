/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSevenDayCollection {

    private let scrollView: UIScrollView
    private var sevenDayCardList = [ObjectCardSevenDay]()
    var locationIndex = 0
    var objectCardSunTime: ObjectCardSunTime?

    init(
        _ stackView: UIStackView,
        _ scrollView: UIScrollView,
        _ objSevenDay: ObjectSevenDay,
        _ isUS: Bool = true
    ) {
        self.scrollView = scrollView
        var numCards = 0
        let stackViewLocal7Day = ObjectStackViewHS()
        stackView.addArrangedSubview(stackViewLocal7Day)
        stackViewLocal7Day.setupWithPadding(stackView)
        let days = objSevenDay.forecastList
        let daysShort = objSevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                let objectCardSevenDay = ObjectCardSevenDay(stackViewLocal7Day, index, objSevenDay.icons, days, daysShort, isUS)
                objectCardSevenDay.addGestureRecognizer(
                    UITapGestureRecognizer(
                        target: self,
                        action: #selector(self.sevenDayAction)),
                        UITapGestureRecognizer(target: self, action: #selector(self.sevenDayAction)
                    )
                )
                numCards += 1
                sevenDayCardList.append(objectCardSevenDay)
            }
        }
        if !isUS {
            _ = ObjectCanadaLegal(stackViewLocal7Day)
            numCards += 1
        } else {
            objectCardSunTime = ObjectCardSunTime(
                stackViewLocal7Day,
                UITapGestureRecognizer(target: self, action: #selector(self.sevenDayAction))
            )
            numCards += 1
        }
    }

    func resetTextSize() {
        sevenDayCardList.forEach { item in
            item.resetTextSize()
        }
        objectCardSunTime?.resetTextSize()
    }

    func update(_ objectSevenDay: ObjectSevenDay, _ isUS: Bool = true) {
        let days = objectSevenDay.forecastList
        let daysShort = objectSevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                if sevenDayCardList.count > index {
                    sevenDayCardList[index].update(index, objectSevenDay.icons, days, daysShort, isUS)
                }
            }
        }
    }

    @objc func sevenDayAction() {
        scrollView.scrollToTop()
    }
}
