/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsLocation: UIwXViewController {

    private var fab: ObjectFab?
    private var productButton = ToolbarIcon()
    private var locationCards = [ObjectCardLocationItem]()
    private var currentConditions = [ObjectCurrentConditions]()

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton]).items
        objScrollStackView = ScrollStackView(self)
        fab = ObjectFab(self, #selector(addClicked), iconType: .plus)
    }

    override func willEnterForeground() {}

    override func getContent() {
        currentConditions.removeAll()
        _ = FutureVoid(download, update)
    }

    func download() {
        (0..<Location.numLocations).forEach {
            self.currentConditions.append(ObjectCurrentConditions($0))
        }
    }

    func update() {
        locationCards.indices.forEach { index in
            locationCards[index].tvCurrentConditions.text = currentConditions[index].topLine
            Location.updateObservation(index, currentConditions[index].topLine)
        }
    }

    override func doneClicked() {
        Location.refreshLocationData()
        super.doneClicked()
    }

    @objc func addClicked() {
        Route.locationAdd(self)
    }

    @objc func actionLocationPopup(sender: GestureData) {
        let locName = Location.getName(sender.data)
        let alert = ObjectPopUp(self, locName, productButton)
        alert.addAction(UIAlertAction(title: "Edit \"" + locName + "\"", style: .default, handler: { _ in self.actionLocation(sender.data) }))
        if Location.numLocations > 1 {
            alert.addAction(UIAlertAction(title: "Delete \"" + locName + "\"", style: .default, handler: { _ in self.deleteLocation(sender.data) }))
            alert.addAction(UIAlertAction(title: "Move Up", style: .default, handler: { _ in self.moveUp(sender.data) }))
            alert.addAction(UIAlertAction(title: "Move Down", style: .default, handler: { _ in self.moveDown(sender.data) }))
        }
        alert.finish()
    }

    func actionLocation(_ position: Int) {
        Route.locationEdit(self, String(position + 1))
    }

    func moveUp(_ position: Int) {
        if position > 0 {
            let locA = ObjectLocation(position - 1)
            let locB = ObjectLocation(position)
            locA.saveToNewSlot(position)
            locB.saveToNewSlot(position - 1)
        } else {
            let locA = ObjectLocation(Location.numLocations - 1)
            let locB = ObjectLocation(0)
            locA.saveToNewSlot(0)
            locB.saveToNewSlot(Location.numLocations - 1)
        }
        display()
    }

    func moveDown(_ position: Int) {
        if position < (Location.numLocations - 1) {
            let locA = ObjectLocation(position)
            let locB = ObjectLocation(position + 1)
            locA.saveToNewSlot(position + 1)
            locB.saveToNewSlot(position)
        } else {
            let locA = ObjectLocation(position)
            let locB = ObjectLocation(0)
            locA.saveToNewSlot(0)
            locB.saveToNewSlot(position)
        }
        display()
    }

    func deleteLocation(_ position: Int) {
        if Location.numLocations > 1 {
            Location.delete(to.String(position + 1))
            display()
        }
    }

    func initializeObservations() {
        (0..<Location.numberOfLocations).forEach {
            Location.updateObservation($0, "")
        }
    }

    func display() {
        locationCards = []
        stackView.removeViews()
        (0..<Location.numberOfLocations).forEach { index in
            let name = Location.getName(index)
            let observation = Location.getObservation(index)
            let latLon = Location.getX(index).truncate(10) + ", " + Location.getY(index).truncate(10)
            let details = "WFO: " + Location.getWfo(index) + " Radar: " + Location.getRid(index)
            locationCards.append(ObjectCardLocationItem(
                    self,
                    name,
                    observation,
                    details + " (" + latLon + ")",
                    GestureData(index, self, #selector(actionLocationPopup))
                )
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeObservations()
        display()
        getContent()
    }
}
