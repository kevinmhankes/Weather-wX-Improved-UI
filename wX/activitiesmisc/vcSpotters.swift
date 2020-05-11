/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpotters: UIwXViewController {
    
    private var spotterDataSorted = [Spotter]()
    private var spotterReportsButton = ObjectToolbarIcon()
    private var spotterCountButton = ObjectToolbarIcon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportsButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        spotterReportsButton.title = "Spotter Reports"
        spotterCountButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterCountButton, spotterReportsButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    // FIXME no rotation support
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let spotterData = UtilitySpotter.get()
            DispatchQueue.main.async { self.displayContent(spotterData) }
        }
    }
    
    private func displayContent(_ spotterData: [Spotter]) {
        self.refreshViews()
        self.spotterCountButton.title = "Count: " + String(spotterData.count)
        self.spotterDataSorted = spotterData.sorted(by: {$1.lastName > $0.lastName})
        self.spotterDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterCard(self, item, UITapGestureRecognizerWithData(index, self, #selector(self.buttonPressed(sender:))))
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
        Route.map(self, self.spotterDataSorted[selection].location.latString, self.spotterDataSorted[selection].location.lonString)
    }
}
