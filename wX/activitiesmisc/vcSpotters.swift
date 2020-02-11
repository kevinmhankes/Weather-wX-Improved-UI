/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpotters: UIwXViewController {

    var spotterData = [Spotter]()
    var spotterDataSorted = [Spotter]()
    var spotterReportsButton = ObjectToolbarIcon()
    var spotterCountButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        spotterReportsButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        spotterReportsButton.title = "Spotter Reports"
        spotterCountButton = ObjectToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterCountButton, spotterReportsButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.spotterData = UtilitySpotter.getSpotterData()
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    private func displayContent() {
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

    @objc func showSpotterReports() {
        let vc = vcSpotterReports()
        self.goToVC(vc)
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let alert = ObjectPopUp(self, "", spotterReportsButton)
        let c = UIAlertAction(title: "Show on map", style: .default, handler: { _ -> Void in self.showMap(index)})
        alert.addAction(c)
        alert.finish()
    }

    func showMap(_ selection: Int) {
        let vc = vcMapKitView()
        vc.mapKitLat = self.spotterDataSorted[selection].lat
        vc.mapKitLon = self.spotterDataSorted[selection].lon
        vc.mapKitRadius = 20000.0
        self.goToVC(vc)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
