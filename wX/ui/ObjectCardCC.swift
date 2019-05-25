/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

// FIXME rename
final class ObjectCardCC {

    private var image = ObjectCardImage()
    private let topText: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let middleText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    private let bottomText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    let condenseScale: CGFloat = 0.50

    // FIXME rename objFcst
    init(_ stackView: UIStackView, _ objCc: ObjectForecastPackageCurrentConditions, _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            image = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            image = ObjectCardImage(sizeFactor: 1.0)
        }
        let verticalTextConainer: ObjectStackView
        if UIPreferences.showMetarInCC {
            verticalTextConainer = ObjectStackView(
                .fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, middleText.view, bottomText.view]
            )
        } else {
            verticalTextConainer = ObjectStackView(
                .fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, middleText.view]
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
        updateCard(objCc, isUS)
    }

    func updateCard(_ objCc: ObjectForecastPackageCurrentConditions, _ isUS: Bool) {
        setImage(objCc, isUS)
        setText(objCc)
    }

    func setImage(_ objCc: ObjectForecastPackageCurrentConditions, _ isUS: Bool) {
        if isUS {
            if !UIPreferences.mainScreenCondense {
                image.view.image = UtilityNws.getIcon(objCc.iconUrl).image
            } else {
                image.view.image = UtilityImg.resizeImage(
                    UtilityNws.getIcon(objCc.iconUrl).image,
                    condenseScale
                )
            }
        } else {
            image.view.image = UtilityNws.getIcon(
                UtilityCanada.translateIconNameCurrentConditions(
                    objCc.data,
                    objCc.status
                )
            ).image
        }
    }

    func setText(_ objCc: ObjectForecastPackageCurrentConditions) {
        topText.text = objCc.topLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        middleText.text = objCc.middleLine.trimmingCharacters(in: .whitespaces)
        bottomText.text = objCc.rawMetar
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
