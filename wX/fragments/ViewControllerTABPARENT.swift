/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABPARENT: UIViewController {

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var objTileMatrix = ObjectImageTileMatrix()
    var fab: ObjectFab?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: AppColors.primaryColorRed,
                                                             green: AppColors.primaryColorGreen,
                                                             blue: AppColors.primaryColorBlue,
                                                             alpha: CGFloat(1.0))
        _ = ObjectScrollStackView(self, scrollView, stackView, .TAB)
        if UIPreferences.mainScreenRadarFab {
            fab = ObjectFab(self, #selector(radarClicked))
            self.view.addSubview(fab!.view)
        }
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            let selectedIndex = self.tabBarController!.selectedIndex
            if selectedIndex == 2 {
                self.tabBarController!.selectedIndex = 0
            } else {
                self.tabBarController!.selectedIndex = selectedIndex + 1
            }
        }
        if sender.direction == .right {
            let selectedIndex = self.tabBarController!.selectedIndex
            if selectedIndex == 0 {
                self.tabBarController!.selectedIndex = 2
            } else {
                self.tabBarController!.selectedIndex = selectedIndex - 1
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizer) {
        objTileMatrix.imgClicked(sender: sender)
    }

    @objc func cloudClicked() {
        objTileMatrix.cloudClicked()
    }

    @objc func radarClicked() {
        objTileMatrix.radarClicked()
    }

    @objc func wfotextClicked() {
        objTileMatrix.wfotextClicked()
    }

    @objc func menuClicked() {
        objTileMatrix.menuClicked()
    }

    @objc func dashClicked() {
        objTileMatrix.dashClicked()
    }
}
