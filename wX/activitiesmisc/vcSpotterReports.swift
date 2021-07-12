/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpotterReports: UIwXViewController {

    private var spotterReportsDataSorted = [SpotterReports]()
    private var spotterReportCountButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportCountButton = ToolbarIcon(self, nil)
        spotterReportCountButton.title = ""
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterReportCountButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let spotterReportsData = UtilitySpotter.reportsList
            DispatchQueue.main.async { self.display(spotterReportsData) }
        }
    }

    func display(_ spotterReportsData: [SpotterReports]) {
        refreshViews()
        spotterReportCountButton.title = "Count: " + String(spotterReportsData.count)
        spotterReportsDataSorted = spotterReportsData.sorted(by: { $1.time > $0.time })
        spotterReportsDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterReportCard(self, item, UITapGestureRecognizerWithData(index, self, #selector(buttonPressed(sender:))))
        }
        if spotterReportsData.count == 0 {
            let objectTextView = Text(stackView, "No active spotter reports.")
            objectTextView.constrain(scrollView)
        }
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportCountButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(index) })
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }

    func showMap(_ selection: Int) {
        Route.map(self, spotterReportsDataSorted[selection].location.latString, spotterReportsDataSorted[selection].location.lonString)
    }
}
