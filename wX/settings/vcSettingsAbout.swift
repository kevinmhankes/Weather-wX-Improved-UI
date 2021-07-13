/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsAbout: UIwXViewController {

    private let faqUrl = "https://docs.google.com/document/d/e/2PACX-1vQVkTWlnpRZCSn-ZI7tNLMDHUq-oWp9i1bf8e1yFf1ebEA2CFMapVUsALGJASj2aNhEMYAwBMs4GstL/pub"
    private let releaseNotesUrl = "https://docs.google.com/document/d/e/2PACX-1vRZeQDVwKgzgzO2byDxjxcsTbj9JbwZIU_zhS-r7vUwlIDx1QjcltHThLOmG5P_FKs0Td8bYiQdRMgO/pub"
    private static let copyright = "©"
    private let aboutText = "\(GlobalVariables.appName) is an efficient and configurable method to access weather content from the "
        + "National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + copyright
        + "2016-2021 joshua.tee@gmail.com . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews."
        + " \(GlobalVariables.appName) is bi-licensed under the Mozilla Public License Version 2 as well "
        + "as the GNU General Public License Version 3 or later. "
        + "For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/"
        + " and http://www.gnu.org/licenses/gpl-3.0.en.html" + GlobalVariables.newline
//        + "Keyboard shortcuts: " + GlobalVariables.newline + GlobalVariables.newline
//        + "r: Nexrad radar" + GlobalVariables.newline
//        + "d: Severe Dashboard" + GlobalVariables.newline
//        + "c: GOES viewer" + GlobalVariables.newline
//        + "a: Location text product viewer" + GlobalVariables.newline
//        + "m: open menu" + GlobalVariables.newline
//        + "2: Dual pane nexrad radar" + GlobalVariables.newline
//        + "4: Quad pane nexrad radar" + GlobalVariables.newline
//        + "w: US Alerts" + GlobalVariables.newline
//        + "s: Settings" + GlobalVariables.newline
//        + "e: SPC Mesoanalysis" + GlobalVariables.newline
//        + "n: NCEP Models" + GlobalVariables.newline
//        + "h: Hourly forecast" + GlobalVariables.newline
//        + "t: NHC" + GlobalVariables.newline
//        + "l: Lightning" + GlobalVariables.newline
//        + "i: National images" + GlobalVariables.newline
//        + "z: National text discussions" + GlobalVariables.newline

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    @objc func actionClick(sender: UITapGestureRecognizerWithData) {
        switch sender.strData {
        case "faq":
            Route.web(self, faqUrl)
        case "notes":
            Route.web(self, releaseNotesUrl)
        default:
            break
        }
    }

    private func display() {
        let objectTextView1 = Text(
            stackView,
            "View FAQ (Outage notifications listed at top if any are current)",
            FontSize.extraLarge.size,
            UITapGestureRecognizerWithData("faq", self, #selector(actionClick))
        )
        objectTextView1.color = ColorCompatibility.highlightText
        objectTextView1.tv.isSelectable = false
        objectTextView1.constrain(scrollView)
        let objectTextView2 = Text(
            stackView,
            "View release notes",
            FontSize.extraLarge.size,
            UITapGestureRecognizerWithData("notes", self, #selector(actionClick))
        )
        objectTextView2.color = ColorCompatibility.highlightText
        objectTextView2.tv.isSelectable = false
        objectTextView2.constrain(scrollView)
        let objectTextView3 = Text(
            stackView,
            aboutText + Utility.showDiagnostics(),
            FontSize.medium.size,
            UITapGestureRecognizerWithData("", self, #selector(actionClick))
        )
        objectTextView3.constrain(scrollView)
    }
}
