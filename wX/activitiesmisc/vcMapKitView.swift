// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class vcMapKitView: UIwXViewController, MKMapViewDelegate {

    private var latLonButton = ToolbarIcon()
    private let mapView = MKMapView()
    var mapKitLat = ""
    var mapKitLon = ""
    var mapKitRadius = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locationC = CLLocationCoordinate2D(latitude: to.Double(mapKitLat), longitude: to.Double(mapKitLon))
        ObjectMap.centerMapForMapKit(mapView, location: locationC, regionRadius: mapKitRadius)
        latLonButton = ToolbarIcon(self, #selector(showExternalMap))
        latLonButton.title = mapKitLat + ", " + mapKitLon
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, latLonButton]).items
        view.addSubview(mapView)
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
