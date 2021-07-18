/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsLocationCanada: UIwXViewController {

    private var objectTextViews = [Text]()
    private var cityDisplay = false
    private var provSelected = ""
    private var listIds = [String]()
    private var listCity = [String]()
    private var statusButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ToolbarIcon(self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        displayProvinces()
    }

    func displayProvinces() {
        UtilityCanada.provinces.enumerated().forEach { index, province in
            let objectTextView = Text(
                stackView,
                province,
                FontSize.extraLarge.size,
                GestureData(index, self, #selector(goToProvinces(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
            objectTextViews.append(objectTextView)
        }
    }

    @objc func goToProvinces(sender: GestureData) {
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

    func finishSave() {
        let locStr = Utility.readPref("LOCATION_CANADA_PROV", "") + " " +
            Utility.readPref("LOCATION_CANADA_CITY", "") + " " +
            Utility.readPref("LOCATION_CANADA_ID", "")
        statusButton.title = locStr
        doneClicked()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureVoid(download, displayCities)
    }

    private func download() {
        let html = UtilityCanada.getProvinceHtml(provSelected)
        let idTmpAl = html.parseColumn("<li><a href=\"/city/pages/" + provSelected.lowercased() + "-(.*?)_metric_e.html\">.*?</a></li>")
        let idCityAl = html.parseColumn("<li><a href=\"/city/pages/" + provSelected.lowercased() + "-.*?_metric_e.html\">(.*?)</a></li>")
        idTmpAl.forEach { listIds.append($0) }
        listCity = Array(idCityAl[0 ..< idCityAl.count / 2])
    }

    private func displayCities() {
        stackView.removeViews()
        cityDisplay = true
        listCity.enumerated().forEach { index, city in
            let objectTextView = Text(
                stackView,
                city,
                FontSize.extraLarge.size,
                GestureData(index, self, #selector(goToProvinces))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
            objectTextViews.append(objectTextView)
        }
    }
}
