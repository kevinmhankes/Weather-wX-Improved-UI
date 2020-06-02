/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class SevereNotice {
    
    var numberList = [String]()
    var bitmaps = [Bitmap]()
    let type: PolygonEnum
    
    init(_ type: PolygonEnum) {
        self.type = type
    }
    
    func getBitmaps() {
        let noAlertsVerbiage: String
        let html: String
        bitmaps = []
        switch type {
        case .SPCMCD:
            noAlertsVerbiage = "No Mesoscale Discussions are currently in effect."
            html = MyApplication.mcdNoList.value
        case .SPCWAT:
            noAlertsVerbiage = "No watches are currently valid"
            html = MyApplication.watNoList.value
        case .WPCMPD:
            noAlertsVerbiage = "No MPDs are currently in effect."
            html = MyApplication.mpdNoList.value
        default:
            noAlertsVerbiage = ""
            html = ""
        }
        var text: String
        if !html.contains(noAlertsVerbiage) {
            text = html
        } else {
            text = ""
        }
        numberList = text.split(":").filter { $0 != "" }
        if text != "" {
            numberList.forEach {
                var url: String
                switch type {
                case .SPCMCD:
                    url = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + $0 + ".gif"
                case .SPCWAT:
                    url = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + $0 + "_radar.gif"
                case .WPCMPD:
                    url = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + $0 + ".gif"
                default:
                    url = ""
                }
                bitmaps.append(Bitmap(url))
            }
        }
    }
}
