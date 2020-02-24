/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import MapKit

public class ObjectMap {
    
    let mapView = MKMapView()
    var mapShown = false
    var officeType: OfficeTypeEnum
    
    init(_ officeType: OfficeTypeEnum) {
        self.officeType = officeType
    }
    
    func setupMap( _ itemList: [String]) {
        let locations = createLocationsList(itemList)
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
        centerMapOnLocation(location: usCenter, regionRadius: MyApplication.mapRegionRadius)
    }
    
    func createLocationsList(_ itemList: [String]) -> [[String: String]] {
        var locations = [[String: String]]()
        itemList.forEach {
            let ridArr = $0.split(":")
            let latLon: LatLon
            switch officeType {
            case .WFO:
                latLon = Utility.getWfoSiteLatLon(ridArr[0])
            case .RADAR:
                latLon = Utility.getRadarSiteLatLon(ridArr[0])
            case .SOUNDING:
                latLon = Utility.getSoundingSiteLatLon(ridArr[0])
            }
            //let latlon = Utility.getWfoSiteLatLon(ridArr[0])
            if ridArr.count > 1 {
                let arr = [
                    "name": ridArr[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": ridArr[1]
                ]
                locations.append(arr)
            } else {
                let arr = [
                    "name": ridArr[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": ""
                ]
                locations.append(arr)
            }
        }
        return locations
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, regionRadius: Double) {
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
    
    func toggleMap(_ uiv: UIViewController) {
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            uiv.view.addSubview(mapView)
        }
    }
}
