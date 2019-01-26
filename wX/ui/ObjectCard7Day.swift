/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCard7Day {

    private var isUS = true
    // TODO HS?
    private let horizontalContainer: ObjectCardStackView
    private let tv = ObjectTextViewLarge(80.0)
    private let tv2 = ObjectTextViewSmallGray(80.0)
    private var img = ObjectCardImage()
    let condenseScale: CGFloat = 0.50

    init(
        _ stackView: UIStackView,
        _ index: Int,
        _ dayImgUrl: [String],
        _ dayArr: [String],
        _ dayArrShort: [String],
        _ isUS: Bool
    ) {
        if UIPreferences.mainScreenCondense {
            img = ObjectCardImage(sizeFactor: condenseScale)
        } else {
             img = ObjectCardImage(sizeFactor: 1.0)
        }
        tv.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let verticalTextConainer = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tv.view, tv2.view])
        verticalTextConainer.view.alignment = UIStackView.Alignment.top
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [img.view, verticalTextConainer.view])
        //horizontalContainer.view.alignment = UIStackView.Alignment.top
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(bounds.0 - (UIPreferences.stackviewCardSpacing * 2.0))
        ).isActive = true
        stackView.addArrangedSubview(horizontalContainer.view)
        update(index, dayImgUrl, dayArr, dayArrShort, isUS)
    }

    func update(_ index: Int, _ dayImgUrl: [String], _ dayArr: [String], _ dayArrShort: [String], _ isUS: Bool) {
        self.isUS = isUS
        setImage(index, dayImgUrl)
        setTextFields(self.format7Day(dayArr[index].replace("</text>", ""), dayArrShort[index].replace("</text>", "")))
    }

    func setTextFields(_ textArr: (String, String)) {
        tv.text = textArr.0
        tv2.text = textArr.1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func setImage(_ index: Int, _ dayImgUrl: [String]) {
        if dayImgUrl.count > index {
            if !UIPreferences.mainScreenCondense {
                img.view.image = UtilityNWS.getIcon(dayImgUrl[index]).image
            } else {
                img.view.image = UtilityImg.resizeImage(UtilityNWS.getIcon(dayImgUrl[index]).image, condenseScale)
            }
        }
    }

    func format7Day(_ dayStr: String, _ dayStrShort: String) -> (String, String) {
        var dayTmpArr = dayStr.split(": ")
        var dayTmpArrShort = dayStrShort.split(": ")
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
        tv2.view.addGestureRecognizer(gesture2)
    }
}
