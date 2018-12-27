/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbarItems {

    var items: [UIBarButtonItem]

    init(_ itemsArr: [UIBarButtonItem]) {
        items = itemsArr
        items.forEach {
            $0.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: AppColors.toolbarTextColor],
                for: .normal
            )
        }
    }
}
