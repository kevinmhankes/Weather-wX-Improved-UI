/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import simd

final class vcTabLocation: vcTabParent {

    var menuButton = ToolbarIcon()
//    private var lastRefresh: Int64 = 0
//    private var currentTime: Int64 = 0
//    private var currentTimeSec: Int64 = 0
//    private var refreshIntervalSec: Int64 = 0
    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var textArr = [String: String]()
    private var oldLocation = LatLon()
    private var isUS = true
    private var locationLabel = Text()
    private var stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
    private var stackViewForecast = ObjectStackView(.fill, .vertical)
    private var stackViewHazards = ObjectStackView(.fill, .vertical)
    var stackViewRadar = ObjectStackViewHS()
    private var objectCardCurrentConditions: ObjectCardCurrentConditions?
    private var objectCardSevenDayCollection: ObjectCardSevenDayCollection?
    private var extraDataCards = [ObjectStackViewHS]()
    private var toolbar = ObjectToolbar()
    private var globalHomeScreenFav = ""
    private var globalTextViewFontSize: CGFloat = 0.0
    private let downloadTimer = DownloadTimer("MAIN_LOCATION_TAB")
    private var nexradTab = NexradTab()
    #if targetEnvironment(macCatalyst)
    private var oneMinRadarFetch = Timer()
    #endif

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toolbar.resize(uiv: self)
        fab?.resize()
        let topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        if objScrollStackView != nil && objScrollStackView!.fragmentHeightAnchor1 != nil {
            view.removeConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
        if objScrollStackView != nil {
            objScrollStackView!.fragmentHeightAnchor1 = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIPreferences.tabBarHeight)
            objScrollStackView!.fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace)
            objScrollStackView!.fragmentWidthAnchor1 = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            objScrollStackView!.fragmentWidthAnchor2 = scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            view.addConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        toolbar = ObjectToolbar()
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        let cloudButton = ToolbarIcon(self, .cloud, #selector(cloudClicked))
        let wfoTextButton = ToolbarIcon(self, .wfo, #selector(wfotextClicked))
        menuButton = ToolbarIcon(self, .submenu, #selector(menuClicked))
        let dashButton = ToolbarIcon(self, .severeDashboard, #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        if UIPreferences.mainScreenRadarFab {
            toolbar.items = ToolbarItems([
                GlobalVariables.flexBarButton,
                dashButton,
                wfoTextButton,
                cloudButton,
                menuButton
            ]).items
        } else {
            toolbar.items = ToolbarItems([
                GlobalVariables.flexBarButton,
                dashButton,
                wfoTextButton,
                cloudButton,
                radarButton,
                menuButton
            ]).items
        }
        view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self, toolbarType: .top)
        stackView.get().widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        if objScrollStackView != nil && objScrollStackView!.fragmentHeightAnchor1 != nil {
            view.removeConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
        objScrollStackView = ScrollStackView(self, scrollView, stackView.get())
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        globalTextViewFontSize = UIPreferences.textviewFontSize
        addLocationSelectionCard()
        getContentSuper()
        #if targetEnvironment(macCatalyst)
        oneMinRadarFetch = Timer.scheduledTimer(
            timeInterval: 60.0 * Double(UIPreferences.refreshLocMin),
            target: self,
            selector: #selector(getContentSuper),
            userInfo: nil,
            repeats: true
        )
        #endif
    }

    @objc func getContentSuper() {
        oldLocation = Location.latLon
//        if Location.isUS {
//            isUS = true
//        } else {
//            isUS = false
//        }
        isUS = Location.isUS
        clearViews()
        getForecastData()
        getContent()
    }

    func getForecastData() {
        _ = FutureVoid({ self.objectCurrentConditions = ObjectCurrentConditions(Location.getCurrentLocation()) }, { self.getCurrentConditionCards() })
        _ = FutureVoid(downloadSevenDay, updateSevenDay)
        _ = FutureVoid(downloadHazards, updateHazards)
        if fab != nil {
            view.bringSubviewToFront(fab!.view)
        }
    }

    func downloadSevenDay() {
        objectSevenDay = ObjectSevenDay(Location.getCurrentLocation())
        objectSevenDay.locationIndex = Location.getCurrentLocation()
    }

    func updateSevenDay() {
        if objectCardSevenDayCollection == nil
            || !isUS
            || objectSevenDay.locationIndex != objectCardSevenDayCollection?.locationIndex
            || objectCardSevenDayCollection?.objectCardSevenDayList.count == 0 {
            stackViewForecast.view.subviews.forEach { $0.removeFromSuperview() }
            objectCardSevenDayCollection = ObjectCardSevenDayCollection(
                stackViewForecast,
                scrollView,
                objectSevenDay,
                isUS
            )
            objectCardSevenDayCollection?.locationIndex = Location.getCurrentLocation()
        } else {
            objectCardSevenDayCollection?.update(
                objectSevenDay,
                isUS
            )
        }
    }

    func downloadHazards() {
        objectHazards = Utility.getCurrentHazards(self, Location.getCurrentLocation())
    }

    func updateHazards() {
        if ObjectHazards.getHazardCount(objectHazards) > 0 {
            ObjectHazards.getHazardCards(stackViewHazards, objectHazards, isUS)
            stackViewHazards.isHidden = false
        } else {
            stackViewHazards.isHidden = true
        }
    }

    func getContent() {
        _ = FutureVoid(mainDownload, mainDisplay)
    }

    private func mainDownload() {
        if Location.isUS {
            isUS = true
        } else {
            isUS = false
            objectHazards.hazards = objectHazards.hazards.replaceAllRegexp("<.*?>", "")
        }
    }

    private func mainDisplay() {
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let homescreenFav = TextUtils.split(globalHomeScreenFav, ":")
        textArr = [:]
        homescreenFav.forEach {
            switch $0 {
            case "TXT-CC2":
                stackView.addLayout(stackViewCurrentConditions)
                stackViewCurrentConditions.constrain(stackView)
            case "TXT-HAZ":
                stackView.addLayout(stackViewHazards)
                stackViewHazards.constrain(stackView)
            case "TXT-7DAY2":
                stackView.addLayout(stackViewForecast)
                stackViewForecast.constrain(stackView)
            case "METAL-RADAR":
                stackViewRadar = ObjectStackViewHS()
                stackView.addLayout(stackViewRadar)
                nexradTab.uiv = self
                nexradTab.getNexradRadar(stackViewRadar.get())
            default:
                let stackViewLocal = ObjectStackViewHS()
                stackView.addLayout(stackViewLocal)
                stackViewLocal.setup(stackView.get())
                extraDataCards.append(stackViewLocal)
                if $0.hasPrefix("TXT-") {
                    let product = $0.replace("TXT-", "")
                    getContentText(product, stackViewLocal.get())
                } else if $0.hasPrefix("IMG-") {
                    let product = $0.replace("IMG-", "")
                    getContentImage(product, stackViewLocal)
                }
            }
        }
        // lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
    }

    override func cloudClicked() {
        Route.cloud(self)
    }

    override func radarClicked() {
        Route.radarFromMainScreen(self)
    }

    override func wfotextClicked() {
        Route.wfoText(self)
    }

    override func menuClicked() {
        UtilityActions.menuClicked(self, menuButton)
    }

    override func dashClicked() {
        Route.severeDashboard(self)
    }

    @objc override func willEnterForeground() {
        super.willEnterForeground()
        updateColors()
        if objectCardSevenDayCollection != nil && objectCardSevenDayCollection!.objectCardSunTime != nil {
            objectCardSevenDayCollection!.objectCardSunTime!.update()
        }
        scrollView.scrollToTop()
        if downloadTimer.isRefreshNeeded() {
            print("AAA getContentSuper")
            getContentSuper()
        }
//        currentTime = UtilityTime.currentTimeMillis64()
//        currentTimeSec = currentTime / 1000
//        refreshIntervalSec = Int64(UIPreferences.refreshLocMin) * Int64(60)
//        if currentTimeSec > (lastRefresh + refreshIntervalSec) {
//            lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
//            getContentSuper()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(UIPreferences.backButtonAnimation)
        updateColors()
        locationLabel.text = Location.name
        let newhomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let textSizeHasChange = abs(UIPreferences.textviewFontSize - globalTextViewFontSize) > 0.5
        Location.checkCurrentLocationValidity()
        if (Location.latLon != oldLocation) || (newhomeScreenFav != globalHomeScreenFav) || textSizeHasChange {
            scrollView.scrollToTop()
            objectCardCurrentConditions?.resetTextSize()
            objectCardSevenDayCollection?.resetTextSize()
            locationLabel.font = FontSize.extraLarge.size
            getContentSuper()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            // Utility.writePref("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            locationLabel.text = Location.name
            getContentSuper()
        } else {
            Route.locationAdd(self)
        }
    }

    func editLocation() {
        Route.locationEdit(self, Location.getCurrentLocationStr())
    }

    @objc func locationAction() {
        let alert = UIAlertController(title: "Select location:", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        (0..<Location.numberOfLocations).forEach { index in
            let action = UIAlertAction(title: Location.getName(index), style: .default, handler: { _ in self.locationChanged(index) })
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Add location..", style: .default, handler: { _ in self.locationChanged(Location.numLocations) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }

    @objc func ccAction() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        alert.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: { _ in self.editLocation() }))
        alert.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: { _ in self.getContentSuper() }))
        if UtilitySettings.isRadarInHomeScreen() {
            alert.addAction(UIAlertAction(
                                title: Location.rid + ": " + WXGLNexrad.getRadarTimeStamp(nexradTab.wxMetal[0]!.fileStorage),
                                style: .default,
                                handler: { _ in Route.radarFromMainScreen(self) })
                            )
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
    
    @objc func gotoHourly() {
        goToVC(vcHourly())
    }

    func getCurrentConditionCards() {
        if objectCardCurrentConditions == nil {
            let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(ccAction))
            let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
            let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
            objectCardCurrentConditions = ObjectCardCurrentConditions(stackViewCurrentConditions, objectCurrentConditions, isUS)
            objectCardCurrentConditions?.addGestureRecognizer(tapOnCC1, tapOnCC2, tapOnCC3)
        } else {
            objectCardCurrentConditions?.updateCard(objectCurrentConditions, isUS)
        }
    }

    func getContentText(_ product: String, _ stackView: UIStackView) {
        _ = FutureText(product.uppercased(), { s in self.displayText(product, stackView, s) })
    }

    private func displayText(_ product: String, _ stackView: UIStackView, _ html: String) {
        textArr[product] = html
        let objectTextView = Text(stackView, html.truncate(UIPreferences.homescreenTextLength))
        if product == "HOURLY" || UtilityWpcText.needsFixedWidthFont(product.uppercased()) {
            objectTextView.font = FontSize.hourly.size
        }
        objectTextView.addGesture(GestureData(product, self, #selector(textTap)))
        objectTextView.accessibilityLabel = html
        objectTextView.isSelectable = false
    }

    @objc func textTap(sender: GestureData) {
        if let v = sender.view as? UITextView {
            let currentLength = v.text!.count
            if currentLength < (UIPreferences.homescreenTextLength + 1) {
                v.text = textArr[sender.strData]
            } else {
                v.text = textArr[sender.strData]?.truncate(UIPreferences.homescreenTextLength)
            }
        }
    }

    func getContentImage(_ product: String, _ stackView: ObjectStackViewHS) {
        _ = FutureBytes2({ UtilityDownload.getImageProduct(product) }, { bitmap in self.displayImage(product, stackView, bitmap) })
    }

    private func displayImage(_ product: String, _ stackView: ObjectStackViewHS, _ bitmap: Bitmap) {
        let imgObj = ObjectImage(scrollView, stackView, bitmap, hs: true)
        imgObj.addGestureRecognizer(GestureData(product, self, #selector(imageTap)))
    }

    @objc func imageTap(sender: GestureData) {
        UtilityHomeScreen.jumpToActivity(self, sender.strData)
    }

    func addLocationSelectionCard() {
        //
        // location card loaded regardless of settings
        //
        let stackViewLocationButton = ObjectStackViewHS()
        stackView.addLayout(stackViewLocationButton)
        stackViewLocationButton.setup(stackView.get())
        locationLabel = Text(stackViewLocationButton, Location.name, FontSize.extraLarge.size, ColorCompatibility.highlightText)
        locationLabel.addGesture(UITapGestureRecognizer(target: self, action: #selector(locationAction)))
        locationLabel.isSelectable = false
    }

    // Clear all views except 7day and current conditions
    func clearViews() {
//        stackViewHazards.view.subviews.forEach {
//            $0.removeFromSuperview()
//        }
        stackViewHazards.removeChildren()
        extraDataCards.forEach {
            $0.removeFromSuperview()
        }
        extraDataCards.removeAll()
        stackViewHazards.isHidden = true
        stackViewRadar.removeFromSuperview()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                } else {
                }
                updateColors()
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override func updateColors() {
        toolbar.setColorToTheme()
        locationLabel.color = ColorCompatibility.highlightText
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        setTabBarColor()
        if UIPreferences.mainScreenRadarFab {
            fab?.setColor()
        }
    }
}
