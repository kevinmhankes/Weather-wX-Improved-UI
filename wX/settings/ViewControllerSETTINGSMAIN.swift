/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSMAIN: UIwXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        let titles = ["Location",
                      "Colors",
                      "PlayList",
                      "Radar",
                      "Home Screen",
                      "User Interface",
                      "Celsius to Fahrenheit table"
        ]
        titles.forEach {
            let objText = ObjectTextView(self.stackView, $0)
            objText.textSize = 1.5
            objText.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(actionClick(sender:))))
        }
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
        case "PlayList":       self.goToVC("playlist")
        case "Celsius to Fahrenheit table":
            ActVars.TEXTVIEWProd = "Celsius to Fahrenheit table"
            ActVars.TEXTVIEWText = UtilityMath.celsiusToFarenheitTable()
            self.goToVC("textviewer")
        default: break
        }
    }
}
