/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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

    func setupWithPadding() {
        setup()
        spacing = UIPreferences.stackviewCardSpacing
    }
}
