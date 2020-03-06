/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpotters: UIwXViewController {
    
    private var spotterData = [Spotter]()
    private var spotterDataSorted = [Spotter]()
    private var spotterReportsButton = ObjectToolbarIcon()
    private var spotterCountButton = ObjectToolbarIcon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportsButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        spotterReportsButton.title = "Spotter Reports"
        spotterCountButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                spotterCountButton,
                spotterReportsButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    // FIXME no rotation support
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.spotterData = UtilitySpotter.get()
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    private func displayContent() {
        self.refreshViews()
        self.spotterCountButton.title = "Count: " + String(self.spotterData.count)
        self.spotterDataSorted = self.spotterData.sorted(by: {$1.lastName > $0.lastName})
        self.spotterDataSorted.enumerated().forEach {
            _ = ObjectSpotterCard(self, $1, UITapGestureRecognizerWithData($0, self, #selector(self.buttonPressed(sender:))))
        }
    }
    
    @objc func showSpotterReports() {
        let vc = vcSpotterReports()
        self.goToVC(vc)
    }
    
    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportsButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(index)})
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }
    
    func showMap(_ selection: Int) {
        let vc = vcMapKitView()
        vc.mapKitLat = self.spotterDataSorted[selection].lat
        vc.mapKitLon = self.spotterDataSorted[selection].lon
        vc.mapKitRadius = 20000.0
        self.goToVC(vc)
    }
}
