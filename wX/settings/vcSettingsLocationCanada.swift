/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsLocationCanada: UIwXViewController {
    
    private var objectTextViews = [ObjectTextView]()
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
        UtilityCanada.provinces.enumerated().forEach { index, province in
            let objectTextView = ObjectTextView(
                stackView,
                province,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData(index, self, #selector(goToProvinces(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
            objectTextViews.append(objectTextView)
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
    
    func finishSave() {
        let locStr = Utility.readPref("LOCATION_CANADA_PROV", "") + " " +
            Utility.readPref("LOCATION_CANADA_CITY", "") + " " +
            Utility.readPref("LOCATION_CANADA_ID", "")
        statusButton.title = locStr
        doneClicked()
    }
    
    override func willEnterForeground() {}
    
    override func getContent() {
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
        stackView.removeViews()
        cityDisplay = true
        listCity.enumerated().forEach { index, city in
            let objectTextView = ObjectTextView(
                stackView,
                city,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData(index, self, #selector(goToProvinces(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
            objectTextViews.append(objectTextView)
        }
    }
}
