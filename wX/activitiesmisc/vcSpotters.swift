/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpotters: UIwXViewController {
    
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
        getContent()
    }
    
    // FIXME no rotation support
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let spotterData = UtilitySpotter.get()
            DispatchQueue.main.async { self.display(spotterData) }
        }
    }
    
    private func display(_ spotterData: [Spotter]) {
        refreshViews()
        spotterCountButton.title = "Count: " + String(spotterData.count)
        spotterDataSorted = spotterData.sorted(by: { $1.lastName > $0.lastName })
        spotterDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterCard(self, item, UITapGestureRecognizerWithData(index, self, #selector(buttonPressed(sender:))))
        }
    }
    
    @objc func showSpotterReports() {
        let vc = vcSpotterReports()
        goToVC(vc)
    }
    
    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportsButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default, handler: { _ in self.showMap(index) })
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }
    
    func showMap(_ selection: Int) {
        Route.map(self, spotterDataSorted[selection].location.latString, spotterDataSorted[selection].location.lonString)
    }
}
