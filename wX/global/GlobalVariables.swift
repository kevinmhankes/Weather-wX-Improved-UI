/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

var globalSynth = AVSpeechSynthesizer()

let mapRegionRadius = 1000000.0

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
