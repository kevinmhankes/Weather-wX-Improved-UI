/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpotterReports: UIwXViewController {
    
    private var spotterReportsDataSorted = [SpotterReports]()
    private var spotterReportCountButton = ObjectToolbarIcon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportCountButton = ObjectToolbarIcon(self, nil)
        spotterReportCountButton.title = ""
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterReportCountButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let spotterReportsData = UtilitySpotter.reportsList
            DispatchQueue.main.async { self.displayContent(spotterReportsData) }
        }
    }
    
    func displayContent(_ spotterReportsData: [SpotterReports]) {
        self.refreshViews()
        self.spotterReportCountButton.title = "Count: " + String(spotterReportsData.count)
        self.spotterReportsDataSorted = spotterReportsData.sorted(by: { $1.time > $0.time })
        self.spotterReportsDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterReportCard(self, item, UITapGestureRecognizerWithData(index, self, #selector(self.buttonPressed(sender:))))
        }
        if spotterReportsData.count == 0 {
            let objectTextView = ObjectTextView(self.stackView, "No active spotter reports.")
            objectTextView.constrain(self.scrollView)
        }
    }
    
    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportCountButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(index)})
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }
    
    func showMap(_ selection: Int) {
        Route.map(self, self.spotterReportsDataSorted[selection].location.latString, self.spotterReportsDataSorted[selection].location.lonString)
    }
}
