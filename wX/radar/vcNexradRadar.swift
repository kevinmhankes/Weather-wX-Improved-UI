/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import CoreLocation
import MapKit
import simd

final class vcNexradRadar: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    private var wxMetalRenders = [WXMetalRender?]()
    private var device: MTLDevice!
    private var metalLayer = [CAMetalLayer?]()
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var timer: CADisplayLink!
    private var projectionMatrix: float4x4!
    private var locationManager = CLLocationManager()
    private var lastFrameTimestamp: CFTimeInterval = 0.0
    private var mapIndex = 0
    private let toolbar = ObjectToolbar()
    private var doneButton = ToolbarIcon()
    private var timeButton = ToolbarIcon()
    private var warningButton = ToolbarIcon()
    private var radarSiteButton = ToolbarIcon()
    private var productButton = [ToolbarIcon]()
    private var animateButton = ToolbarIcon()
    private var siteButton = [ToolbarIcon]()
    private var inOglAnim = false
    private var longPressCount = 0
    private var numberOfPanes = 1
    private var oneMinRadarFetch = Timer()
    private let ortInt: Float = 250.0
    private var wxMetalTextObject = WXMetalTextObject()
    private var uiColorLegend = UIColorLegend()
    private var screenScale = 0.0
    private var paneRange: Range<Int> = 0..<1
    private let semaphore = DispatchSemaphore(value: 1)
    private var screenWidth = 0.0
    private var screenHeight = 0.0
    var wxoglPaneCount = ""
    var wxoglCalledFromTimeButton = false
    var radarSiteOverride = ""
    private let map = ObjectMap(.RADAR)
    private var warningCount = 0
    // below var is override in severe dash and us alerts as preferences should not be saved
    var savePreferences = true

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setPaneSize(size)
        paneRange.indices.forEach {
            render($0)
        }
        coordinator.animate(alongsideTransition: nil,
                            completion: { _ in
                                self.map.setupMap(GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap)
                                self.resetTextObject() }
        )
    }

    func setPaneSize(_ cgsize: CGSize) {
        let width = cgsize.width
        let height = cgsize.height
        screenWidth = Double(width)
        screenHeight = Double(height)
        let screenWidth = width
        var screenHeight = height + CGFloat(UIPreferences.toolbarHeight)
        #if targetEnvironment(macCatalyst)
        screenHeight = height
        #endif
        var surfaceRatio = Float(screenWidth) / Float(screenHeight)
        if numberOfPanes == 2 {
            surfaceRatio = Float(screenWidth) / Float(screenHeight / 2.0)
        }
        if numberOfPanes == 4 {
            surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight / 2.0)
        }
        let bottom = -1.0 * ortInt * (1.0 / surfaceRatio)
        let top = ortInt * (1 / surfaceRatio)
        projectionMatrix = float4x4.makeOrtho(-1.0 * ortInt, right: ortInt, bottom: bottom, top: top, nearZ: -100.0, farZ: 100.0)
        let halfWidth: CGFloat = screenWidth / 2
        let halfHeight: CGFloat = screenHeight / 2
        if numberOfPanes == 1 {
            metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else if numberOfPanes == 2 {
            if UtilityUI.isLandscape() || screenWidth > screenHeight {
                surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight)
                let scaleFactor: Float = 0.5
                projectionMatrix = float4x4.makeOrtho(
                    -1.0 * ortInt * scaleFactor,
                    right: ortInt * scaleFactor,
                    bottom: -1.0 * ortInt * (1.0 / surfaceRatio) * scaleFactor,
                    top: ortInt * (1.0 / surfaceRatio) * scaleFactor,
                    nearZ: -100.0,
                    farZ: 100.0
                )
                // left half for dual
                metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: screenWidth / 2.0, height: height)
                // right half for dual
                metalLayer[1]!.frame = CGRect(x: halfWidth, y: 0, width: screenWidth / 2.0, height: height)
            } else {
                metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: screenWidth, height: halfHeight)
                // bottom half for dual
                metalLayer[1]!.frame = CGRect(x: 0, y: halfHeight, width: screenWidth, height: halfHeight)
            }
        } else if numberOfPanes == 4 {
            // top half for quad
            metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight)
            metalLayer[1]!.frame = CGRect(x: CGFloat(halfWidth), y: 0, width: halfWidth, height: halfHeight)
            // bottom half for quad
            metalLayer[2]!.frame = CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight)
            metalLayer[3]!.frame = CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        // edgePan.edges = .left
        // view.addGestureRecognizer(edgePan)
        view.backgroundColor = UIColor.black
        numberOfPanes = Int(wxoglPaneCount) ?? 1
        paneRange = 0..<numberOfPanes
        UtilityFileManagement.deleteAllFiles()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap)
        let toolbarTop = ObjectToolbar()
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            view.addSubview(toolbarTop)
            toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
            paneRange.forEach { index in
                siteButton.append(ToolbarIcon(title: "L", self, #selector(radarSiteClicked(sender:)), tag: index))
            }
            var items = [UIBarButtonItem]()
            items.append(GlobalVariables.flexBarButton)
            paneRange.forEach { index in
                items.append(siteButton[index])
            }
            toolbarTop.items = ToolbarItems(items).items
            if UIPreferences.radarToolbarTransparent {
                toolbarTop.setTransparent()
            }
        }
        view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        if UIPreferences.radarToolbarTransparent {
            toolbar.setTransparent()
        }
        if RadarPreferences.locdotFollowsGps {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(invalidateGps),
                name: UIApplication.willResignActiveNotification,
                object: nil
            )
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPause),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onResume),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked))
        paneRange.forEach { index in
            productButton.append(ToolbarIcon(title: "", self, #selector(productClicked), tag: index))
        }
        radarSiteButton = ToolbarIcon(title: "", self, #selector(radarSiteClicked))
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked))
        var toolbarButtons = [UIBarButtonItem]()
        toolbarButtons.append(doneButton)
        if numberOfPanes == 1 {
            timeButton = ToolbarIcon(title: "", self, #selector(timeClicked))
            warningButton = ToolbarIcon(title: "", self, #selector(warningClicked))
            toolbarButtons.append(timeButton)
            toolbarButtons.append(warningButton)
        } else {
            warningButton = ToolbarIcon(title: "", self, #selector(warningClicked))
            toolbarButtons.append(timeButton)
            toolbarButtons.append(warningButton)
        }
        toolbarButtons += [GlobalVariables.flexBarButton, animateButton, GlobalVariables.fixedSpace]
        paneRange.forEach {
            toolbarButtons.append(productButton[$0])
        }
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            toolbarButtons.append(radarSiteButton)
        }
        toolbar.items = ToolbarItems(toolbarButtons).items
        device = MTLCreateSystemDefaultDevice()
        paneRange.indices.forEach { index in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
        }
        setPaneSize(UtilityUI.getScreenBoundsCGSize())
        metalLayer.forEach { mlayer in
            view.layer.addSublayer(mlayer!)
        }
        paneRange.forEach { index in
            wxMetalRenders.append(WXMetalRender(device, wxMetalTextObject, timeButton, productButton[index], paneNumber: index, numberOfPanes))
        }
        productButton.enumerated().forEach {
            $1.title = wxMetalRenders[$0]!.product
        }
        // when called from severedashboard and us alerts
        if radarSiteOverride != "" {
            wxMetalRenders[0]!.resetRid(radarSiteOverride)
        }
        radarSiteButton.title = wxMetalRenders[0]!.rid
        if !RadarPreferences.dualpaneshareposn {
            siteButton.enumerated().forEach {
                $1.title = wxMetalRenders[$0]!.rid
            }
        }
        if RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            let x = wxMetalRenders[0]!.xPos
            let y = wxMetalRenders[0]!.yPos
            let zoom = wxMetalRenders[0]!.zoom
            let rid = wxMetalRenders[0]!.rid
            wxMetalRenders.forEach {
                $0!.xPos = x
                $0!.yPos = y
                $0!.zoom = zoom
                $0!.rid = rid
                $0!.loadGeometry()
            }
        }
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error init pipelineState")
        }
        commandQueue = device.makeCommandQueue()
        wxMetalRenders.forEach {
            $0?.setRenderFunction(render)
        }
        // Below two lines enable continuous updates
        if RadarPreferences.nexradContinuousMode {
            timer = CADisplayLink(target: self, selector: #selector(newFrame(displayLink:)))
            timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        }
        setupGestures()
        if RadarPreferences.locdotFollowsGps {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 10
            }
        }
        screenScale = Double(UIScreen.main.scale)
        #if targetEnvironment(macCatalyst)
        screenScale *= 2.0
        #endif
        wxMetalTextObject = WXMetalTextObject(
            self,
            numberOfPanes,
            screenWidth,
            screenHeight,
            wxMetalRenders[0]!,
            screenScale
        )
        wxMetalTextObject.initializeTextLabels()
        wxMetalTextObject.addTextLabels()
        wxMetalRenders.forEach {
            $0?.wxMetalTextObject = wxMetalTextObject
            $0?.getRadar("")
        }
        getPolygonWarnings()
        updateColorLegend()
        if RadarPreferences.wxoglRadarAutorefresh {
            UIApplication.shared.isIdleTimerDisabled = true
            oneMinRadarFetch = Timer.scheduledTimer(
                timeInterval: 60.0 * Double(RadarPreferences.dataRefreshInterval),
                target: self,
                selector: #selector(getRadarEveryMinute),
                userInfo: nil,
                repeats: true
            )
        }
        view.bringSubviewToFront(toolbar)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            view.bringSubviewToFront(toolbarTop)
        }
    }

    // @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
    // if recognizer.state == .recognized { doneClicked() }
    // }

    @objc func onPause() {
        // print("viewWillDisappear")
        stopAnimate()
    }

    func modelMatrix(_ index: Int) -> float4x4 {
        var matrix = float4x4()
        if !RadarPreferences.wxoglCenterOnLocation {
            matrix.translate(wxMetalRenders[index]!.xPos, y: wxMetalRenders[index]!.yPos, z: wxMetalRenders[index]!.zPos)
        } else {
            wxMetalRenders[index]!.xPos = wxMetalRenders[index]!.gpsLatLonTransformed.0 * wxMetalRenders[index]!.zoom
            wxMetalRenders[index]!.yPos = wxMetalRenders[index]!.gpsLatLonTransformed.1 * wxMetalRenders[index]!.zoom
            matrix.translate(wxMetalRenders[index]!.xPos, y: wxMetalRenders[index]!.yPos, z: wxMetalRenders[index]!.zPos)
        }
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetalRenders[index]!.zoom, y: wxMetalRenders[index]!.zoom, z: wxMetalRenders[index]!.zoom)
        return matrix
    }

    func render(_ index: Int) {
        guard let drawable = metalLayer[index]!.nextDrawable() else { return }
        wxMetalRenders[index]?.render(
            commandQueue: commandQueue,
            pipelineState: pipelineState,
            drawable: drawable,
            parentModelViewMatrix: modelMatrix(index),
            projectionMatrix: projectionMatrix
            // clearColor: MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
            // clearColor: nil
        )
    }

    // needed for continuous
    @objc func newFrame(displayLink: CADisplayLink) {
         if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
         }
         let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
         lastFrameTimestamp = displayLink.timestamp
         radarLoop(timeSinceLastUpdate: elapsed)
     }

    // needed for continuous
    func radarLoop(timeSinceLastUpdate: CFTimeInterval) {
         autoreleasepool {
            // if self.wxMetalRenders[0] != nil {
            // self.render(0)
            for (index, wxMetal) in wxMetalRenders.enumerated() {
                if wxMetal != nil {
                    render(index)
                }
            }
            // }
         }
     }

    func setupGestures() {
        // let pan = UIPanGestureRecognizer(target: self, action: #selector(gesturePan))
        // let gestureZoomVar = UIPinchGestureRecognizer(target: self, action: #selector(gestureZoom))
        let gestureRecognizerSingleTap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gestureRecognizerSingleTap.numberOfTapsRequired = 1
        gestureRecognizerSingleTap.delegate = self
        let gestureRecognizerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(tapGestureDouble))
        gestureRecognizerDoubleTap.numberOfTapsRequired = 2
        gestureRecognizerDoubleTap.delegate = self
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gesturePan)))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(gestureZoom)))
        view.addGestureRecognizer(gestureRecognizerSingleTap)
        view.addGestureRecognizer(gestureRecognizerDoubleTap)
        gestureRecognizerSingleTap.require(toFail: gestureRecognizerDoubleTap)
        gestureRecognizerSingleTap.delaysTouchesBegan = true
        gestureRecognizerDoubleTap.delaysTouchesBegan = true
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress)))
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == gestureRecognizer.view
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if !map.mapShown { WXMetalSurfaceView.singleTap(self, wxMetalRenders, wxMetalTextObject, gestureRecognizer) }
    }

    @objc func tapGestureDouble(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.doubleTap(self, wxMetalRenders, wxMetalTextObject, numberOfPanes, gestureRecognizer)
    }

    @objc func gestureZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        WXMetalSurfaceView.gestureZoom(self, wxMetalRenders, wxMetalTextObject, gestureRecognizer)
    }

    @objc func gesturePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        WXMetalSurfaceView.gesturePan(self, wxMetalRenders, wxMetalTextObject, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXMetalSurfaceView.gestureLongPress(
            self,
            wxMetalRenders,
            longPressCount,
            longPressAction,
            gestureRecognizer
        )
    }

    @objc func doneClicked() {
        if map.mapShown {
            hideMap()
        } else {
            if presentedViewController == nil && wxMetalRenders[0] != nil {
                // Don't disable screen being left on if one goes from single pane to dual pane via time
                // button and back
                if wxoglCalledFromTimeButton && RadarPreferences.wxoglRadarAutorefresh {
                    wxoglCalledFromTimeButton = false
                } else {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                if RadarPreferences.wxoglRadarAutorefresh {
                    oneMinRadarFetch.invalidate()
                    oneMinRadarFetch = Timer()
                }
                locationManager.stopUpdatingLocation()
                locationManager.stopMonitoringSignificantLocationChanges()
                stopAnimate()
                if savePreferences {
                    wxMetalRenders.forEach {
                        $0!.writePreferences()
                    }
                }
                wxMetalRenders.forEach {
                    $0!.cleanup()
                }
                device = nil
                wxMetalTextObject.wxMetalRender = nil
                metalLayer.indices.forEach {
                    metalLayer[$0] = nil
                }
                wxMetalRenders.indices.forEach {
                    wxMetalRenders[$0] = nil
                }
                commandQueue = nil
                pipelineState = nil
                timer = nil
                wxMetalTextObject = WXMetalTextObject()
                dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            } else {
                dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            }
        }
    }

    @objc func productClicked(sender: ToolbarIcon) {
        let alert = ObjectPopUp(self, "", productButton[sender.tag])
        if WXGLNexrad.isRidTdwr(wxMetalRenders[sender.tag]!.rid) {
            WXGLNexrad.radarProductListTdwr.forEach { product in
                alert.addAction(UIAlertAction(product, { _ in self.productChanged(sender.tag, product.split(":")[0]) }))
            }
        } else {
            wxMetalRenders[sender.tag]!.radarProductList.forEach { product in
                alert.addAction(UIAlertAction(product, { _ in self.productChanged(sender.tag, product.split(":")[0]) }))
            }
        }
        alert.finish()
    }

    @objc func timeClicked() {
        wxMetalRenders.forEach {
            $0!.writePreferences()
        }
        wxMetalRenders[0]?.writePreferencesForSingleToDualPaneTransition()
        Route.radarFromTimeButton(self, "2")
    }

    @objc func warningClicked() {
        Route.severeDashboard(self)
    }

    func productChanged(_ index: Int, _ product: String) {
        stopAnimate()
        wxMetalRenders[index]!.changeProduct(product)
        updateColorLegend()
        getPolygonWarnings()
    }

    @objc func onResume() {
        if RadarPreferences.locdotFollowsGps {
            resumeGps()
        }
        // stopAnimate()
        if wxMetalRenders[0] != nil {
            wxMetalRenders.forEach {
                $0!.updateTimeToolbar()
            }
            wxMetalRenders.forEach {
                $0!.getRadar("")
            }
            getPolygonWarnings()
        }
    }

    func updateWarningsInToolbar() {
        warningCount = 0
        if RadarPreferences.warnings {
            let tstCount = WXGLPolygonWarnings.getCount(PolygonEnum.TST)
            let torCount = WXGLPolygonWarnings.getCount(PolygonEnum.TOR)
            let ffwCount = WXGLPolygonWarnings.getCount(PolygonEnum.FFW)
            let countString = "(" + torCount + "," + tstCount + "," + ffwCount + ")"
            warningButton.title = countString
            let sum = to.Int(tstCount) + to.Int(torCount) + to.Int(ffwCount)
            warningCount += sum
        }
        ObjectPolygonWarning.polygonList.forEach {
            let polygonType = ObjectPolygonWarning.polygonDataByType[$0]!
            if polygonType.isEnabled {
                warningCount += Int(ObjectPolygonWarning.getCount(polygonType.storage.value)) ?? 0
            }
        }
    }

    func getPolygonWarnings() {
        updateWarningsInToolbar()
        getPolygonWatchGeneric()
        getPolygonWarningsNonGeneric()
        if ObjectPolygonWarning.areAnyEnabled() {
            _ = FutureVoid(getPolygonWarningsGeneric, updatePolygonWarningsGeneric)
        }
    }
    
    private func getPolygonWarningsGeneric() {
        // self.semaphore.wait()
        if wxMetalRenders[0] != nil {
            wxMetalRenders.forEach {
                $0!.constructAlertPolygons()
            }
        }
        for t in [PolygonTypeGeneric.SMW, PolygonTypeGeneric.SQW, PolygonTypeGeneric.DSW, PolygonTypeGeneric.SPS] {
            if ObjectPolygonWarning.polygonDataByType[t]!.isEnabled {
                ObjectPolygonWarning.polygonDataByType[t]!.download()
            }
        }
    }
    
    private func updatePolygonWarningsGeneric() {
        semaphore.wait()
        if wxMetalRenders[0] != nil {
            wxMetalRenders.forEach {
                $0!.constructAlertPolygons()
            }
        }
        updateWarningsInToolbar()
        semaphore.signal()
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
        semaphore.wait()
        if wxMetalRenders[0] != nil {
            wxMetalRenders.forEach {
                $0!.constructAlertPolygonsByType(type)
            }
        }
        updateWarningsInToolbar()
        semaphore.signal()
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
        semaphore.wait()
        if wxMetalRenders[0] != nil {
            wxMetalRenders.forEach {
                $0!.constructWatchPolygonsByType(type)
            }
        }
        updateWarningsInToolbar()
        semaphore.signal()
    }

    @objc func radarSiteClicked(sender: ToolbarIcon) {
        mapIndex = sender.tag
        hideMap()
    }

    func hideMap() {
        map.toggleMap(self)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { map.mapView(annotation) }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.mapShown = map.mapViewExtra(annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        radarSiteChanged((annotationView.annotation!.title!)!, mapIndex)
    }

    func radarSiteChanged(_ radarSite: String, _ index: Int) {
        stopAnimate()
        UtilityFileManagement.deleteAllFiles()
        wxMetalRenders[index]!.fileStorage.memoryBuffer = MemoryBuffer()
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            siteButton[index].title = radarSite
        } else {
            radarSiteButton.title = radarSite
        }
        getPolygonWarnings()
        if RadarPreferences.dualpaneshareposn {
            wxMetalRenders.forEach {
                $0!.resetRidAndGet(radarSite)
            }
        } else {
            wxMetalRenders[index]!.resetRidAndGet(radarSite)
        }
        view.subviews.forEach {
            if $0 is UITextView {
                $0.removeFromSuperview()
            }
        }
        wxMetalTextObject = WXMetalTextObject(
            self,
            numberOfPanes,
            Double(view.frame.width),
            Double(view.frame.height),
            wxMetalRenders[0]!,
            screenScale
        )
        wxMetalTextObject.initializeTextLabels()
        wxMetalTextObject.addTextLabels()
    }

    // TODO use above
    func resetTextObject() {
        view.subviews.forEach {
            if $0 is UITextView {
                $0.removeFromSuperview()
            }
        }
        wxMetalTextObject = WXMetalTextObject(
            self,
            numberOfPanes,
            Double(view.frame.width),
            Double(view.frame.height),
            wxMetalRenders[0]!,
            screenScale
        )
        wxMetalTextObject.initializeTextLabels()
        wxMetalTextObject.addTextLabels()
    }

    @objc func animateClicked() {
        if !inOglAnim {
            _ = ObjectPopUp(
                self,
                title: "Select number of animation frames:",
                animateButton,
                [5, 10, 20, 30, 40, 50, 60],
                animateFrameCntClicked(_:)
            )
        } else {
            stopAnimate()
        }
    }

    @objc func stopAnimate() {
        if inOglAnim {
            inOglAnim = false
            animateButton.setImage(.play)
            if wxMetalRenders[0] != nil {
                wxMetalRenders.forEach {
                    $0!.getRadar("")
                }
                getPolygonWarnings()
            }
        }
        updateWarningsInToolbar()
    }

    func animateFrameCntClicked(_ frameCnt: Int) {
        if !inOglAnim {
            warningButton.title = ""
            inOglAnim = true
            animateButton.setImage(.stop)
            getAnimate(frameCnt)
        } else {
            stopAnimate()
        }
    }

    func getAnimate(_ frameCnt: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var animArray = [[String]]()
            self.wxMetalRenders.enumerated().forEach { index, wxMetalRender in
                if RadarPreferences.useFileStorage {
                    _ = WXGLDownload.getRadarFilesForAnimation(wxMetalRender!.radarBuffers, frameCnt, wxMetalRender!.product, wxMetalRender!.rid, wxMetalRender!.fileStorage)
                } else {
                    animArray.append(WXGLDownload.getRadarFilesForAnimation(wxMetalRender!.radarBuffers, frameCnt, wxMetalRender!.product, wxMetalRender!.rid, wxMetalRender!.fileStorage))
                    animArray[index].indices.forEach {
                        UtilityFileManagement.deleteFile(String(index) + "nexrad_anim" + String($0))
                        UtilityFileManagement.moveFile(animArray[index][$0], String(index) + "nexrad_anim" + String($0))
                    }
                }
            }
            var scaleFactor = 1
            while self.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.inOglAnim {
                        self.wxMetalRenders.enumerated().forEach { index, wxMetalRender in
                            let buttonText = " (" + String(frame + 1) + "/" + String(frameCnt) + ")"
                            if RadarPreferences.useFileStorage {
                                wxMetalRender!.getRadar(String(frame), buttonText)
                            } else {
                                wxMetalRender!.getRadar(String(index) + "nexrad_anim" + String(frame), buttonText)
                            }
                            scaleFactor = 1
                        }
                        var interval = UIPreferences.animInterval
                        if self.wxMetalRenders[0]!.product.hasPrefix("L2") {
                            if interval < 12 {
                                interval = 12
                            }
                        }
                        usleep(UInt32(100000 * interval * scaleFactor))
                    } else {
                        break
                    }
                }
            }
            DispatchQueue.main.async {
            }
        }
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        let pointerLocation = UtilityRadarUI.getLatLonFromScreenPosition(
            self,
            wxMetalRenders[index]!,
            numberOfPanes,
            ortInt,
            x,
            y
        )
        let ridNearbyList = UtilityLocation.getNearestRadarSites(pointerLocation, 5)
        let dist = LatLon.distance(Location.latLon, pointerLocation, .MILES)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: wxMetalRenders[index]!.rid)
        let distRid = LatLon.distance(radarSiteLocation, pointerLocation, .MILES)
        let distRidKm = LatLon.distance(radarSiteLocation, pointerLocation, .K)
        // TODO FIXME
        let radarInfo = wxMetalRenders[0]!.fileStorage.radarInfo
        var alertMessage = radarInfo + GlobalVariables.newline
            + String(dist.roundTo(places: 2)) + " miles from location" + GlobalVariables.newline
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetalRenders[index]!.rid
        if wxMetalRenders[index]!.gpsLocation.latString != "0.0" && wxMetalRenders[index]!.gpsLocation.lonString != "0.0" {
            alertMessage += GlobalVariables.newline + "GPS: " + wxMetalRenders[index]!.getGpsString()
        }
        let heightAgl = Int(UtilityMath.getRadarBeamHeight(wxMetalRenders[index]!.radarBuffers.rd.degree, distRidKm))
        let heightMsl = Int(wxMetalRenders[index]!.radarBuffers.rd.radarHeight) + heightAgl
        alertMessage += GlobalVariables.newline + "Beam Height MSL: " + String(heightMsl) + " ft, AGL: " + String(heightAgl) + " ft"
        if RadarPreferences.radarShowWpcFronts {
            var wpcFrontsTimeStamp = Utility.readPref("WPC_FRONTS_TIMESTAMP", "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.replace(String(UtilityTime.getYear()), "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.insert(4, " ")
            alertMessage += GlobalVariables.newline + "WPC Fronts: " + wpcFrontsTimeStamp
        }
        let alert = UIAlertController(
            title: "",
            message: alertMessage,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        ridNearbyList.forEach { rid in
            let radarDescription = rid.name
                + " "
                + Utility.getRadarSiteName(rid.name)
                + " " + String(rid.distance) + " mi"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.radarSiteChanged(rid.name, index) }))
        }

        if WXGLNexrad.canTilt(wxMetalRenders[index]!.product) {
            alert.addAction(UIAlertAction("Change Tilt", { _ in self.showTiltMenu() }))
        }
        if RadarPreferences.warnings || ObjectPolygonWarning.areAnyEnabled() { // took out && warningCount > 0
            alert.addAction(UIAlertAction("Show Warning", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self) }))
        }
//        if RadarPreferences.radarWatMcd && MyApplication.watNoList.value != "" {
//            alert.addAction(UIAlertAction("Show Watch text", { _ in UtilityRadarUI.showNearestProduct(.SPCWAT, pointerLocation, self) }))
//        }
//        if RadarPreferences.radarWatMcd && MyApplication.mcdNoList.value != "" {
//            // print(MyApplication.mcdNoList.value)
//            alert.addAction(UIAlertAction("Show MCD text", { _ in UtilityRadarUI.showNearestProduct(.SPCMCD, pointerLocation, self) }))
//        }
//        if RadarPreferences.radarMpd && MyApplication.mpdNoList.value != "" {
//            alert.addAction(UIAlertAction("Show MPD text", { _ in UtilityRadarUI.showNearestProduct(.WPCMPD, pointerLocation, self) }))
//        }
        
        if RadarPreferences.watMcd && ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT]!.numberList.getValue() != "" {
            alert.addAction(UIAlertAction("Show Watch", { _ in UtilityRadarUI.showNearestProduct(.SPCWAT, pointerLocation, self) }))
        }
        if RadarPreferences.watMcd && ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCMCD]!.numberList.getValue()  != "" {
            // print(MyApplication.mcdNoList.value)
            alert.addAction(UIAlertAction("Show MCD", { _ in UtilityRadarUI.showNearestProduct(.SPCMCD, pointerLocation, self) }))
        }
        if RadarPreferences.mpd && ObjectPolygonWatch.polygonDataByType[PolygonEnum.WPCMPD]!.numberList.getValue()  != "" {
            alert.addAction(UIAlertAction("Show MPD", { _ in UtilityRadarUI.showNearestProduct(.WPCMPD, pointerLocation, self) }))
        }

        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction("Observation: " + obsSite.name + " " + to.String(obsSite.distance) + " miles", { _ in UtilityRadarUI.getMetar(pointerLocation, self) }))
        alert.addAction(
            UIAlertAction(
                "Forecast: "
                    + pointerLocation.latString.truncate(6)
                    + ", "
                    + pointerLocation.lonString.truncate(6), { _ in UtilityRadarUI.getForecast(pointerLocation, self) }
            )
        )
        alert.addAction(UIAlertAction("Meteogram: " + obsSite.name, { _ in UtilityRadarUI.getMeteogram(pointerLocation, self) }))
        alert.addAction(
            UIAlertAction(
                "Radar status message: " + wxMetalRenders[index]!.rid, { _ in
                    UtilityRadarUI.getRadarStatus(self, self.wxMetalRenders[index]!.rid) }
            )
        )
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(dismiss)

        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = radarSiteButton
            }
        } else {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = siteButton[0]
            }
        }
        present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }

    @objc func invalidateGps() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func resumeGps() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate { // type CLLocationCoordinate2D
            if wxMetalRenders[0] != nil {
                wxMetalRenders.forEach {
                    $0!.gpsLocation = LatLon(Double(locValue.latitude), Double(locValue.longitude) * -1.0)
                    $0!.constructLocationDot()
                }
            }
        }
    }

    @objc func getRadarEveryMinute() {
        wxMetalRenders.forEach {
            $0!.getRadar("")
        }
        getPolygonWarnings()
    }

    func updateColorLegend() {
        if RadarPreferences.showLegend && numberOfPanes == 1 {
            uiColorLegend.removeFromSuperview()
            uiColorLegend = UIColorLegend(
                wxMetalRenders[0]!.product,
                CGRect(
                    x: 0,
                    y: UIPreferences.statusBarHeight,
                    width: 100,
                    height: view.frame.size.height
                        - UIPreferences.toolbarHeight
                        - UIPreferences.statusBarHeight
                )
            )
            uiColorLegend.backgroundColor = UIColor.clear
            uiColorLegend.isOpaque = false
            view.addSubview(uiColorLegend)
        }
    }

    func showTiltMenu() {
        var tilts = ["Tilt 1", "Tilt 2", "Tilt 3", "Tilt 4"]
        if wxMetalRenders[0]!.isTdwr {
            tilts = ["Tilt 1", "Tilt 2", "Tilt 3"]
        }
        _ = ObjectPopUp(self, title: "Tilt Selection", productButton[0], tilts, changeTilt(_:))
    }

    func changeTilt(_ tilt: Int) {
        wxMetalRenders.forEach {
            $0!.tilt = tilt
            $0!.getRadar("")
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                } else {
                    AppColors.update()
                }
            } else {
            }
        }
    }

    override var keyCommands: [UIKeyCommand]? {
         [
            UIKeyCommand(input: "4", modifierFlags: .numericPad, action: #selector(keyLeftArrow)),
            UIKeyCommand(input: "8", modifierFlags: .numericPad, action: #selector(keyUpArrow)),
            UIKeyCommand(input: "6", modifierFlags: .numericPad, action: #selector(keyRightArrow)),
            UIKeyCommand(input: "2", modifierFlags: .numericPad, action: #selector(keyDownArrow)),

            UIKeyCommand(input: "7", modifierFlags: .numericPad, action: #selector(keyLeftUpArrow)),
            UIKeyCommand(input: "9", modifierFlags: .numericPad, action: #selector(keyRightUpArrow)),
            UIKeyCommand(input: "3", modifierFlags: .numericPad, action: #selector(keyRightDownArrow)),
            UIKeyCommand(input: "1", modifierFlags: .numericPad, action: #selector(keyLeftDownArrow)),

            UIKeyCommand(input: "5", modifierFlags: .numericPad, action: #selector(keyZoomOut)),
            UIKeyCommand(input: "0", modifierFlags: .numericPad, action: #selector(keyZoomIn)),

            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyRightArrow)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyLeftArrow)),
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyUpArrow)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyDownArrow)),

            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: .alternate, action: #selector(keyZoomOut)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: .alternate, action: #selector(keyZoomIn))
        ]
    }

    @objc func keyRightArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .right)
    }

    @objc func keyLeftArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .left)
    }

    @objc func keyUpArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .up)
    }

    @objc func keyDownArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .down)
    }

    @objc func keyRightUpArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .rightUp)
    }

    @objc func keyRightDownArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .rightDown)
    }

    @objc func keyLeftUpArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .leftUp)
    }

    @objc func keyLeftDownArrow() {
        UtilityRadarUI.moveByKey(wxMetalRenders, .leftDown)
    }

    @objc func keyZoomIn() {
        UtilityRadarUI.zoomInByKey(wxMetalRenders)
    }

    @objc func keyZoomOut() {
        UtilityRadarUI.zoomOutByKey(wxMetalRenders)
    }
}
