/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardSevenDay {

    private var isUS = true
    private let horizontalContainer: ObjectCardStackView
    private let topText = ObjectTextViewLarge(80.0)
    private let bottomText = ObjectTextViewSmallGray()
    private let objectCardImage: ObjectCardImage
    private let condenseScale: CGFloat = 0.50
    private let stackView: UIStackView

    init(_ stackView: UIStackView, _ index: Int, _ urls: [String], _ days: [String], _ daysShort: [String], _ isUS: Bool) {
        self.stackView = stackView
        if UIPreferences.mainScreenCondense {
            objectCardImage = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            objectCardImage = ObjectCardImage(sizeFactor: 1.0)
        }
        topText.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let verticalTextContainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, bottomText.view])
        bottomText.view.widthAnchor.constraint(equalTo: verticalTextContainer.view.widthAnchor).isActive = true
        verticalTextContainer.view.alignment = UIStackView.Alignment.top
        topText.tv.isAccessibilityElement = false
        bottomText.tv.isAccessibilityElement = false
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [objectCardImage.view, verticalTextContainer.view])
        horizontalContainer.view.isAccessibilityElement = true
        stackView.addArrangedSubview(horizontalContainer.view)
        horizontalContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        let padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        verticalTextContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding).isActive = true
        update(index, urls, days, daysShort, isUS)
    }

    func update(_ index: Int, _ urls: [String], _ days: [String], _ daysShort: [String], _ isUS: Bool) {
        self.isUS = isUS
        setImage(index, urls)
        setTextFields(formatSevenDay(days[index].replace("</text>", ""), daysShort[index].replace("</text>", "")))
    }

    func setTextFields(_ labels: (top: String, bottom: String)) {
        topText.text = labels.top.replace("\"", "")
        bottomText.text = labels.bottom.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        horizontalContainer.view.accessibilityLabel = labels.top
            + labels.bottom.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
        let string: String
        if !UIPreferences.mainScreenCondense || !isUS {
            if items.count > 1 {
                if isUS {
                    string = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    string = items[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCanadaTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractCanadaWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extractCanadaWindSpeed(items[1])
                        + ")" + GlobalVariables.newline
                }
                return (string, items[1])
            } else {
                return ("", "")
            }
        } else {
            if itemsShort.count > 1 {
                if isUS {
                    string = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    string = items[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCanadaTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractCanadaWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extractCanadaWindSpeed(items[1])
                        + ")" + GlobalVariables.newline
                }
                return (string, itemsShort[1])
            } else {
                return ("", "")
            }
        }
    }

    func addGestureRecognizer(_ gesture1: UITapGestureRecognizer, _ gesture2: UITapGestureRecognizer) {
        horizontalContainer.view.addGestureRecognizer(gesture1)
        bottomText.view.addGestureRecognizer(gesture2)
    }
}
