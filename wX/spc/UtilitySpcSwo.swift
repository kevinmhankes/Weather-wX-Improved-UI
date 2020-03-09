/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySpcSwo {

    static func getImageUrls(_ day: String, getAllImages: Bool = true) -> [Bitmap] {
        var urls = [String]()
        if day == "48" {
            urls = (4...8).map {
                MyApplication.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + String($0) + "prob.gif"
            }
            return urls.map { Bitmap($0) }
        }
        let html = (MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
        let time = html.parseFirst("show_tab\\(.otlk_([0-9]{4}).\\)")
        switch day {
        case "1", "2":
            let baseUrl = MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
            urls.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".gif")
            ["_torn.gif", "_hail.gif", "_wind.gif"].forEach { product in
                urls.append(baseUrl + time + product)
            }
        case "3":
            ["otlk_", "prob_"].forEach { product in
                urls.append(MyApplication.nwsSPCwebsitePrefix + "/products/outlook/day" + day + product + time + ".gif")
            }
        default:
            break
        }
        if getAllImages {
            return urls.map { Bitmap($0) }
        } else {
            return [Bitmap(urls[0])]
        }
    }
}
