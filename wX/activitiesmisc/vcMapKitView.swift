/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class vcMapKitView: UIwXViewController, MKMapViewDelegate {

    var latLonButton = ObjectToolbarIcon()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locationC = CLLocationCoordinate2D(
            latitude: Double(ActVars.mapKitLat) ?? 0.0,
            longitude: Double(ActVars.mapKitLon) ?? 0.0
        )
        UtilityMap.centerMapForMapKit(mapView, location: locationC, regionRadius: ActVars.mapKitRadius)
        latLonButton = ObjectToolbarIcon(self, #selector(showExternalMap))
        latLonButton.title = ActVars.mapKitLat + ", " + ActVars.mapKitLon
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, latLonButton]).items
        self.view.addSubview(toolbar)
        self.view.addSubview(mapView)
    }

    @objc func showExternalMap() {
        let directionsURL = "http://maps.apple.com/?daddr=" + ActVars.mapKitLat + "," + ActVars.mapKitLon
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
