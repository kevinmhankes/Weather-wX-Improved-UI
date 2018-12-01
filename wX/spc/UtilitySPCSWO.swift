/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySPCSWO {

    static let day1BaseUrl = MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day1probotlk_"
    static let day1Urls = ["_torn.gif", "_hail.gif", "_wind.gif"]

    static func getImageUrls(_ day: String, getAllImages: Bool=true) -> [Bitmap] {
        var imgURLs = [String]()
        if day == "48" {
            imgURLs = (4...8).map {
                MyApplication.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + String($0) + "prob.gif"
            }
            return imgURLs.map {Bitmap($0)}
        }
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
        let time = html.parseFirst("show_tab\\(.otlk_([0-9]{4}).\\)")
        switch day {
        case "1":
            imgURLs.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day1otlk_" + time + ".gif")
            day1Urls.forEach {imgURLs.append(day1BaseUrl + time + $0)}
        case "2":
            imgURLs.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day2otlk_" + time + ".gif")
            imgURLs.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day2probotlk_" + time + "_any.gif")
        case "3":
            ["otlk_", "prob_"].forEach {
                imgURLs.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + $0 + time + ".gif")
            }
        default: break
        }
        if getAllImages {
            return imgURLs.map {Bitmap($0)}
        } else {
            return [Bitmap(imgURLs[0])]
        }
    }
}
