/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var urls = [String]()
    var wfos = [String]()
    private var objImage = ObjectImage()
    private var imageIndex = 0
    static let imageUrls = [
        "https://forecast.weather.gov/wwamap/png/US.png",
        "https://forecast.weather.gov/wwamap/png/ak.png",
        "https://forecast.weather.gov/wwamap/png/hi.png"
    ]

    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {}
    
    @objc func goToRadar(sender: UITapGestureRecognizerWithData) {}

    convenience init(
        _ uiv: UIwXViewController,
        _ filter: String,
        _ capAlerts: [CapAlert],
        _ gesture: UITapGestureRecognizer?,
        showImage: Bool = true
    ) {
        self.init()
        uiv.stackView.removeViews()
        let objTextSummary = ObjectTextView(uiv.stackView)
        objTextSummary.addGestureRecognizer(gesture!)
        objTextSummary.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
        if showImage {
            objImage = ObjectImage(uiv.stackView)
            objImage.addGestureRecognizer(UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked)))
        }
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var state = ""
        var stateCntMap = [String: Int]()
        capAlerts.forEach { alert in
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning") || alert.title.contains("Severe Thunderstorm Warning") || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/ThunderStorm/FFW"
            } else {
                filterBool = (alert.title.hasPrefix(filter))
                filterLabel = filter
            }
            if filterBool {
                var nwsOffice = ""
                var nwsLocation = ""
                if alert.vtec.count > 15 {
                    nwsOffice = alert.vtec.substring(8, 11)
                    nwsLocation = Utility.getWfoSiteName(nwsOffice)
                    state = nwsLocation.substring(0, 2)
                    if stateCntMap.keys.contains(state) {
                        stateCntMap[state] = (stateCntMap[state]! + 1)
                    } else {
                        stateCntMap[state] = 1
                    }
                } else {
                    nwsOffice = ""
                    nwsLocation = ""
                }
                _ = ObjectCardAlertSummaryItem(
                    uiv,
                    nwsOffice,
                    nwsLocation,
                    alert,
                    UITapGestureRecognizerWithData(index, uiv, #selector(warningSelected(sender:))),
                    UITapGestureRecognizerWithData(index, uiv, #selector(goToRadar(sender:))),
                    UITapGestureRecognizerWithData(index, uiv, #selector(goToRadar(sender:)))
                )
                self.urls.append(alert.url)
                self.wfos.append(nwsOffice)
                index += 1
            }
        }
        var stateCnt = ""
        stateCntMap.forEach { state, count in
            stateCnt += state + ":" + String(count) + " "
        }
        objTextSummary.text = "Total alerts: " + String(capAlerts.count) + MyApplication.newline + "Filter: " + filterLabel + "(" + String(index) + " total)" + MyApplication.newline + "State counts: " + stateCnt
    }

    func getUrl(_ index: Int) -> String { urls[index] }

    @objc func imageClicked() {}

    func changeImage(_ uiv: UIViewController) {
        let vc = vcImageViewer()
        vc.url = ObjectAlertSummary.imageUrls[0]
        uiv.goToVC(vc)
    }
    
    func getImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.imageIndex = 0
            let bitmap = Bitmap(ObjectAlertSummary.imageUrls[self.imageIndex])
            self.imageIndex = (self.imageIndex + 1) % ObjectAlertSummary.imageUrls.count
            DispatchQueue.main.async {
                self.objImage.setBitmap(bitmap)
            }
        }
    }

    var image: Bitmap {
        get { self.objImage.bitmap }
        set { self.objImage.setBitmap(newValue) }
    }
}
