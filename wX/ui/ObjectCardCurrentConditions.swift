/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCurrentConditions {

    private var image = ObjectCardImage()
    private let topText: ObjectTextViewLarge = ObjectTextViewLarge(80.0)
    private let middleText: ObjectTextViewSmallGray = ObjectTextViewSmallGray(80.0)
    let condenseScale: CGFloat = 0.50
    private var horizontalContainer = ObjectCardStackView()

    init(
        _ stackView: UIStackView,
        _ objectForecastPackageCurrentConditions: ObjectForecastPackageCurrentConditions,
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
        //bottomText.tv.isAccessibilityElement = false
        horizontalContainer = ObjectCardStackView(arrangedSubviews: [image.view, verticalTextConainer.view])
        horizontalContainer.stackView.isAccessibilityElement = true
        let stackViewLocalCC = ObjectStackViewHS()
        stackViewLocalCC.setupWithPadding()
        stackView.addArrangedSubview(stackViewLocalCC)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(width - (UIPreferences.stackviewCardSpacing * 2.0))
        ).isActive = true
        
        stackViewLocalCC.addArrangedSubview(horizontalContainer.view)
        
        //horizontalContainer.view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: //UIPreferences.stackviewCardSpacing - UIPreferences.stackviewCardSpacing).isActive = true
        
        updateCard(objectForecastPackageCurrentConditions, isUS)
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
        //updateTimeStamp()
        horizontalContainer.stackView.accessibilityLabel = objCc.spokenText
    }

    /*func updateTimeStamp() {
        let radarTimeStamp = Utility.readPref("WX_RADAR_CURRENT_INFO", "")
        if radarTimeStamp != "" {
            var radarTimeFinal = ""
            var radarTimeFinalWithDate = ""
            let radarTimeSplit = radarTimeStamp.split(MyApplication.newline)
            if radarTimeSplit.count > 0 {
                radarTimeFinalWithDate = radarTimeSplit[0]
                let radarTimeFinalWithDateInParts = radarTimeFinalWithDate.split(" ")
                if radarTimeFinalWithDateInParts.count > 1 {
                    radarTimeFinal = radarTimeFinalWithDateInParts[1]
                }
            }
            bottomText.text = Location.rid + ": " + radarTimeFinal
            if UtilityTime.isRadarTimeOld(radarTimeFinal) {
                bottomText.tv.textColor = UIColor.red
            } else {
                bottomText.tv.textColor = ColorCompatibility.secondaryLabel
            }
        } else {
            bottomText.text = ""
        }
    }*/

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
