/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcUSAlerts: UIwXViewController {
    
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
        self.getContent()
    }
    
    override func getContent() {
        capAlerts = []
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownloadNws.getCap("us")
            let alerts = html.parseColumn("<entry>(.*?)</entry>")
            alerts.forEach { self.capAlerts.append(CapAlert(eventText: $0)) }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {
        let vc = vcUSAlertsDetail()
        vc.usAlertsDetailUrl = objAlertSummary.getUrl(sender.data)
        self.goToVC(vc)
    }
    
    @objc func goToRadar(sender: UITapGestureRecognizerWithData) {
        let wfo = objAlertSummary.wfos[sender.data]
        let radarSite = GlobalDictionaries.wfoToRadarSite[wfo] ?? ""
        let vc = vcNexradRadar()
        vc.radarSiteOverride = radarSite
        vc.savePreferences = false
        self.goToVC(vc)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.objAlertSummary.image)
    }
    
    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        self.capAlerts.forEach { eventArr.append($0.event) }
        eventArr.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        Array(counts.keys).sorted().forEach { eventArrWithCount.append($0 + ": " + String(counts[$0]!)) }
        _ = ObjectPopUp(self, title: "Filter Selection", filterButton, eventArrWithCount, self.filterChanged(_:))
    }
    
    func filterChanged(_ filter: String) {
        self.filterButton.title = filter
        self.objAlertSummary = ObjectAlertSummary(
            self,
            filter,
            self.capAlerts,
            self.filterGesture,
            showImage: false
        )
        self.objAlertSummary.image = bitmap
        self.filterShown = true
        self.filter = filter
    }
    
    @objc func imageClicked() {
        self.objAlertSummary.changeImage(self)
    }
    
    private func displayContent() {
        self.refreshViews()
        if !filterShown {
            self.filterButton.title = "Tornado/ThunderStorm/FFW"
            self.objAlertSummary = ObjectAlertSummary(self, "", self.capAlerts, self.filterGesture)
            self.objAlertSummary.getImage()
            self.bitmap = self.objAlertSummary.image
        } else {
            filterChanged(filter)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.displayContent() })
    }
}
