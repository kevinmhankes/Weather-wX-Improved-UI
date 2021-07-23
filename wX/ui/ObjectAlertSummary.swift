/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var urls = [String]()
    var radarSites = [String]()

    @objc func warningSelected(sender: GestureData) {}

    @objc func goToRadar(sender: GestureData) {}

    convenience init(
        _ uiv: UIwXViewController,
        _ stackView: UIStackView,
        _ filter: String,
        _ capAlerts: [CapAlert],
        _ gesture: UITapGestureRecognizer?
    ) {
        self.init()
        let objTextSummary = Text(stackView)
        objTextSummary.addGesture(gesture!)
        objTextSummary.constrain(stackView)
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var stateCountDict = [String: Int]()
        capAlerts.forEach { alert in
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning") || alert.title.contains("Severe Thunderstorm Warning") || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/ThunderStorm/FFW"
            } else {
                filterBool = alert.title.hasPrefix(filter)
                filterLabel = filter
            }
            if filterBool {
                let wfo: String
                let wfoName: String
                if alert.vtec.count > 15 {
                    wfo = alert.vtec.substring(8, 11)
                    wfoName = Utility.getWfoSiteName(wfo)
                    let state = wfoName.substring(0, 2)
                    if stateCountDict.keys.contains(state) {
                        stateCountDict[state] = (stateCountDict[state]! + 1)
                    } else {
                        stateCountDict[state] = 1
                    }
                } else {
                    wfo = ""
                    wfoName = ""
                }
                _ = ObjectCardAlertSummaryItem(
                    stackView,
                    wfo,
                    wfoName,
                    alert,
                    GestureData(index, uiv, #selector(warningSelected)),
                    GestureData(index, uiv, #selector(goToRadar)),
                    GestureData(index, uiv, #selector(goToRadar))
                )
                radarSites.append(alert.getClosestRadar())
                urls.append(alert.url)
                index += 1
            }
        }
        var stateCount = ""
        stateCountDict.forEach { state, count in
            stateCount += state + ": " + to.String(count) + "  "
        }
        objTextSummary.text = "Total alerts: " + to.String(capAlerts.count) + GlobalVariables.newline + "Filter: " + filterLabel + "(" + to.String(index) + " total)" + GlobalVariables.newline + "State counts: " + stateCount
    }

    func getUrl(_ index: Int) -> String {
        urls[index]
    }
}
