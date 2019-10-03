/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCALegal {

    init(_ stackView: UIStackView) {
        _ = ObjectTextView(stackView, MyApplication.mainScreenCaDisclaimor, FontSize.small.size, ColorCompatibility.secondaryLabel)
    }
}
