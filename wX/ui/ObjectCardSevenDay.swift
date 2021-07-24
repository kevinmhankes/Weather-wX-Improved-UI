/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSevenDay {

    private var isUS = true
    private let boxH: ObjectCardStackView
    private let topText = TextLarge(80.0)
    private let bottomText = TextSmallGray()
    private let objectCardImage: ObjectCardImage
    private let condenseScale: CGFloat = 0.50

    init(_ box: ObjectStackViewHS, _ index: Int, _ urls: [String], _ days: [String], _ daysShort: [String], _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            objectCardImage = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            objectCardImage = ObjectCardImage(sizeFactor: 1.0)
        }
        topText.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let boxV = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, bottomText.view])
        bottomText.constrain(boxV)
        boxV.alignment = .top
        topText.isAccessibilityElement = false
        bottomText.isAccessibilityElement = false
        boxH = ObjectCardStackView(arrangedSubviews: [objectCardImage.view, boxV.view])
        boxH.isAccessibilityElement = true
        box.addLayout(boxH.get())
        boxH.constrain(box.get())
        let padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        boxV.constrain(box.get(), padding)
        update(index, urls, days, daysShort, isUS)
    }

    func update(_ index: Int, _ urls: [String], _ days: [String], _ daysShort: [String], _ isUS: Bool) {
        self.isUS = isUS
        setImage(index, urls)
        setTextFields(formatSevenDay(days[index].replace("</text>", ""), daysShort[index].replace("</text>", "")))
    }

    func setTextFields(_ labels: (top: String, bottom: String)) {
        topText.text = labels.top.replace("\"", "")
        bottomText.text = labels.bottom.trimnl()
        boxH.accessibilityLabel = labels.top + labels.bottom.trimnl()
    }

    func resetTextSize() {
        topText.resetTextSize()
        bottomText.resetTextSize()
    }

    func setImage(_ index: Int, _ urls: [String]) {
        if urls.count > index {
            if !UIPreferences.mainScreenCondense {
                objectCardImage.view.image = UtilityNws.getIcon(urls[index]).image
            } else {
                objectCardImage.view.image = UtilityImg.resizeImage(UtilityNws.getIcon(urls[index]).image, condenseScale)
            }
        }
    }

    func formatSevenDay(_ dayStr: String, _ dayStrShort: String) -> (String, String) {
        let items = dayStr.split(": ")
        let itemsShort = dayStrShort.split(": ")
        let s: String
        if !UIPreferences.mainScreenCondense || !isUS {
            if items.count > 1 {
                if isUS {
                    s = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    s = items[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCanadaTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractCanadaWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extractCanadaWindSpeed(items[1])
                        + ")" + GlobalVariables.newline
                }
                return (s, items[1])
            } else {
                return ("", "")
            }
        } else {
            if itemsShort.count > 1 {
                if isUS {
                    s = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    s = items[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCanadaTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractCanadaWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extractCanadaWindSpeed(items[1])
                        + ")" + GlobalVariables.newline
                }
                return (s, itemsShort[1])
            } else {
                return ("", "")
            }
        }
    }

    func addGestureRecognizer(_ gesture1: UITapGestureRecognizer, _ gesture2: UITapGestureRecognizer) {
        boxH.addGesture(gesture1)
        bottomText.addGesture(gesture2)
    }
}
