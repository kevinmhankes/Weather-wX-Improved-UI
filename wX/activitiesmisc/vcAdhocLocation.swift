/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcAdhocLocation: UIwXViewController {

    private var objCurrentConditions = ObjectForecastPackageCurrentConditions()
    private var objHazards = ObjectForecastPackageHazards()
    private var objSevenDay = ObjectForecastPackage7Day()
    var adhocLocation = LatLon()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let titleButton = ObjectToolbarIcon(self, #selector(doneClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, titleButton]).items
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10.0).isActive = true
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        titleButton.title = adhocLocation.latString.truncate(6) + ", " + adhocLocation.lonString.truncate(6)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.objCurrentConditions = ObjectForecastPackageCurrentConditions(self.adhocLocation)
            self.objSevenDay = ObjectForecastPackage7Day(self.adhocLocation)
            self.objHazards = ObjectForecastPackageHazards(self, self.adhocLocation)
            DispatchQueue.main.async {
                _ = ObjectCardCurrentConditions(self.stackView, self.objCurrentConditions, true)
                ObjectForecastPackageHazards.getHazardCards(self.stackView, self.objHazards)
                _ = ObjectCard7DayCollection(
                    self.stackView,
                    self.scrollView,
                    self.objSevenDay
                )
            }
        }
    }
}
