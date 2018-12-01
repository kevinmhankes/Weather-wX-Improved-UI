/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class CustomTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 14)]
        appearance.setTitleTextAttributes(attributes as Any as? [NSAttributedStringKey: Any], for: .normal)
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = true
        if let items = self.tabBar.items {
            items.forEach {
                if let image = $0.image {$0.image = image.withRenderingMode(.alwaysOriginal)}
            }
        }
    }
}
