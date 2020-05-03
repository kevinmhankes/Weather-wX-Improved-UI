/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcTabParent: UIViewController {

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var objTileMatrix = ObjectTileMatrix()
    var fab: ObjectFab?
    var objScrollStackView: ObjectScrollStackView?
    
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
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, .TAB)
        if UIPreferences.mainScreenRadarFab { fab = ObjectFab(self, #selector(radarClicked)) }
    }
    
    func setTabBarColor() {
        self.tabBarController?.tabBar.barTintColor = UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
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

    @objc func swipeRight() {
        let selectedIndex = self.tabBarController!.selectedIndex
        if selectedIndex == 0 {
            self.tabBarController!.selectedIndex = 2
        } else {
            self.tabBarController!.selectedIndex = selectedIndex - 1
        }
    }

    @objc func swipeLeft() {
        let selectedIndex = self.tabBarController!.selectedIndex
        if selectedIndex == 2 {
            self.tabBarController!.selectedIndex = 0
        } else {
            self.tabBarController!.selectedIndex = selectedIndex + 1
        }
    }

    @objc func escape() {
        self.tabBarController!.selectedIndex = 0
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

    @objc func dualPaneRadarClicked() {
        objTileMatrix.multiPaneRadarClicked("2")
    }

    @objc func quadPaneRadarClicked() {
        objTileMatrix.multiPaneRadarClicked("4")
    }

    func refreshViews() {
        self.removeAllViews()
        self.scrollView = UIScrollView()
        self.stackView = UIStackView()
        self.objScrollStackView = ObjectScrollStackView(self, self.scrollView, self.stackView, .TAB)
        if UIPreferences.mainScreenRadarFab { fab = ObjectFab(self, #selector(radarClicked)) }
    }

    func removeAllViews() {
        self.view.subviews.forEach { $0.removeFromSuperview() }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
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
        if UIPreferences.mainScreenRadarFab { fab?.setColor() }
    }

    @objc func willEnterForeground() {
        updateColors()
    }

    /*override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputRightArrow,
             modifierFlags: [],
             action: #selector(swipeLeft)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow,
            modifierFlags: [],
            action: #selector(swipeRight)),
            UIKeyCommand(input: UIKeyCommand.inputEscape,
            modifierFlags: [],
            action: #selector(escape)),
            UIKeyCommand(input: "r", modifierFlags: .control, action: #selector(radarClicked)),
            UIKeyCommand(input: "d", modifierFlags: .control, action: #selector(dashClicked)),
            UIKeyCommand(input: "c", modifierFlags: .control, action: #selector(cloudClicked)),
            UIKeyCommand(input: "a", modifierFlags: .control, action: #selector(wfotextClicked)),
            UIKeyCommand(input: "m", modifierFlags: .control, action: #selector(menuClicked)),
            UIKeyCommand(input: "2", modifierFlags: .control, action: #selector(dualPaneRadarClicked)),
            UIKeyCommand(input: "4", modifierFlags: .control, action: #selector(quadPaneRadarClicked)),
            UIKeyCommand(input: "w", modifierFlags: .control, action: #selector(warningsClicked)),
            UIKeyCommand(input: "s", modifierFlags: .control, action: #selector(settingsClicked)),
            UIKeyCommand(input: "e", modifierFlags: .control, action: #selector(mesoanalysisClicked)),
            UIKeyCommand(input: "n", modifierFlags: .control, action: #selector(ncepModelsClicked)),
            UIKeyCommand(input: "h", modifierFlags: .control, action: #selector(hourlyClicked)),
            UIKeyCommand(input: "t", modifierFlags: .control, action: #selector(nhcClicked)),
            UIKeyCommand(input: "l", modifierFlags: .control, action: #selector(lightningClicked)),
            UIKeyCommand(input: "z", modifierFlags: .control, action: #selector(nationalTextClicked)),
            UIKeyCommand(input: "i", modifierFlags: .control, action: #selector(nationalImagesClicked)),
            UIKeyCommand(input: "/", modifierFlags: .control, action: #selector(showKeyboardShortcuts))
        ]
    }*/

    @objc func settingsClicked() {
        let vc = vcSettingsMain()
        objTileMatrix.genericClicked(vc)
    }

    @objc func mesoanalysisClicked() {
        let vc = vcSpcMeso()
        objTileMatrix.genericClicked(vc)
    }

    @objc func ncepModelsClicked() {
        let vc = vcModels()
        vc.modelActivitySelected = "NCEP"
        objTileMatrix.genericClicked(vc)
    }

    @objc func hourlyClicked() {
        if Location.isUS {
            let vc = vcHourly()
            objTileMatrix.genericClicked(vc)
        } else {
            let vc = vcCanadaHourly()
            objTileMatrix.genericClicked(vc)
        }
    }

    @objc func nhcClicked() {
        let vc = vcNhc()
        objTileMatrix.genericClicked(vc)
    }

    @objc func lightningClicked() {
        let vc = vcLightning()
        objTileMatrix.genericClicked(vc)
    }

    @objc func nationalImagesClicked() {
        let vc = vcWpcImg()
        objTileMatrix.genericClicked(vc)
    }

    @objc func nationalTextClicked() {
        let vc = vcWpcText()
        objTileMatrix.genericClicked(vc)
    }

    @objc func showKeyboardShortcuts() {
        UtilityUI.showDialogue(self, Utility.showMainScreenShortCuts())
    }
}
