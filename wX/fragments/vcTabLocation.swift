/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import simd

class vcTabLocation: vcTabParent {

    private var locationButton = UITextView()
    private var forecastText = [String]()
    private var forecastImage = [UIImage]()
    private var menuButton = ObjectToolbarIcon()
    private var lastRefresh: Int64 = 0
    private var currentTime: Int64 = 0
    private var currentTimeSec: Int64 = 0
    private var refreshIntervalSec: Int64 = 0
    private var objCurrentConditions = ObjectForecastPackageCurrentConditions()
    private var objHazards = ObjectForecastPackageHazards()
    private var objSevenDay = ObjectForecastPackage7Day()
    private var textArr = [String: String]()
    private var timeButton = ObjectToolbarIcon()
    private var oldLocation = LatLon()
    private var isUS = true
    private var isUSDisplayed = true
    private var objLabel = ObjectTextView()
    private var stackViewCurrentConditions: ObjectStackView!
    private var stackViewForecast: ObjectStackView!
    private var stackViewHazards: ObjectStackView!
    private var stackViewRadar = ObjectStackViewHS()
    private var ccCard: ObjectCardCurrentConditions?
    private var objCard7DayCollection: ObjectCard7DayCollection?
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
    private var textObj = WXMetalTextObject()
    private var longPressCount = 0
    private var toolbar = ObjectToolbar(.top)
    private var globalHomeScreenFav = ""
    private var globalTextViewFontSize: CGFloat = 0.0
    #if targetEnvironment(macCatalyst)
    private var oneMinRadarFetch = Timer()
    #endif

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toolbar.resize(uiv: self)
        fab?.resize()
        let topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        if self.objScrollStackView != nil && self.objScrollStackView!.fragmentHeightAnchor1 != nil {
            self.view.removeConstraints(
                [
                    self.objScrollStackView!.fragmentHeightAnchor1!,
                    self.objScrollStackView!.fragmentHeightAnchor2!,
                    self.objScrollStackView!.fragmentWidthAnchor1!,
                    self.objScrollStackView!.fragmentWidthAnchor2!,
                    //self.objScrollStackView!.fragmentCenterAnchor!
                ]
            )
        }
        if self.objScrollStackView != nil {
            /*self.objScrollStackView!.fragmentHeightAnchor1 = scrollView.heightAnchor.constraint(
                equalTo: self.view.heightAnchor
            )
            self.objScrollStackView!.fragmentHeightAnchor2 = scrollView.topAnchor.constraint(
                equalTo: self.view.topAnchor, constant: topSpace
            )
            self.objScrollStackView!.fragmentCenterAnchor = scrollView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor, constant: -UIPreferences.tabBarHeight
            )
            
            self.objScrollStackView!.fragmentWidthAnchor1 = scrollView.leftAnchor.constraint(
                equalTo: self.view.leftAnchor
            )
            self.objScrollStackView!.fragmentWidthAnchor2 = scrollView.rightAnchor.constraint(
                equalTo: self.view.rightAnchor
            )*/
            
            self.objScrollStackView!.fragmentHeightAnchor1 = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIPreferences.tabBarHeight)
            self.objScrollStackView!.fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace)
            self.objScrollStackView!.fragmentWidthAnchor1 = scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            self.objScrollStackView!.fragmentWidthAnchor2 = scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            //self.objScrollStackView!.fragmentCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            self.view.addConstraints(
                [
                    self.objScrollStackView!.fragmentHeightAnchor1!,
                    self.objScrollStackView!.fragmentHeightAnchor2!,
                    self.objScrollStackView!.fragmentWidthAnchor1!,
                    self.objScrollStackView!.fragmentWidthAnchor2!,
                    //self.objScrollStackView!.fragmentCenterAnchor!
                ]
            )
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
        toolbar = ObjectToolbar(.top)
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
            toolbar.items = ObjectToolbarItems(
                [
                    GlobalVariables.flexBarButton,
                    dashButton,
                    wfoTextButton,
                    cloudButton,
                    menuButton
                ]
            ).items
        } else {
            toolbar.items = ObjectToolbarItems(
                [
                    GlobalVariables.flexBarButton,
                    dashButton,
                    wfoTextButton,
                    cloudButton,
                    radarButton,
                    menuButton
                ]
            ).items
        }
        //self.displayContent()
        self.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self, toolbarType: .top)
        stackView = UIStackView()
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        if self.objScrollStackView != nil && self.objScrollStackView!.fragmentHeightAnchor1 != nil {
            self.view.removeConstraints(
                [
                    self.objScrollStackView!.fragmentHeightAnchor1!,
                    self.objScrollStackView!.fragmentHeightAnchor2!,
                    self.objScrollStackView!.fragmentWidthAnchor1!,
                    self.objScrollStackView!.fragmentWidthAnchor2!,
                    //self.objScrollStackView!.fragmentCenterAnchor!
                ]
            )
        }
        self.objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, .TAB)
        self.stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
        self.stackViewForecast = ObjectStackView(.fill, .vertical)
        self.stackViewHazards = ObjectStackView(.fill, .vertical)
        self.stackViewCurrentConditions.sV.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        globalHomeScreenFav = Utility.readPref(
            "HOMESCREEN_FAV",
            MyApplication.homescreenFavDefault
        )
        globalTextViewFontSize = UIPreferences.textviewFontSize
        addLocationSelectionCard()
        self.getContentMaster()
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
        self.oldLocation = Location.latlon
        if Location.isUS {
            self.isUS = true
        } else {
            self.isUS = false
        }
        clearViews()
        getForecastData()
        getContent()
    }

    func getForecastData() {
        getLocationForecast()
        getLocationForecastSevenDay()
        getLocationHazards()
        if fab != nil {
            self.view.bringSubviewToFront(fab!.view)
        }
    }

    func getLocationForecast() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objCurrentConditions = ObjectForecastPackageCurrentConditions(Location.getCurrentLocation())
            DispatchQueue.main.async {
                self.getCurrentConditionCards()
            }
        }
    }

    func getLocationForecastSevenDay() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objSevenDay = ObjectForecastPackage7Day(Location.getCurrentLocation())
            self.objSevenDay.locationIndex = Location.getCurrentLocation()
            DispatchQueue.main.async {
                if self.objCard7DayCollection == nil
                    || !self.isUS
                    || self.objSevenDay.locationIndex != self.objCard7DayCollection?.locationIndex {
                    self.stackViewForecast.view.subviews.forEach {$0.removeFromSuperview()}
                    self.objCard7DayCollection = ObjectCard7DayCollection(
                        self.stackViewForecast.view,
                        self.scrollView,
                        self.objSevenDay,
                        self.isUS
                    )
                    self.objCard7DayCollection?.locationIndex = Location.getCurrentLocation()
                } else {
                    self.objCard7DayCollection?.update(
                        self.objSevenDay,
                        self.isUS
                    )
                }
            }
        }
    }

    func getLocationHazards() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objHazards = Utility.getCurrentHazards(self, Location.getCurrentLocation())
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
        print("DEBUG: getContent")
        DispatchQueue.global(qos: .userInitiated).async {
            if Location.isUS {
                self.isUS = true
            } else {
                self.isUS = false
                self.objHazards.hazards = self.objHazards.hazards.replaceAllRegexp("<.*?>", "")
            }
            DispatchQueue.main.async {
                self.globalHomeScreenFav = Utility.readPref(
                    "HOMESCREEN_FAV",
                    MyApplication.homescreenFavDefault
                )
                let homescreenFav = TextUtils.split(self.globalHomeScreenFav, ":")
                self.textArr = [:]
                homescreenFav.forEach {
                    switch $0 {
                    case "TXT-CC2":
                        self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                    case "TXT-HAZ":
                        self.stackView.addArrangedSubview(self.stackViewHazards.view)
                    case "TXT-7DAY2":
                        self.stackView.addArrangedSubview(self.stackViewForecast.view)
                    case "METAL-RADAR":
                        self.stackViewRadar = ObjectStackViewHS()
                        self.stackView.addArrangedSubview(self.stackViewRadar)
                        self.getNexradRadar($0.split("-")[1], self.stackViewRadar)
                    default:
                        let stackViewLocal = ObjectStackViewHS()
                        stackViewLocal.setup()
                        self.extraDataCards.append(stackViewLocal)
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

    @objc override func warningsClicked() {
        let vc = vcUSAlertsDetail()
        self.goToVC(vc)
    }

    @objc override func dualPaneRadarClicked() {
        UtilityActions.multiPaneRadarClicked(self, "2")
    }

    @objc override func quadPaneRadarClicked() {
        UtilityActions.multiPaneRadarClicked(self, "4")
    }

    @objc override func settingsClicked() {
        let vc = vcSettingsMain()
        self.goToVC(vc)
    }

    @objc override func mesoanalysisClicked() {
        let vc = vcSpcMeso()
        self.goToVC(vc)
    }

    @objc override func ncepModelsClicked() {
        let vc = vcModels()
        vc.modelActivitySelected = "NCEP"
        self.goToVC(vc)
    }

    @objc override func hourlyClicked() {
        if Location.isUS {
            let vc = vcHourly()
            self.goToVC(vc)
        } else {
            let vc = vcCanadaHourly()
            self.goToVC(vc)
        }
    }

    @objc override func nhcClicked() {
        let vc = vcNhc()
        self.goToVC(vc)
    }

    @objc override func lightningClicked() {
        let vc = vcLightning()
        self.goToVC(vc)
    }

    @objc override func nationalImagesClicked() {
        let vc = vcWpcImg()
        self.goToVC(vc)
    }

    @objc override func nationalTextClicked() {
        let vc = vcWpcText()
        self.goToVC(vc)
    }

    @objc override func willEnterForeground() {
        super.willEnterForeground()
        updateColors()
        if objCard7DayCollection != nil && objCard7DayCollection!.objectCardSunTime != nil {
            objCard7DayCollection!.objectCardSunTime!.update()
        }
        scrollView.scrollToTop()
        currentTime = UtilityTime.currentTimeMillis64()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = Int64(UIPreferences.refreshLocMin) * Int64(60)
        if currentTimeSec > (lastRefresh + refreshIntervalSec) {
            self.lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
            self.getContentMaster()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        objLabel.text = Location.name
        let newhomeScreenFav = Utility.readPref(
            "HOMESCREEN_FAV",
            MyApplication.homescreenFavDefault
        )
        let textSizeHasChange = abs(UIPreferences.textviewFontSize - globalTextViewFontSize) > 0.5
        Location.checkCurrentLocationValidity()
        if (Location.latlon != oldLocation)
            || (newhomeScreenFav != globalHomeScreenFav)
            || textSizeHasChange {
            print("refresh homescreen")
            scrollView.scrollToTop()
            self.ccCard?.resetTextSize()
            self.objCard7DayCollection?.resetTextSize()
            self.objLabel.tv.font = FontSize.extraLarge.size
            self.getContentMaster()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            Utility.writePref("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            self.objLabel.text = Location.name
            self.getContentMaster()
        } else {
            let vc = vcSettingsLocationEdit()
            vc.settingsLocationEditNum = "0"
            self.goToVC(vc)
        }
    }

    func editLocation() {
        let vc = vcSettingsLocationEdit()
        vc.settingsLocationEditNum = Location.getCurrentLocationStr()
        self.goToVC(vc)
    }

    @objc func locationAction() {
        let alert = UIAlertController(
            title: "Select location:",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        MyApplication.locations.indices.forEach { location in
            let action = UIAlertAction(
                title: Location.getName(location),
                style: .default,
                handler: {_ in self.locationChanged(location)}
            )
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(
            title: "Add location..",
            style: .default,
            handler: {_ in self.locationChanged(Location.numLocations)}
            )
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc func ccAction() {
        let alert = UIAlertController(
            title: "Select from:",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        alert.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: {_ in self.editLocation()}))
        alert.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: {_ in self.getContentMaster()}))
        if UtilitySettings.isRadarInHomescreen() {
            alert.addAction(UIAlertAction(
                title: Location.rid + ": " + WXGLNexrad.getRadarTimeStamp(),
                style: .default,
                handler: {_ in UtilityActions.radarClicked(self)})
            )
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc func gotoHourly() {
        let vc = vcHourly()
        self.goToVC(vc)
    }

    func getCurrentConditionCards() {
        let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(ccAction))
        let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        if ccCard == nil {
            ccCard = ObjectCardCurrentConditions(self.stackViewCurrentConditions.view, objCurrentConditions, isUS)
            ccCard?.addGestureRecognizer(tapOnCC1, tapOnCC2, tapOnCC3)
        } else {
            ccCard?.updateCard(objCurrentConditions, isUS)
        }
    }

    func getContentText(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product)
            DispatchQueue.main.async {
                self.textArr[product] = html
                let objectTextView = ObjectTextView(stackView, html.truncate(UIPreferences.homescreenTextLength))
                if product == "HOURLY" {
                    objectTextView.font = FontSize.hourly.size
                }
                objectTextView.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.textTap(sender:)))
                )
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
                let imgObj = ObjectImage(stackView, bitmap, hs: true)
                imgObj.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.imageTap(sender:)))
                )
            }
        }
    }

    func cleanupRadarObjects() {
        if wxMetal[0] != nil {
            //wxMetal.forEach { $0!.cleanup() }
        }
    }

    func getNexradRadar(_ product: String, _ stackView: UIStackView) {
        cleanupRadarObjects()
        let paneRange = [0]
        let device = MTLCreateSystemDefaultDevice()
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        let screenWidth = width
        let screenHeight = screenWidth
        let carect = CGRect(
            x: 0,
            y: 0,
            width: CGFloat(screenWidth),
            height: CGFloat(screenWidth)
        )
        let caview = UIView(frame: carect)
        caview.widthAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        caview.heightAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        let surfaceRatio = Float(screenWidth)/Float(screenHeight)
        projectionMatrix = float4x4.makeOrtho(
            -1.0 * ortInt,
            right: ortInt,
            bottom: -1.0 * ortInt * (1.0 / surfaceRatio),
            top: ortInt * (1 / surfaceRatio),
            nearZ: -100.0,
            farZ: 100.0
        )
        paneRange.enumerated().forEach { index, _ in
            if metalLayer.count < 1 {
                metalLayer.append(CAMetalLayer())
                metalLayer[index]!.device = device
                metalLayer[index]!.pixelFormat = .bgra8Unorm
                metalLayer[index]!.framebufferOnly = true
            }
        }
        metalLayer[0]!.frame = CGRect(
            x: 0,
            y: 0,
            width: CGFloat(screenWidth),
            height: CGFloat(screenWidth)
        )
        metalLayer.forEach {
            caview.layer.addSublayer($0!)
        }
        stackView.addArrangedSubview(caview)
        if wxMetal.count < 1 {
            wxMetal.append(
                WXMetalRender(
                    device!,
                    textObj,
                    ObjectToolbarIcon(),
                    ObjectToolbarIcon(),
                    paneNumber: 0,
                    numberOfPanes
                )
            )
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
            UtilityPolygons.getData()
            DispatchQueue.main.async {
                if self.wxMetal[0] != nil {
                    self.wxMetal.forEach {
                        $0!.constructAlertPolygons()
                    }
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
            projectionMatrix: projectionMatrix,
            clearColor: nil
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
        stackViewLocationButton.setup()
        self.stackView.addArrangedSubview(stackViewLocationButton)
        self.objLabel = ObjectTextView(
            stackViewLocationButton,
            Location.name,
            FontSize.extraLarge.size,
            ColorCompatibility.highlightText
        )
        self.objLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationAction)))
        self.objLabel.tv.isSelectable = false
    }

    // Clear all views except 7day and current conditions
    func clearViews() {
        self.stackViewHazards.view.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.extraDataCards.forEach {
            $0.removeFromSuperview()
        }
        self.forecastImage = []
        self.forecastText = []
        self.extraDataCards = []
        self.stackViewHazards.view.isHidden = true
        self.stackViewRadar.removeFromSuperview()
    }

    func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapGesture(_:))
        )
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = UITapGestureRecognizer(
            target: self,
            action: #selector(tapGesture(_:double:))
        )
        gestureRecognizer2.numberOfTapsRequired = 2
        stackViewRadar.addGestureRecognizer(gestureRecognizer)
        stackViewRadar.addGestureRecognizer(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        self.view.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(gestureLongPress(_:))
            )
        )
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.singleTap(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer, double: Int) {
        WXMetalSurfaceView.doubleTap(self, wxMetal, textObj, numberOfPanes, ortInt, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXMetalSurfaceView.gestureLongPress(
            self,
            wxMetal,
            textObj,
            longPressCount,
            longPressAction,
            gestureRecognizer
        )
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        let pointerLocation = UtilityRadarUI.getLatLonFromScreenPosition(
            self,
            wxMetal[index]!,
            numberOfPanes,
            ortInt,
            x,
            y
        )
        let ridNearbyList = UtilityLocation.getNearestRadarSites(pointerLocation, 5)
        let dist = LatLon.distance(Location.latlon, pointerLocation, .MILES)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: wxMetal[index]!.rid)
        let distRid = LatLon.distance(radarSiteLocation, pointerLocation, .MILES)
        var alertMessage = WXGLNexrad.getRadarInfo("") + MyApplication.newline
            + String(dist.roundTo(places: 2)) + " miles from location"
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetal[index]!.rid
        if wxMetal[index]!.gpsLocation.latString != "0.0" && wxMetal[index]!.gpsLocation.lonString != "0.0" {
            alertMessage += MyApplication.newline + "GPS: " + wxMetal[index]!.getGpsString()
        }
        let alert = UIAlertController(
            title: "Closest radar site:",
            message: alertMessage,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        ridNearbyList.forEach { rid in
            let radarDescription = rid.name
                + ": "
                + Utility.getRadarSiteName(rid.name)
                + " (" + String(rid.distance) + " mi)"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.ridChanged(rid.name)}))
        }
        alert.addAction(UIAlertAction(
            "Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self)})
        )
        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction(
            "Nearest observation: " + obsSite.name, { _ in UtilityRadarUI.getMetar(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Nearest forecast", { _ in UtilityRadarUI.getForecast(pointerLocation, self)})
        )
        alert.addAction(
            UIAlertAction(
                "Nearest meteogram: " + obsSite.name, { _ in UtilityRadarUI.getMeteogram(pointerLocation, self)}
            )
        )
        alert.addAction(
            UIAlertAction(
                "Radar status message: " + self.wxMetal[index]!.rid, { _ in
                    UtilityRadarUI.getRadarStatus(self, self.wxMetal[index]!.rid)}
            )
        )
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(dismiss)
        if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = menuButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    func ridChanged(_ rid: String) {
        getPolygonWarnings()
        wxMetal[0]!.resetRidAndGet(rid, isHomeScreen: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
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
