/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import UserNotifications

class ViewControllerSETTINGSLOCATIONEDIT: UIViewController, CLLocationManagerDelegate {

    let labelTextView = UITextView()
    let latTextView = UITextView()
    let lonTextView = UITextView()
    let statusTextView = UITextView()
    var status = ""
    var numLocsLocalStr = ""
    let boolean = [String: String]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        editor.putString("LOCATION_CANADA_PROV", "")
        editor.putString("LOCATION_CANADA_CITY", "")
        editor.putString("LOCATION_CANADA_ID", "")
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
        var textViews = [labelTextView, latTextView, lonTextView, statusTextView]
        labelTextView.text = "Label"
        latTextView.text = "Lat"
        lonTextView.text = "Lon"
        textViews.forEach {$0.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize + 5.0)}
        textViews[3].font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize - 5.0)
        (0...6).forEach {_ in textViews.append(UITextView())}
        let stackView = UIStackView(arrangedSubviews: textViews)
        setupStackView(stackView)
        view.addSubview(stackView)
        let viewsDictionary = ["stackView": stackView]
        let stackViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|",
                                                        options: NSLayoutFormatOptions(rawValue: 0),
                                                        metrics: nil,
                                                        views: viewsDictionary)
        let stackViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-70-[stackView]-70-|",
                                                        options: NSLayoutFormatOptions(rawValue: 0),
                                                        metrics: nil,
                                                        views: viewsDictionary)
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
        }
    }

    func setupStackView(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func doneClicked() {
        Location.refreshLocationData()
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    @objc func saveClicked() {
        status = Location.locationSave(
            numLocsLocalStr,
            LatLon(latTextView.text!, lonTextView.text!),
            labelTextView.text!
        )
        statusTextView.text = status
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
            self.labelTextView.text = textField.text?.capitalized
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
        let caProv = preferences.getString("LOCATION_CANADA_PROV", "")
        let caCity = preferences.getString("LOCATION_CANADA_CITY", "")
        let caId = preferences.getString("LOCATION_CANADA_ID", "")
        if caProv != "" || caCity != "" || caId != "" {
            self.latTextView.text = "CANADA:" + caProv
            self.lonTextView.text = caId
            self.labelTextView.text = caCity + ", " + caProv
        }
        if self.latTextView.text.contains("CANADA:") && self.lonTextView.text != "" {
            saveClicked()
        }
    }
}
