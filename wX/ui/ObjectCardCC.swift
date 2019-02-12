/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCC {

    private var image = ObjectCardImage()
    private let topText: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let middleText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    private let bottomText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    let condenseScale: CGFloat = 0.50

    init(_ stackView: UIStackView, _ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            image = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            image = ObjectCardImage(sizeFactor: 1.0)
        }
        let verticalTextConainer: ObjectStackView
        if UIPreferences.showMetarInCC {
            verticalTextConainer = ObjectStackView(
                .fill, .vertical, 0, arrangedSubviews: [topText.view, middleText.view, bottomText.view]
            )
        } else {
            verticalTextConainer = ObjectStackView(
                .fill, .vertical, 0, arrangedSubviews: [topText.view, middleText.view]
            )
        }
        verticalTextConainer.view.alignment = UIStackView.Alignment.top
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [image.view, verticalTextConainer.view])
        let stackViewLocalCC = ObjectStackViewHS()
        stackViewLocalCC.setupWithPadding()
        stackView.addArrangedSubview(stackViewLocalCC)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(width - (UIPreferences.stackviewCardSpacing * 2.0))
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
                image.view.image = UtilityNWS.getIcon(objFcst.objCC.iconUrl).image
            } else {
                image.view.image = UtilityImg.resizeImage(
                    UtilityNWS.getIcon(objFcst.objCC.iconUrl).image,
                    condenseScale
                )
            }
        } else {
            image.view.image = UtilityNWS.getIcon(
                UtilityCanada.translateIconNameCurrentConditions(
                    objFcst.objCC.data1,
                    objFcst.objCC.status
                )
            ).image
        }
    }

    func setText(_ objFcst: ObjectForecastPackage) {
        topText.text = objFcst.objCC.ccLine1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        middleText.text = objFcst.objCC.ccLine2.trimmingCharacters(in: .whitespaces)
        bottomText.text = objFcst.objCC.rawMetar
    }

    func addGestureRecognizer(
        _ gesture1: UITapGestureRecognizer,
        _ gesture2: UITapGestureRecognizer,
        _ gesture3: UITapGestureRecognizer
    ) {
        image.view.addGestureRecognizer(gesture1)
        topText.view.addGestureRecognizer(gesture2)
        middleText.view.addGestureRecognizer(gesture3)
    }
}
