// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class vcUSAlerts: UIwXViewController {

    private var capAlerts = [CapAlert]()
    private var filter = ""
    private var filterButton = ToolbarIcon()
    private var objectAlertSummary = ObjectAlertSummary()
    private var filterGesture: UITapGestureRecognizer?
    private var filterShown = false
    private var boxImage = ObjectStackView(.fill, .vertical)
    private var boxText = ObjectStackView(.fill, .vertical, spacing: 1.0)
    private var image = ObjectImage()
    private var bitmap = Bitmap()

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton = ToolbarIcon(self, #selector(filterClicked))
        filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, filterButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        stackView.addLayout(boxImage)
        stackView.addLayout(boxText)
        boxImage.constrain(self)
        boxText.constrain(self)
        image = ObjectImage(boxImage)
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(downloadText, display)
        _ = FutureBytes("https://forecast.weather.gov/wwamap/png/US.png", image.setBitmap)
    }

    func downloadText() {
        capAlerts.removeAll()
        let html = UtilityDownloadNws.getCap("us")
        let alerts = html.parseColumn("<entry>(.*?)</entry>")
        alerts.forEach {
            capAlerts.append(CapAlert(eventText: $0))
        }
    }

    private func display() {
        boxText.removeChildren()
        if !filterShown {
            filterButton.title = "Tornado/ThunderStorm/FFW"
            objectAlertSummary = ObjectAlertSummary(self, boxText, "", capAlerts, filterGesture)
        } else {
            filterChanged(filter)
        }
    }

    @objc func warningSelected(sender: GestureData) {
        Route.alertDetail(self, objectAlertSummary.getUrl(sender.data))
    }

    @objc func goToRadar(sender: GestureData) {
        Route.radarNoSave(self, objectAlertSummary.radarSites[sender.data])
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap)
    }

    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        capAlerts.forEach {
            eventArr.append($0.event)
        }
        eventArr.forEach {
            counts[$0] = (counts[$0] ?? 0) + 1
        }
        Array(counts.keys).sorted().forEach {
            eventArrWithCount.append($0 + ": " + to.String(counts[$0]!))
        }
        _ = ObjectPopUp(self, title: "Filter Selection", filterButton, eventArrWithCount, filterChanged)
    }

    func filterChanged(_ filter: String) {
        boxText.removeChildren()
        filterButton.title = filter
        objectAlertSummary = ObjectAlertSummary(self, boxText, filter, capAlerts, filterGesture)
        filterShown = true
        self.filter = filter
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
