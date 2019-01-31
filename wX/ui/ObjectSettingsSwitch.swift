/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSettingsSwitch {

    let button = UIButton(type: UIButton.ButtonType.system)
    let switchUi = UISwitch()
    var prefMap = [String: String]()

    init(_ stackView: UIStackView, _ prefVar: String, _ boolDefArray: [String: String], _ prefMap: [String: String]) {
        self.prefMap = prefMap
        [button, switchUi].forEach {
            $0.backgroundColor = UIColor.white
        }
        button.contentHorizontalAlignment = .left
        button.setTitle(prefMap[prefVar], for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        switchUi.thumbTintColor = AppColors.primaryDarkBlueUIColor
        switchUi.onTintColor = AppColors.primaryColorUIColor
        switchUi.setOn(Utility.readPref(prefVar, boolDefArray[prefVar]!).hasPrefix("t"), animated: true)
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [button, switchUi])
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(bounds.0 - (UIPreferences.stackviewCardSpacing * 2.0))
        ).isActive = true
        stackView.addArrangedSubview(horizontalContainer.view)
    }
}
