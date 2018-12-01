/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

var globalSynth = AVSpeechSynthesizer()
let copyright = "©"
let appName = "wXL23"
let mapRegionRadius = 1000000.0
let appCreatorEmail = "joshua.tee@gmail.com"
let aboutStr = "\(appName) is an efficient and configurable method to access weather content from the National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org. Software is provided \"as is\". Use at your own risk. Use for educational purposes and non-commercial purposes only. Do not use for operational purposes.  " + copyright + "2016-2018 joshua.tee@gmail.com . Please report bugs or suggestions via email to me as opposed to app store reviews. \(appName) is bi-licensed under the Mozilla Public License Version 2 as well as the GNU General Public License Version 3 or later. For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/ and http://www.gnu.org/licenses/gpl-3.0.en.html"
let mainScreenCaDisclaimor = "Data for Canada forecasts and radar provided by http://weather.gc.ca/canada_e.html."
let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
let preferences = Preferences()
let editor = Editor()

enum ToolbarType {
    case top
    case bottom
}

enum TabType {
    case spc
    case misc
}
