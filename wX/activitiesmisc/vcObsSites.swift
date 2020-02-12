/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcObsSites: UIwXViewController {

    private var capAlerts = [CapAlert]()
    private var filter = ""
    private var listCity = [String]()
    private var stateView = true
    private var stateSelected = ""
    private var siteButton = ObjectToolbarIcon()
    private var mapButton = ObjectToolbarIcon()
    private let prefToken = "NWS_OBSSITE_LAST_USED"

    override func viewDidLoad() {
        super.viewDidLoad()
        siteButton = ObjectToolbarIcon(self, #selector(siteClicked))
        mapButton = ObjectToolbarIcon(self, #selector(mapClicked))
        self.siteButton.title = "Last Used: " + Utility.readPref(prefToken, "")
        self.mapButton.title = "Map"
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, mapButton, siteButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        constructStateView()
    }

    @objc func gotoState(sender: UITapGestureRecognizerWithData) {
        stateSelected = GlobalArrays.states[sender.data].split(":")[0]
        showState()
    }

    func showState() {
        stateView = false
        var idTmp = ""
        var cityTmp = ""
        let lines = UtilityIO.rawFileToStringArray(R.Raw.stations_us4)
        listCity = []
        var listIds = [String]()
        var listSort = [String]()
        listCity.append("..Back to state list")
        listIds.append("..Back to state list")
        var tmpArr = [String]()
        lines.forEach {
            if $0.hasPrefix(stateSelected.uppercased()) {
                listSort.append($0)
            }
        }
        listSort = listSort.sorted()
        listSort.forEach {
            tmpArr = $0.split(",")
            idTmp = tmpArr[2]
            cityTmp = tmpArr[1]
            listCity.append(idTmp + ": " + cityTmp)
            listIds.append(idTmp)
        }
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        listCity.enumerated().forEach {
            let objectTextView = ObjectTextView(
                stackView,
                $1,
                UITapGestureRecognizerWithData($0, self, #selector(gotoObsSite(sender:)))
            )
            objectTextView.tv.isSelectable = false
        }
        self.scrollView.scrollToTop()
    }

    @objc func gotoObsSite(sender: UITapGestureRecognizerWithData) {
        if sender.data == 0 {
            constructStateView()
        } else {
            let site = listCity[sender.data].split(":")[0]
            Utility.writePref(prefToken, site)
            self.siteButton.title = "Last Used: " + site
            let vc = vcWebView()
            vc.webViewShowProduct = false
            vc.webViewUseUrl = true
            vc.webViewUrl = "https://www.wrh.noaa.gov/mesowest/timeseries.php?sid=" + site
            self.goToVC(vc)
        }
    }

    func constructStateView() {
        self.stateView = true
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        GlobalArrays.states.enumerated().forEach {
            let objectTextView = ObjectTextView(
                stackView,
                $1,
                UITapGestureRecognizerWithData($0, self, #selector(gotoState(sender:)))
            )
            objectTextView.tv.isSelectable = false
        }
    }

    @objc func siteClicked() {
        let vc = vcWebView()
        vc.webViewShowProduct = false
        vc.webViewUseUrl = true
        vc.webViewUrl = "https://www.wrh.noaa.gov/mesowest/timeseries.php?sid=" + Utility.readPref(prefToken, "")
        self.goToVC(vc)
    }

    @objc func mapClicked() {
        let vc = vcWebView()
        vc.webViewShowProduct = false
        vc.webViewUseUrl = true
        vc.webViewUrl = "https://www.wrh.noaa.gov/map/?obs=true&wfo=" + Location.wfo.lowercased()
        self.goToVC(vc)
    }

    private func displayContent() {
        if stateView {
            constructStateView()
        } else {
            showState()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
