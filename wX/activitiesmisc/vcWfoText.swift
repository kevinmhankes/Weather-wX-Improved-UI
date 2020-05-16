/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class vcWfoText: UIwXViewControllerWithAudio, MKMapViewDelegate {
    
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private var wfo = Location.wfo
    private let map = ObjectMap(.WFO)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        product = "AFD"
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.wfos)
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                siteButton,
                productButton,
                playButton,
                playListButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(stackView)
        objectTextView.constrain(scrollView)
        if Utility.readPref("WFO_REMEMBER_LOCATION", "") == "true" {
            wfo = Utility.readPref("WFO_LAST_USED", Location.wfo)
        } else {
            wfo = Location.wfo
        }
        product = Utility.readPref("WFOTEXT_PARAM_LAST_USED", product)
        if product.hasPrefix("RTP") && product.count == 5 {
            let state = Utility.getWfoSiteName(wfo).split(",")[0]
            product = "RTP" + state
        }
        self.getContent()
    }
    
    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.product.hasPrefix("RTP") && self.product.count == 5 {
                let state = Utility.getWfoSiteName(self.wfo).split(",")[0]
                self.product = "RTP" + state
            }
            self.productButton.title = self.product
            self.siteButton.title = self.wfo
            let html: String
            if self.product.hasPrefix("RTP") && self.product.count == 5 {
                html = UtilityDownload.getTextProduct(self.product)
            } else {
                html = UtilityDownload.getTextProduct(self.product + self.wfo)
            }
            DispatchQueue.main.async { self.displayContent(html) }
        }
    }
    
    private func displayContent(_ html: String) {
        if html == "" {
            self.objectTextView.text = "None issued by this office recently."
        } else {
            self.objectTextView.text = html
        }
        if UtilityWfoText.needsFixedWidthFont(self.product) {
            self.objectTextView.font = FontSize.hourly.size
        } else {
            self.objectTextView.font = FontSize.medium.size
        }
        if self.product.hasPrefix("RTP") && self.product.count == 5 {
            Utility.writePref("WFOTEXT_PARAM_LAST_USED", "RTPZZ")
        } else {
            Utility.writePref("WFOTEXT_PARAM_LAST_USED", self.product)
        }
        Utility.writePref("WFO_LAST_USED", self.wfo)
        self.scrollView.scrollToTop()
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityWfoText.wfoProdListNoCode, self.productChanged(_:))
    }
    
    func productChanged(_ index: Int) {
        self.product = UtilityWfoText.wfoProdList[index].split(":")[0]
        UtilityAudio.resetAudio(self, playButton)
        self.getContent()
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
    
    @objc func mapClicked() {
        map.toggleMap(self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { map.mapView(annotation) }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.mapShown = map.mapViewExtra(annotationView, control, mapCall)
    }
    
    func mapCall(annotationView: MKAnnotationView) {
        scrollView.scrollToTop()
        self.wfo = (annotationView.annotation!.title!)!
        UtilityAudio.resetAudio(self, playButton)
        self.getContent()
    }
    
    override func playlistClicked() {
        _ = UtilityPlayList.add(self.product + self.wfo, self.objectTextView.text, self, playListButton)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil,
            completion: { _ -> Void in
                self.map.setupMap(GlobalArrays.wfos)
        }
        )
    }
}
