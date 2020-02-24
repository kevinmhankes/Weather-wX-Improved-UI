/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class vcWfoText: UIwXViewController, MKMapViewDelegate, AVSpeechSynthesizerDelegate {

    private var product = "AFD"
    private var objectTextView = ObjectTextView()
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private var wfo = Location.wfo
    private var playButton = ObjectToolbarIcon()
    private let mapView = MKMapView()
    private var mapShown = false
    private var playlistButton = ObjectToolbarIcon()
    private var synth = AVSpeechSynthesizer()
    private var html = ""
    
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
                playlistButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        objectTextView = ObjectTextView(stackView)
        objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
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

    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.product.hasPrefix("RTP") && self.product.count == 5 {
                let state = Utility.getWfoSiteName(self.wfo).split(",")[0]
                self.product = "RTP" + state
            }
            self.productButton.title = self.product
            self.siteButton.title = self.wfo
            if self.product.hasPrefix("RTP") && self.product.count == 5 {
                self.html = UtilityDownload.getTextProduct(self.product)
            } else {
                self.html = UtilityDownload.getTextProduct(self.product + self.wfo)
            }
            DispatchQueue.main.async {
                if self.html == "" {
                    self.html = "None issused by this office recently."
                }
                self.objectTextView.text = self.html
                if self.product == "RWR"
                    || self.product.hasPrefix("RTP")
                    || self.product == "RVA"
                    || self.product == "LSR"
                    || self.product == "ESF"
                    || self.product == "NSH"
                    || self.product == "PNS" {
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
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(objectTextView.view, synth, playButton)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
        }
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityWfoText.wfoProdListNoCode, self.productChanged(_:))
    }
    
    func productChanged(_ index: Int) {
        self.product = UtilityWfoText.wfoProdList[index].split(":")[0]
        UtilityActions.resetAudio(&synth, playButton)
        self.getContent()
    }

    /*func productChanged(_ product: String) {
        self.product = product
        UtilityActions.resetAudio(&synth, playButton)
        self.getContent()
    }*/

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
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
        UtilityPlayList.add(self.product + self.wfo, self.objectTextView.text, self, playlistButton)
    }
}
