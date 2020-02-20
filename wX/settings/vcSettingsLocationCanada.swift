/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsLocationCanada: UIwXViewController {

    private var textViews = [ObjectTextView]()
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
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        showDisplayProv()
    }

    func showDisplayProv() {
        UtilityCanada.providences.enumerated().forEach {
            let objectTextView = ObjectTextView(
                self.stackView, $1,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData($0, self, #selector(gotoProv(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            self.textViews.append(objectTextView)
        }
    }

    @objc func gotoProv(sender: UITapGestureRecognizerWithData) {
        let position = sender.data
        if !cityDisplay {
            provSelected = UtilityCanada.providences[position].truncate(2)
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
            let html = UtilityCanada.getProvidenceHtml(self.provSelected)
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
            let objectTextView = ObjectTextView(
                self.stackView, $1,
                FontSize.extraLarge.size,
                UITapGestureRecognizerWithData($0, self, #selector(self.gotoProv(sender:)))
            )
            objectTextView.tv.isSelectable = false
            objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            self.textViews.append(objectTextView)
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
