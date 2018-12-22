/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABLOCATIONGL: ViewControllerTABPARENT {

    var locationButton = UITextView()
    var forecastText = [String]()
    var forecastImage = [UIImage]()
    var menuButton = ObjectToolbarIcon()
    var lastRefresh: Int64 = 0
    var currentTime: Int64 = 0
    var currentTimeSec: Int64 = 0
    var refreshIntervalSec: Int64 = 0
    var objFcst = ObjectForecastPackage()
    var objHazards = ObjectForecastPackageHazards()
    var objSevenDay = ObjectForecastPackage7Day()
    var textArr = [String: String]()
    var timeButton = ObjectToolbarIcon()
    var oldLocation = LatLon()
    var isUS = true
    var objLabel = ObjectTextView()
    var stackViewCurrentConditions: ObjectStackView!
    var stackViewForecast: ObjectStackView!
    var stackViewHazards: ObjectStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ActVars.vc = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        let toolbar = ObjectToolbar(.top)
        let radarButton = ObjectToolbarIcon(self, "ic_flash_on_24dp", #selector(radarClicked))
        let cloudButton = ObjectToolbarIcon(self, "ic_cloud_24dp", #selector(cloudClicked))
        let wfoTextButton = ObjectToolbarIcon(self, "ic_info_outline_24dp", #selector(wfotextClicked))
        menuButton = ObjectToolbarIcon(self, "ic_more_vert_white_24dp", #selector(menuClicked))
        let dashButton = ObjectToolbarIcon(self, "ic_report_24dp", #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                         target: nil,
                                         action: nil)
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ObjectToolbarItems([flexBarButton,
                                            dashButton,
                                            wfoTextButton,
                                            cloudButton,
                                            radarButton,
                                            menuButton]).items
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10.0).isActive = true
        _ = ObjectScrollStackView(self, scrollView, stackView, .TAB)
        self.view.addSubview(toolbar)
        self.stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
        self.stackViewForecast = ObjectStackView(.fill, .vertical)
        self.stackViewHazards = ObjectStackView(.fill, .vertical)
        self.getContentMaster()
    }

    func getContentMaster() {
        self.oldLocation = Location.latlon
        self.stackViewCurrentConditions.view.subviews.forEach {$0.removeFromSuperview()}
        self.stackViewForecast.view.subviews.forEach {$0.removeFromSuperview()}
        self.stackViewHazards.view.subviews.forEach {$0.removeFromSuperview()}
        self.stackView.subviews.forEach {$0.removeFromSuperview()}
        self.forecastImage = []
        self.forecastText = []
        self.stackViewHazards.view.isHidden = true
        //
        // location card loaded regardless of settings
        //
        let stackViewLocationButton = ObjectStackViewHS()
        stackViewLocationButton.setup()
        self.stackView.addArrangedSubview(stackViewLocationButton)
        self.objLabel = ObjectTextView(
            stackViewLocationButton,
            Location.name,
            UIFont.systemFont(ofSize: 20),
            UIColor.blue
        )
        self.objLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationAction)))
        self.getForecastData()
        self.getContent()
    }

    func getForecastData() {
        getLocationForecast()
        getLocationForecastSevenDay()
        getLocationHazards()
    }

    func getLocationForecast() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objFcst = Utility.getCurrentConditionsV2(Location.getCurrentLocation())
            DispatchQueue.main.async {
                //self.stackViewForecast.view.subviews.forEach {$0.removeFromSuperview()}
                self.getCurrentConditionCards(self.stackViewCurrentConditions.view)
            }
        }
    }

    func getLocationForecastSevenDay() {
        // FIXME on immediate phone restart sometimes 7day does not show
        // figure out a way to detect/retry once
        DispatchQueue.global(qos: .userInitiated).async {
            self.objSevenDay = Utility.getCurrentSevenDay(Location.getCurrentLocation())
            DispatchQueue.main.async {
                ObjectForecastPackage7Day.getSevenDayCards(
                    self.stackViewForecast.view,
                    self.objSevenDay,
                    self.isUS
                )
            }
        }
    }

    func getLocationHazards() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objHazards = Utility.getCurrentHazards(Location.getCurrentLocation())
            DispatchQueue.main.async {
                if ObjectForecastPackageHazards.getHazardCount(self.objHazards) > 0 {
                    ObjectForecastPackageHazards.getHazardCards(self.stackViewHazards.view, self.objHazards, self.isUS)
                    self.stackViewHazards.view.isHidden = false
                } else {
                    self.stackViewHazards.view.isHidden = true
                }
            }
        }
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if Location.isUS {
                self.isUS = true
            } else {
                self.isUS = false
                self.objHazards.hazards = self.objHazards.hazards.replaceAllRegexp("<.*?>", "")
            }
            DispatchQueue.main.async {
                let homescreenFav = TextUtils.split(preferences.getString("HOMESCREEN_FAV",
                                                                          MyApplication.homescreenFavDefault), ":")
                self.textArr = [:]
                homescreenFav.forEach {
                    switch $0 {
                    case "TXT-CC2":
                        self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                    case "TXT-HAZ":
                        self.stackView.addArrangedSubview(self.stackViewHazards.view)
                    case "TXT-7DAY2":
                        self.stackView.addArrangedSubview(self.stackViewForecast.view)
                    default:
                        let stackViewLocal = ObjectStackViewHS()
                        stackViewLocal.setup()
                        self.stackView.addArrangedSubview(stackViewLocal)
                        if $0.hasPrefix("TXT-") {
                            self.getContentText($0.split("-")[1], stackViewLocal)
                        } else if $0.hasPrefix("IMG-") {
                            self.getContentImage($0.split("-")[1], stackViewLocal)
                        }
                    }
                }
                self.lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
            }
        }
    }

    @objc override func cloudClicked() {
        UtilityActions.cloudClicked(self)
    }

    @objc override func radarClicked() {
        UtilityActions.radarClicked(self)
    }

    @objc override func wfotextClicked() {
        UtilityActions.wfotextClicked(self)
    }

    @objc override func menuClicked() {
        UtilityActions.menuClicked(self, menuButton)
    }

    @objc override func dashClicked() {
        UtilityActions.dashClicked(self)
    }

    @objc func willEnterForeground() {
        scrollView.scrollToTop()
        currentTime = UtilityTime.currentTimeMillis64()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = Int64(UIPreferences.refreshLocMin) * Int64(60)
        if currentTimeSec > (lastRefresh + refreshIntervalSec) {
            self.getContentMaster()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActVars.vc = self
        Location.checkCurrentLocationValidity()
        if Location.latlon != oldLocation {
            self.getContentMaster()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            editor.putString("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            self.objLabel.text = Location.name
            self.getContentMaster()
        } else {
            ActVars.settingsLocationEditNum = "0"
            self.goToVC("settingslocationedit")
        }
    }

    func editLocation() {
        ActVars.settingsLocationEditNum = Location.getCurrentLocationStr()
        self.goToVC("settingslocationedit")
    }

    func sunMoonData() {
        self.goToVC("sunmoondata")
    }

    @objc func locationAction() {
        let alert = UIAlertController(title: "Select location:",
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.actionSheet)
        MyApplication.locations.indices.forEach { location in
            let action = UIAlertAction(title: Location.getName(location),
                                       style: .default,
                                       handler: {_ in self.locationChanged(location)})
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Add location..",
                                      style: .default,
                                      handler: {_ in self.locationChanged(Location.numLocations)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc func ccAction() {
        let alert2 = UIAlertController(title: "Select from:",
                                       message: "",
                                       preferredStyle: UIAlertControllerStyle.actionSheet)
        alert2.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: {_ in self.editLocation()}))
        alert2.addAction(UIAlertAction(title: "Sun/Moon data..", style: .default, handler: {_ in self.sunMoonData()}))
        alert2.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: {_ in self.getContentMaster()}))
        alert2.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        if let popoverController = alert2.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert2, animated: true, completion: nil)
    }

    // FIXME move to class as static method
    func getCurrentConditionCards(_ stackView: UIStackView) {
        let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        let ccCard = ObjectCardCC(stackView, objFcst, isUS)
        ccCard.addGestureRecognizer(tapOnCC1, tapOnCC2, tapOnCC3)
    }

    func getContentText(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product)
            DispatchQueue.main.async {
                self.textArr[product] = html
                let objTv = ObjectTextView(stackView, html.truncate(UIPreferences.homescreenTextLength))
                objTv.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.textTap(sender:)))
                )
            }
        }
    }

    @objc func textTap(sender: UITapGestureRecognizerWithData) {
        if let v = sender.view as? UITextView {
            let currentLength = v.text!.count
            if currentLength < (UIPreferences.homescreenTextLength + 1) {
                v.text = textArr[sender.strData]
            } else {
                v.text = textArr[sender.strData]?.truncate(UIPreferences.homescreenTextLength)
            }
        }
    }

    func getContentImage(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityDownload.getImageProduct(product)
            DispatchQueue.main.async {
                let imgObj = ObjectImage(stackView, bitmap, hs: true)
                imgObj.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.imageTap(sender:)))
                )
            }
        }
    }

    @objc func imageTap(sender: UITapGestureRecognizerWithData) {
        var token = ""
        switch sender.strData {
        case "VIS_1KM":
            token = "wpcimg"
        case "FMAP":
            token = "wpcimg"
        case "VIS_CONUS":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "02"
            token = "goes16"
        case "CONUSWV":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "09"
            token = "goes16"
        case "SWOD1":
            ActVars.spcswoDay = "1"
            token = "spcswo"
        case "SWOD2":
            ActVars.spcswoDay = "2"
            token = "spcswo"
        case "SWOD3":
            ActVars.spcswoDay = "3"
            token = "spcswo"
        case "STRPT":
            ActVars.spcStormReportsDay = "today"
            token = "spcstormreports"
        case "SND":
            token = "sounding"
        case "SPCMESO_500":
            token = "spcmeso"
        case "SPCMESO_MSLP":
            token = "spcmeso"
        case "SPCMESO_TTD":
            token = "spcmeso"
        case "GOES16":
            ActVars.goesSector = ""
            ActVars.goesProduct = ""
            token = "goes16"
        default:
            token = "wpcimg"
        }
        self.goToVC(token)
    }
}
