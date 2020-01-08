/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSMAIN: UIwXViewController {

    var titles = [String]()
    let aboutText = "\(GlobalVariables.appName) is an efficient and configurable method to access weather content from the "
        + "National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + GlobalVariables.copyright
        + "2016-2019 joshua.tee@gmail.com . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews."
        + " \(GlobalVariables.appName) is bi-licensed under the Mozilla Public License Version 2 as well "
        + "as the GNU General Public License Version 3 or later. "
        + "For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/"
        + " and http://www.gnu.org/licenses/gpl-3.0.en.html" + MyApplication.newline
        + "Keyboard shortcuts: " + MyApplication.newline + MyApplication.newline
        + "r: Nexrad radar" + MyApplication.newline
        + "d: Severe Dashboard" + MyApplication.newline
        + "c: GOES viewer" + MyApplication.newline
        + "a: Location text product viewer" + MyApplication.newline
        + "m: open menu" + MyApplication.newline
        + "2: Dual pane nexrad radar" + MyApplication.newline
        + "4: Quad pane nexrad radar" + MyApplication.newline
        + "w: US Alerts" + MyApplication.newline
    + "s: Settings" + MyApplication.newline
    + "e: SPC Mesoanalysis" + MyApplication.newline
    + "n: NCEP Models" + MyApplication.newline
    + "h: Hourly forecast" + MyApplication.newline
    + "t: NHC" + MyApplication.newline
    + "l: Lightning" + MyApplication.newline
    + "i: National images" + MyApplication.newline
    + "z: National text discussions" + MyApplication.newline

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
        case "About "  + GlobalVariables.appName:
            ActVars.textViewText = aboutText
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
