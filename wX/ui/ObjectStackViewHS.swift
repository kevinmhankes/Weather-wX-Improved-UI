/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackViewHS: UIStackView {

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        axis = .vertical
        alignment = .center
        spacing = 0.0
    }
    
    func setup(_ stackView: UIStackView) {
        self.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        axis = .vertical
        alignment = .center
        spacing = 0.0
    }

    func setupWithPadding() {
        setup()
        spacing = UIPreferences.stackviewCardSpacing
    }
    
    func setupWithPadding(_ stackView: UIStackView) {
        setup(stackView)
        spacing = UIPreferences.stackviewCardSpacing
    }
}
