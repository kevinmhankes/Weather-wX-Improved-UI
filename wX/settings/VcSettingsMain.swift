// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsMain: UIwXViewController {

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
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton]).items
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
            Route.settingsLocation(self)
        case "Radar":
            Route.settingsRadar(self)
        case "User Interface":
            Route.settingsUI(self)
        case "Colors":
            Route.settingsColors(self)
        case "Home Screen":
            Route.settingsHomeScreen(self)
        case "Spotters":
            Route.spotters(self)
        case "Celsius to Fahrenheit table":
            Route.textViewer(self, UtilityMath.celsiusToFahrenheitTable(), isFixedWidth: true)
        case "About " + GlobalVariables.appName:
            Route.settingsAbout(self)
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
