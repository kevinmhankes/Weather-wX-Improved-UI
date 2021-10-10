// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSettingsAbout: UIwXViewController {

    private let faqUrl = "https://gitlab.com/joshua.tee/wxl23/-/tree/master/doc/FAQ.md"
    private let releaseNotesUrl = "https://gitlab.com/joshua.tee/wxl23/-/tree/master/doc/ChangeLog_User.md"
    private let nwsStatusUrl = "https://forecast.weather.gov/product.php?site=NWS&product=ADA&issuedby=SDM"
    private static let copyright = "©"
    private let aboutText = GlobalVariables.appName + " is an efficient and configurable method to access weather content from the "
        + "National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + copyright
        + "2016-2021 joshua.tee@gmail.com . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews. "
        + GlobalVariables.appName + " is bi-licensed under the Mozilla Public License Version 2 as well "
        + "as the GNU General Public License Version 3 or later. "
        + "For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/"
        + " and http://www.gnu.org/licenses/gpl-3.0.en.html" + GlobalVariables.newline

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon("version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    @objc func actionClick(sender: GestureData) {
        switch sender.strData {
        case "faq":
            Route.web(self, faqUrl)
        case "notes":
            Route.web(self, releaseNotesUrl)
        case "nwsStatus":
            Route.web(self, nwsStatusUrl)
        default:
            break
        }
    }

    private func display() {
        let text1 = Text(
            stackView,
            "View FAQ (Outage notifications listed at top if any are current)",
            FontSize.extraLarge.size,
            GestureData("faq", self, #selector(actionClick))
        )
        text1.color = ColorCompatibility.highlightText
        text1.isSelectable = false
        text1.constrain(scrollView)
        
        let text2 = Text(
            stackView,
            "View release notes",
            FontSize.extraLarge.size,
            GestureData("notes", self, #selector(actionClick))
        )
        text2.color = ColorCompatibility.highlightText
        text2.isSelectable = false
        text2.constrain(scrollView)
        
        let text4 = Text(
            stackView,
            "NWS Status",
            FontSize.extraLarge.size,
            GestureData("nwsStatus", self, #selector(actionClick))
        )
        text4.color = ColorCompatibility.highlightText
        text4.isSelectable = false
        text4.constrain(scrollView)
        
        let text3 = Text(
            stackView,
            aboutText + Utility.showDiagnostics(),
            FontSize.medium.size,
            GestureData("", self, #selector(actionClick))
        )
        text3.constrain(scrollView)
    }
}
