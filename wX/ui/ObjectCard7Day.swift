/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCard7Day {

    let iconSize = 80.0
    private var isUS = true
    private let horizontalContainer: ObjectCardStackView
    private let topText = ObjectTextViewLarge(80.0)
    private let bottomText = ObjectTextViewSmallGray(80.0)
    private var image = ObjectCardImage()
    let condenseScale: CGFloat = 0.50
    private var stackView: UIStackView

    init(
        _ stackView: UIStackView,
        _ index: Int,
        _ dayImgUrl: [String],
        _ dayArr: [String],
        _ dayArrShort: [String],
        _ isUS: Bool
    ) {
        self.stackView = stackView
        if UIPreferences.mainScreenCondense {
            image = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            image = ObjectCardImage(sizeFactor: 1.0)
        }
        topText.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let verticalTextConainer = ObjectStackView(
            .fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, bottomText.view]
        )
        bottomText.view.widthAnchor.constraint(equalTo: verticalTextConainer.sV.widthAnchor).isActive = true
        verticalTextConainer.view.alignment = UIStackView.Alignment.top
        topText.tv.isAccessibilityElement = false
        bottomText.tv.isAccessibilityElement = false
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [image.view, verticalTextConainer.view])
        horizontalContainer.stackView.isAccessibilityElement = true
        stackView.addArrangedSubview(horizontalContainer.view)
        horizontalContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        var padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        if UtilityUI.isTablet() {
            padding -= 8.0
        }
        verticalTextConainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding).isActive = true
        update(index, dayImgUrl, dayArr, dayArrShort, isUS)
    }

    func update(_ index: Int, _ dayImgUrl: [String], _ dayArr: [String], _ dayArrShort: [String], _ isUS: Bool) {
        self.isUS = isUS
        setImage(index, dayImgUrl)
        setTextFields(self.format7Day(dayArr[index].replace("</text>", ""), dayArrShort[index].replace("</text>", "")))
    }

    func setTextFields(_ textArr: (top: String, bottom: String)) {
        topText.text = textArr.top
        bottomText.text = textArr.bottom.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        horizontalContainer.stackView.accessibilityLabel = textArr.top
            + textArr.bottom.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func resetTextSize() {
        topText.resetTextSize()
        bottomText.resetTextSize()
    }

    func setImage(_ index: Int, _ dayImgUrl: [String]) {
        if dayImgUrl.count > index {
            if !UIPreferences.mainScreenCondense {
                image.view.image = UtilityNws.getIcon(dayImgUrl[index]).image
            } else {
                image.view.image = UtilityImg.resizeImage(UtilityNws.getIcon(dayImgUrl[index]).image, condenseScale)
            }
        }
    }

    func format7Day(_ dayStr: String, _ dayStrShort: String) -> (String, String) {
        let dayTmpArr = dayStr.split(": ")
        let dayTmpArrShort = dayStrShort.split(": ")
        var retStr = ""
        if !UIPreferences.mainScreenCondense || !isUS {
            if dayTmpArr.count > 1 {
                if isUS {
                    retStr = dayTmpArr[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(dayTmpArr[1])
                        + MyApplication.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(dayTmpArr[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(dayTmpArr[1].substring(1))
                        + ")" + MyApplication.newline
                } else {
                    retStr = dayTmpArr[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCATemp(dayTmpArr[1])
                        + MyApplication.degreeSymbol
                        + UtilityLocationFragment.extractCAWindDirection(dayTmpArr[1].substring(1))
                        + UtilityLocationFragment.extractCAWindSpeed(dayTmpArr[1])
                        + ")" + MyApplication.newline
                }
                return (retStr, dayTmpArr[1])
            } else {
                return (retStr, "")
            }
        } else {
            if dayTmpArrShort.count > 1 {
                if isUS {
                    retStr = dayTmpArr[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(dayTmpArr[1])
                        + MyApplication.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(dayTmpArr[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(dayTmpArr[1].substring(1))
                        + ")" + MyApplication.newline
                } else {
                    retStr = dayTmpArr[0].replace(":", " ") + " ("
                        + UtilityLocationFragment.extractCATemp(dayTmpArr[1])
                        + MyApplication.degreeSymbol
                        + UtilityLocationFragment.extractCAWindDirection(dayTmpArr[1].substring(1))
                        + UtilityLocationFragment.extractCAWindSpeed(dayTmpArr[1])
                        + ")" + MyApplication.newline
                }
                return (retStr, dayTmpArrShort[1])
            } else {
                return (retStr, "")
            }
        }
    }

    func addGestureRecognizer(_ gesture1: UITapGestureRecognizer, _ gesture2: UITapGestureRecognizer) {
        horizontalContainer.view.addGestureRecognizer(gesture1)
        bottomText.view.addGestureRecognizer(gesture2)
    }
}
