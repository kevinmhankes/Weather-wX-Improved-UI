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
    private var stackViewCurrentConditions: ObjectStackView!
    private var stackViewForecast: ObjectStackView!
    private var stackViewHazards: ObjectStackView!
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
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                titleButton
            ]
        ).items
        self.stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
        self.stackViewForecast = ObjectStackView(.fill, .vertical)
        self.stackViewHazards = ObjectStackView(.fill, .vertical)
        objScrollStackView = ObjectScrollStackView(self)
        scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
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
                _ = ObjectCardCurrentConditions(
                    self.stackViewCurrentConditions.view,
                    self.objCurrentConditions,
                    true
                )
                self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                self.stackViewCurrentConditions.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
                ObjectForecastPackageHazards.getHazardCards(self.stackView, self.objHazards)
                _ = ObjectCard7DayCollection(
                    self.stackViewForecast.view,
                    self.scrollView,
                    self.objSevenDay
                )
                self.stackView.addArrangedSubview(self.stackViewForecast.view)
                self.stackViewForecast.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            }
        }
    }
}
