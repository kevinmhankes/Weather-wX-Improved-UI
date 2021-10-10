// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSpotters: UIwXViewController {

    private var spotterData = [Spotter]()
    private var spotterDataSorted = [Spotter]()
    private var spotterReportsButton = ToolbarIcon()
    private var spotterCountButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportsButton = ToolbarIcon(self, #selector(showSpotterReports))
        spotterReportsButton.title = "Spotter Reports"
        spotterCountButton = ToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterCountButton, spotterReportsButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        spotterData.removeAll()
        _ = FutureVoid({ self.spotterData = UtilitySpotter.get() }, display)
    }

    private func display() {
        refreshViews()
        spotterCountButton.title = "Count: " + String(spotterData.count)
        spotterDataSorted = spotterData.sorted { $1.lastName > $0.lastName }
        spotterDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterCard(self, item, GestureData(index, self, #selector(buttonPressed)))
        }
    }

    @objc func showSpotterReports() {
        Route.spotterReports(self)
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportsButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default) { _ in self.showMap(index) }
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }

    func showMap(_ selection: Int) {
        Route.map(self, spotterDataSorted[selection].location.latString, spotterDataSorted[selection].location.lonString)
    }
}
