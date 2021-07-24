/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcTabParent: UIViewController {

    var scrollView = UIScrollView()
    var stackView = ObjectStackView(.fill, .horizontal)
    var objTileMatrix = ObjectTileMatrix()
    var fab: ObjectFab?
    var objScrollStackView: ScrollStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        setTabBarColor()
        objScrollStackView = ScrollStackView(self, scrollView, stackView.get())
        if UIPreferences.mainScreenRadarFab {
            fab = ObjectFab(self, #selector(radarClicked))
        }
    }

    func setTabBarColor() {
        tabBarController?.tabBar.barTintColor = UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            let selectedIndex = tabBarController!.selectedIndex
            if selectedIndex == 2 {
                tabBarController!.selectedIndex = 0
            } else {
                tabBarController!.selectedIndex = selectedIndex + 1
            }
        }
        if sender.direction == .right {
            let selectedIndex = tabBarController!.selectedIndex
            if selectedIndex == 0 {
                tabBarController!.selectedIndex = 2
            } else {
                tabBarController!.selectedIndex = selectedIndex - 1
            }
        }
    }

    @objc func swipeRight() {
        let selectedIndex = tabBarController!.selectedIndex
        if selectedIndex == 0 {
            tabBarController!.selectedIndex = 2
        } else {
            tabBarController!.selectedIndex = selectedIndex - 1
        }
    }

    @objc func swipeLeft() {
        let selectedIndex = tabBarController!.selectedIndex
        if selectedIndex == 2 {
            tabBarController!.selectedIndex = 0
        } else {
            tabBarController!.selectedIndex = selectedIndex + 1
        }
    }

    @objc func escape() {
        tabBarController!.selectedIndex = 0
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

    @objc func warningsClicked() {
        let vc = vcUSAlerts()
        objTileMatrix.genericClicked(vc)
    }

    func refreshViews() {
        removeAllViews()
        scrollView = UIScrollView()
        stackView = ObjectStackView(.fill, .horizontal)
        objScrollStackView = ScrollStackView(self, scrollView, stackView.get())
        if UIPreferences.mainScreenRadarFab {
            fab = ObjectFab(self, #selector(radarClicked))
        }
    }

    func removeAllViews() {
        view.subviews.forEach { $0.removeFromSuperview() }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                } else {
                    AppColors.update()
                }
                updateColors()
            } else {
            }
        }
    }

    func updateColors() {
        setTabBarColor()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        if UIPreferences.mainScreenRadarFab {
            fab?.setColor()
        }
    }

    @objc func willEnterForeground() {
        updateColors()
    }
}
