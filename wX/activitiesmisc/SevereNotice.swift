/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class SevereNotice {

    var numberList = [String]()
    var bitmaps = [Bitmap]()
    private var type = ""

    init(_ type: String) {
        self.type = type
    }

    func getBitmaps(_ html: String) {
        var comp = ""
        var url = ""
        var text = ""
        bitmaps = [Bitmap]()
        switch type {
        case "SPCMCD": comp = "<center>No Mesoscale Discussions are currently in effect."
        case "SPCWAT": comp = "<center><strong>No watches are currently valid"
        case "WPCMPD": comp = "No MPDs are currently in effect."
        default: break
        }
        if !html.contains(comp) {
            text = html
        } else {
            text = ""
        }
        numberList = text.split(":")
        if text != "" {
            (0..<(numberList.count - 1)).forEach {
                switch type {
                case "SPCMCD": url = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + numberList[$0] + ".gif"
                case "SPCWAT": url = MyApplication.nwsSPCwebsitePrefix
                    + "/products/watch/ww" + numberList[$0] + "_radar.gif"
                case "WPCMPD": url = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + numberList[$0] + ".gif"
                default: break
                }
                bitmaps.append(Bitmap(url))
            }
        }
    }
}
