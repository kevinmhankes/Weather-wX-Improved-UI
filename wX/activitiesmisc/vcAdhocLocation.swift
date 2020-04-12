/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcAdhocLocation: UIwXViewController {
    
    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var stackViewCurrentConditions: ObjectStackView!
    private var stackViewForecast: ObjectStackView!
    private var stackViewHazards: ObjectStackView!
    var adhocLocation = LatLon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleButton = ObjectToolbarIcon(self, #selector(doneClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, titleButton]).items
        self.stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
        self.stackViewForecast = ObjectStackView(.fill, .vertical)
        self.stackViewHazards = ObjectStackView(.fill, .vertical)
        objScrollStackView = ObjectScrollStackView(self)
        scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        titleButton.title = adhocLocation.latString.truncate(6) + ", " + adhocLocation.lonString.truncate(6)
        self.getContent()
    }
    
    override func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.objectCurrentConditions = ObjectCurrentConditions(self.adhocLocation)
            self.objectSevenDay = ObjectSevenDay(self.adhocLocation)
            self.objectHazards = ObjectHazards(self, self.adhocLocation)
            DispatchQueue.main.async {
                _ = ObjectCardCurrentConditions(
                    self.stackViewCurrentConditions.view,
                    self.objectCurrentConditions,
                    true
                )
                self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                self.stackViewCurrentConditions.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
                ObjectHazards.getHazardCards(self.stackView, self.objectHazards)
                _ = ObjectCardSevenDayCollection(
                    self.stackViewForecast.view,
                    self.scrollView,
                    self.objectSevenDay
                )
                self.stackView.addArrangedSubview(self.stackViewForecast.view)
                self.stackViewForecast.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            }
        }
    }
}
