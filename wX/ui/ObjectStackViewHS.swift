/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackViewHS: UIStackView {

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        axis = .vertical
        alignment = .center
        spacing = 0.0
    }

    func setupWithPadding() {
        setup()
        spacing = UIPreferences.stackviewCardSpacing
    }
}
