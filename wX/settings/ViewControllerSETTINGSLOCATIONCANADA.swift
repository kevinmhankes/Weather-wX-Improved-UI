/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSLOCATIONCANADA: UIwXViewController {

    var tvArr = [ObjectTextView]()
    var html = ""
    var filter = ""
    var cityDisplay = false
    var provSelected = ""
    var listIds = [String]()
    var listCity = [String]()
    var statusButton = ObjectToolbarIcon()
    //var showProv = true

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        showDisplayProv()
    }

    func showDisplayProv() {
        UtilityCanada.provList.enumerated().forEach {
            let objText = ObjectTextView(self.stackView, $1)
            self.tvArr.append(objText)
            objText.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(gotoProv(sender:))))
            objText.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 3)
        }
    }

    @objc func gotoProv(sender: UITapGestureRecognizerWithData) {
        let position = sender.data
        if !cityDisplay {
            provSelected = UtilityCanada.provList[position].truncate(2)
            statusButton.title = "Canadian Locations (" + provSelected + ")"
            getContent()
        } else {
            Utility.writePref("LOCATION_CANADA_PROV", provSelected)
            Utility.writePref("LOCATION_CANADA_CITY", listCity[position])
            Utility.writePref("LOCATION_CANADA_ID", listIds[position])
            finishSave()
        }
    }

    func finishSave() {
        let locStr = Utility.readPref("LOCATION_CANADA_PROV", "") + " " +
            Utility.readPref("LOCATION_CANADA_CITY", "") + " " +
            Utility.readPref("LOCATION_CANADA_ID", "")
        statusButton.title = locStr
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityCanada.getProvHtml(self.provSelected)
            let idTmpAl = html.parseColumn("<li><a href=\"/city/pages/"
                + self.provSelected.lowercased()
                + "-(.*?)_metric_e.html\">.*?</a></li>")
            let idCityAl = html.parseColumn("<li><a href=\"/city/pages/"
                + self.provSelected.lowercased()
                + "-.*?_metric_e.html\">(.*?)</a></li>")
            idTmpAl.forEach {self.listIds.append($0)}
            self.listCity = Array(idCityAl[0 ..< idCityAl.count / 2])
            DispatchQueue.main.async {
                self.showDisplayCity()
            }
        }
    }

    private func showDisplayCity() {
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        self.cityDisplay = true
        self.listCity.enumerated().forEach {
            let objText = ObjectTextView(self.stackView, $1)
            self.tvArr.append(objText)
            objText.addGestureRecognizer(
                UITapGestureRecognizerWithData($0, self, #selector(self.gotoProv(sender:)))
            )
            objText.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 3)
        }
    }

    private func displayContent() {
        if self.cityDisplay {
            showDisplayCity()
        } else {
            showDisplayProv()
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
