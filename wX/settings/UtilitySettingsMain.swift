/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySettingsMain {

    static let boolean = [String: String]()

    static let helpStrings = [
        "Show count for tor/tst/ffw warnings on main screen": "Check for Severe Thunderstorm, Flash Flood, "
            + "and Tornado warnings at the selected interval. "
            + "The text in the tab headings is then modified. This also requires a periodic job run at the "
            + "notification interval to download warning data.",
        "Show SPC MPD/WAT count on main screen": "Check for SPC MCD or Watches at the selected interval. "
            + "The text in the tab headings is then modified. "
            + "This also requires a periodic job run at the notification interval to download warning data.",
        "Show WPC MPD count on main screen": "Check for WPC MPD at the selected interval. The text in the "
            + "tab headings is then modified. "
            + "This also requires a periodic job run at the notification interval to download warning data."
        ]

    static let booleanDefault = [
        "CHECKTOR": "false" ,
        "CHECKSPC": "false",
        "CHECKWPC": "false"
        ]
}
