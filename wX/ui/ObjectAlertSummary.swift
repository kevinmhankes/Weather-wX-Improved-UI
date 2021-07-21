/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var urls = [String]()
    var wfos = [String]()

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
        objTextSummary.addGestureRecognizer(gesture!)
        objTextSummary.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var stateCntMap = [String: Int]()
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
                    if stateCntMap.keys.contains(state) {
                        stateCntMap[state] = (stateCntMap[state]! + 1)
                    } else {
                        stateCntMap[state] = 1
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
                urls.append(alert.url)
                wfos.append(wfo)
                index += 1
            }
        }
        var stateCount = ""
        stateCntMap.forEach { state, count in
            stateCount += state + ":" + to.String(count) + " "
        }
        objTextSummary.text = "Total alerts: " + to.String(capAlerts.count) + GlobalVariables.newline + "Filter: " + filterLabel + "(" + to.String(index) + " total)" + GlobalVariables.newline + "State counts: " + stateCount
    }

    func getUrl(_ index: Int) -> String {
        urls[index]
    }
}
