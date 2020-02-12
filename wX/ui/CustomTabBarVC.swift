/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class CustomTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 14)]
        appearance.setTitleTextAttributes(attributes as Any as? [NSAttributedString.Key: Any], for: .normal)
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = true
        if let items = self.tabBar.items {
            items.forEach {
                if let image = $0.image {
                    $0.image = image.withRenderingMode(.alwaysOriginal)
                }
            }
        }
        
        
        /*let firstViewController = vcTabLocation()
        firstViewController.tabBarItem = UITabBarItem(title: "LOCAL", image: nil, tag: 0)
        let secondViewController = vcTabSpc()
        secondViewController.tabBarItem = UITabBarItem(title: "SPC", image: nil, tag: 1)
        let thirdViewController = vcTabMisc()
        thirdViewController.tabBarItem = UITabBarItem(title: "MISC", image: nil, tag: 2)
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        viewControllers = tabBarList*/
        
    }
}
