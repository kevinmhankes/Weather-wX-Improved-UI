/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import MapKit

final class UtilityMap {

    static func genMapURL(_ xStr: String, _ yStr: String, _ zoomLevel: String) -> String {
        return "http://www.openstreetmap.org/?mlat=" + xStr + "&mlon=" + yStr + "&zoom=" + zoomLevel + "&layers=M"
    }

    static func genMapURLFromStreetAddress(_ streetAddr: String) -> String {
        return "http://www.openstreetmap.org/search?query=" + streetAddr.replace(",", "%2C").replace(" ", "%20")
    }

    static func setupMap(_ mapView: MKMapView, _ itemList: [String], _ prefVar: String) {
        let locations = createLocationsArray(itemList, prefVar)
        var annotations = [MKPointAnnotation]()
        locations.forEach { dictionary in
            let latitude = CLLocationDegrees(Double(dictionary["latitude"]!)!)
            let longitude = CLLocationDegrees(Double(dictionary["longitude"]!)!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"]!
            let mediaURL = dictionary["mediaURL"]
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        let usCenter = CLLocationCoordinate2D(latitude: Location.latlon.lat, longitude: Location.latlon.lon)
        centerMapOnLocation(mapView, location: usCenter, regionRadius: MyApplication.mapRegionRadius)
    }

    static func createLocationsArray(_ itemList: [String], _ prefVar: String) -> [[String: String]] {
        var locations = [[String: String]]()
        itemList.forEach {
            let ridArr = $0.split(":")
            let latStr = Utility.readPref(prefVar + ridArr[0] + "_X", "40.00")
            var lonStr = Utility.readPref(prefVar + ridArr[0] + "_Y", "80.00")
            if !lonStr.hasPrefix("-") {
                lonStr = "-" + lonStr
            }
            if ridArr.count > 1 {
                let arr = ["name": ridArr[0], "latitude": latStr, "longitude": lonStr, "mediaURL": ridArr[1]]
                locations.append(arr)
            } else {
                let arr = ["name": ridArr[0], "latitude": latStr, "longitude": lonStr, "mediaURL": ""]
                locations.append(arr)
            }
        }
        return locations
    }

    static func setupMapForWfo(_ mapView: MKMapView, _ itemList: [String]) {
        let locations = createLocationsArrayForWfo(itemList)
        var annotations = [MKPointAnnotation]()
        locations.forEach { dictionary in
            let latitude = CLLocationDegrees(Double(dictionary["latitude"]!)!)
            let longitude = CLLocationDegrees(Double(dictionary["longitude"]!)!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"]!
            let mediaURL = dictionary["mediaURL"]
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        let usCenter = CLLocationCoordinate2D(latitude: Location.latlon.lat, longitude: Location.latlon.lon)
        centerMapOnLocation(mapView, location: usCenter, regionRadius: MyApplication.mapRegionRadius)
    }

    static func createLocationsArrayForWfo(_ itemList: [String]) -> [[String: String]] {
        var locations = [[String: String]]()
        itemList.forEach {
            let ridArr = $0.split(":")
            let latlon = Utility.getWfoSiteLatLon(ridArr[0])
            if ridArr.count > 1 {
                let arr = [
                    "name": ridArr[0],
                    "latitude": latlon.latString,
                    "longitude": latlon.lonString,
                    "mediaURL": ridArr[1]
                ]
                locations.append(arr)
            } else {
                let arr = [
                    "name": ridArr[0],
                    "latitude": latlon.latString,
                    "longitude": latlon.lonString,
                    "mediaURL": ""
                ]
                locations.append(arr)
            }
        }
        return locations
    }

    static func centerMapOnLocation(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: height
                - UIPreferences.toolbarHeight
                - UtilityUI.getBottomPadding()
                - UtilityUI.getTopPadding()
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }

    static func centerMapOnLocationEdit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: width
        )
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    static func centerMapForMapKit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: height
                - UIPreferences.toolbarHeight
                - UtilityUI.getBottomPadding()
                - UtilityUI.getTopPadding()
        )
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    static func mapView(_ mapView: MKMapView, _ annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinTintColor = .red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }

    static func mapViewExtra(
        _ mapView: MKMapView,
        _ annotationView: MKAnnotationView,
        _ control: UIControl,
        _ localChanges: (MKAnnotationView) -> Void
    ) -> Bool {
        var mapShown = true
        if control == annotationView.rightCalloutAccessoryView {
            mapView.removeFromSuperview()
            mapShown = false
            localChanges(annotationView)
        }
        return mapShown
    }
}
