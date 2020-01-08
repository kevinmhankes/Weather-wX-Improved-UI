/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
    var toolbar = ObjectToolbar(.top)
    var toolbarBottom = ObjectToolbar(.bottom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longTapGesture)
        Utility.writePref("LOCATION_CANADA_PROV", "")
        Utility.writePref("LOCATION_CANADA_CITY", "")
        Utility.writePref("LOCATION_CANADA_ID", "")
        self.locationManager.delegate = self
        toolbar = ObjectToolbar(.top)
        toolbarBottom = ObjectToolbar(.bottom)
        let caButton = ObjectToolbarIcon(title: "Canada", self, #selector(caClicked))
        let doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        let doneButton2 = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        let saveButton = ObjectToolbarIcon(self, .save, #selector(saveClicked))
        let searchButton = ObjectToolbarIcon(self, .search, #selector(searchClicked))
        let deleteButton = ObjectToolbarIcon(self, .delete, #selector(deleteClicked))
        let gpsButton = ObjectToolbarIcon(self, .gps, #selector(gpsClicked))
        let items = [doneButton, GlobalVariables.flexBarButton, searchButton, gpsButton, saveButton]
        var itemsBottom = [doneButton2, GlobalVariables.flexBarButton, caButton]
        if Location.numLocations > 1 {
            itemsBottom.append(deleteButton)
        }
        toolbar.items = ObjectToolbarItems(items).items
        toolbarBottom.items = ObjectToolbarItems(itemsBottom).items
        self.view.addSubview(toolbar)
        self.view.addSubview(toolbarBottom)
        toolbar.setConfigWithUiv(uiv: self, toolbarType: .top)
        toolbarBottom.setConfigWithUiv(uiv: self)
        labelTextView = ObjectTextView("Label")
        latTextView = ObjectTextView("Lat")
        lonTextView = ObjectTextView("Lon")
        statusTextView = ObjectTextView("")
        let textViews = [labelTextView.view, latTextView.view, lonTextView.view, statusTextView.view]
        textViews.forEach {
            $0.font = FontSize.extraLarge.size
            $0.isEditable = true
        }
        textViews[3].font = FontSize.extraSmall.size
        textViews[3].isEditable = false
        let stackView = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: textViews + [mapView])
        stackView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView.view)
        let topSpace = UIPreferences.toolbarHeight + UtilityUI.getTopPadding()
        let bottomSpace = UIPreferences.toolbarHeight + UtilityUI.getBottomPadding()
        stackView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace).isActive = true
        stackView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomSpace).isActive = true
        if ActVars.settingsLocationEditNum == "0" {
            numLocsLocalStr = String(Location.numLocations + 1)
        } else {
            numLocsLocalStr = ActVars.settingsLocationEditNum
            let locIdx = Int(numLocsLocalStr)! - 1
            labelTextView.text = Location.getName(locIdx)
            latTextView.text = MyApplication.locations[locIdx].lat
            lonTextView.text = MyApplication.locations[locIdx].lon
            var latString = MyApplication.locations[locIdx].lat
            var lonString = MyApplication.locations[locIdx].lon
            if !Location.isUS(locIdx) {
                latString = MyApplication.locations[locIdx].lat.split(":")[2]
                lonString = "-" + MyApplication.locations[locIdx].lon.split(":")[1]
            }
            let locationC = CLLocationCoordinate2D(
                latitude: Double(latString) ?? 0.0,
                longitude: Double(lonString) ?? 0.0
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
        var latString = latTextView.view.text!
        var lonString = lonTextView.view.text!
        if self.latTextView.text.contains("CANADA:") && self.lonTextView.text != "" {
            print(self.latTextView.text)
            print(self.lonTextView.text)
            if latTextView.view.text!.split(":").count > 2 {
                latString = latTextView.view.text!.split(":")[2]
            }
            if self.lonTextView.text.contains(":") {
                lonString = "-" + lonTextView.view.text!.split(":")[1]
            }
        }
        centerMap(latString, lonString)
    }

    func centerMap(_ lat: String, _ lon: String) {
        let locationC = CLLocationCoordinate2D(
            latitude: Double(lat) ?? 0.0,
            longitude: Double(lon) ?? 0.0
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
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: {_ in
                    let textField = alert.textFields![0]
                    self.searchAddress(textField.text!)
                    //self.labelTextView.view.text = textField.text?.capitalized
                }
            )
        )
        self.present(alert, animated: true, completion: nil)
    }

    func searchAddress(_ address: String) {
        CLGeocoder().geocodeAddressString(
            address,
            completionHandler: {(placemarks, error) in
                if error != nil {
                    return
                }
                if (placemarks?.count)! > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    let locationName: String
                    if placemark?.locality != nil && placemark?.administrativeArea != nil {
                        locationName = (placemark?.administrativeArea! ?? "") + ", " + (placemark?.locality! ?? "")
                    } else {
                        locationName = "Location"
                    }
                    //print(locationName)
                    self.labelTextView.text = locationName
                    self.latTextView.text = String(coordinate!.latitude)
                    self.lonTextView.text = String(coordinate!.longitude)
                    if self.latTextView.text != "" && self.lonTextView.text != "" {
                        self.saveClicked()
                    }
                }
        }
        )
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
            //self.saveClicked()
            getAddressAndSaveLocation(self.latTextView.text, self.lonTextView.text)
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
            //print(locationOnMap)
            getAddressAndSaveLocation(String(locationOnMap.latitude), String(locationOnMap.longitude))
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
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .contactAdd) // was infoDark
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
        centerMap(lat, lon)
    }

    func getAddressAndSaveLocation(_ latStr: String, _ lonStr: String) {
        var center = CLLocationCoordinate2D()
        let lat = Double(latStr) ?? 0.0
        let lon = Double(lonStr) ?? 0.0
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(
            loc,
            completionHandler: { (placemarks, error) in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm)
                    let locationName: String
                    if pm.locality != nil && pm.administrativeArea != nil {
                        locationName = pm.administrativeArea! + ", " + pm.locality!
                    } else {
                        locationName = "Location"
                    }
                    self.saveFromMap(locationName, latStr, lonStr)
                }
            }
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                    print("Dark mode")
                } else {
                    AppColors.update()
                    print("Light mode")
                }
                view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
                toolbar.setColorToTheme()
                toolbarBottom.setColorToTheme()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: UIKeyCommand.inputEscape,
             modifierFlags: [],
             action: #selector(doneClicked))
        ]
    }
}
