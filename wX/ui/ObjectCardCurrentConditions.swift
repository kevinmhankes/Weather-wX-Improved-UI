/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCurrentConditions {

    private let objectCardImage: ObjectCardImage
    private let topText: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let middleText: ObjectTextViewSmallGray = ObjectTextViewSmallGray()
    private let condenseScale: CGFloat = 0.50
    private let horizontalContainer: ObjectCardStackView

    init(_ stackView: UIStackView, _ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        if UIPreferences.mainScreenCondense {
            objectCardImage = ObjectCardImage(sizeFactor: condenseScale)
        } else {
            objectCardImage = ObjectCardImage(sizeFactor: 1.0)
        }
        let verticalTextContainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [topText.view, middleText.view])
        verticalTextContainer.view.alignment = UIStackView.Alignment.top
        topText.tv.isAccessibilityElement = false
        middleText.tv.isAccessibilityElement = false
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [objectCardImage.view, verticalTextContainer.view])
        horizontalContainer.view.isAccessibilityElement = true
        stackView.addArrangedSubview(horizontalContainer.view)
        horizontalContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        let padding: CGFloat = CGFloat(-UIPreferences.nwsIconSize - 6.0)
        verticalTextContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding).isActive = true
        updateCard(objectCurrentConditions, isUS)
    }

    func updateCard(_ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        setImage(objectCurrentConditions, isUS)
        setText(objectCurrentConditions)
    }

    func setImage(_ objectCurrentConditions: ObjectCurrentConditions, _ isUS: Bool) {
        if isUS {
            if !UIPreferences.mainScreenCondense {
                objectCardImage.view.image = UtilityNws.getIcon(objectCurrentConditions.iconUrl).image
            } else {
                objectCardImage.view.image = UtilityImg.resizeImage(
                    UtilityNws.getIcon(objectCurrentConditions.iconUrl).image,
                    condenseScale
                )
            }
        } else {
            objectCardImage.view.image = UtilityNws.getIcon(
                UtilityCanada.translateIconNameCurrentConditions(
                    objectCurrentConditions.data,
                    objectCurrentConditions.status
                )
            ).image
        }
    }

    func setText(_ objectCurrentConditions: ObjectCurrentConditions) {
        topText.text = objectCurrentConditions.topLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        middleText.text = objectCurrentConditions.middleLine.trimmingCharacters(in: .whitespaces)
        horizontalContainer.view.accessibilityLabel = objectCurrentConditions.spokenText
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
