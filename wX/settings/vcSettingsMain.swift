/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsMain: UIwXViewController {

    private var titles = [String]()

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
            "About "  + GlobalVariables.appName
        ]
        displayContent()
    }

    @objc override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    @objc func actionClick(sender: UITapGestureRecognizerWithData) {
        switch sender.strData {
        case "Location":
            let vc = vcSettingsLocation()
            self.goToVC(vc)
        case "Radar":
            let vc = vcSettingsRadar()
            self.goToVC(vc)
        case "User Interface":
            let vc = vcSettingsUI()
            self.goToVC(vc)
        case "Colors":
            let vc = vcSettingsColorListing()
            self.goToVC(vc)
        case "Home Screen":
            let vc = vcSettingsHomescreen()
            self.goToVC(vc)
        case "Spotters (beta)":
            let vc = vcSpotters()
            self.goToVC(vc)
        case "Celsius to Fahrenheit table":
            let vc = vcTextViewer()
            vc.textViewProduct = "Celsius to Fahrenheit table"
            vc.textViewText = UtilityMath.celsiusToFarenheitTable()
            self.goToVC(vc)
        case "About "  + GlobalVariables.appName:
            let vc = vcSettingsAbout()
            self.goToVC(vc)
        default:
            break
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
            objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            objectTextView.tv.isSelectable = false
        }
    }
}
