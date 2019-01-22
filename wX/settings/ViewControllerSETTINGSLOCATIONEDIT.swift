/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import UserNotifications

class ViewControllerSETTINGSLOCATIONEDIT: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var labelTextView = ObjectTextView()
    var latTextView = ObjectTextView()
    var lonTextView = ObjectTextView()
    var statusTextView = ObjectTextView()
    var status = ""
    var numLocsLocalStr = ""
    let boolean = [String: String]()
    let locationManager = CLLocationManager()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longTapGesture)
        Utility.writePref("LOCATION_CANADA_PROV", "")
        Utility.writePref("LOCATION_CANADA_CITY", "")
        Utility.writePref("LOCATION_CANADA_ID", "")
        self.locationManager.delegate = self
        let toolbar = ObjectToolbar(.top)
        let toolbarBottom = ObjectToolbar(.bottom)
        let caButton = ObjectToolbarIcon(title: "Canada", self, #selector(caClicked))
        let doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        let doneButton2 = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        let saveButton = ObjectToolbarIcon(self, .save, #selector(saveClicked))
        let searchButton = ObjectToolbarIcon(self, .search, #selector(searchClicked))
        let deleteButton = ObjectToolbarIcon(self, .delete, #selector(deleteClicked))
        let gpsButton = ObjectToolbarIcon(self, .gps, #selector(gpsClicked))
        let items = [doneButton, flexBarButton, searchButton, gpsButton, saveButton]
        var itemsBottom = [doneButton2, flexBarButton, caButton]
        if Location.numLocations > 1 {
            itemsBottom.append(deleteButton)
        }
        toolbar.items = ObjectToolbarItems(items).items
        toolbarBottom.items = ObjectToolbarItems(itemsBottom).items
        self.view.addSubview(toolbar)
        self.view.addSubview(toolbarBottom)
        labelTextView = ObjectTextView("Label")
        latTextView = ObjectTextView("Lat")
        lonTextView = ObjectTextView("Lon")
        statusTextView = ObjectTextView("")
        var textViews = [labelTextView.view, latTextView.view, lonTextView.view, statusTextView.view]
        textViews.forEach {
            $0.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 5.0)
            $0.isEditable = true
        }
        textViews[3].font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize - 5.0)
        textViews[3].isEditable = false
        let stackView = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: textViews + [mapView])
        stackView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView.view)
        let viewsDictionary = ["stackView": stackView.view]
        let stackViewH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",
            options: .alignAllCenterX,
            metrics: nil,
            views: viewsDictionary
        )
        let topSpace = String(50 + Int(Float(UtilityUI.getTopPadding())))
        let bottomSpace = String(Int(UIPreferences.toolbarHeight) + Int(Float(UtilityUI.getBottomPadding())))
        let stackViewV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-" + topSpace + "-[stackView]-" + bottomSpace + "-|",
            options: .alignAllCenterX,
            metrics: nil,
            views: viewsDictionary
        )
        view.addConstraints(stackViewH)
        view.addConstraints(stackViewV)
        if ActVars.settingsLocationEditNum == "0" {
            numLocsLocalStr = String(Location.numLocations + 1)
        } else {
            numLocsLocalStr = ActVars.settingsLocationEditNum
            let locIdx = Int(numLocsLocalStr)! - 1
            labelTextView.text = Location.getName(locIdx)
            latTextView.text = MyApplication.locations[locIdx].lat
            lonTextView.text = MyApplication.locations[locIdx].lon
            let locationC = CLLocationCoordinate2D(
                latitude: Double(MyApplication.locations[locIdx].lat) ?? 0.0,
                longitude: Double(MyApplication.locations[locIdx].lon) ?? 0.0
            )
            UtilityMap.centerMapOnLocationEdit(mapView, location: locationC, regionRadius: 50000.0)
        }
    }

    @objc func doneClicked() {
        Location.refreshLocationData()
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    @objc func saveClicked() {
        status = Location.locationSave(
            numLocsLocalStr,
            LatLon(latTextView.view.text!, lonTextView.view.text!),
            labelTextView.view.text!
        )
        statusTextView.text = status
        view.endEditing(true)
        let locationC = CLLocationCoordinate2D(
            latitude: Double(latTextView.view.text!) ?? 0.0,
            longitude: Double(lonTextView.view.text!) ?? 0.0
        )
        UtilityMap.centerMapOnLocationEdit(mapView, location: locationC, regionRadius: 50000.0)
    }

    @objc func deleteClicked() {
        Location.deleteLocation(numLocsLocalStr)
        doneClicked()
    }

    @objc func searchClicked() {
        let alert = UIAlertController(
            title: "Search for location",
            message: "Enter a city,state combination or a zipcode. After the search completes, "
                + "valid latitude and longitude values should appear. Hit save after they appear.",
            preferredStyle: .alert
        )
        alert.addTextField {(textField) in textField.text = ""}
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            let textField = alert.textFields![0]
            self.searchAddress(textField.text!)
            self.labelTextView.view.text = textField.text?.capitalized
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func searchAddress(_ address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) in
            if error != nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                self.latTextView.text = String(coordinate!.latitude)
                self.lonTextView.text = String(coordinate!.longitude)
                if self.latTextView.text != "" && self.lonTextView.text != "" {
                    self.saveClicked()
                }
            }
        })
    }

    @objc func gpsClicked() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        self.latTextView.text = String(locValue.latitude)
        self.lonTextView.text = String(locValue.longitude)
        if self.latTextView.text != "" && self.lonTextView.text != "" {
            self.saveClicked()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    @objc func caClicked() {
        self.goToVC("settingslocationcanada")
    }

    override func viewWillAppear(_ animated: Bool) {
        let caProv = Utility.readPref("LOCATION_CANADA_PROV", "")
        let caCity = Utility.readPref("LOCATION_CANADA_CITY", "")
        let caId = Utility.readPref("LOCATION_CANADA_ID", "")
        if caProv != "" || caCity != "" || caId != "" {
            self.latTextView.text = "CANADA:" + caProv
            self.lonTextView.text = caId
            self.labelTextView.text = caCity + ", " + caProv
        }
        if self.latTextView.text.contains("CANADA:") && self.lonTextView.text != "" {
            saveClicked()
        }
    }

    @objc func longPress(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let latlonTruncateLength = 9
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = String(location.latitude).truncate(latlonTruncateLength)
            + ","
            + String(location.longitude).truncate(latlonTruncateLength)
        annotation.subtitle = ""
        self.mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // TODO use pin or marker?
        // https://developer.apple.com/documentation/mapkit/mkpointannotation
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        if control == view.rightCalloutAccessoryView {
            if let locationString = view.annotation?.title! {
                let locationList = locationString.split(",")
                getAddressAndSaveLocation(locationList[0], locationList[1])
            }
        }
    }

    func saveFromMap(_ locationName: String, _ lat: String, _ lon: String) {
        // TODO get street address or city from lat/lon
        // https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
        labelTextView.text = locationName
        status = Location.locationSave(
            numLocsLocalStr,
            LatLon(lat, lon),
            labelTextView.view.text!
        )
        latTextView.text = lat
        lonTextView.text = lon
        statusTextView.text = status
        view.endEditing(true)
        let locationC = CLLocationCoordinate2D(
            latitude: Double(latTextView.view.text!) ?? 0.0,
            longitude: Double(lonTextView.view.text!) ?? 0.0
        )
        UtilityMap.centerMapOnLocationEdit(mapView, location: locationC, regionRadius: 50000.0)
    }

    func getAddressAndSaveLocation(_ latStr: String, _ lonStr: String) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double(latStr) ?? 0.0
        let lon: Double = Double(lonStr) ?? 0.0
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    //print(pm.country)
                    //print(pm.locality)
                    //print(pm.subLocality)
                    //print(pm.thoroughfare)
                    //print(pm.postalCode)
                    //print(pm.subThoroughfare)
                    let locationName: String
                    if pm.locality != nil {
                        locationName = pm.locality!
                    } else {
                        locationName = "Location"
                    }
                    self.saveFromMap(locationName, latStr, lonStr)
                }
        })
    }
}
