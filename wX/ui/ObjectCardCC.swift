/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardCC {

    private let textPadding: CGFloat = 80.0
    private let img = ObjectCardImage()
    private let tv: ObjectTextViewLarge
    private let tv2: ObjectTextViewSmallGray
    private let tv3: ObjectTextViewSmallGray

    init(_ stackView: UIStackView, _ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        let stackViewLocal = ObjectStackViewHS()
        stackViewLocal.setup()
        stackView.addArrangedSubview(stackViewLocal)
        tv = ObjectTextViewLarge(textPadding)
        tv.view.isUserInteractionEnabled = true
        tv2 = ObjectTextViewSmallGray(textPadding)
        tv3 = ObjectTextViewSmallGray(textPadding)
        updateCard(objFcst, isUS)
        var sV2 = StackView()
        // TODO use ObjectStackView instead of raw StackView and UtilityUI below
        if UIPreferences.showMetarInCC {
            sV2 = StackView(arrangedSubviews: [tv.view, tv2.view, tv3.view])
            UtilityUI.setupStackView(sV2)
        } else {
            sV2 = StackView(arrangedSubviews: [tv.view, tv2.view])
            UtilityUI.setupStackView(sV2)
        }
        let sV3 = StackView()
        UtilityUI.setupStackView(sV3)
        let sVVertView = StackView(arrangedSubviews: [sV2, sV3])
        UtilityUI.setupStackView(sVVertView)
        stackViewLocal.addArrangedSubview(ObjectCardStackView(arrangedSubviews: [img.view, sVVertView]).view)
    }

    func updateCard(_ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        setImage(objFcst, isUS)
        setText(objFcst)
    }

    func setImage(_ objFcst: ObjectForecastPackage, _ isUS: Bool) {
        if isUS {
            img.view.image = UtilityNWS.getIcon(objFcst.objCC.iconUrl).image
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
        tv2.text = objFcst.objCC.ccLine2.trimmingCharacters(in: .whitespaces)
        tv3.text = objFcst.objCC.rawMetar
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
