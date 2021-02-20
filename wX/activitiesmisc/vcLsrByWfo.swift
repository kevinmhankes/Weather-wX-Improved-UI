/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

final class vcLsrByWfo: UIwXViewController, MKMapViewDelegate {

    private var wfoProd = [String]()
    private var siteButton = ObjectToolbarIcon()
    private let map = ObjectMap(.WFO)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.wfos)
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, siteButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent(Location.wfo)
    }
    
    func getContent(_ wfo: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.wfoProd = self.getLsrFromWfo(wfo)
            DispatchQueue.main.async {
                self.siteButton.title = wfo
                self.display()
            }
        }
    }
    
    private func display() {
        if !map.mapShown {
            self.stackView.removeViews()
            self.wfoProd.forEach { item in
                let objectTextView = ObjectTextView(self.stackView, item)
                objectTextView.font = FontSize.hourly.size
                objectTextView.constrain(scrollView)
            }
        }
    }
    
    func getLsrFromWfo(_ wfo: String) -> [String] {
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
            stride(from: 1, to: maxVers, by: 2).forEach { version in
                lsrList.append(UtilityDownload.getTextProductWithVersion("LSR" + wfo, version))
            }
        }
        return lsrList
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
        self.getContent((annotationView.annotation!.title!)!)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                //self.refreshViews()
                self.map.setupMap(GlobalArrays.wfos)
                self.display()
        }
        )
    }
}
