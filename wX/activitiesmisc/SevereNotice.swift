/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
        switch type {
        case "mcd": comp = "<center>No Mesoscale Discussions are currently in effect."
        case "wat": comp = "<center><strong>No watches are currently valid"
        case "mpd": comp = "No MPDs are currently in effect."
        default: break
        }
        if !dataAsStringMCD.contains(comp) {
            switch type {
            case "mcd": break
            case "wat": break
            case "mpd": break
            default:    break
            }
            text = dataAsStringMCD
        } else {
            text = ""
        }
        numberList = text.split(":")
        if text != "" {
            (0..<(numberList.count - 1)).forEach {
                switch type {
                case "mcd": url = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + numberList[$0] + ".gif"
                case "wat": url = MyApplication.nwsSPCwebsitePrefix
                    + "/products/watch/ww" + numberList[$0] + "_radar.gif"
                case "mpd": url = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + numberList[$0] + ".gif"
                default: break
                }
                bitmaps.append(Bitmap(url))
            }
        }
    }
}
