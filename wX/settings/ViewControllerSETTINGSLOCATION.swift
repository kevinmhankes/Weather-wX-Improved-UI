/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSLOCATION: UIwXViewController {

    var addButton = ObjectToolbarIcon()
    var locations = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = ObjectToolbarIcon(self, .plus, #selector(addClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, addButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        updateView()
    }

    @objc override func doneClicked() {
        Location.refreshLocationData()
        super.doneClicked()
    }

    @objc func addClicked() {
        ActVars.settingsLocationEditNum = "0"
        self.goToVC("settingslocationedit")
    }

    @objc func actionLocationPopup(sender: UITapGestureRecognizerWithData) {
        let locName = MyApplication.locations[sender.data].name
        let alert = ObjectPopUp(self, locName, addButton)
        alert.addAction(UIAlertAction(title: "Edit \"" + locName + "\"",
                                      style: .default,
                                      handler: {_ in self.actionLocation(sender.data)}))
        if Location.numLocations > 1 {
            alert.addAction(UIAlertAction(title: "Delete \"" + locName + "\"",
                                          style: .default,
                                          handler: {_ in self.deleteLocation(sender.data)}))
            alert.addAction(UIAlertAction(title: "Move Up",
                                          style: .default,
                                          handler: {_ in self.moveUp(sender.data)}))
            alert.addAction(UIAlertAction(title: "Move Down",
                                          style: .default,
                                          handler: {_ in self.moveDown(sender.data)}))
        }
        alert.finish()
    }

    func actionLocation(_ position: Int) {
        ActVars.settingsLocationEditNum = locations[position].split(":")[0]
        self.goToVC("settingslocationedit")
    }

    func moveUp(_ position: Int) {
        if position > 0 {
            let locA = Location(position - 1)
            let locB = Location(position)
            locA.saveLocationToNewSlot(position)
            locB.saveLocationToNewSlot(position - 1)
        } else {
            let locA = Location(Location.numLocations-1)
            let locB = Location(0)
            locA.saveLocationToNewSlot(0)
            locB.saveLocationToNewSlot(Location.numLocations-1)
        }
        updateView()
    }

    func moveDown(_ position: Int) {
        if position < (Location.numLocations - 1) {
            let locA = Location(position)
            let locB = Location(position + 1)
            locA.saveLocationToNewSlot(position + 1)
            locB.saveLocationToNewSlot(position)
        } else {
            let locA = Location(position)
            let locB = Location(0)
            locA.saveLocationToNewSlot(0)
            locB.saveLocationToNewSlot(position)
        }
        updateView()
    }

    func deleteLocation(_ position: Int) {
        if Location.numLocations > 1 {
            Location.deleteLocation(String(position + 1))
            updateView()
        }
    }

    func updateView() {
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        locations = []
        (0..<Location.numLocations).forEach {
            let locationStr = (String($0+1)
                + ": \(MyApplication.locations[$0].name) \(MyApplication.locations[$0].lat)"
                + " \(MyApplication.locations[$0].lon) "
                + "\(MyApplication.locations[$0].wfo) \(MyApplication.locations[$0].rid)"
                + " \(MyApplication.locations[$0].state)")
            locations.append(locationStr)
            let latLon = "\(MyApplication.locations[$0].lat) \(MyApplication.locations[$0].lon)"
            let off = "WFO:\(MyApplication.locations[$0].wfo) RID:\(MyApplication.locations[$0].rid)"
            let objLocCard = ObjectTextView(stackView,
                                            Location.getName($0)
                                                + MyApplication.newline
                                                + latLon
                                                + MyApplication.newline
                                                + off)
            objLocCard.addGestureRecognizer(
                UITapGestureRecognizerWithData($0, self, #selector(self.actionLocationPopup(sender:)))
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
}
