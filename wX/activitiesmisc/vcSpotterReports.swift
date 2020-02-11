/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpotterReports: UIwXViewController {

    var spotterReportsData = [SpotterReports]()
    var spotterReportsDataSorted = [SpotterReports]()
    var spotterReportCountButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportCountButton = ObjectToolbarIcon(self, nil)
        spotterReportCountButton.title = ""
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterReportCountButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.view.addSubview(toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.spotterReportsData = UtilitySpotter.reportsList
            DispatchQueue.main.async {
                self.spotterReportCountButton.title = "Count: \(self.spotterReportsData.count)"
                self.spotterReportsDataSorted = self.spotterReportsData.sorted(by: { $1.time > $0.time })
                self.spotterReportsDataSorted.enumerated().forEach {
                    _ = ObjectSpotterReportCard(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(self.buttonPressed(sender:)))
                    )
                }
                if self.spotterReportsData.count == 0 {
                    _ = ObjectTextView(self.stackView, "No active spotter reports.")
                }
            }
        }
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let idx = sender.data
        let alert = ObjectPopUp(self, "", spotterReportCountButton)
        let c = UIAlertAction(
         title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(idx)})
        alert.addAction(c)
        alert.finish()
    }

    func showMap(_ selection: Int) {
        let vc = vcMapKitView()
        vc.mapKitLat = self.spotterReportsDataSorted[selection].location.latString
        vc.mapKitLon = self.spotterReportsDataSorted[selection].location.lonString
        vc.mapKitRadius = 20000.0
        self.goToVC(vc)
    }
}
