/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsLocationCanada: UIwXViewController {

    private var objectTextViews = [ObjectTextView]()
    private var html = ""
    private var filter = ""
    private var cityDisplay = false
    private var provSelected = ""
    private var listIds = [String]()
    private var listCity = [String]()
    private var statusButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        displayProvinces()
    }

    func displayProvinces() {
        UtilityCanada.provinces.enumerated().forEach {
            let objectTextView = ObjectTextView(
                self.stackView, $1,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData($0, self, #selector(goToProvinces(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(self.scrollView)
            self.objectTextViews.append(objectTextView)
        }
    }

    @objc func goToProvinces(sender: UITapGestureRecognizerWithData) {
        let position = sender.data
        if !cityDisplay {
            provSelected = UtilityCanada.provinces[position].truncate(2)
            statusButton.title = "Canadian Locations (" + provSelected + ")"
            getContent()
        } else {
            Utility.writePref("LOCATION_CANADA_PROV", provSelected)
            Utility.writePref("LOCATION_CANADA_CITY", listCity[position])
            Utility.writePref("LOCATION_CANADA_ID", listIds[position])
            finishSave()
        }
    }

    @objc override func doneClicked() {
          super.doneClicked()
    }

    func finishSave() {
        let locStr = Utility.readPref("LOCATION_CANADA_PROV", "") + " " +
            Utility.readPref("LOCATION_CANADA_CITY", "") + " " +
            Utility.readPref("LOCATION_CANADA_ID", "")
        statusButton.title = locStr
        doneClicked()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityCanada.getProvinceHtml(self.provSelected)
            let idTmpAl = html.parseColumn("<li><a href=\"/city/pages/" + self.provSelected.lowercased() + "-(.*?)_metric_e.html\">.*?</a></li>")
            let idCityAl = html.parseColumn("<li><a href=\"/city/pages/" + self.provSelected.lowercased() + "-.*?_metric_e.html\">(.*?)</a></li>")
            idTmpAl.forEach {self.listIds.append($0)}
            self.listCity = Array(idCityAl[0 ..< idCityAl.count / 2])
            DispatchQueue.main.async {
                self.displayCities()
            }
        }
    }

    private func displayCities() {
        self.stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.cityDisplay = true
        self.listCity.enumerated().forEach {
            let objectTextView = ObjectTextView(
                self.stackView, $1,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData($0, self, #selector(self.goToProvinces(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(self.scrollView)
            self.objectTextViews.append(objectTextView)
        }
    }

    private func displayContent() {
        if self.cityDisplay {
            displayCities()
        } else {
            displayProvinces()
        }
    }
}
