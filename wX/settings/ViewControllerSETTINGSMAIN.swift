/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSMAIN: UIwXViewController {

    var titles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        titles = [
            "Location",
            "Colors",
            "Radar",
            "Home Screen",
            "User Interface",
            "Celsius to Fahrenheit table",
            "Spotters (beta)",
            "About "  + GlobalVariables.appName + " " + UtilityUI.getVersion()
        ]
        displayContent()
    }

    @objc override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    @objc func actionClick(sender: UITapGestureRecognizerWithData) {
        switch sender.strData {
        case "Location":       self.goToVC("settingslocation")
        case "Radar":          self.goToVC("settingsradar")
        case "User Interface": self.goToVC("settingsui")
        case "Colors":         self.goToVC("settingscolorlisting")
        case "Home Screen":    self.goToVC("settingshomescreen")
        case "Spotters (beta)":    self.goToVC("spotters")
        case "Celsius to Fahrenheit table":
            ActVars.textViewProduct = "Celsius to Fahrenheit table"
            ActVars.textViewText = UtilityMath.celsiusToFarenheitTable()
            self.goToVC("textviewer")
        case "About "  + GlobalVariables.appName + " " + UtilityUI.getVersion():
            ActVars.textViewText = GlobalVariables.aboutText
            self.goToVC("textviewer")
        default: break
        }
    }

    private func displayContent() {
        titles.forEach {
            let objectTextView = ObjectTextView(
                self.stackView,
                $0,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData($0, self, #selector(actionClick(sender:)))
            )
            objectTextView.tv.isSelectable = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshViews()
        self.displayContent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
