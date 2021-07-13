/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcObsSites: UIwXViewController {

    private var listCity = [String]()
    private var stateView = true
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

    @objc func goToState(sender: UITapGestureRecognizerWithData) {
        stateSelected = GlobalArrays.states[sender.data].split(":")[0]
        showState()
    }

    func showState() {
        stateView = false
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
                UITapGestureRecognizerWithData(index, self, #selector(gotoObsSite))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
        }
        scrollView.scrollToTop()
    }

    @objc func gotoObsSite(sender: UITapGestureRecognizerWithData) {
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
        stateView = true
        stackView.removeViews()
        GlobalArrays.states.enumerated().forEach { index, state in
            let objectTextView = Text(
                stackView,
                state,
                UITapGestureRecognizerWithData(index, self, #selector(goToState))
            )
            objectTextView.tv.isSelectable = false
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
