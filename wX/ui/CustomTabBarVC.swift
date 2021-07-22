/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class CustomTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        if let items = tabBar.items {
            items.forEach {
                if let image = $0.image { $0.image = image.withRenderingMode(.alwaysOriginal) }
            }
        }
        // To remove dependancy on storyboard uncomment the following and 3 lines in AppDelegate.application
        // In Deployment Info change Main Interface from Main to ""
        /*
        let firstViewController = vcTabLocation()
        firstViewController.tabBarItem = UITabBarItem(title: "LOCAL", image: nil, tag: 0)
        let secondViewController = vcTabSpc()
        secondViewController.tabBarItem = UITabBarItem(title: "SPC", image: nil, tag: 1)
        let thirdViewController = vcTabMisc()
        thirdViewController.tabBarItem = UITabBarItem(title: "MISC", image: nil, tag: 2)
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        viewControllers = tabBarList
         */
    }
}
