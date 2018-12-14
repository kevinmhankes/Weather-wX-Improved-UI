/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class ViewControllerLSRbyWFO: UIwXViewController, MKMapViewDelegate {

    var html = ""
    var capAlerts = [CAPAlert]()
    var filter = ""
    var imgArr = [UIImageView]()
    var urlArr = [String]()
    var nwsOffice = ""
    var wfoProd = [String]()
    var mapShown = false
    let mapView = MKMapView()
    var siteButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.wfos, "NWS_")
        nwsOffice = Location.wfo
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, siteButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.wfoProd = self.getLSRFromWFO()
            DispatchQueue.main.async {
                self.siteButton.title = self.nwsOffice
                self.stackView.subviews.forEach { $0.removeFromSuperview() }
                self.wfoProd.forEach {_ = ObjectTextView(self.stackView, $0)}
            }
        }
    }

    func warningSelected(sender: UITapGestureRecognizer) {
        let tv1 = sender.view!
        ActVars.usalertsDetailUrl = urlArr[tv1.tag]
        self.goToVC("usalertsdetail")
    }

    func getLSRFromWFO() -> [String] {
        var lsrArr = [String]()
        let html = ("http://forecast.weather.gov/product.php?site=" + nwsOffice + "&issuedby="
            + nwsOffice + "&product=LSR&format=txt&version=1&glossary=0").getHtml()
        let numberLSR = UtilityString.parseLastMatch(html, "product=LSR&format=TXT&version=(.*?)&glossary")
        if numberLSR == "" {
            lsrArr.append("None issued by this office recently.")
        } else {
            var maxVers = Int(numberLSR) ?? 0
            if maxVers > 30 {
                maxVers = 30
            }
            stride(from: 1, to: maxVers, by: 2).forEach {
                lsrArr.append(UtilityDownload.getTextProductWithVersion("LSR" + nwsOffice, $0))
            }
        }
        return lsrArr
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
        self.nwsOffice = (annotationView.annotation!.title!)!
        self.getContent()
    }
}
