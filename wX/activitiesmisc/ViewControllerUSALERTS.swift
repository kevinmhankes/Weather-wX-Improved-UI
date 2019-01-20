/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerUSALERTS: UIwXViewController {

    var capAlerts = [CAPAlert]()
    var filter = ""
    var filterButton = ObjectToolbarIcon()
    var objAlertSummary = ObjectAlertSummary()
    var bitmap = Bitmap()

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton = ObjectToolbarIcon(self, #selector(filterClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, filterButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownloadNWS.getCAP("us")
            let alertArr = html.parseColumn("<entry>(.*?)</entry>")
            alertArr.forEach {self.capAlerts.append(CAPAlert(eventTxt: $0))}
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {
        ActVars.usalertsDetailUrl = objAlertSummary.getUrl(sender.data)
        self.goToVC("usalertsdetail")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.objAlertSummary.image)
    }

    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        self.capAlerts.forEach {eventArr.append($0.event)}
        eventArr.forEach {counts[$0] = (counts[$0] ?? 0) + 1}
        Array(counts.keys).sorted().forEach {eventArrWithCount.append("\($0): \(counts[$0]!)")}
        _ = ObjectPopUp(self, "Filter Selection", filterButton, eventArrWithCount, self.filterChanged(_:))
    }

    func filterChanged(_ filter: String) {
        self.filterButton.title = filter
        self.objAlertSummary = ObjectAlertSummary(self, self.stackView, filter, self.capAlerts, showImage: false)
        self.objAlertSummary.image = bitmap
    }

    @objc func imageClicked() {
        self.objAlertSummary.changeImage()
        self.bitmap = self.objAlertSummary.image
    }
    
    private func displayContent() {
        self.filterButton.title = "Tornado/FFW/ThunderStorm"
        self.objAlertSummary = ObjectAlertSummary(self, self.stackView, "", self.capAlerts)
        self.objAlertSummary.changeImage()
        self.bitmap = self.objAlertSummary.image
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
