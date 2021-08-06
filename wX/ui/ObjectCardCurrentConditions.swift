// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectCardCurrentConditions {

    private let objectCardImage: ObjectCardImage
    private let topText: TextLarge = TextLarge(80.0)
    private let middleText: TextSmallGray = TextSmallGray()
    private let condenseScale: CGFloat = 0.50
    private let boxH: ObjectCardStackView

    init(_ box: ObjectStackView, _ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            objectCardImage = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            objectCardImage = ObjectCardImage(sizeFactor: 1.0)
        }
        let boxV = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, middleText.view])
        boxV.alignment = .top
        topText.isAccessibilityElement = false
        middleText.isAccessibilityElement = false
        boxH = ObjectCardStackView(arrangedSubviews: [objectCardImage.view, boxV.view])
        boxH.isAccessibilityElement = true
        box.addLayout(boxH)
        boxH.constrain(box)
        let padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        boxV.constrain(box, padding)
        updateCard(objectCurrentConditions, isUS)
    }

    func updateCard(_ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        setImage(objectCurrentConditions, isUS)
        setText(objectCurrentConditions)
    }

    func setImage(_ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        if isUS {
            let bitmap = UtilityNws.getIcon(objectCurrentConditions.iconUrl)
            if !UIPreferences.mainScreenCondense {
                objectCardImage.setBitmap(bitmap)
            } else {
                objectCardImage.setImage(UtilityImg.resizeImage(bitmap.image, condenseScale))
            }
        } else {
            let iconName = UtilityCanada.translateIconNameCurrentConditions(objectCurrentConditions.data, objectCurrentConditions.status)
            objectCardImage.setBitmap(UtilityNws.getIcon(iconName))
        }
    }

    func setText(_ objectCurrentConditions: ObjectCurrentConditions) {
        topText.text = objectCurrentConditions.topLine.trimnl()
        middleText.text = objectCurrentConditions.middleLine.trim()
        boxH.accessibilityLabel = objectCurrentConditions.spokenText
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
        objectCardImage.view.addGestureRecognizer(gesture1)
        topText.view.addGestureRecognizer(gesture2)
        middleText.view.addGestureRecognizer(gesture3)
    }
}
