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
    //private let mapView = MKMapView()
    //private var mapShown = false
    private var siteButton = ObjectToolbarIcon()
    private let map = ObjectMap(.SOUNDING)

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
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
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        //UtilityMap.setupMapForSnd(self, mapView, GlobalArrays.soundingSites)
        //elf.view.addSubview(mapView)
        //mapView.isHidden = true
        self.wfo = UtilityLocation.getNearestSoundingSite(Location.latlon)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcSoundings.getImage(self.wfo)
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
        map.toggleMap(self)
        /*if mapShown {
            //mapView.removeFromSuperview()
            mapView.isHidden = true
            mapShown = false
        } else {
            print("DEBUG: show map")
            mapShown = true
            mapView.isHidden = false
            //self.view.addSubview(mapView)
        }*/
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return UtilityMap.mapView(mapView, annotation)
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        map.mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        self.wfo = (annotationView.annotation!.title!)!
        self.getContent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.map.setupMap(GlobalArrays.soundingSites)
            }
        )
    }
}
