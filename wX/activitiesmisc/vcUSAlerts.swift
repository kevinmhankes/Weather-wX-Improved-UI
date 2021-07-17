/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class vcUSAlerts: UIwXViewController {

    private var capAlerts = [CapAlert]()
    private var filter = ""
    private var filterButton = ToolbarIcon()
    private var objAlertSummary = ObjectAlertSummary()
    private var bitmap = Bitmap()
    private var filterGesture: UITapGestureRecognizer?
    private var filterShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton = ToolbarIcon(self, #selector(filterClicked))
        filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, filterButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        capAlerts.removeAll()
        _ = FutureVoid(download, display)
        // TODO download image in thread
    }

    func download() {
        let html = UtilityDownloadNws.getCap("us")
        let alerts = html.parseColumn("<entry>(.*?)</entry>")
        alerts.forEach {
            capAlerts.append(CapAlert(eventText: $0))
        }
    }

    private func display() {
        refreshViews()
        if !filterShown {
            filterButton.title = "Tornado/ThunderStorm/FFW"
            objAlertSummary = ObjectAlertSummary(self, "", capAlerts, filterGesture)
            objAlertSummary.getImage()
            bitmap = objAlertSummary.image
        } else {
            filterChanged(filter)
        }
    }

    @objc func warningSelected(sender: GestureData) {
        Route.alertDetail(self, objAlertSummary.getUrl(sender.data))
    }

    @objc func goToRadar(sender: GestureData) {
        let wfo = objAlertSummary.wfos[sender.data]
        Route.radarNoSave(self, GlobalDictionaries.wfoToRadarSite[wfo] ?? "")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, objAlertSummary.image)
    }

    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        capAlerts.forEach { eventArr.append($0.event) }
        eventArr.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        Array(counts.keys).sorted().forEach {
            eventArrWithCount.append($0 + ": " + to.String(counts[$0]!))
        }
        _ = ObjectPopUp(self, title: "Filter Selection", filterButton, eventArrWithCount, filterChanged)
    }

    func filterChanged(_ filter: String) {
        filterButton.title = filter
        objAlertSummary = ObjectAlertSummary(self, filter, capAlerts, filterGesture, showImage: false)
        objAlertSummary.image = bitmap
        filterShown = true
        self.filter = filter
    }

    @objc func imageClicked() {
        objAlertSummary.changeImage(self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
