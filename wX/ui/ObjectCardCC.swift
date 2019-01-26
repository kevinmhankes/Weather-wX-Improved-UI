/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCC {

    private var img = ObjectCardImage()
    private let tv: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let tv2: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    private let tv3: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    let condenseScale: CGFloat = 0.50

    init(_ stackView: UIStackView, _ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            img = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            img = ObjectCardImage(sizeFactor: 1.0)
        }
        tv.view.isUserInteractionEnabled = true
        let verticalTextConainer: ObjectStackView
        if UIPreferences.showMetarInCC {
            verticalTextConainer = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tv.view, tv2.view, tv3.view])
        } else {
            verticalTextConainer = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tv.view, tv2.view])
        }
        verticalTextConainer.view.alignment = UIStackView.Alignment.top
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [img.view, verticalTextConainer.view])
        let stackViewLocalCC = ObjectStackViewHS()
        stackViewLocalCC.setupWithPadding()
        stackView.addArrangedSubview(stackViewLocalCC)
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(bounds.0 - (UIPreferences.stackviewCardSpacing * 2.0))
        ).isActive = true
        stackViewLocalCC.addArrangedSubview(horizontalContainer.view)
        updateCard(objFcst, isUS)
    }

    func updateCard(_ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        setImage(objFcst, isUS)
        setText(objFcst)
    }

    func setImage(_ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        if isUS {
            if !UIPreferences.mainScreenCondense {
                img.view.image = UtilityNWS.getIcon(objFcst.objCC.iconUrl).image
            } else {
                img.view.image = UtilityImg.resizeImage(UtilityNWS.getIcon(objFcst.objCC.iconUrl).image, condenseScale)
            }
        } else {
            img.view.image = UtilityNWS.getIcon(
                UtilityCanada.translateIconNameCurrentConditions(
                    objFcst.objCC.data1,
                    objFcst.objCC.status
                )
            ).image
        }
    }

    func setText(_ objFcst: ObjectForecastPackage) {
        tv.text = objFcst.objCC.ccLine1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !UIPreferences.mainScreenCondense {
            tv2.text = objFcst.objCC.ccLine2.trimmingCharacters(in: .whitespaces)
            tv3.text = objFcst.objCC.rawMetar
        //}
    }

    func addGestureRecognizer(
        _ gesture1: UITapGestureRecognizer,
        _ gesture2: UITapGestureRecognizer,
        _ gesture3: UITapGestureRecognizer
    ) {
        img.view.addGestureRecognizer(gesture1)
        tv.view.addGestureRecognizer(gesture2)
        tv2.view.addGestureRecognizer(gesture3)
    }
}
