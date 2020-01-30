/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySpcSwo {

    static func getImageUrls(_ day: String, getAllImages: Bool = true) -> [Bitmap] {
        var imgUrls = [String]()
        if day == "48" {
            imgUrls = (4...8).map {
                MyApplication.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + String($0) + "prob.gif"
            }
            return imgUrls.map {Bitmap($0)}
        }
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
        let time = html.parseFirst("show_tab\\(.otlk_([0-9]{4}).\\)")
        switch day {
        case "1", "2":
            let day1and2Urls = ["_torn.gif", "_hail.gif", "_wind.gif"]
            let baseUrl = MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
            imgUrls.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".gif")
            day1and2Urls.forEach {
                imgUrls.append(baseUrl + time + $0)
            }
        case "3":
            ["otlk_", "prob_"].forEach {
                imgUrls.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + $0 + time + ".gif")
            }
        default: break
        }
        if getAllImages {
            return imgUrls.map {Bitmap($0)}
        } else {
            return [Bitmap(imgUrls[0])]
        }
    }
}
