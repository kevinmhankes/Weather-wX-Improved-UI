/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var urls = [String]()
    private var objImage = ObjectImage()
    private var imageIndex = 0
    private let imageUrls = [
        "http://forecast.weather.gov/wwamap/png/US.png",
        "http://forecast.weather.gov/wwamap/png/ak.png",
        "http://forecast.weather.gov/wwamap/png/hi.png"
    ]

    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {}

    convenience init(
        _ uiv: UIViewController,
        _ stackView: UIStackView,
        _ filter: String,
        _ capAlerts: [CAPAlert],
        _ gesture: UITapGestureRecognizer?,
        showImage: Bool = true
    ) {
        self.init()
        stackView.subviews.forEach {$0.removeFromSuperview()}
        let objTextSummary = ObjectTextView(stackView)
        objTextSummary.addGestureRecognizer(gesture!)
        if showImage {
            objImage = ObjectImage(stackView)
            objImage.addGestureRecognizer(UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked)))
        }
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var state = ""
        var stateCntMap = [String: Int]()
        for alert in capAlerts {
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning")
                    || alert.title.contains("Severe Thunderstorm Warning")
                    || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/FFW/ThunderStorm"
            } else {
                filterBool = (alert.title.hasPrefix(filter))
                filterLabel = filter
            }
            if filterBool {
                var nwsOffice = ""
                var nwsLoc = ""
                if alert.vtec.count > 15 {
                    nwsOffice = alert.vtec.substring(8, 11)
                    nwsLoc = Utility.readPref("NWS_LOCATION_" + nwsOffice, "MI")
                    state = nwsLoc.substring(0, 2)
                    if stateCntMap.keys.contains(state) {
                        stateCntMap[state] = (stateCntMap[state]! + 1)
                    } else {
                        stateCntMap[state] = 1
                    }
                } else {
                    nwsOffice = ""
                    nwsLoc = ""
                }
                _ = ObjectCardAlertSummaryItem(
                    stackView,
                    nwsOffice,
                    nwsLoc,
                    alert,
                    UITapGestureRecognizerWithData(index, uiv, #selector(warningSelected(sender:)))
                )
                self.urls.append(alert.url)
                index += 1
            }
        }
        var stateCnt = ""
        stateCntMap.forEach {stateCnt += "\($0):\($1) "}
        objTextSummary.text = "Filter: " + filterLabel + "(" + String(index) + ")" + MyApplication.newline + stateCnt
    }

    func getUrl(_ index: Int) -> String {
        return urls[index]
    }

    @objc func imageClicked() {}

    func changeImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(self.imageUrls[self.imageIndex])
            self.imageIndex = (self.imageIndex + 1) % self.imageUrls.count
            DispatchQueue.main.async {
                self.objImage.setBitmap(bitmap)
            }
        }
    }

    var image: Bitmap {
        get {
            return self.objImage.bitmap
        }
        set {
            self.objImage.setBitmap(newValue)
        }
    }
}
