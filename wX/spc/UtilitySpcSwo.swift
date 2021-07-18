/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySpcSwo {
    
    static func getSwoStateUrl(_ state: String, _ day: String) -> String {
        GlobalVariables.nwsSPCwebsitePrefix + "/public/state/images/" + state + "_swody" + day + ".png"
    }

    static func getImageUrls(_ day: String, getAllImages: Bool = true) -> [Bitmap] {
        var urls = [String]()
        if day == "48" {
            urls = (4...8).map { GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + String($0) + "prob.gif" }
            return urls.map { Bitmap($0) }
        }
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
        let time = html.parseFirst("show_tab\\(.otlk_([0-9]{4}).\\)")
        switch day {
        case "1", "2":
            let baseUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
            urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".gif")
            ["_torn.gif", "_hail.gif", "_wind.gif"].forEach { urls.append(baseUrl + time + $0) }
        case "3":
            ["otlk_", "prob_"].forEach { urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + $0 + time + ".gif") }
        default:
            break
        }
        if getAllImages {
            return urls.map { Bitmap($0) }
        } else {
            return [Bitmap(urls[0])]
        }
    }
    
    static func getUrls(_ day: String) -> [String] {
        var imgUrls = [String]()
        if day == "4-8" || day == "48" || day == "4" {
            (4...8).forEach { imgUrls.append("${MyApplication.nwsSPCwebsitePrefix}/products/exper/day4-8/day" + to.String($0) + "prob.gif") }
            return imgUrls
        } else {
            let html = ("${MyApplication.nwsSPCwebsitePrefix}/products/outlook/day" + day + "otlk.html").getHtml()
            let time = html.parse("show_tab\\(.otlk_([0-9]{4}).\\)")
            switch day {
            case "1", "2":
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}otlk_$time.gif")
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_torn.gif")
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_hail.gif")
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_wind.gif")
            case "3":
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day3otlk_$time.gif")
                    imgUrls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day3prob_$time.gif")
            default:
                break
            }
            return imgUrls
        }
    }

    static func getImageUrlsDays48(_ day: String) -> String {
        return GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + day + "prob.gif"
    }
}
