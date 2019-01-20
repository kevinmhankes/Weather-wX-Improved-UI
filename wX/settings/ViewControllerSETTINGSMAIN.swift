/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSMAIN: UIwXViewController {

    var titles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        titles = [
            "Location",
            "Colors",
            "Radar",
            "Home Screen",
            "User Interface",
            "Celsius to Fahrenheit table",
            "About "  + MyApplication.appName + " " + UtilityUI.getVersion()
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
        case "Celsius to Fahrenheit table":
            ActVars.textViewProduct = "Celsius to Fahrenheit table"
            ActVars.textViewText = UtilityMath.celsiusToFarenheitTable()
            self.goToVC("textviewer")
        case "About "  + MyApplication.appName + " " + UtilityUI.getVersion():
            ActVars.textViewText = MyApplication.aboutStr + " " + UtilityUI.getVersion()
            self.goToVC("textviewer")
        default: break
        }
    }

    private func displayContent() {
        titles.forEach {
            let objText = ObjectTextView(self.stackView, $0)
            objText.textSize = 1.5
            objText.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(actionClick(sender:))))
        }
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
