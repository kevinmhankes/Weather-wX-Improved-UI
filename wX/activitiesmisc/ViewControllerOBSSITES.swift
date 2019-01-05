/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerOBSSITES: UIwXViewController {

    var capAlerts = [CAPAlert]()
    var filter = ""
    var listCity = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        constructStateView()
    }

    @objc func gotoState(sender: UITapGestureRecognizerWithData) {
        var idTmp = ""
        var cityTmp = ""
        let lines = UtilityIO.rawFileToStringArray(R.Raw.stations_us4)
        listCity = []
        var listIds = [String]()
        var listSort = [String]()
        listCity.append("..Back to state list")
        listIds.append("..Back to state list")
        var tmpArr = [String]()
        let provSelected = GlobalArrays.states[sender.data].split(":")[0]
        lines.forEach {
            if $0.hasPrefix(provSelected.uppercased()) {
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
            let cityTv = ObjectTextView(stackView, $1)
            cityTv.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(self.gotoObsSite(sender:))))
        }
        self.scrollView.scrollToTop()
    }

    @objc func gotoObsSite(sender: UITapGestureRecognizerWithData) {
        if sender.data == 0 {
            constructStateView()
        } else {
            ActVars.webViewShowProduct = false
            ActVars.webViewUseUrl = true
            ActVars.webViewUrl = "http://www.wrh.noaa.gov/mesowest/timeseries.php?sid="
                + listCity[sender.data].split(":")[0]
            self.goToVC("webview")
        }
    }

    func constructStateView() {
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        GlobalArrays.states.enumerated().forEach {
            let stateTv = ObjectTextView(stackView, $1)
            stateTv.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(self.gotoState(sender:))))
        }
    }
}
