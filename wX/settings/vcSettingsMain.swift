/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsMain: UIwXViewController {
    
    private let titles = [
        "Locations",
        "Colors",
        "Radar",
        "Home Screen",
        "User Interface",
        "Celsius to Fahrenheit table",
        "Spotters (beta)",
        "About "  + GlobalVariables.appName
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        displayContent()
    }
    
    override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }
    
    @objc func actionClick(sender: UITapGestureRecognizerWithData) {
        switch sender.strData {
        case "Locations":
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
        titles.forEach { title in
            let objectTextView = ObjectTextView(
                self.stackView,
                title,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData(title, self, #selector(actionClick(sender:)))
            )
            objectTextView.constrain(scrollView)
            objectTextView.tv.isSelectable = false
        }
    }
}
