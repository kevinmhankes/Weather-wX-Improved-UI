/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSevenDayCollection {

    private let uiScrollView: UIScrollView
    var objectCardSevenDayList = [ObjectCardSevenDay]()
    var locationIndex = 0
    var objectCardSunTime: ObjectCardSunTime?

    init(_ stackView: UIStackView, _ scrollView: UIScrollView, _ objectSevenDay: ObjectSevenDay, _ isUS: Bool = true) {
        uiScrollView = scrollView
        var numCards = 0
        let stackViewLocal7Day = ObjectStackViewHS()
        stackView.addArrangedSubview(stackViewLocal7Day)
        stackViewLocal7Day.setupWithPadding(stackView)
        let days = objectSevenDay.forecastList
        let daysShort = objectSevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                let objectCardSevenDay = ObjectCardSevenDay(stackViewLocal7Day, index, objectSevenDay.icons, days, daysShort, isUS)
                objectCardSevenDay.addGestureRecognizer(
                    UITapGestureRecognizer(
                        target: self,
                        action: #selector(sevenDayAction)),
                        UITapGestureRecognizer(target: self, action: #selector(sevenDayAction)
                    )
                )
                numCards += 1
                objectCardSevenDayList.append(objectCardSevenDay)
            }
        }
        if !isUS {
            _ = ObjectCanadaLegal(stackViewLocal7Day)
            numCards += 1
        } else {
            objectCardSunTime = ObjectCardSunTime(
                stackViewLocal7Day,
                UITapGestureRecognizer(target: self, action: #selector(sevenDayAction))
            )
            numCards += 1
        }
    }

    func resetTextSize() {
        objectCardSevenDayList.forEach { $0.resetTextSize() }
        objectCardSunTime?.resetTextSize()
    }

    func update(_ objectSevenDay: ObjectSevenDay, _ isUS: Bool = true) {
        let days = objectSevenDay.forecastList
        let daysShort = objectSevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                if objectCardSevenDayList.count > index {
                    objectCardSevenDayList[index].update(index, objectSevenDay.icons, days, daysShort, isUS)
                }
            }
        }
    }

    @objc func sevenDayAction() {
        uiScrollView.scrollToTop()
    }
}
