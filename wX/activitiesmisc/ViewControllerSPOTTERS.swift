/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPOTTERS: UIwXViewController {

    var spotterData = [Spotter]()
    var spotterDataSorted = [Spotter]()
    var spotterReportsButton = ObjectToolbarIcon()
    var spotterCountButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportsButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        spotterReportsButton.title = "Spotter Reports"
        spotterCountButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, spotterCountButton, spotterReportsButton]).items
        stackView.widthAnchor.constraint(
            equalToConstant: self.view.frame.width - UIPreferences.sideSpacing
        ).isActive = true
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }
    
    // TODO add onrestart

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.spotterData = UtilitySpotter.getSpotterData()
            DispatchQueue.main.async {
                self.spotterCountButton.title = "Count: \(self.spotterData.count)"
                self.spotterDataSorted = self.spotterData.sorted(by: {$1.lastName > $0.lastName})
                self.spotterDataSorted.enumerated().forEach {
                    _ = ObjectSpotterCard(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(self.buttonPressed(sender:)))
                    )
                }
            }
        }
    }

    @objc func showSpotterReports() {
        UtilityActions.goToVCS(self, "spotterreports")
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let alert = ObjectPopUp(self, "", spotterReportsButton)
        let c = UIAlertAction(title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(index)})
        alert.addAction(c)
        alert.finish()
    }

    func showMap(_ selection: Int) {
        ActVars.mapKitLat = self.spotterDataSorted[selection].lat
        ActVars.mapKitLon = self.spotterDataSorted[selection].lon
        ActVars.mapKitRadius = 20000.0
        self.goToVC("mapkitview")
    }
}
