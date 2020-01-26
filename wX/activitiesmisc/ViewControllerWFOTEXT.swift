/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class ViewControllerWFOTEXT: UIwXViewController, MKMapViewDelegate, AVSpeechSynthesizerDelegate {

    var product = "AFD"
    var textView = ObjectTextView()
    var productButton = ObjectToolbarIcon()
    var siteButton = ObjectToolbarIcon()
    var wfo = Location.wfo
    var playButton = ObjectToolbarIcon()
    let mapView = MKMapView()
    var mapShown = false
    var playlistButton = ObjectToolbarIcon()
    var synth = AVSpeechSynthesizer()
    var html = ""
    let wfoProdList = [
        "AFD: Area Forecast Discussion",
        "ESF: Hydrologic Outlook",
        "FWF: Fire weather Forecast",
        "HWO: Hazardous Weather Outlook",
        "LSR: Local Storm Report",
        "NSH: Nearshore Marine Forecast",
        "PNS: Public Information Statement",
        "RTP: Regional Temp/Precip Summary",
        "RVA: Hydrologic Summary"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        synth.delegate = self
        mapView.delegate = self
        UtilityMap.setupMapForWfo(mapView, GlobalArrays.wfos)
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                siteButton,
                productButton,
                playButton,
                shareButton,
                playlistButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        if Utility.readPref("WFO_REMEMBER_LOCATION", "") == "true" {
            wfo = Utility.readPref("WFO_LAST_USED", Location.wfo)
        } else {
            wfo = Location.wfo
        }
        product = Utility.readPref("WFOTEXT_PARAM_LAST_USED", product)
        self.getContent()
    }

    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
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
                Utility.writePref("WFO_LAST_USED", self.wfo)
                self.scrollView.scrollToTop()
            }
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
        }
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, wfoProdList, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
        self.product = product
        UtilityActions.resetAudio(&synth, playButton)
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
        UtilityActions.resetAudio(&synth, playButton)
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
                UtilityMap.setupMapForWfo(self.mapView, GlobalArrays.wfos)
                self.textView = ObjectTextView(self.stackView)
                self.textView.text = self.html
            }
        )
    }
}
