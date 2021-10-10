// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class VcWfoText: UIwXViewControllerWithAudio, MKMapViewDelegate {

    private var productButton = ToolbarIcon()
    private var siteButton = ToolbarIcon()
    private var wfo = Location.wfo
    private let map = ObjectMap(.WFO)

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        product = "AFD"
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.wfos)
        productButton = ToolbarIcon(self, #selector(productClicked))
        siteButton = ToolbarIcon(self, #selector(mapClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            siteButton,
            productButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        objectTextView = Text(stackView)
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
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func getContent() {
        _ = FutureText2(download, display)
    }
    
    private func download() -> String {
        if product.hasPrefix("RTP") && product.count == 5 {
            let state = Utility.getWfoSiteName(wfo).split(",")[0]
            product = "RTP" + state
        }
        productButton.title = product
        siteButton.title = wfo
        let html: String
        if product.hasPrefix("RTP") && product.count == 5 {
            html = UtilityDownload.getTextProduct(product)
        } else {
            html = UtilityDownload.getTextProduct(product + wfo)
        }
        return html
    }

    private func display(_ html: String) {
        if html == "" {
            objectTextView.text = "None issued by this office recently."
        } else {
            objectTextView.text = html
        }
        if UtilityWfoText.needsFixedWidthFont(product) {
            objectTextView.font = FontSize.hourly.size
        } else {
            objectTextView.font = FontSize.medium.size
        }
        if product.hasPrefix("RTP") && product.count == 5 {
            Utility.writePref("WFOTEXT_PARAM_LAST_USED", "RTPZZ")
        } else {
            Utility.writePref("WFOTEXT_PARAM_LAST_USED", product)
        }
        Utility.writePref("WFO_LAST_USED", wfo)
        scrollView.scrollToTop()
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityWfoText.wfoProdListNoCode, productChanged)
    }

    func productChanged(_ index: Int) {
        product = UtilityWfoText.wfoProdList[index].split(":")[0]
        UtilityAudio.resetAudio(self)
        playButton.setImage(.play)
        getContent()
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }

    @objc func mapClicked() {
        map.toggleMap(self)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        map.mapView(annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.mapShown = map.mapViewExtra(annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        scrollView.scrollToTop()
        wfo = (annotationView.annotation!.title!)!
        UtilityAudio.resetAudio(self)
        playButton.setImage(.play)
        getContent()
    }

    override func playlistClicked() {
        _ = UtilityPlayList.add(product + wfo, objectTextView.text, self, playListButton)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.map.setupMap(GlobalArrays.wfos) }
    }
}
