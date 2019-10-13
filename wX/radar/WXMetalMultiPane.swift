/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import CoreLocation
import MapKit
import simd

class WXMetalMultipane: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var wxMetal = [WXMetalRender?]()
    var device: MTLDevice!
    var metalLayer = [CAMetalLayer?]()
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    var projectionMatrix: float4x4!
    var locationManager = CLLocationManager()
    var lastFrameTimestamp: CFTimeInterval = 0.0
    var mapIndex = 0
    var mapView = MKMapView()
    var mapShown = false
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let toolbar = ObjectToolbar()
    var doneButton = ObjectToolbarIcon()
    var timeButton = ObjectToolbarIcon()
    var warningButton = ObjectToolbarIcon()
    var radarSiteButton = ObjectToolbarIcon()
    var productButton = [ObjectToolbarIcon]()
    var animateButton = ObjectToolbarIcon()
    var siteButton = [ObjectToolbarIcon]()
    var inOglAnim = false
    var longPressCount = 0
    var numberOfPanes = 1
    var oneMinRadarFetch = Timer()
    let ortInt: Float = 250.0
    var textObj = WXMetalTextObject()
    var colorLegend = UIColorLegend()
    var screenScale = 0.0
    var paneRange: Range<Int> = 0..<1
    let semaphore = DispatchSemaphore(value: 1)

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setPaneSize(size)
        paneRange.enumerated().forEach { index, _ in
            self.render(index)
        }
        coordinator.animate(alongsideTransition: nil,
            completion: { _ -> Void in
                UtilityMap.setupMap(
                    self.mapView,
                    GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap, "RID_"
                )
            }
        )
    }

    func setPaneSize(_ cgsize: CGSize) {
        let width = cgsize.width
        let height = cgsize.height
        let screenWidth = width
        let screenHeight = height + CGFloat(UIPreferences.toolbarHeight)
        var surfaceRatio = Float(screenWidth) / Float(screenHeight)
        if numberOfPanes == 2 {
            surfaceRatio = Float(screenWidth) / Float(screenHeight / 2.0)
        }
        if numberOfPanes == 4 {
            surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight / 2.0)
        }
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
        print(RadarPreferences.radarWarnings)
        self.view.backgroundColor = UIColor.black
        numberOfPanes = Int(ActVars.wxoglPaneCount) ?? 1
        paneRange = 0..<numberOfPanes
        UtilityFileManagement.deleteAllFiles()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap, "RID_")
        let toolbarTop = ObjectToolbar(.top)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            toolbarTop.setConfig(.top)
            paneRange.forEach {
                siteButton.append(ObjectToolbarIcon(title: "L", self, #selector(radarSiteClicked(sender:)), tag: $0))
            }
            var items = [UIBarButtonItem]()
            items.append(flexBarButton)
            paneRange.forEach {
                items.append(siteButton[$0])
            }
            toolbarTop.items = ObjectToolbarItems(items).items
            if UIPreferences.radarToolbarTransparent {
                toolbarTop.setTransparent()
            }
        }
        toolbar.setConfig()
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
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name:
            UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onResume),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        paneRange.forEach {
            productButton.append(ObjectToolbarIcon(title: "", self, #selector(productClicked(sender:)), tag: $0))
        }
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
        toolbarButtons += [flexBarButton, animateButton, fixedSpace]
        paneRange.forEach {
            toolbarButtons.append(productButton[$0])
        }
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            toolbarButtons.append(radarSiteButton)
        }
        toolbar.items = ObjectToolbarItems(toolbarButtons).items
        device = MTLCreateSystemDefaultDevice()
        paneRange.enumerated().forEach { index, _ in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
        }
        setPaneSize(UtilityUI.getScreenBoundsCGSize())
        metalLayer.forEach { view.layer.addSublayer($0!) }
        paneRange.forEach {
            wxMetal.append(WXMetalRender(device, timeButton, productButton[$0], paneNumber: $0, numberOfPanes))
        }
        productButton.enumerated().forEach {$1.title = wxMetal[$0]!.product}
        radarSiteButton.title = wxMetal[0]!.rid
        if !RadarPreferences.dualpaneshareposn {
            siteButton.enumerated().forEach {$1.title = wxMetal[$0]!.rid}
        }
        if RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            let x = wxMetal[0]!.xPos
            let y = wxMetal[0]!.yPos
            let zoom = wxMetal[0]!.zoom
            let rid = wxMetal[0]!.rid
            wxMetal.forEach {
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
        wxMetal.forEach {$0?.setRenderFunction(render(_:))}
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
        self.view.addSubview(toolbar)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            self.view.addSubview(toolbarTop)
        }
        screenScale = Double(UIScreen.main.scale)
        #if targetEnvironment(macCatalyst)
        screenScale *= 2.0
        #endif
        textObj = WXMetalTextObject(
            self,
            numberOfPanes,
            Double(view.frame.width),
            Double(view.frame.height),
            wxMetal[0]!,
            screenScale
        )
        textObj.initTV()
        textObj.addTV()
        self.wxMetal.forEach { $0!.getRadar("") }
        getPolygonWarnings()
        updateColorLegend()
        if RadarPreferences.wxoglRadarAutorefresh {
            UIApplication.shared.isIdleTimerDisabled = true
            oneMinRadarFetch = Timer.scheduledTimer(
                timeInterval: 60.0,
                target: self,
                selector: #selector(getRadarEveryMinute),
                userInfo: nil,
                repeats: true
            )
        }
    }

    @objc func onPause() {
        print("viewWillDisappear")
        stopAnimate()
    }

    func modelMatrix(_ index: Int) -> float4x4 {
        var matrix = float4x4()
        if !RadarPreferences.wxoglCenterOnLocation {
            matrix.translate(wxMetal[index]!.xPos, y: wxMetal[index]!.yPos, z: wxMetal[index]!.zPos)
        } else {
            wxMetal[index]!.xPos = wxMetal[index]!.gpsLatLonTransformed.0 * wxMetal[index]!.zoom
            wxMetal[index]!.yPos = wxMetal[index]!.gpsLatLonTransformed.1 * wxMetal[index]!.zoom
            matrix.translate(wxMetal[index]!.xPos, y: wxMetal[index]!.yPos, z: wxMetal[index]!.zPos)
        }
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
                //clearColor: MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
                clearColor: nil
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
        let gestureZoomvar = UIPinchGestureRecognizer(target: self, action: #selector(gestureZoom))
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
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(gestureZoomvar)
        self.view.addGestureRecognizer(gestureRecognizer)
        self.view.addGestureRecognizer(gestureRecognizer2)
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
        if !mapShown {
            WXMetalSurfaceView.singleTap(self, wxMetal, textObj, gestureRecognizer)
        }
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer, double: Int) {
        WXMetalSurfaceView.doubleTap(self, wxMetal, textObj, numberOfPanes, ortInt, gestureRecognizer)
    }

    @objc func gestureZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        WXMetalSurfaceView.gestureZoom(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func gesturePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        WXMetalSurfaceView.gesturePan(self, wxMetal, textObj, gestureRecognizer)
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

    @objc func doneClicked() {
        if mapShown {
            hideMap()
        } else {
            if self.presentedViewController == nil {
                // Don't disable screen being left on if one goes from single pane to dual pane via time
                // button and back
                if ActVars.wxoglCalledFromTimeButton && RadarPreferences.wxoglRadarAutorefresh {
                    ActVars.wxoglCalledFromTimeButton = false
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
                wxMetal.forEach { $0!.writePrefs() }
                wxMetal.forEach { $0!.cleanup() }
                device = nil
                textObj.OGLR = nil
                metalLayer.enumerated().forEach { index, _ in metalLayer[index] = nil }
                wxMetal.enumerated().forEach { index, _ in wxMetal[index] = nil }
                commandQueue = nil
                pipelineState = nil
                timer = nil
                textObj = WXMetalTextObject()
                self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            } else {
                self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
            }
        }
    }

    @objc func productClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Select radar product:", productButton[sender.tag])
        if WXGLNexrad.isRidTdwr(wxMetal[sender.tag]!.rid) {
            WXGLNexrad.radarProductListTdwr.forEach {product in
                alert.addAction(UIAlertAction(product, {_ in
                    self.productChanged(sender.tag, product.split(":")[0])}))
            }
        } else {
            wxMetal[sender.tag]!.radarProductList.forEach {product in
                alert.addAction(UIAlertAction(product, {_ in
                    self.productChanged(sender.tag, product.split(":")[0])}))
            }
        }
        alert.finish()
    }

    @objc func timeClicked() {
        ActVars.wxoglPaneCount = "2"
        ActVars.wxoglCalledFromTimeButton = true
        let token = "wxmetalradar"
        wxMetal.forEach { $0!.writePrefs() }
        wxMetal[0]?.writePrefsForSingleToDualPaneTransition()
        self.goToVC(token)
    }

    @objc func warningClicked() {
        UtilityActions.dashClicked(self)
    }

    func productChanged(_ index: Int, _ product: String) {
        stopAnimate()
        self.wxMetal[index]!.changeProduct(product)
        updateColorLegend()
        getPolygonWarnings()
    }

    @objc func onResume() {
        if RadarPreferences.locdotFollowsGps {
            resumeGps()
        }
        //stopAnimate()
        if wxMetal[0] != nil {
            self.wxMetal.forEach { $0!.updateTimeToolbar() }
            self.wxMetal.forEach { $0!.getRadar("") }
            getPolygonWarnings()
        }
    }

    func updateWarningsInToolbar() {
        if RadarPreferences.radarWarnings {
            let tstCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardTst.value)
            let torCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardTor.value)
            let ffwCount = ObjectPolygonWarning.getCount(MyApplication.severeDashboardFfw.value)
            let countString = "(" + torCount + "," + tstCount + "," + ffwCount + ")"
            self.warningButton.title = countString
        }
    }

    func getPolygonWarnings() {
        updateWarningsInToolbar()
        DispatchQueue.global(qos: .userInitiated).async {
            self.semaphore.wait()
            //print("display existing warning data")
            if self.wxMetal[0] != nil {
                self.wxMetal.forEach { $0!.constructAlertPolygons() }
            }
            UtilityPolygons.getData()
            DispatchQueue.main.async {
                if self.wxMetal[0] != nil {
                    self.wxMetal.forEach { $0!.constructAlertPolygons() }
                }
                //print("display new warning data")
                self.updateWarningsInToolbar()
                self.semaphore.signal()
            }
        }
    }

    @objc func radarSiteClicked(sender: ObjectToolbarIcon) {
        mapIndex = sender.tag
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            self.view.addSubview(mapView)
        }
    }

    func hideMap() {
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            self.view.addSubview(mapView)
        }
    }

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        return UtilityMap.mapView(mapView, annotation)
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
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
            wxMetal.forEach {
                $0!.resetRidAndGet(radarSite)
            }
        } else {
            wxMetal[index]!.resetRidAndGet(radarSite)
        }
        self.view.subviews.forEach {
            if $0 is UITextView {
                $0.removeFromSuperview()
            }
        }
        textObj = WXMetalTextObject(
            self,
            numberOfPanes,
            Double(view.frame.width),
            Double(view.frame.height),
            wxMetal[0]!,
            screenScale
        )
        textObj.initTV()
        textObj.addTV()
    }

    @objc func animateClicked() {
        if !inOglAnim {
            _ = ObjectPopUp(
                self,
                "Select number of animation frames:",
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
            animateButton.setImage(UIImage(named: "ic_play_arrow_24dp")!, for: .normal)
            if wxMetal[0] != nil {
                self.wxMetal.forEach { $0!.getRadar("") }
                getPolygonWarnings()
            }
        }
    }

    func animateFrameCntClicked(_ frameCnt: Int) {
        if !inOglAnim {
            inOglAnim = true
            animateButton.setImage(UIImage(named: "ic_stop_24dp")!, for: .normal)
            getAnimate(frameCnt)
        } else {
            stopAnimate()
        }
    }

    func getAnimate(_ frameCnt: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            var animArray = [[String]]()
            self.wxMetal.enumerated().forEach { index, glv in
                animArray.append(glv!.rdDownload.getRadarFilesForAnimation(frameCnt))
                animArray[index].indices.forEach {
                    UtilityFileManagement.deleteFile(String(index) + "nexrad_anim" + String($0))
                    UtilityFileManagement.moveFile(animArray[index][$0], String(index)  + "nexrad_anim" + String($0))
                    print(animArray[index][$0] + " move to " +  String(index)  + "nexrad_anim" + String($0))
                }
            }
            var scaleFactor = 1
            while self.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.inOglAnim {
                        self.wxMetal.enumerated().forEach { index, glv in
                            let buttonText = " (\(String(frame+1))/\(frameCnt))"
                            glv!.getRadar(String(index) + "nexrad_anim" + String(frame), buttonText)
                            scaleFactor = 1
                        }
                        usleep(UInt32(100000 * MyApplication.animInterval * scaleFactor))
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
        let distRidKm = LatLon.distance(radarSiteLocation, pointerLocation, .K)
        var alertMessage = Utility.readPref("WX_RADAR_CURRENT_INFO", "") + MyApplication.newline
            + String(dist.roundTo(places: 2)) + " miles from location" + MyApplication.newline
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetal[index]!.rid
        if wxMetal[index]!.gpsLocation.latString != "0.0" && wxMetal[index]!.gpsLocation.lonString != "0.0" {
            alertMessage += MyApplication.newline + "GPS: " + wxMetal[index]!.getGpsString()
        }
        let heightAgl = Int(UtilityMath.getRadarBeamHeight(wxMetal[index]!.radarBuffers.rd.degree, distRidKm))
        let heightMsl = Int(wxMetal[index]!.radarBuffers.rd.radarHeight) + heightAgl
        alertMessage += MyApplication.newline
            + "Beam Height MSL: " + String(heightMsl)  + " ft, AGL: " + String(heightAgl) + " ft"
        let alert = UIAlertController(
            title: "Closest radar site:",
            message: alertMessage,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        ridNearbyList.forEach { rid in
            let radarDescription = rid.name
                + ": "
                +  Utility.readPref("RID_LOC_" + rid.name, "")
                + " (" + String(rid.distance) + " mi)"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.radarSiteChanged(rid.name, index)}))
        }
        if WXGLNexrad.canTilt(wxMetal[index]!.product) {
            alert.addAction(UIAlertAction(
                "Change Tilt", { _ in self.showTiltMenu()})
            )
        }
        alert.addAction(UIAlertAction(
            "Show Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show Watch text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.WATCH, pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show MCD text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.MCD, pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show MPD text", { _ in UtilityRadarUI.showNearestProduct(PolygonType.MPD, pointerLocation, self)})
        )
        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction(
            "Nearest observation: " + obsSite.name, { _ in UtilityRadarUI.getMetar(pointerLocation, self)})
        )
        alert.addAction(
            UIAlertAction(
                "Nearest forecast: "
                    + pointerLocation.latString.truncate(6)
                    + ", "
                    + pointerLocation.lonString.truncate(6), { _ in
                    UtilityRadarUI.getForecast(pointerLocation, self)}
            )
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
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = radarSiteButton
            }
        } else {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = siteButton[0]
            }
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
            if wxMetal[0] != nil {
                wxMetal.forEach {
                    $0!.gpsLocation = LatLon(Double(locValue.latitude), Double(locValue.longitude) * -1.0)
                    $0!.constructLocationDot()
                }
            }
        }
    }

    @objc func getRadarEveryMinute() {
        wxMetal.forEach { $0!.getRadar("") }
        getPolygonWarnings()
    }

    func updateColorLegend() {
        if RadarPreferences.radarShowLegend && numberOfPanes == 1 {
            colorLegend.removeFromSuperview()
            colorLegend = UIColorLegend(
                wxMetal[0]!.product,
                CGRect(
                    x: 0,
                    y: UIPreferences.statusBarHeight,
                    width: 100,
                    height: self.view.frame.size.height
                    - UIPreferences.toolbarHeight
                    - UIPreferences.statusBarHeight
                )
            )
            colorLegend.backgroundColor = UIColor.clear
            colorLegend.isOpaque = false
            self.view.addSubview(colorLegend)
        }
    }

    func showTiltMenu() {
        var tilts = ["Tilt 1", "Tilt 2", "Tilt 3", "Tilt 4"]
        if wxMetal[0]!.tdwr {
            tilts = ["Tilt 1", "Tilt 2", "Tilt 3"]
        }
        _ = ObjectPopUp(self, "Tilt Selection", productButton[0], tilts, self.changeTilt(_:))
    }

    func changeTilt(_ tilt: Int) {
        wxMetal.forEach {
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
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           if #available(iOS 13.0, *) {
               //let userInterfaceStyle = traitCollection.userInterfaceStyle
               if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
                   if UITraitCollection.current.userInterfaceStyle == .dark {
                       AppColors.update()
                       print("Dark mode")
                   } else {
                       AppColors.update()
                       print("Light mode")
                   }
           } else {
               // Fallback on earlier versions
           }
       }
    }

    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(doneClicked)),
            UIKeyCommand(input: "a", modifierFlags: .command, action: #selector(animateClicked)),
            UIKeyCommand(input: "s", modifierFlags: .command, action: #selector(stopAnimate)),
            UIKeyCommand(input: "d", modifierFlags: .command, action: #selector(timeClicked)),
            UIKeyCommand(input: "w", modifierFlags: .command, action: #selector(warningClicked))
        ]
    }
}
