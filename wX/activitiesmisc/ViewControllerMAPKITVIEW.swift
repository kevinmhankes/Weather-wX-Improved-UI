/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

class ViewControllerMAPKITVIEW: UIwXViewController, MKMapViewDelegate {

    var productButton = ObjectToolbarIcon()
    var browserButton = ObjectToolbarIcon()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locationC = CLLocationCoordinate2D(
            latitude: Double(ActVars.mapKitLat) ?? 0.0,
            longitude: Double(ActVars.mapKitLon) ?? 0.0
        )
        UtilityMap.centerMapForMapKit(mapView, location: locationC, regionRadius: ActVars.mapKitRadius)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        self.view.addSubview(toolbar)
        self.view.addSubview(mapView)
    }
}
