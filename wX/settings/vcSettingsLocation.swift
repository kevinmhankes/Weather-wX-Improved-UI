/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsLocation: UIwXViewController {
    
    private var locations = [String]()
    private var fab: ObjectFab?
    private var productButton = ObjectToolbarIcon()
    private var objectCards = [ObjectCardLocationItem]()
    private var currentConditions = [ObjectForecastPackageCurrentConditions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        fab = ObjectFab(self, #selector(addClicked), iconType: .plus)
    }
    
    override func willEnterForeground() {}
    
    override func getContent() {
        currentConditions = []
        DispatchQueue.global(qos: .userInitiated).async {
            MyApplication.locations.indices.forEach { index in
                self.currentConditions.append(ObjectForecastPackageCurrentConditions(index))
            }
            DispatchQueue.main.async {
                self.objectCards.indices.forEach { index in
                    self.objectCards[index].tvCurrentConditions.text = self.currentConditions[index].topLine
                    MyApplication.locations[index].updateObservation(self.currentConditions[index].topLine)
                }
            }
        }
    }
    
    @objc override func doneClicked() {
        Location.refreshLocationData()
        super.doneClicked()
    }
    
    @objc func addClicked() {
        let vc = vcSettingsLocationEdit()
        vc.settingsLocationEditNum = "0"
        self.goToVC(vc)
    }
    
    @objc func actionLocationPopup(sender: UITapGestureRecognizerWithData) {
        let locName = MyApplication.locations[sender.data].name
        let alert = ObjectPopUp(self, locName, productButton)
        alert.addAction(
            UIAlertAction(
                title: "Edit \"" + locName + "\"",
                style: .default,
                handler: {_ in self.actionLocation(sender.data)}
            )
        )
        if Location.numLocations > 1 {
            alert.addAction(
                UIAlertAction(
                    title: "Delete \"" + locName + "\"",
                    style: .default,
                    handler: {_ in self.deleteLocation(sender.data)})
            )
            alert.addAction(
                UIAlertAction(
                    title: "Move Up",
                    style: .default,
                    handler: {_ in self.moveUp(sender.data)})
            )
            alert.addAction(
                UIAlertAction(
                    title: "Move Down",
                    style: .default,
                    handler: {_ in self.moveDown(sender.data)})
            )
        }
        alert.finish()
    }
    
    func actionLocation(_ position: Int) {
        let vc = vcSettingsLocationEdit()
        vc.settingsLocationEditNum = locations[position].split(":")[0]
        self.goToVC(vc)
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
        displayContent()
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
        displayContent()
    }
    
    func deleteLocation(_ position: Int) {
        if Location.numLocations > 1 {
            Location.deleteLocation(String(position + 1))
            displayContent()
        }
    }
    
    func initializeObservations() {
        (0..<Location.numLocations).forEach { index in
            MyApplication.locations[index].updateObservation("")
        }
    }
    
    func displayContent() {
        objectCards = []
        self.stackView.removeViews()
        locations = []
        (0..<Location.numLocations).forEach { index in
            locations.append(String(index + 1))
            let name = MyApplication.locations[index].name
            let observation = MyApplication.locations[index].observation
            let latLon = MyApplication.locations[index].lat.truncate(10) + ", " + MyApplication.locations[index].lon.truncate(10)
            let details = "WFO: " + MyApplication.locations[index].wfo + " Radar: " + MyApplication.locations[index].rid
            objectCards.append(ObjectCardLocationItem(
                self,
                name,
                observation,
                details + " (" + latLon + ")",
                UITapGestureRecognizerWithData(index, self, #selector(actionLocationPopup(sender:)))
                )
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeObservations()
        displayContent()
        self.getContent()
    }
}
