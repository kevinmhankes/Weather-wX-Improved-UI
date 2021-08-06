// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSettingsMain: UIwXViewController {

    private let titles = [
        "Locations",
        "Colors",
        "Radar",
        "Home Screen",
        "User Interface",
        "Celsius to Fahrenheit table",
        "Spotters",
        "About " + GlobalVariables.appName
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    @objc func actionClick(sender: GestureData) {
        switch sender.strData {
        case "Locations":
            goToVC(vcSettingsLocation())
        case "Radar":
            goToVC(vcSettingsRadar())
        case "User Interface":
            goToVC(vcSettingsUI())
        case "Colors":
            goToVC(vcSettingsColorListing())
        case "Home Screen":
            goToVC(vcSettingsHomescreen())
        case "Spotters":
            goToVC(vcSpotters())
        case "Celsius to Fahrenheit table":
            Route.textViewer(self, UtilityMath.celsiusToFahrenheitTable())
        case "About " + GlobalVariables.appName:
            goToVC(vcSettingsAbout())
        default:
            break
        }
    }

    private func display() {
        titles.forEach { title in
            let text = Text(
                stackView,
                title,
                FontSize.extraLarge.size,
                GestureData(title, self, #selector(actionClick))
            )
            text.constrain(scrollView)
            text.isSelectable = false
        }
    }
}
