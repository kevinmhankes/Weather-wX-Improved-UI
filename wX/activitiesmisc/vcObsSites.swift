// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcObsSites: UIwXViewController {

    private var listCity = [String]()
    private var stateSelected = ""
    private var siteButton = ToolbarIcon()
    private var mapButton = ToolbarIcon()
    private let prefToken = "NWS_OBSSITE_LAST_USED"

    override func viewDidLoad() {
        super.viewDidLoad()
        siteButton = ToolbarIcon(self, #selector(siteClicked))
        mapButton = ToolbarIcon(self, #selector(mapClicked))
        siteButton.title = "Last Used: " + Utility.readPref(prefToken, "")
        mapButton.title = "Map"
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, mapButton, siteButton]).items
        objScrollStackView = ScrollStackView(self)
        constructStateView()
    }

    @objc func goToState(sender: GestureData) {
        stateSelected = sender.strData.split(":")[0]
        showState()
    }

    func showState() {
        let lines = UtilityIO.rawFileToStringArray(R.Raw.stations_us4)
        listCity = ["..Back to state list"]
        var listIds = ["..Back to state list"]
        var listSort = [String]()
        lines.forEach {
            if $0.hasPrefix(stateSelected.uppercased()) {
                listSort.append($0)
            }
        }
        listSort = listSort.sorted()
        listSort.forEach { item in
            let list = item.split(",")
            let id = list[2]
            let city = list[1]
            listCity.append(id + ": " + city)
            listIds.append(id)
        }
        stackView.removeViews()
        listCity.enumerated().forEach { index, city in
            let objectTextView = Text(
                stackView,
                city,
                GestureData(index, self, #selector(gotoObsSite))
            )
            objectTextView.isSelectable = false
            objectTextView.constrain(scrollView)
        }
        scrollView.scrollToTop()
    }

    @objc func gotoObsSite(sender: GestureData) {
        if sender.data == 0 {
            constructStateView()
        } else {
            let site = listCity[sender.data].split(":")[0]
            Utility.writePref(prefToken, site)
            siteButton.title = "Last Used: " + site
            Route.web(self, "https://www.wrh.noaa.gov/mesowest/timeseries.php?sid=" + site)
        }
    }

    func constructStateView() {
        stackView.removeViews()
        GlobalArrays.states.forEach { state in
            let objectTextView = Text(
                stackView,
                state,
                GestureData(state, self, #selector(goToState))
            )
            objectTextView.isSelectable = false
            objectTextView.constrain(scrollView)
        }
    }

    @objc func siteClicked() {
        Route.web(self, "https://www.wrh.noaa.gov/mesowest/timeseries.php?sid=" + Utility.readPref(prefToken, ""))
    }

    @objc func mapClicked() {
        Route.web(self, "https://www.wrh.noaa.gov/map/?obs=true&wfo=" + Location.wfo.lowercased())
    }
}
