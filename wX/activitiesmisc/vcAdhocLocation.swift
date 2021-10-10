// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class vcAdhocLocation: UIwXViewController {

    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
    private var stackViewHazards = ObjectStackView(.fill, .vertical)
    private var stackViewForecast = ObjectStackView(.fill, .vertical)
    var saveButton = ToolbarIcon()
    var latLon = LatLon()

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleButton = ToolbarIcon(self, nil)
        saveButton = ToolbarIcon("Save Location", self, #selector(save))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, saveButton, titleButton]).items
        objScrollStackView = ScrollStackView(self)
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.constrain(scrollView)
        titleButton.title = latLon.latString.truncate(6) + ", " + latLon.lonString.truncate(6)
        
        stackView.addLayout(stackViewCurrentConditions)
        stackViewCurrentConditions.constrain(scrollView)
        stackView.addLayout(stackViewHazards)
        stackViewHazards.constrain(scrollView)
        stackView.addLayout(stackViewForecast)
        stackViewForecast.constrain(scrollView)
        
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(downloadCc, displayCc)
        _ = FutureVoid(downloadHazards, displayHazards)
        _ = FutureVoid(downloadSevenDay, displaySevenDay)
    }
    
    private func downloadCc() {
        objectCurrentConditions = ObjectCurrentConditions(latLon)
    }
    
    private func downloadHazards() {
        objectHazards = ObjectHazards(self, latLon)
    }
    
    private func downloadSevenDay() {
        objectSevenDay = ObjectSevenDay(latLon)
    }

    private func displayCc() {
        _ = ObjectCardCurrentConditions(stackViewCurrentConditions, objectCurrentConditions, true)
    }
    
    private func displayHazards() {
        ObjectHazards.getHazardCards(stackViewHazards, objectHazards)
    }
    
    private func displaySevenDay() {
        _ = ObjectCardSevenDayCollection(stackViewForecast, scrollView, objectSevenDay)
    }

    @objc func save() {
        let status = Location.save(latLon)
        ObjectPopUp(self, status, saveButton).present()
    }
}
