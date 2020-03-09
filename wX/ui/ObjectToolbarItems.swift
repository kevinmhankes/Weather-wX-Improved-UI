/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbarItems {

    var items: [UIBarButtonItem]

    init(_ items: [UIBarButtonItem]) {
        self.items = items
        items.forEach { item in
            item.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: AppColors.toolbarTextColor],
                for: .normal
            )
        }
    }
}
