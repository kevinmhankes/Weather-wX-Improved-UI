/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class vcMapKitView: UIwXViewController, MKMapViewDelegate {
    
    private var latLonButton = ObjectToolbarIcon()
    private let mapView = MKMapView()
    var mapKitLat = ""
    var mapKitLon = ""
    var mapKitRadius = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locationC = CLLocationCoordinate2D(latitude: Double(mapKitLat) ?? 0.0, longitude: Double(mapKitLon) ?? 0.0)
        ObjectMap.centerMapForMapKit(mapView, location: locationC, regionRadius: mapKitRadius)
        latLonButton = ObjectToolbarIcon(self, #selector(showExternalMap))
        latLonButton.title = mapKitLat + ", " + mapKitLon
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, latLonButton]).items
        self.view.addSubview(mapView)
    }
    
    @objc func showExternalMap() {
        let directionsURL = "http://maps.apple.com/?daddr=" + mapKitLat + "," + mapKitLon
        guard let url = URL(string: directionsURL) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
