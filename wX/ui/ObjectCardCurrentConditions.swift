/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCurrentConditions {

    private var image = ObjectCardImage()
    private let topText: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let middleText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    private let condenseScale: CGFloat = 0.50
    private var horizontalContainer = ObjectCardStackView()

    init(
        _ stackView: UIStackView,
        _ objectForecastPackageCurrentConditions: ObjectCurrentConditions,
        _ isUS: Bool
    ) {
        if UIPreferences.mainScreenCondense {
            image = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            image = ObjectCardImage(sizeFactor: 1.0)
        }
        let verticalTextConainer: ObjectStackView
        verticalTextConainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, middleText.view])
        verticalTextConainer.view.alignment = UIStackView.Alignment.top
        topText.tv.isAccessibilityElement = false
        middleText.tv.isAccessibilityElement = false
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [image.view, verticalTextConainer.view])
        horizontalContainer.stackView.isAccessibilityElement = true
        stackView.addArrangedSubview(horizontalContainer.view)
        horizontalContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        let padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        verticalTextConainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding).isActive = true
        updateCard(objectForecastPackageCurrentConditions, isUS)
    }

    func updateCard(_ objCc: ObjectCurrentConditions, _ isUS: Bool) {
        setImage(objCc, isUS)
        setText(objCc)
    }

    func setImage(_ objCc: ObjectCurrentConditions, _ isUS: Bool) {
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

    func setText(_ objCc: ObjectCurrentConditions) {
        topText.text = objCc.topLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        middleText.text = objCc.middleLine.trimmingCharacters(in: .whitespaces)
        horizontalContainer.stackView.accessibilityLabel = objCc.spokenText
    }

    func resetTextSize() {
        topText.resetTextSize()
        middleText.resetTextSize()
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
