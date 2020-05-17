/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsLocation: UIwXViewController {
    
    private var fab: ObjectFab?
    private var productButton = ObjectToolbarIcon()
    private var locationCards = [ObjectCardLocationItem]()
    private var currentConditions = [ObjectCurrentConditions]()
    
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
            MyApplication.locations.indices.forEach { self.currentConditions.append(ObjectCurrentConditions($0)) }
            DispatchQueue.main.async {
                self.locationCards.indices.forEach { index in
                    self.locationCards[index].tvCurrentConditions.text = self.currentConditions[index].topLine
                    MyApplication.locations[index].updateObservation(self.currentConditions[index].topLine)
                }
            }
        }
    }
    
    override func doneClicked() {
        Location.refreshLocationData()
        super.doneClicked()
    }
    
    @objc func addClicked() {
        Route.locationAdd(self)
    }
    
    @objc func actionLocationPopup(sender: UITapGestureRecognizerWithData) {
        let locName = MyApplication.locations[sender.data].name
        let alert = ObjectPopUp(self, locName, productButton)
        alert.addAction(UIAlertAction(title: "Edit \"" + locName + "\"", style: .default, handler: {_ in self.actionLocation(sender.data)}))
        if Location.numLocations > 1 {
            alert.addAction(UIAlertAction(title: "Delete \"" + locName + "\"", style: .default, handler: {_ in self.deleteLocation(sender.data)}))
            alert.addAction(UIAlertAction(title: "Move Up", style: .default, handler: {_ in self.moveUp(sender.data)}))
            alert.addAction(UIAlertAction(title: "Move Down", style: .default, handler: {_ in self.moveDown(sender.data)}))
        }
        alert.finish()
    }
    
    func actionLocation(_ position: Int) {
        Route.locationEdit(self, String(position + 1))
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
        MyApplication.locations.forEach { $0.updateObservation("") }
    }
    
    func displayContent() {
        locationCards = []
        self.stackView.removeViews()
        MyApplication.locations.indices.forEach { index in
            let name = MyApplication.locations[index].name
            let observation = MyApplication.locations[index].observation
            let latLon = MyApplication.locations[index].lat.truncate(10) + ", " + MyApplication.locations[index].lon.truncate(10)
            let details = "WFO: " + MyApplication.locations[index].wfo + " Radar: " + MyApplication.locations[index].rid
            locationCards.append(ObjectCardLocationItem(
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
