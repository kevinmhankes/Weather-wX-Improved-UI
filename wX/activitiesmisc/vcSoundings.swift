/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class vcSoundings: UIwXViewController, MKMapViewDelegate {
    
    private var image = ObjectTouchImageView()
    private var wfo = ""
    private var siteButton = ObjectToolbarIcon()
    private let map = ObjectMap(.SOUNDING)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.soundingSites)
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        siteButton = ObjectToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                GlobalVariables.fixedSpace,
                siteButton,
                shareButton
            ]
        ).items
        image = ObjectTouchImageView(self, toolbar)
        self.wfo = UtilityLocation.getNearestSoundingSite(Location.latlon)
        self.getContent()
    }
    
    override func getContent() {
        self.siteButton.title = self.wfo
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcSoundings.getImage(self.wfo)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
            }
        }
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func mapClicked() {
        map.toggleMap(self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { map.mapView(annotation) }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.mapShown = map.mapViewExtra(annotationView, control, mapCall)
    }
    
    func mapCall(annotationView: MKAnnotationView) {
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil,
            completion: { _ -> Void in
                self.image.refresh()
                self.map.setupMap(GlobalArrays.soundingSites)
        }
        )
    }
}
