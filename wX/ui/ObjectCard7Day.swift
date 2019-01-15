/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCard7Day {

    private var isUS = true
    private let sV: ObjectCardStackView
    private let tv = ObjectTextViewLarge(80.0)
    private let tv2 = ObjectTextViewSmallGray(80.0)
    private let img = ObjectCardImage()

    init(_ stackView: UIStackView, _ index: Int, _ dayImgUrl: [String], _ dayArr: [String], _ isUS: Bool) {
        tv.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let sV2 = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tv.view, tv2.view])
        // FIXME add constructor to avoid this
        sV2.view.alignment = UIStackView.Alignment.top
        let sVVertView = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [sV2.view])
        sV = ObjectCardStackView(arrangedSubviews: [img.view, sVVertView.view])
        stackView.addArrangedSubview(sV.view)
        update(index, dayImgUrl, dayArr, isUS)
    }

    func update(_ index: Int, _ dayImgUrl: [String], _ dayArr: [String], _ isUS: Bool) {
        self.isUS = isUS
        setImage(index, dayImgUrl)
        setTextFields(self.format7Day(dayArr[index].replace("</text>", "")))
    }

    func setTextFields(_ textArr: (String, String)) {
        tv.text = textArr.0
        tv2.text = textArr.1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func setImage(_ index: Int, _ dayImgUrl: [String]) {
        if dayImgUrl.count > index {
            img.view.image = UtilityNWS.getIcon(dayImgUrl[index]).image
        }
    }

    func format7Day(_ dayStr: String) -> (String, String) {
        var dayTmpArr = dayStr.split(": ")
        var retStr = ""
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
    }

    func addGestureRecognizer(_ gesture1: UITapGestureRecognizer, _ gesture2: UITapGestureRecognizer) {
        sV.view.addGestureRecognizer(gesture1)
        tv2.view.addGestureRecognizer(gesture2)
    }
}
