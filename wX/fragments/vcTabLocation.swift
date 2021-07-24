/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import simd

final class vcTabLocation: vcTabParent {

    private var menuButton = ToolbarIcon()
    private var lastRefresh: Int64 = 0
    private var currentTime: Int64 = 0
    private var currentTimeSec: Int64 = 0
    private var refreshIntervalSec: Int64 = 0
    private var objectCurrentConditions = ObjectCurrentConditions()
    private var objectHazards = ObjectHazards()
    private var objectSevenDay = ObjectSevenDay()
    private var textArr = [String: String]()
    private var oldLocation = LatLon()
    private var isUS = true
    private var objLabel = Text()
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
    private var projectionMatrix: float4x4!
    private let ortInt: Float = 350.0
    private let numberOfPanes = 1
    private var wxMetalTextObject = WXMetalTextObject()
    private var longPressCount = 0
    private var toolbar = ObjectToolbar()
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
                getNexradRadar(stackViewRadar.get())
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
        lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
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
            getContentSuper()
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
            objLabel.font = FontSize.extraLarge.size
            getContentSuper()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            Utility.writePref("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            objLabel.text = Location.name
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
        present(alert, animated: true, completion: nil)
    }

    @objc func ccAction() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        alert.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: { _ in self.editLocation() }))
        alert.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: { _ in self.getContentSuper() }))
        if UtilitySettings.isRadarInHomeScreen() {
            alert.addAction(UIAlertAction(
                title: Location.rid + ": " + getRadarTimeStamp(),
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
    
    private func getRadarTimeStamp() -> String {
        let radarTimeStamp = wxMetal[0]?.fileStorage.radarInfo ?? ""
        var radarTimeFinal = ""
        if radarTimeStamp != "" {
            var radarTimeFinalWithDate = ""
            let radarTimeSplit = radarTimeStamp.split(GlobalVariables.newline)
            if radarTimeSplit.count > 0 {
                radarTimeFinalWithDate = radarTimeSplit[0]
                let radarTimeFinalWithDateInParts = radarTimeFinalWithDate.split(" ")
                if radarTimeFinalWithDateInParts.count > 1 {
                    radarTimeFinal = radarTimeFinalWithDateInParts[1]
                }
            }
        }
        return radarTimeFinal
    }

    @objc func gotoHourly() {
        goToVC(vcHourly())
    }

    func getCurrentConditionCards() {
        let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(ccAction))
        let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(gotoHourly))
        if objectCardCurrentConditions == nil {
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
            wxMetal.append(WXMetalRender(device!, wxMetalTextObject, ToolbarIcon(), ToolbarIcon(), paneNumber: 0, numberOfPanes))
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
        getPolygonWatchGeneric()
        getPolygonWarningsNonGeneric()
        if ObjectPolygonWarning.areAnyEnabled() {
            _ = FutureVoid(getPolygonWarningsGeneric, updatePolygonWarningsGeneric)
        }
    }

    func getPolygonWarningsGeneric() {
        // self.semaphore.wait()
        if wxMetal[0] != nil {
            wxMetal.forEach { $0!.constructAlertPolygons() }
        }
        for t in [PolygonTypeGeneric.SMW, PolygonTypeGeneric.SQW, PolygonTypeGeneric.DSW, PolygonTypeGeneric.SPS] {
            if ObjectPolygonWarning.polygonDataByType[t]!.isEnabled {
                ObjectPolygonWarning.polygonDataByType[t]!.download()
            }
        }
    }

    func updatePolygonWarningsGeneric() {
        // self.semaphore.wait()
        if wxMetal[0] != nil {
            wxMetal.forEach { $0!.constructAlertPolygons() }
        }
        // self.updateWarningsInToolbar()
        // self.semaphore.signal()
    }

    func getPolygonWarningsNonGeneric() {
        if PolygonType.TST.display {
            for t in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW] {
                updatePolygonWarningsNonGeneric(t)
            }
            for t in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW] {
                _ = FutureVoid(ObjectPolygonWarning.polygonDataByType[t]!.download, { self.updatePolygonWarningsNonGeneric(t) })
            }
        }
    }

    func updatePolygonWarningsNonGeneric(_ type: PolygonTypeGeneric) {
        // semaphore.wait()
        if wxMetal[0] != nil {
            wxMetal.forEach { $0!.constructAlertPolygonsByType(type) }
        }
        // updateWarningsInToolbar()
        // semaphore.signal()
    }

    func getPolygonWatchGeneric() {
        for t in [PolygonEnum.SPCMCD, PolygonEnum.SPCWAT, PolygonEnum.WPCMPD] {
            updatePolygonWatchGeneric(t)
        }
        if PolygonType.MCD.display {
            _ = FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCMCD]!.download, { self.updatePolygonWatchGeneric(PolygonEnum.SPCMCD) })
        }

        if PolygonType.WATCH.display {
            _ = FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT]!.download, { self.updatePolygonWatchGeneric(PolygonEnum.SPCWAT) })
        }

        if PolygonType.MPD.display {
            _ = FutureVoid(ObjectPolygonWatch.polygonDataByType[PolygonEnum.WPCMPD]!.download, { self.updatePolygonWatchGeneric(PolygonEnum.WPCMPD) })
        }
    }

    func updatePolygonWatchGeneric(_ type: PolygonEnum) {
        // semaphore.wait()
        if wxMetal[0] != nil {
            wxMetal.forEach { $0!.constructWatchPolygonsByType(type) }
        }
        // updateWarningsInToolbar()
        // semaphore.signal()
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
            // clearColor: nil
        )
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
        objLabel = Text(stackViewLocationButton, Location.name, FontSize.extraLarge.size, ColorCompatibility.highlightText)
        objLabel.addGesture(UITapGestureRecognizer(target: self, action: #selector(locationAction)))
        objLabel.isSelectable = false
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

    func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureDouble(_:)))
        gestureRecognizer2.numberOfTapsRequired = 2
        stackViewRadar.addGesture(gestureRecognizer)
        stackViewRadar.addGesture(gestureRecognizer2)
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
        let radarInfo = wxMetal[0]!.fileStorage.radarInfo
        var alertMessage = radarInfo + GlobalVariables.newline
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
        if RadarPreferences.warnings || ObjectPolygonWarning.areAnyEnabled() {
            alert.addAction(UIAlertAction("Show Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self) }))
        }
        if RadarPreferences.watMcd {
            alert.addAction(UIAlertAction("Show Watch text", { _ in UtilityRadarUI.showNearestProduct(.SPCWAT, pointerLocation, self) }))
            alert.addAction(UIAlertAction("Show MCD text", { _ in UtilityRadarUI.showNearestProduct(.SPCMCD, pointerLocation, self) }))
        }
        if RadarPreferences.mpd {
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
