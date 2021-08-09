// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class vcSoundings: UIwXViewController, MKMapViewDelegate {

    private var image = TouchImage()
    private var siteButton = ToolbarIcon()
    private let map = ObjectMap(.SOUNDING)

    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.soundingSites)
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        let textButton = ToolbarIcon(self, #selector(textClicked))
        textButton.title = "TEXT"
        siteButton = ToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, GlobalVariables.fixedSpace, textButton, siteButton, shareButton]).items
        image = TouchImage(self, toolbar)
        getContent(UtilityLocation.getNearestSoundingSite(Location.latLon))
    }

    func getContent(_ wfo: String) {
        siteButton.title = wfo
        _ = FutureBytes2({ UtilitySpcSoundings.getImage(wfo) }, image.setBitmap)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func mapClicked() {
        map.toggleMap(self)
    }
    
    @objc func textClicked() {
        let textUrl = "https://www.spc.noaa.gov/exper/soundings/LATEST/" + siteButton.title! + ".txt"
        _ = FutureText2({ textUrl.getHtml() }, gotoTextViewer)
    }
    
    private func gotoTextViewer(_ s: String) {
        Route.textViewer(self, s, isFixedWidth: true)
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
        coordinator.animate(alongsideTransition: nil,
            completion: { _ in
                self.image.refresh()
                self.map.setupMap(GlobalArrays.soundingSites)
            }
        )
    }
}
