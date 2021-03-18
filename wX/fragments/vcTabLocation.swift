/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import simd

final class vcTabLocation: vcTabParent {

    private var locationButton = UITextView()
    private var forecastText = [String]()
    private var forecastImage = [UIImage]()
    private var menuButton = ObjectToolbarIcon()
    private var lastRefresh: Int64 = 0
    private var currentTime: Int64 = 0
    private var currentTimeSec: Int64 = 0
    private var refreshIntervalSec: Int64 = 0
    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var textArr = [String: String]()
    private var timeButton = ObjectToolbarIcon()
    private var oldLocation = LatLon()
    private var isUS = true
    private var isUSDisplayed = true
    private var objLabel = ObjectTextView()
    private var stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
    private var stackViewForecast = ObjectStackView(.fill, .vertical)
    private var stackViewHazards = ObjectStackView(.fill, .vertical)
    private var stackViewRadar = ObjectStackViewHS()
    private var objectCardCurrentConditions: ObjectCardCurrentConditions?
    private var objectCardSevenDayCollection: ObjectCardSevenDayCollection?
    private var extraDataCards = [ObjectStackViewHS]()
    private var wxMetal = [WXMetalRender?]()
    private var metalLayer = [CAMetalLayer?]()
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var timer: CADisplayLink!
    private var projectionMatrix: float4x4!
    private var lastFrameTimestamp: CFTimeInterval = 0.0
    private let ortInt: Float = 350.0
    private let numberOfPanes = 1
    private var wxMetalTextObject = WXMetalTextObject()
    private var longPressCount = 0
    private var toolbar = ObjectToolbar()
    private var globalHomeScreenFav = ""
    // private var globalTextViewFontSize = UIPreferences.textviewFontSize
    private var globalTextViewFontSize: CGFloat = 0.0
    private var firstLoadCompleted = false
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
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        let cloudButton = ObjectToolbarIcon(self, .cloud, #selector(cloudClicked))
        let wfoTextButton = ObjectToolbarIcon(self, .wfo, #selector(wfotextClicked))
        menuButton = ObjectToolbarIcon(self, .submenu, #selector(menuClicked))
        let dashButton = ObjectToolbarIcon(self, .severeDashboard, #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        if UIPreferences.mainScreenRadarFab {
            toolbar.items = ObjectToolbarItems([
                GlobalVariables.flexBarButton,
                dashButton,
                wfoTextButton,
                cloudButton,
                menuButton
            ]).items
        } else {
            toolbar.items = ObjectToolbarItems([
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
        // stackView = UIStackView()
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        if objScrollStackView != nil && objScrollStackView!.fragmentHeightAnchor1 != nil {
            view.removeConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView)
//        stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
//        stackViewForecast = ObjectStackView(.fill, .vertical)
//        stackViewHazards = ObjectStackView(.fill, .vertical)
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        globalTextViewFontSize = UIPreferences.textviewFontSize
        addLocationSelectionCard()
        getContentMaster()
        #if targetEnvironment(macCatalyst)
        oneMinRadarFetch = Timer.scheduledTimer(
            timeInterval: 60.0 * Double(UIPreferences.refreshLocMin),
            target: self,
            selector: #selector(getContentMaster),
            userInfo: nil,
            repeats: true
        )
        #endif
    }

    @objc func getContentMaster() {
        firstLoadCompleted = true
        print("22234 getContentMaster")
        oldLocation = Location.latLon
        if Location.isUS {
            isUS = true
        } else {
            isUS = false
        }
        clearViews()
        getForecastData()
        getContent()
    }

    func getForecastData() {
        print("22234 Get forecast")
        getLocationForecast()
        getLocationForecastSevenDay()
        getLocationHazards()
        if fab != nil {
            view.bringSubviewToFront(fab!.view)
        }
    }

    func getLocationForecast() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objectCurrentConditions = ObjectCurrentConditions(Location.getCurrentLocation())
            DispatchQueue.main.async { self.getCurrentConditionCards() }
        }
    }

    func getLocationForecastSevenDay() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objectSevenDay = ObjectSevenDay(Location.getCurrentLocation())
            self.objectSevenDay.locationIndex = Location.getCurrentLocation()
            DispatchQueue.main.async {
                if self.objectCardSevenDayCollection == nil
                    || !self.isUS
                    || self.objectSevenDay.locationIndex != self.objectCardSevenDayCollection?.locationIndex
                    || self.objectCardSevenDayCollection?.objectCardSevenDayList.count == 0 {
                    self.stackViewForecast.view.subviews.forEach { $0.removeFromSuperview() }
                    self.objectCardSevenDayCollection = ObjectCardSevenDayCollection(
                        self.stackViewForecast.view,
                        self.scrollView,
                        self.objectSevenDay,
                        self.isUS
                    )
                    self.objectCardSevenDayCollection?.locationIndex = Location.getCurrentLocation()
                } else {
                    self.objectCardSevenDayCollection?.update(
                        self.objectSevenDay,
                        self.isUS
                    )
                }
            }
        }
    }

    func getLocationHazards() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objectHazards = Utility.getCurrentHazards(self, Location.getCurrentLocation())
            print("22234 get hazards")
            DispatchQueue.main.async {
                if ObjectHazards.getHazardCount(self.objectHazards) > 0 {
                    ObjectHazards.getHazardCards(self.stackViewHazards.view, self.objectHazards, self.isUS)
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
                self.objectHazards.hazards = self.objectHazards.hazards.replaceAllRegexp("<.*?>", "")
            }
            DispatchQueue.main.async {
                self.globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
                let homescreenFav = TextUtils.split(self.globalHomeScreenFav, ":")
                self.textArr = [:]
                homescreenFav.forEach {
                    switch $0 {
                    case "TXT-CC2":
                        self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                        self.stackViewCurrentConditions.view.widthAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
                    case "TXT-HAZ":
                        self.stackView.addArrangedSubview(self.stackViewHazards.view)
                        self.stackViewHazards.view.widthAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
                    case "TXT-7DAY2":
                        self.stackView.addArrangedSubview(self.stackViewForecast.view)
                        self.stackViewForecast.view.widthAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
                    case "METAL-RADAR":
                        self.stackViewRadar = ObjectStackViewHS()
                        self.stackView.addArrangedSubview(self.stackViewRadar)
                        self.getNexradRadar(self.stackViewRadar)
                    default:
                        let stackViewLocal = ObjectStackViewHS()
                        self.stackView.addArrangedSubview(stackViewLocal)
                        stackViewLocal.setup(self.stackView)
                        self.extraDataCards.append(stackViewLocal)
                        if $0.hasPrefix("TXT-") {
                            let product = $0.replace("TXT-", "")
                            self.getContentText(product, stackViewLocal)
                        } else if $0.hasPrefix("IMG-") {
                            let product = $0.replace("IMG-", "")
                            self.getContentImage(product, stackViewLocal)
                        }
                    }
                }
                self.lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
            }
        }
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
        currentTime = UtilityTime.currentTimeMillis64()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = Int64(UIPreferences.refreshLocMin) * Int64(60)
        if currentTimeSec > (lastRefresh + refreshIntervalSec) {
            lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
            getContentMaster()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        objLabel.text = Location.name
        let newhomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let textSizeHasChange = abs(UIPreferences.textviewFontSize - globalTextViewFontSize) > 0.5
        Location.checkCurrentLocationValidity()
        if (Location.latLon != oldLocation) || (newhomeScreenFav != globalHomeScreenFav) || textSizeHasChange {
            scrollView.scrollToTop()
            objectCardCurrentConditions?.resetTextSize()
            objectCardSevenDayCollection?.resetTextSize()
            objLabel.tv.font = FontSize.extraLarge.size
            if firstLoadCompleted {
                // print("22234 " + String(UIPreferences.textviewFontSize))
                print("22234 view appears")
                getContentMaster()
            }
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            Utility.writePref("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            objLabel.text = Location.name
            getContentMaster()
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
        present(alert, animated: true, completion: nil)
    }

    @objc func ccAction() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        alert.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: { _ in self.editLocation() }))
        alert.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: { _ in self.getContentMaster() }))
        if UtilitySettings.isRadarInHomeScreen() {
            alert.addAction(UIAlertAction(
                title: Location.rid + ": " + WXGLNexrad.getRadarTimeStamp(),
                style: .default,
                handler: { _ in Route.radarFromMainScreen(self) })
            )
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        present(alert, animated: true, completion: nil)
    }

    @objc func gotoHourly() {
        goToVC(vcHourly())
    }

    func getCurrentConditionCards() {
        let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(ccAction))
        let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        if objectCardCurrentConditions == nil {
            objectCardCurrentConditions = ObjectCardCurrentConditions(stackViewCurrentConditions.view, objectCurrentConditions, isUS)
            objectCardCurrentConditions?.addGestureRecognizer(tapOnCC1, tapOnCC2, tapOnCC3)
        } else {
            objectCardCurrentConditions?.updateCard(objectCurrentConditions, isUS)
        }
    }

    func getContentText(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product.uppercased())
            DispatchQueue.main.async {
                self.textArr[product] = html
                let objectTextView = ObjectTextView(stackView, html.truncate(UIPreferences.homescreenTextLength))
                if product == "HOURLY" || UtilityWpcText.needsFixedWidthFont(product.uppercased()) {
                    objectTextView.font = FontSize.hourly.size
                }
                objectTextView.addGestureRecognizer(UITapGestureRecognizerWithData(product, self, #selector(self.textTap(sender:))))
                objectTextView.tv.accessibilityLabel = html
                objectTextView.tv.isSelectable = false
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
                let imgObj = ObjectImage(self.scrollView, stackView, bitmap, hs: true)
                imgObj.addGestureRecognizer(UITapGestureRecognizerWithData(product, self, #selector(self.imageTap(sender:))))
            }
        }
    }

    func getNexradRadar(_ stackView: UIStackView) {
        let paneRange = [0]
        let device = MTLCreateSystemDefaultDevice()
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        let screenWidth = width
        let screenHeight = screenWidth
        let carect = CGRect(x: 0, y: 0, width: CGFloat(screenWidth), height: CGFloat(screenWidth))
        let caview = UIView(frame: carect)
        caview.widthAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        caview.heightAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        let surfaceRatio = Float(screenWidth) / Float(screenHeight)
        projectionMatrix = float4x4.makeOrtho(
            -1.0 * ortInt,
            right: ortInt,
            bottom: -1.0 * ortInt * (1.0 / surfaceRatio),
            top: ortInt * (1.0 / surfaceRatio),
            nearZ: -100.0,
            farZ: 100.0
        )
        paneRange.indices.forEach { index in
            if metalLayer.count < 1 {
                metalLayer.append(CAMetalLayer())
                metalLayer[index]!.device = device
                metalLayer[index]!.pixelFormat = .bgra8Unorm
                metalLayer[index]!.framebufferOnly = true
            }
        }
        metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: CGFloat(screenWidth), height: CGFloat(screenWidth))
        metalLayer.forEach { caview.layer.addSublayer($0!) }
        stackView.addArrangedSubview(caview)
        if wxMetal.count < 1 {
            wxMetal.append(WXMetalRender(device!, wxMetalTextObject, ObjectToolbarIcon(), ObjectToolbarIcon(), paneNumber: 0, numberOfPanes))
        }
        setupGestures()
        let defaultLibrary = device?.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error init pipelineState")
        }
        commandQueue = device?.makeCommandQueue()
        wxMetal[0]!.gpsLocation = LatLon(Location.xDbl, Location.yDbl * -1.0)
        wxMetal[0]!.constructLocationDot()
        wxMetal[0]!.setRenderFunction(render(_:))
        wxMetal[0]!.resetRidAndGet(Location.rid, isHomeScreen: true)
        getPolygonWarnings()
    }

    func getPolygonWarnings() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityPolygons.get()
            DispatchQueue.main.async {
                if self.wxMetal[0] != nil {
                    self.wxMetal.forEach { $0!.constructAlertPolygons() }
                }
            }
        }
    }

    func modelMatrix(_ index: Int) -> float4x4 {
        var matrix = float4x4()
        matrix.translate(wxMetal[index]!.xPos, y: wxMetal[index]!.yPos, z: wxMetal[index]!.zPos)
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetal[index]!.zoom, y: wxMetal[index]!.zoom, z: wxMetal[index]!.zoom)
        return matrix
    }

    func render(_ index: Int) {
        guard let drawable = metalLayer[index]!.nextDrawable() else { return }
        wxMetal[index]?.render(
            commandQueue: commandQueue,
            pipelineState: pipelineState,
            drawable: drawable,
            parentModelViewMatrix: modelMatrix(index),
            projectionMatrix: projectionMatrix
            //clearColor: nil
        )
    }

    @objc func imageTap(sender: UITapGestureRecognizerWithData) {
        UtilityHomeScreen.jumpToActivity(self, sender.strData)
    }

    func addLocationSelectionCard() {
        //
        // location card loaded regardless of settings
        //
        let stackViewLocationButton = ObjectStackViewHS()
        stackView.addArrangedSubview(stackViewLocationButton)
        stackViewLocationButton.setup(stackView)
        objLabel = ObjectTextView(stackViewLocationButton, Location.name, FontSize.extraLarge.size, ColorCompatibility.highlightText)
        objLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationAction)))
        objLabel.tv.isSelectable = false
    }

    // Clear all views except 7day and current conditions
    func clearViews() {
        stackViewHazards.view.subviews.forEach { $0.removeFromSuperview() }
        extraDataCards.forEach { $0.removeFromSuperview() }
        forecastImage = []
        forecastText = []
        extraDataCards = []
        stackViewHazards.view.isHidden = true
        stackViewRadar.removeFromSuperview()
    }

    func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureDouble(_:)))
        gestureRecognizer2.numberOfTapsRequired = 2
        stackViewRadar.addGestureRecognizer(gestureRecognizer)
        stackViewRadar.addGestureRecognizer(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress(_:))))
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.singleTap(self, wxMetal, wxMetalTextObject, gestureRecognizer)
    }

    @objc func tapGestureDouble(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.doubleTap(self, wxMetal, wxMetalTextObject, numberOfPanes, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXMetalSurfaceView.gestureLongPress(self, wxMetal, longPressCount, longPressAction, gestureRecognizer)
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        let pointerLocation = UtilityRadarUI.getLatLonFromScreenPosition(self, wxMetal[index]!, numberOfPanes, ortInt, x, y)
        let ridNearbyList = UtilityLocation.getNearestRadarSites(pointerLocation, 5)
        let dist = LatLon.distance(Location.latLon, pointerLocation, .MILES)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: wxMetal[index]!.rid)
        let distRid = LatLon.distance(radarSiteLocation, pointerLocation, .MILES)
        var alertMessage = WXGLNexrad.getRadarInfo("") + GlobalVariables.newline
            + String(dist.roundTo(places: 2)) + " miles from location"
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetal[index]!.rid
        if wxMetal[index]!.gpsLocation.latString != "0.0" && wxMetal[index]!.gpsLocation.lonString != "0.0" {
            alertMessage += GlobalVariables.newline + "GPS: " + wxMetal[index]!.getGpsString()
        }
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        ridNearbyList.forEach { rid in
            let radarDescription = rid.name + " " + Utility.getRadarSiteName(rid.name) + " " + String(rid.distance) + " mi"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.ridChanged(rid.name) }))
        }
        if RadarPreferences.radarWarnings || ObjectPolygonWarning.areAnyEnabled() {
            alert.addAction(UIAlertAction("Show Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self) }))
        }
        if RadarPreferences.radarWatMcd {
            alert.addAction(UIAlertAction("Show Watch text", { _ in UtilityRadarUI.showNearestProduct(.SPCWAT, pointerLocation, self) }))
            alert.addAction(UIAlertAction("Show MCD text", { _ in UtilityRadarUI.showNearestProduct(.SPCMCD, pointerLocation, self) }))
        }
        if RadarPreferences.radarMpd {
            alert.addAction(UIAlertAction("Show MPD text", { _ in UtilityRadarUI.showNearestProduct(.WPCMPD, pointerLocation, self) }))
        }
        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction("Nearest observation: " + obsSite.name, { _ in UtilityRadarUI.getMetar(pointerLocation, self) }))
        alert.addAction(UIAlertAction(
            "Nearest forecast: " + pointerLocation.latString.truncate(6) + ", " + pointerLocation.lonString.truncate(6), { _ in
                UtilityRadarUI.getForecast(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction("Nearest meteogram: " + obsSite.name, { _ in UtilityRadarUI.getMeteogram(pointerLocation, self) }))
        alert.addAction(UIAlertAction("Radar status message: " + wxMetal[index]!.rid, { _ in UtilityRadarUI.getRadarStatus(self, self.wxMetal[index]!.rid) }))
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(dismiss)
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        present(alert, animated: true, completion: nil)
    }

    func ridChanged(_ rid: String) {
        getPolygonWarnings()
        wxMetal[0]!.resetRidAndGet(rid, isHomeScreen: true)
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
        objLabel.color = ColorCompatibility.highlightText
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        setTabBarColor()
        if UIPreferences.mainScreenRadarFab {
            fab?.setColor()
        }
    }
}
