/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class ViewControllerSOUNDING: UIwXViewController, MKMapViewDelegate {

    var image = ObjectTouchImageView()
    var wfo = ""
    let mapView = MKMapView()
    var mapShown = false
    var siteButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.soundingSites, "SND_")
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, fixedSpace, siteButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        self.wfo = UtilityLocation.getNearestSoundingSite(Location.latlon)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySPCSoundings.getImage(self.wfo)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.siteButton.title = self.wfo
            }
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
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
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil,
                            completion: { _ -> Void in
                                UtilityMap.setupMap(
                                    self.mapView,
                                    GlobalArrays.soundingSites,
                                    "SND_"
                                )
        })
    }
}
