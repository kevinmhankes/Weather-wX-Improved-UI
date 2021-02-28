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
    private var filterButton = ObjectToolbarIcon()
    private var objAlertSummary = ObjectAlertSummary()
    private var bitmap = Bitmap()
    private var filterGesture: UITapGestureRecognizer?
    private var filterShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton = ObjectToolbarIcon(self, #selector(filterClicked))
        filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, filterButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        getContent()
    }
    
    override func getContent() {
        capAlerts = []
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownloadNws.getCap("us")
            let alerts = html.parseColumn("<entry>(.*?)</entry>")
            alerts.forEach { self.capAlerts.append(CapAlert(eventText: $0)) }
            DispatchQueue.main.async { self.display() }
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
    
    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {
        Route.alertDetail(self, objAlertSummary.getUrl(sender.data))
    }
    
    @objc func goToRadar(sender: UITapGestureRecognizerWithData) {
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
            eventArrWithCount.append($0 + ": " + String(counts[$0]!))
        }
        _ = ObjectPopUp(self, title: "Filter Selection", filterButton, eventArrWithCount, filterChanged(_:))
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
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
