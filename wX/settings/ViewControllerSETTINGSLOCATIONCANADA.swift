/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        UtilityCanada.provList.enumerated().forEach {
            let objText = ObjectTextView(self.stackView, $1)
            self.tvArr.append(objText)
            objText.addGestureRecognizer(UITapGestureRecognizerWithData(data: $0,
                                                                        target: self,
                                                                        action: #selector(gotoProv(sender:))))
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
            editor.putString("LOCATION_CANADA_PROV", provSelected)
            editor.putString("LOCATION_CANADA_CITY", listCity[position])
            editor.putString("LOCATION_CANADA_ID", listIds[position])
            finishSave()
        }
    }

    func finishSave() {
        let locStr = preferences.getString("LOCATION_CANADA_PROV", "") + " " +
            preferences.getString("LOCATION_CANADA_CITY", "") + " " +
            preferences.getString("LOCATION_CANADA_ID", "")
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
                self.stackView.subviews.forEach { $0.removeFromSuperview() }
                self.cityDisplay = true
                self.listCity.enumerated().forEach {
                    let objText = ObjectTextView(self.stackView, $1)
                    self.tvArr.append(objText)
                    objText.addGestureRecognizer(UITapGestureRecognizerWithData(data: $0,
                                                                                target: self,
                                                                                action: #selector(self.gotoProv(sender:))))
                    objText.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 3)
                }
            }
        }
    }
}
