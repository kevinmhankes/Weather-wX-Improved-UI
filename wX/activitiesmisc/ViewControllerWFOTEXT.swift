/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class ViewControllerWFOTEXT: UIwXViewController, MKMapViewDelegate {

    var product = "AFD"
    var textView = ObjectTextView()
    var productButton = ObjectToolbarIcon()
    var siteButton = ObjectToolbarIcon()
    var wfo = Location.wfo
    var playButton = ObjectToolbarIcon()
    let mapView = MKMapView()
    var mapShown = false
    var playlistButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()
    var html = ""
    let wfoProdList = [
        "AFD: Area Forecast Discussion",
        "HWO: Hazardous Weather Outlook",
        "LSR: Local Storm Report",
        "PNS: Public Information Statement",
        "RVA: Hydrologic Summary",
        "ESF: Hydrologic Outlook",
        "RTP: Regional Temp/Precip Summary",
        "FWF: Fire weather Forecast",
        "NSH: Nearshore Marine Forecast"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.wfos, "NWS_")
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                siteButton,
                productButton,
                playButton,
                shareButton,
                playlistButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        // TODO add readPref that converts to Bool
        if Utility.readPref("WFO_REMEMBER_LOCATION", "") == "true" {
            wfo = Utility.readPref("WFO_LAST_USED", Location.wfo)
        } else {
            wfo = Location.wfo
        }
        product = Utility.readPref("WFOTEXT_PARAM_LAST_USED", product)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.productButton.title = self.product
            self.siteButton.title = self.wfo
            self.html = UtilityDownload.getTextProduct(self.product + self.wfo)
            DispatchQueue.main.async {
                if self.html == "" {
                    self.html = "None issused by this office recently."
                }
                self.textView.text = self.html
                Utility.writePref("WFOTEXT_PARAM_LAST_USED", self.product)
                Utility.writePref("WFO_REMEMBER_LOCATION", self.wfo)
                // TODO add scrollToTop here
                // scrollView.scrollToTop()
            }
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, wfoProdList, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
        // TODO remove line below
        scrollView.scrollToTop()
        self.product = product
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, textView.text)
    }

    @objc func mapClicked() {
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            self.view.addSubview(mapView)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return UtilityMap.mapView(mapView, annotation)
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        scrollView.scrollToTop()
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product + self.wfo, self.textView.text, self, playlistButton)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                UtilityMap.setupMap(self.mapView, GlobalArrays.wfos, "NWS_")
                self.textView = ObjectTextView(self.stackView)
                self.textView.text = self.html
            }
        )
    }
}
