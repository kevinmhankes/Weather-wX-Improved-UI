/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class vcLsrByWfo: UIwXViewController, MKMapViewDelegate {
    
    private var capAlerts = [CapAlert]()
    private var images = [UIImageView]()
    private var urls = [String]()
    private var wfo = ""
    private var wfoProd = [String]()
    private var siteButton = ObjectToolbarIcon()
    private let map = ObjectMap(.WFO)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.wfos)
        wfo = Location.wfo
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                siteButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.wfoProd = self.getLsrFromWfo()
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    func getLsrFromWfo() -> [String] {
        var lsrList = [String]()
        let html = ("https://forecast.weather.gov/product.php?site=" + wfo + "&issuedby=" + wfo + "&product=LSR&format=txt&version=1&glossary=0").getHtml()
        let numberLSR = UtilityString.parseLastMatch(html, "product=LSR&format=TXT&version=(.*?)&glossary")
        if numberLSR == "" {
            lsrList.append("None issued by this office recently.")
        } else {
            var maxVers = Int(numberLSR) ?? 0
            if maxVers > 30 {
                maxVers = 30
            }
            stride(from: 1, to: maxVers, by: 2).forEach {
                lsrList.append(UtilityDownload.getTextProductWithVersion("LSR" + wfo, $0))
            }
        }
        return lsrList
    }
    
    @objc func mapClicked() {
        map.toggleMap(self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return map.mapView(annotation)
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        map.mapShown = map.mapViewExtra(annotationView, control, mapCall)
    }
    
    func mapCall(annotationView: MKAnnotationView) {
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }
    
    private func displayContent() {
        self.siteButton.title = self.wfo
        self.stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.wfoProd.forEach {
            let objectTextView = ObjectTextView(self.stackView, $0)
            objectTextView.font = FontSize.hourly.size
            objectTextView.constrain(scrollView)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.map.setupMap(GlobalArrays.wfos)
                self.displayContent()
        }
        )
    }
}
