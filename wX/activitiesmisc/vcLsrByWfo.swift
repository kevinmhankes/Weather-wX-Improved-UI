/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

final class vcLsrByWfo: UIwXViewController, MKMapViewDelegate {

    private var wfoProd = [String]()
    private var siteButton = ToolbarIcon()
    private let map = ObjectMap(.WFO)

    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.wfos)
        siteButton = ToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, siteButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent(Location.wfo)
    }

    func getContent(_ wfo: String) {
        siteButton.title = wfo
        wfoProd.removeAll()
        _ = FutureVoid({ self.getLsrFromWfo(wfo) }, display)
    }

    private func display() {
        if !map.mapShown {
            stackView.removeViews()
            wfoProd.forEach { item in
                let objectTextView = Text(stackView, item)
                objectTextView.font = FontSize.hourly.size
                objectTextView.constrain(scrollView)
            }
        }
    }

    func getLsrFromWfo(_ wfo: String) {
        // var lsrList = [String]()
        let html = ("https://forecast.weather.gov/product.php?site=" + wfo + "&issuedby=" + wfo + "&product=LSR&format=txt&version=1&glossary=0").getHtml()
        let numberLSR = UtilityString.parseLastMatch(html, "product=LSR&format=TXT&version=(.*?)&glossary")
        if numberLSR == "" {
            wfoProd.append("None issued by this office recently.")
        } else {
            var maxVers = to.Int(numberLSR)
            if maxVers > 30 {
                maxVers = 30
            }
            stride(from: 1, to: maxVers, by: 2).forEach { version in
                _ = FutureVoid({ self.wfoProd.append(UtilityDownload.getTextProductWithVersion("LSR" + wfo, version)) }, display)
            }
        }
        // return lsrList
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
        getContent((annotationView.annotation!.title!)!)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ in
                self.map.setupMap(GlobalArrays.wfos)
                self.display()
            }
        )
    }
}
