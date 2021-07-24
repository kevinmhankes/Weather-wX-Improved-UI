/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class vcAdhocLocation: UIwXViewController {

    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
    private var stackViewForecast = ObjectStackView(.fill, .vertical)
    var saveButton = ToolbarIcon()
    var adhocLocation = LatLon()

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleButton = ToolbarIcon(self, nil)
        saveButton = ToolbarIcon(title: "Save Location", self, #selector(save))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, saveButton, titleButton]).items
        objScrollStackView = ScrollStackView(self)
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.get().widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        titleButton.title = adhocLocation.latString.truncate(6) + ", " + adhocLocation.lonString.truncate(6)
        getContent()
    }

    override func getContent() {
        refreshViews()
        _ = FutureVoid(download, display)
        // TODO more threads
    }
    
    private func download() {
        objectCurrentConditions = ObjectCurrentConditions(adhocLocation)
        objectSevenDay = ObjectSevenDay(adhocLocation)
        objectHazards = ObjectHazards(self, adhocLocation)
    }

    private func display() {
        _ = ObjectCardCurrentConditions(stackViewCurrentConditions, objectCurrentConditions, true)
        stackView.addLayout(stackViewCurrentConditions)
        stackViewCurrentConditions.constrain(scrollView)
        ObjectHazards.getHazardCards(stackView, objectHazards)
        _ = ObjectCardSevenDayCollection(stackViewForecast, scrollView, objectSevenDay)
        stackView.addLayout(stackViewForecast)
        stackViewForecast.constrain(scrollView)
    }

    @objc func save() {
        let status = Location.save(adhocLocation)
        ObjectPopUp(self, status, saveButton).present()
    }
}
