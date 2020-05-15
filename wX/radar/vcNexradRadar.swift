/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import CoreLocation
import MapKit
import simd

class vcNexradRadar: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
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
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let toolbar = ObjectToolbar()
    private var doneButton = ObjectToolbarIcon()
    private var timeButton = ObjectToolbarIcon()
    private var warningButton = ObjectToolbarIcon()
    private var radarSiteButton = ObjectToolbarIcon()
    private var productButton = [ObjectToolbarIcon]()
    private var animateButton = ObjectToolbarIcon()
    private var siteButton = [ObjectToolbarIcon]()
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
    var warningCount = 0
    // below var is override in severe dash and us alerts as preferences should not be saved
    var savePreferences = true
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setPaneSize(size)
        paneRange.indices.forEach { self.render($0) }
        coordinator.animate(alongsideTransition: nil,
                            completion: { _ -> Void in
                                self.map.setupMap(GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap)
                                self.resetTextObject() }
        )
    }
    
    func setPaneSize(_ cgsize: CGSize) {
        let width = cgsize.width
        let height = cgsize.height
        self.screenWidth = Double(width)
        self.screenHeight = Double(height)
        let screenWidth = width
        var screenHeight = height + CGFloat(UIPreferences.toolbarHeight)
        #if targetEnvironment(macCatalyst)
        screenHeight = height
        #endif
        var surfaceRatio = Float(screenWidth) / Float(screenHeight)
        if numberOfPanes == 2 { surfaceRatio = Float(screenWidth) / Float(screenHeight / 2.0) }
        if numberOfPanes == 4 { surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight / 2.0) }
        let bottom = -1.0 * ortInt * (1.0 / surfaceRatio)
        let top = ortInt * (1 / surfaceRatio)
        projectionMatrix = float4x4.makeOrtho(
            -1.0 * ortInt,
            right: ortInt,
            bottom: bottom,
            top: top,
            nearZ: -100.0,
            farZ: 100.0
        )
        let halfWidth: CGFloat = screenWidth / 2
        let halfHeight: CGFloat = screenHeight / 2
        if numberOfPanes == 1 {
            metalLayer[0]!.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
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
                metalLayer[0]!.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: screenWidth / 2.0,
                    height: height
                )
                // right half for dual
                metalLayer[1]!.frame = CGRect(
                    x: halfWidth,
                    y: 0,
                    width: screenWidth / 2.0,
                    height: height
                )
            } else {
                metalLayer[0]!.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: screenWidth,
                    height: halfHeight
                )
                // bottom half for dual
                metalLayer[1]!.frame = CGRect(
                    x: 0,
                    y: halfHeight,
                    width: screenWidth,
                    height: halfHeight
                )
            }
        } else if numberOfPanes == 4 {
            // top half for quad
            metalLayer[0]!.frame = CGRect(
                x: 0,
                y: 0,
                width: halfWidth,
                height: halfHeight
            )
            metalLayer[1]!.frame = CGRect(
                x: CGFloat(halfWidth),
                y: 0,
                width: halfWidth,
                height: halfHeight
            )
            // bottom half for quad
            metalLayer[2]!.frame = CGRect(
                x: 0,
                y: halfHeight,
                width: halfWidth,
                height: halfHeight
            )
            metalLayer[3]!.frame = CGRect(
                x: halfWidth,
                y: halfHeight,
                width: halfWidth,
                height: halfHeight
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        self.view.backgroundColor = UIColor.black
        numberOfPanes = Int(wxoglPaneCount) ?? 1
        paneRange = 0..<numberOfPanes
        UtilityFileManagement.deleteAllFiles()
        map.mapView.delegate = self
        map.setupMap(GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap)
        let toolbarTop = ObjectToolbar()
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            self.view.addSubview(toolbarTop)
            toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
            paneRange.forEach { siteButton.append(ObjectToolbarIcon(title: "L", self, #selector(radarSiteClicked(sender:)), tag: $0)) }
            var items = [UIBarButtonItem]()
            items.append(GlobalVariables.flexBarButton)
            paneRange.forEach { items.append(siteButton[$0]) }
            toolbarTop.items = ObjectToolbarItems(items).items
            if UIPreferences.radarToolbarTransparent { toolbarTop.setTransparent() }
        }
        self.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        if UIPreferences.radarToolbarTransparent { toolbar.setTransparent() }
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
        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        paneRange.forEach { productButton.append(ObjectToolbarIcon(title: "", self, #selector(productClicked(sender:)), tag: $0)) }
        radarSiteButton = ObjectToolbarIcon(title: "", self, #selector(radarSiteClicked(sender:)))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        var toolbarButtons = [UIBarButtonItem]()
        toolbarButtons.append(doneButton)
        if numberOfPanes == 1 {
            timeButton = ObjectToolbarIcon(title: "", self, #selector(timeClicked))
            warningButton = ObjectToolbarIcon(title: "", self, #selector(warningClicked))
            toolbarButtons.append(timeButton)
            toolbarButtons.append(warningButton)
        } else {
            warningButton = ObjectToolbarIcon(title: "", self, #selector(warningClicked))
            toolbarButtons.append(timeButton)
            toolbarButtons.append(warningButton)
        }
        toolbarButtons += [GlobalVariables.flexBarButton, animateButton, GlobalVariables.fixedSpace]
        paneRange.forEach { toolbarButtons.append(productButton[$0]) }
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 { toolbarButtons.append(radarSiteButton) }
        toolbar.items = ObjectToolbarItems(toolbarButtons).items
        device = MTLCreateSystemDefaultDevice()
        paneRange.indices.forEach { index in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
        }
        setPaneSize(UtilityUI.getScreenBoundsCGSize())
        metalLayer.forEach { view.layer.addSublayer($0!) }
        paneRange.forEach { wxMetalRenders.append(WXMetalRender(device, wxMetalTextObject, timeButton, productButton[$0], paneNumber: $0, numberOfPanes)) }
        productButton.enumerated().forEach { $1.title = wxMetalRenders[$0]!.product }
        // when called from severedashboard and us alerts
        if radarSiteOverride != "" { wxMetalRenders[0]!.resetRid(radarSiteOverride) }
        radarSiteButton.title = wxMetalRenders[0]!.rid
        if !RadarPreferences.dualpaneshareposn { siteButton.enumerated().forEach { $1.title = wxMetalRenders[$0]!.rid } }
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
        wxMetalRenders.forEach { $0?.setRenderFunction(render(_:)) }
        // Below two lines enable continuous updates
        //timer = CADisplayLink(target: self, selector: #selector(WXMetalMultipane.newFrame(displayLink:)))
        //timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        setupGestures()
        if RadarPreferences.locdotFollowsGps {
            self.locationManager.requestWhenInUseAuthorization()
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
        self.wxMetalRenders.forEach {
            $0?.wxMetalTextObject = wxMetalTextObject
            $0?.getRadar("")
        }
        getPolygonWarnings()
        updateColorLegend()
        if RadarPreferences.wxoglRadarAutorefresh {
            UIApplication.shared.isIdleTimerDisabled = true
            oneMinRadarFetch = Timer.scheduledTimer(
                timeInterval: 60.0 * Double(RadarPreferences.radarDataRefreshInterval),
                target: self,
                selector: #selector(getRadarEveryMinute),
                userInfo: nil,
                repeats: true
            )
        }
        self.view.bringSubviewToFront(toolbar)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 { self.view.bringSubviewToFront(toolbarTop) }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized { doneClicked() }
    }
    
    @objc func onPause() {
        //print("viewWillDisappear")
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
            //clearColor: MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
            //clearColor: nil
        )
    }
    
    /*@objc func newFrame(displayLink: CADisplayLink) {
     if lastFrameTimestamp == 0.0 {
     lastFrameTimestamp = displayLink.timestamp
     }
     let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
     lastFrameTimestamp = displayLink.timestamp
     radarLoop(timeSinceLastUpdate: elapsed)
     }*/
    
    /*func radarLoop(timeSinceLastUpdate: CFTimeInterval) {
     autoreleasepool {
     if wxMetal[0] != nil {
     //self.render()
     }
     }
     }*/
    
    func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gesturePan))
        let gestureZoomVar = UIPinchGestureRecognizer(target: self, action: #selector(gestureZoom))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.delegate = self
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureDouble(_:)))
        gestureRecognizer2.numberOfTapsRequired = 2
        gestureRecognizer2.delegate = self
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(gestureZoomVar)
        self.view.addGestureRecognizer(gestureRecognizer)
        self.view.addGestureRecognizer(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress(_:))))
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
            if self.presentedViewController == nil && self.wxMetalRenders[0] != nil {
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
                if savePreferences { wxMetalRenders.forEach { $0!.writePreferences() }}
                wxMetalRenders.forEach { $0!.cleanup() }
                device = nil
                wxMetalTextObject.wxMetalRender = nil
                metalLayer.indices.forEach { metalLayer[$0] = nil }
                wxMetalRenders.indices.forEach { wxMetalRenders[$0] = nil }
                commandQueue = nil
                pipelineState = nil
                timer = nil
                wxMetalTextObject = WXMetalTextObject()
                self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            } else {
                self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            }
        }
    }
    
    @objc func productClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Select radar product:", productButton[sender.tag])
        if WXGLNexrad.isRidTdwr(wxMetalRenders[sender.tag]!.rid) {
            WXGLNexrad.radarProductListTdwr.forEach {product in
                alert.addAction(UIAlertAction(product, {_ in self.productChanged(sender.tag, product.split(":")[0])}))
            }
        } else {
            wxMetalRenders[sender.tag]!.radarProductList.forEach {product in
                alert.addAction(UIAlertAction(product, {_ in self.productChanged(sender.tag, product.split(":")[0])}))
            }
        }
        alert.finish()
    }
    
    @objc func timeClicked() {
        wxMetalRenders.forEach { $0!.writePreferences() }
        wxMetalRenders[0]?.writePreferencesForSingleToDualPaneTransition()
        Route.radarFromTimeButton(self, "2")
    }
    
    @objc func warningClicked() {
        UtilityActions.severeDashboardClicked(self)
    }
    
    func productChanged(_ index: Int, _ product: String) {
        stopAnimate()
        self.wxMetalRenders[index]!.changeProduct(product)
        updateColorLegend()
        getPolygonWarnings()
    }
    
    @objc func onResume() {
        if RadarPreferences.locdotFollowsGps { resumeGps() }
        //stopAnimate()
        if wxMetalRenders[0] != nil {
            self.wxMetalRenders.forEach { $0!.updateTimeToolbar() }
            self.wxMetalRenders.forEach { $0!.getRadar("") }
            getPolygonWarnings()
        }
    }
    
    func updateWarningsInToolbar() {
        warningCount = 0
        if RadarPreferences.radarWarnings {
            let tstCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardTst.value)
            let torCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardTor.value)
            let ffwCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardFfw.value)
            let countString = "(" + torCount + "," + tstCount + "," + ffwCount + ")"
            self.warningButton.title = countString
            let sum = (Int(tstCount) ?? 0) + (Int(torCount) ?? 0) + (Int(ffwCount) ?? 0)
            warningCount += sum
        }
        ObjectPolygonWarning.polygonList.forEach {
            let polygonType = ObjectPolygonWarning.polygonDataByType[$0]!
            if polygonType.isEnabled { warningCount += Int(ObjectPolygonWarning.getCount(polygonType.storage.value)) ?? 0 }
        }
    }
    
    func getPolygonWarnings() {
        updateWarningsInToolbar()
        DispatchQueue.global(qos: .userInitiated).async {
            self.semaphore.wait()
            if self.wxMetalRenders[0] != nil { self.wxMetalRenders.forEach { $0!.constructAlertPolygons() } }
            UtilityPolygons.get()
            DispatchQueue.main.async {
                if self.wxMetalRenders[0] != nil { self.wxMetalRenders.forEach { $0!.constructAlertPolygons() } }
                self.updateWarningsInToolbar()
                self.semaphore.signal()
            }
        }
    }
    
    @objc func radarSiteClicked(sender: ObjectToolbarIcon) {
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
        self.radarSiteChanged((annotationView.annotation!.title!)!, mapIndex)
    }
    
    func radarSiteChanged(_ radarSite: String, _ index: Int) {
        stopAnimate()
        UtilityFileManagement.deleteAllFiles()
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            siteButton[index].title = radarSite
        } else {
            radarSiteButton.title = radarSite
        }
        getPolygonWarnings()
        if RadarPreferences.dualpaneshareposn {
            wxMetalRenders.forEach { $0!.resetRidAndGet(radarSite) }
        } else {
            wxMetalRenders[index]!.resetRidAndGet(radarSite)
        }
        self.view.subviews.forEach { if $0 is UITextView { $0.removeFromSuperview() } }
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
        self.view.subviews.forEach { if $0 is UITextView { $0.removeFromSuperview() } }
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
                self.animateFrameCntClicked(_:)
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
                self.wxMetalRenders.forEach { $0!.getRadar("") }
                getPolygonWarnings()
            }
        }
    }
    
    func animateFrameCntClicked(_ frameCnt: Int) {
        if !inOglAnim {
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
                animArray.append(WXGLDownload.getRadarFilesForAnimation(frameCnt, wxMetalRender!.product, wxMetalRender!.rid))
                animArray[index].indices.forEach {
                    UtilityFileManagement.deleteFile(String(index) + "nexrad_anim" + String($0))
                    UtilityFileManagement.moveFile(animArray[index][$0], String(index)  + "nexrad_anim" + String($0))
                    //print(animArray[index][$0] + " move to " +  String(index)  + "nexrad_anim" + String($0))
                }
            }
            var scaleFactor = 1
            while self.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.inOglAnim {
                        self.wxMetalRenders.enumerated().forEach { index, wxMetalRender in
                            let buttonText = " (" + String(frame + 1) + "/" + String(frameCnt) + ")"
                            wxMetalRender!.getRadar(String(index) + "nexrad_anim" + String(frame), buttonText)
                            scaleFactor = 1
                        }
                        var interval = MyApplication.animInterval
                        if self.wxMetalRenders[0]!.product.hasPrefix("L2") {
                            if interval < 12 { interval = 12 }
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
        var alertMessage = WXGLNexrad.getRadarInfo("") + MyApplication.newline
            + String(dist.roundTo(places: 2)) + " miles from location" + MyApplication.newline
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetalRenders[index]!.rid
        if wxMetalRenders[index]!.gpsLocation.latString != "0.0" && wxMetalRenders[index]!.gpsLocation.lonString != "0.0" {
            alertMessage += MyApplication.newline + "GPS: " + wxMetalRenders[index]!.getGpsString()
        }
        let heightAgl = Int(UtilityMath.getRadarBeamHeight(wxMetalRenders[index]!.radarBuffers.rd.degree, distRidKm))
        let heightMsl = Int(wxMetalRenders[index]!.radarBuffers.rd.radarHeight) + heightAgl
        alertMessage += MyApplication.newline + "Beam Height MSL: " + String(heightMsl)  + " ft, AGL: " + String(heightAgl) + " ft"
        if RadarPreferences.radarShowWpcFronts {
            var wpcFrontsTimeStamp = Utility.readPref("WPC_FRONTS_TIMESTAMP", "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.replace(String(UtilityTime.getYear()), "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.insert(4, " ")
            alertMessage += MyApplication.newline + "WPC Fronts: " + wpcFrontsTimeStamp
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
                +  Utility.getRadarSiteName(rid.name)
                + " (" + String(rid.distance) + " mi)"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.radarSiteChanged(rid.name, index)}))
        }
        if WXGLNexrad.canTilt(wxMetalRenders[index]!.product) {
            alert.addAction(UIAlertAction("Change Tilt", { _ in self.showTiltMenu()}))
        }
        if (RadarPreferences.radarWarnings || ObjectPolygonWarning.areAnyEnabled()) && warningCount > 0 {
            alert.addAction(UIAlertAction("Show Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self)}))
        }
        if RadarPreferences.radarWatMcd && MyApplication.watNoList.value != "" {
            alert.addAction(UIAlertAction("Show Watch text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.WATCH, pointerLocation, self)}))
        }
        if RadarPreferences.radarWatMcd && MyApplication.mcdNoList.value != "" {
            //print(MyApplication.mcdNoList.value)
            alert.addAction(UIAlertAction("Show MCD text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.MCD, pointerLocation, self)}))
        }
        if RadarPreferences.radarMpd && MyApplication.mpdNoList.value != "" {
            alert.addAction(UIAlertAction("Show MPD text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.MPD, pointerLocation, self)}))
        }
        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction("Nearest observation: " + obsSite.name, { _ in UtilityRadarUI.getMetar(pointerLocation, self)}))
        alert.addAction(
            UIAlertAction(
                "Nearest forecast: "
                    + pointerLocation.latString.truncate(6)
                    + ", "
                    + pointerLocation.lonString.truncate(6), { _ in
                        UtilityRadarUI.getForecast(pointerLocation, self)}
            )
        )
        alert.addAction(UIAlertAction("Nearest meteogram: " + obsSite.name, { _ in UtilityRadarUI.getMeteogram(pointerLocation, self)}))
        alert.addAction(
            UIAlertAction(
                "Radar status message: " + self.wxMetalRenders[index]!.rid, { _ in
                    UtilityRadarUI.getRadarStatus(self, self.wxMetalRenders[index]!.rid)}
            )
        )
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(dismiss)
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            if let popoverController = alert.popoverPresentationController { popoverController.barButtonItem = radarSiteButton }
        } else {
            if let popoverController = alert.popoverPresentationController { popoverController.barButtonItem = siteButton[0] }
        }
        self.present(alert, animated: true, completion: nil)
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
        wxMetalRenders.forEach { $0!.getRadar("") }
        getPolygonWarnings()
    }
    
    func updateColorLegend() {
        if RadarPreferences.radarShowLegend && numberOfPanes == 1 {
            uiColorLegend.removeFromSuperview()
            uiColorLegend = UIColorLegend(
                wxMetalRenders[0]!.product,
                CGRect(
                    x: 0,
                    y: UIPreferences.statusBarHeight,
                    width: 100,
                    height: self.view.frame.size.height
                        - UIPreferences.toolbarHeight
                        - UIPreferences.statusBarHeight
                )
            )
            uiColorLegend.backgroundColor = UIColor.clear
            uiColorLegend.isOpaque = false
            self.view.addSubview(uiColorLegend)
        }
    }
    
    func showTiltMenu() {
        var tilts = ["Tilt 1", "Tilt 2", "Tilt 3", "Tilt 4"]
        if wxMetalRenders[0]!.isTdwr { tilts = ["Tilt 1", "Tilt 2", "Tilt 3"] }
        _ = ObjectPopUp(self, title: "Tilt Selection", productButton[0], tilts, self.changeTilt(_:))
    }
    
    func changeTilt(_ tilt: Int) {
        wxMetalRenders.forEach {
            $0!.tilt = tilt
            $0!.getRadar("")
        }
    }
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:
                return DispatchQueue.main
            case .userInteractive:
                return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:
                return DispatchQueue.global(qos: .userInitiated)
            case .utility:
                return DispatchQueue.global(qos: .utility)
            case .background:
                return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
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
        return [
            //UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(doneClicked)),
            //UIKeyCommand(input: "a", modifierFlags: .control, action: #selector(keyboardAnimate)),
            //UIKeyCommand(input: "s", modifierFlags: .control, action: #selector(stopAnimate)),
            //UIKeyCommand(input: "2", modifierFlags: .control, action: #selector(timeClicked)),
            //UIKeyCommand(input: "4", modifierFlags: .control, action: #selector(goToQuadPane)),
            //UIKeyCommand(input: "d", modifierFlags: .control, action: #selector(warningClicked)),
            UIKeyCommand(input: "4", modifierFlags: .numericPad, action: #selector(keyLeftArrow)),
            UIKeyCommand(input: "8", modifierFlags: .numericPad, action: #selector(keyUpArrow)),
            UIKeyCommand(input: "6", modifierFlags: .numericPad, action: #selector(keyRightArrow)),
            UIKeyCommand(input: "2", modifierFlags: .numericPad, action: #selector(keyDownArrow)),
            //UIKeyCommand(input: "/", modifierFlags: .control, action: #selector(showKeyboardShortcuts)),
            
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
    
    @objc func keyboardAnimate() {
        self.animateFrameCntClicked(10)
    }
    
    /*@objc func goToQuadPane() {
        wxMetalRenders.forEach { $0!.writePreferences() }
        wxMetalRenders[0]?.writePreferencesForSingleToQuadPaneTransition()
        Route.radarFromTimeButton(self, "4")
    }*/
    
    //@objc func showKeyboardShortcuts() {
    //    UtilityUI.showDialogue(self, Utility.showRadarShortCuts())
    //}
    
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
