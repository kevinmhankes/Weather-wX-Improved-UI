/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPOTTERREPORTS: UIwXViewController {

    var spotterReportsData = [SpotterReports]()
    var spotterReportsDataSorted = [SpotterReports]()
    // FIXME
    //var spotterReportCountButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        //spotterReportCountButton = ObjectToolbarIcon(self, "", nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.view.addSubview(toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.spotterReportsData = UtilitySpotter.reportsList
            DispatchQueue.main.async {
                //self.spotterReportCountButton.title = "Count: \(self.spotterReportsData.count)"
                self.spotterReportsDataSorted = self.spotterReportsData.sorted(by: { $1.time > $0.time })
                self.spotterReportsDataSorted.enumerated().forEach {
                    let objSpotter = ObjectSpotterReportCard(self.stackView, $1)
                    let tapOutTextField = UITapGestureRecognizerWithData(
                        target: self, action: #selector(self.buttonPressed(sender:))
                    )
                    tapOutTextField.data=$0
                    objSpotter.addGestureRecognizer(tapOutTextField)
                }
                if self.spotterReportsData.count == 0 {
                    _ = ObjectTextView(self.stackView, "No active spotter reports.")
                }
            }
        }
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        //let idx = sender.data
        //let alert = ObjectPopUp(self, "",spotterReportCountButton)
        //let c = UIAlertAction(title: "Show on map", style: .default, handler: { (action) -> Void in self.showMap(idx)})
        //alert.addAction(c)
        //alert.finish()
    }

    func showMap(_ selection: Int) {
        ActVars.mapKitLat = self.spotterReportsDataSorted[selection].location.latString
        ActVars.mapKitLon = self.spotterReportsDataSorted[selection].location.lonString
        ActVars.mapKitRadius = 20000.0
        self.goToVC("mapkitview")
    }
}
