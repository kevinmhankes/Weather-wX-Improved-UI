/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSettingsSwitch {

    private let button = UIButton(type: UIButton.ButtonType.system)
    let switchUi = UISwitch()
    private let prefMap: [String: String]

    init(_ stackView: UIStackView, _ prefVar: String, _ boolDefArray: [String: String], _ prefMap: [String: String]) {
        self.prefMap = prefMap
        button.backgroundColor = ColorCompatibility.systemBackground
        button.setTitleColor(ColorCompatibility.label, for: .normal)
        switchUi.backgroundColor = ColorCompatibility.systemBackground
        button.contentHorizontalAlignment = .left
        button.setTitle(prefMap[prefVar], for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.font = FontSize.medium.size
        switchUi.thumbTintColor = AppColors.primaryDarkBlueUIColor
        switchUi.onTintColor = ColorCompatibility.label
        switchUi.setOn(Utility.readPref(prefVar, boolDefArray[prefVar]!).hasPrefix("t"), animated: true)
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [button, switchUi])
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        horizontalContainer.view.widthAnchor.constraint(
            equalToConstant: CGFloat(width - (UIPreferences.stackviewCardSpacing * 2.0))
        ).isActive = true
        stackView.addArrangedSubview(horizontalContainer.view)
    }
}
