/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()

    func checkLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("already authorized")
        case .notDetermined, .restricted, .denied:
            print("show help")
        default:
            print("future options")
        }
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    // needed for Radar/GPS setting
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
}
