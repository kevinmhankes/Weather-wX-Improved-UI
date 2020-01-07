/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

class GlobalVariables {
    static var globalSynth = AVSpeechSynthesizer()
    static let flexBarButton = UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
        target: nil,
        action: nil
    )
    static let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    static let preferences = Preferences()
    static let editor = Editor()
    static let copyright = "©"
    static let appName = "wXL23"
    static let appCreatorEmail = "joshua.tee@gmail.com"
    static let aboutText = "\(appName) is an efficient and configurable method to access weather content from the "
        + "National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + copyright
        + "2016-2019 joshua.tee@gmail.com . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews."
        + " \(appName) is bi-licensed under the Mozilla Public License Version 2 as well "
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
}
