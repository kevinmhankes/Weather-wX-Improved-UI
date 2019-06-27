/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerADHOCLOCATION: UIwXViewController {

    var location = LatLon()
    var objCurrentConditions = ObjectForecastPackageCurrentConditions()
    var objHazards = ObjectForecastPackageHazards()
    var objSevenDay = ObjectForecastPackage7Day()

    override func viewDidLoad() {
        super.viewDidLoad()
        ActVars.vc = self
        let titleButton = ObjectToolbarIcon(self, #selector(doneClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, titleButton]).items
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10.0).isActive = true
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        location = ActVars.adhocLocation
        titleButton.title = location.latString.truncate(6) + ", " + location.lonString.truncate(6)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objCurrentConditions = ObjectForecastPackageCurrentConditions(self.location)
            self.objSevenDay = ObjectForecastPackage7Day(self.location)
            self.objHazards = ObjectForecastPackageHazards(self.location)
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
