/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, siteButton,
            productButton, playButton, shareButton, playlistButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        if preferences.getString("WFO_REMEMBER_LOCATION", "")=="true" {
            wfo = preferences.getString("WFO_LAST_USED", Location.wfo)
        } else {
            wfo = Location.wfo
        }
        product = preferences.getString("WFOTEXT_PARAM_LAST_USED", product)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var html = UtilityDownload.getTextProduct(self.product + self.wfo)
            DispatchQueue.main.async {
                if html == "" {
                    html = "None issused by this office recently."
                }
                self.textView.text = html
                self.productButton.title = self.product
                self.siteButton.title = self.wfo
                editor.putString("WFOTEXT_PARAM_LAST_USED", self.product)
                editor.putString("WFO_REMEMBER_LOCATION", self.wfo)
            }
        }
    }

    let synth = AVSpeechSynthesizer()

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, wfoProdList, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
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

    func mapView(_ mapView: MKMapView,
                 annotationView: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product + self.wfo, self.textView.text, self, playlistButton)
    }
}
