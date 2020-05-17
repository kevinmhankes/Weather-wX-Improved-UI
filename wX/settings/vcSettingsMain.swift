/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsMain: UIwXViewController {
    
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
            self.goToVC(vcSettingsLocation())
        case "Radar":
            self.goToVC(vcSettingsRadar())
        case "User Interface":
            self.goToVC(vcSettingsUI())
        case "Colors":
            self.goToVC(vcSettingsColorListing())
        case "Home Screen":
            self.goToVC(vcSettingsHomescreen())
        case "Spotters (beta)":
            self.goToVC(vcSpotters())
        case "Celsius to Fahrenheit table":
            Route.textViewer(self, UtilityMath.celsiusToFahrenheitTable())
        case "About "  + GlobalVariables.appName:
            self.goToVC(vcSettingsAbout())
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
