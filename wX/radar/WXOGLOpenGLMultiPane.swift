/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import GLKit
import OpenGLES
import CoreLocation
import MapKit

class WXOGLOpenGLMultiPane: GLKViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var oneMinRadarFetch = Timer()
    var uniforms = [GLint](repeating: 0, count: 2)
    let uniformModelViewProjectionMatrix = 0
    var glviewArr = [GLKView]()
    var oglrArr = [WXGLRender]()
    var timeButton = ObjectToolbarIcon()
    var colorLegend = UIColorLegend()
    var textObj = WXGLTextObject()
    var screenScale = 0.0
    var mapIndex = 0
    var mapView = MKMapView()
    var mapShown = false
    var locationManager = CLLocationManager()
    var program: GLuint = 0
    var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    var mtrxProjectionAndView: GLKMatrix4 = GLKMatrix4Identity
    var longPressCount = 0
    var rotation: Float = 0.0
    var vertexArray: GLuint = 0
    var vertexBuffer: GLuint = 0
    var context: EAGLContext?
    var effect: GLKBaseEffect?
    var width = 0.0
    var height = 0.0
    private var radarProductInitial = ["N0Q", "N0U", "N0C", "DVL"]
    var inOglAnim = false
    var mPositionHandle: GLuint = 0
    var colorHandle: GLuint = 0
    var radarsiteButton = ObjectToolbarIcon()
    var productButton = [ObjectToolbarIcon]()
    var siteButton = [ObjectToolbarIcon]()
    var animateButton = ObjectToolbarIcon()
    var numberOfPanes = 0

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.glviewArr.forEach {$0.setNeedsDisplay()}
            self.view.setNeedsDisplay()
        })
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        WXGLSurfaceView.singleTap(self, oglrArr, textObj, gestureRecognizer)
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer, double: Int) {
        WXGLSurfaceView.doubleTap(self, oglrArr, textObj, numberOfPanes, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXGLSurfaceView.gestureLongPress(self, longPressCount, longPressAction, gestureRecognizer)
    }

    @objc func gestureZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        WXGLSurfaceView.gestureZoom(self, oglrArr, textObj, gestureRecognizer)
    }

    @objc func gesturePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        WXGLSurfaceView.gesturePan(self, oglrArr, textObj, gestureRecognizer)
    }

    deinit {
        self.tearDownGL()
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
    }

    @objc func invalidateGPS() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func resumeGPS() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    // 
    // move external file
    //
    func writePrefs(_ numberOfPanesInt: Int, _ indexInt: Int, _ glv: WXGLRender) {
        let numberOfPanes = String(numberOfPanesInt)
        let index = String(indexInt)
        editor.putFloat("WXOGL" + numberOfPanes + "_ZOOM" + index, Float(glv.zoom))
        editor.putFloat("WXOGL" + numberOfPanes + "_X" + index, glv.x)
        editor.putFloat("WXOGL" + numberOfPanes + "_Y" + index, glv.y)
        editor.putString("WXOGL" + numberOfPanes + "_RID" + index, glv.rid)
        editor.putString("WXOGL" + numberOfPanes + "_PROD" + index, glv.product)
    }

    @objc func doneClicked() {
        oglrArr.enumerated().forEach {writePrefs(numberOfPanes, $0, $1)}
        if RadarPreferences.wxoglRadarAutorefresh {
            oneMinRadarFetch.invalidate()
        }
        tearDownGL()
        if inOglAnim {stopAnimate()}
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        oglrArr.enumerated().forEach { idx, _ in oglrArr[idx] = WXGLRender(self.timeButton, self.productButton[idx])}
        glviewArr.enumerated().forEach { idx, _ in glviewArr[idx] = GLKView()}
        // the following line prevents a retain cycle and severe memory leak with all radar screens
        textObj = WXGLTextObject()
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UtilityFileManagement.deleteAllFiles()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap, "RID_")
        if RadarPreferences.locdotFollowsGps {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(WXOGLOpenGLMultiPane.invalidateGPS),
                                                   name: NSNotification.Name.UIApplicationWillResignActive,
                                                   object: nil)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        self.preferredFramesPerSecond = 0
        numberOfPanes = Int(ActVars.WXOGLPaneCnt) ?? 1
        let pangeRange = 0..<numberOfPanes
        //
        //  setup top toolbar if needed
        //
        let toolbarTop = ObjectToolbar(.top)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            toolbarTop.setConfig(.top)
            pangeRange.forEach {
                siteButton.append(ObjectToolbarIcon(title: "L", self, #selector(radarSiteClicked(sender:)), tag: $0))
            }
            var items = [UIBarButtonItem]()
            items.append(flexBarButton)
            pangeRange.forEach {
                items.append(fixedSpace)
                items.append(siteButton[$0])
            }
            toolbarTop.items = ObjectToolbarItems(items).items
            if UIPreferences.radarToolbarTransparent {
                toolbarTop.setBackgroundImage(UIImage(),
                                           forToolbarPosition: .any,
                                           barMetrics: .default)
                toolbarTop.setShadowImage(UIImage(), forToolbarPosition: .any)
            }
        }
        let toolbar = ObjectToolbar()
        toolbar.setConfig()
        if UIPreferences.radarToolbarTransparent {
            toolbar.setBackgroundImage(UIImage(),
                                       forToolbarPosition: .any,
                                       barMetrics: .default)
            toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        }
        radarsiteButton = ObjectToolbarIcon(title: "RadarSite", self, #selector(radarSiteClicked(sender:)))
        pangeRange.forEach {
            productButton.append(ObjectToolbarIcon(title: "Product", self, #selector(productClicked(sender:)), tag: $0))
        }
        let doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        timeButton = ObjectToolbarIcon(self, nil)
        var toolbarButtons = [UIBarButtonItem]()
        toolbarButtons.append(doneButton)
        if numberOfPanes == 1 {
            toolbarButtons.append(timeButton)
        }
        toolbarButtons.append(flexBarButton)
        toolbarButtons.append(animateButton)
        pangeRange.forEach {
            toolbarButtons.append(fixedSpace)
            toolbarButtons.append(productButton[$0])
        }
        if RadarPreferences.dualpaneshareposn || numberOfPanes == 1 {
            toolbarButtons.append(radarsiteButton)
        }
        toolbar.items = ObjectToolbarItems(toolbarButtons).items
        width = Double(self.view.bounds.size.width)
        height = Double(self.view.bounds.size.height)
        self.context = EAGLContext(api: .openGLES2)
        if self.context == nil {
            print("Failed to create ES context")
        }
        let halfWidth = self.view.frame.width / 2
        var halfHeight = self.view.frame.height / 2
        if numberOfPanes == 2 {
            halfHeight -= UIPreferences.toolbarHeight / 2.0
            glviewArr.append(GLKView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: self.view.frame.width,
                                                   height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: 0,
                                                   y: halfHeight,
                                                   width: self.view.frame.width,
                                                   height: halfHeight), context: self.context!))
        } else if numberOfPanes == 4 {
            halfHeight -= UIPreferences.toolbarHeight / 2.0
            glviewArr.append(GLKView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: halfWidth,
                                                   height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: halfWidth,
                                                   y: 0,
                                                   width: halfWidth,
                                                   height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: 0,
                                                   y: halfHeight,
                                                   width: halfWidth,
                                                   height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: halfWidth,
                                                   y: halfHeight,
                                                   width: halfWidth,
                                                   height: halfHeight), context: self.context!))
        } else {
            glviewArr.append(GLKView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: self.view.frame.width,
                                                   height: self.view.frame.height), context: self.context!))
        }
        pangeRange.forEach {oglrArr.append(WXGLRender(timeButton, productButton[$0]))}
        if RadarPreferences.wxoglRememberLocation || numberOfPanes != 1 {
            if RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
                oglrArr.enumerated().forEach {
                    let numberOfPanes = String(self.numberOfPanes)
                    let index = "0"
                    let indexUnique = String($0)
                    let radarProduct = radarProductInitial[$0]
                    $1.setViewInitial(Double(preferences.getFloat("WXOGL" + numberOfPanes + "_ZOOM" + index, 1.0)),
                                      preferences.getFloat("WXOGL" + numberOfPanes + "_X" + index, 0.0),
                                      preferences.getFloat("WXOGL" + numberOfPanes + "_Y" + index, 0.0))
                    $1.product = preferences.getString("WXOGL" + numberOfPanes + "_PROD" + indexUnique, radarProduct)
                    $1.rid = preferences.getString("WXOGL" + numberOfPanes + "_RID" + index, Location.rid)
                    $1.setParent(self)
                }
            } else {
                oglrArr.enumerated().forEach {
                    let numberOfPanes = String(self.numberOfPanes)
                    let index = String($0)
                    let radarProduct = radarProductInitial[$0]
                    $1.setViewInitial(Double(preferences.getFloat("WXOGL" + numberOfPanes + "_ZOOM" + index, 1.0)),
                                      preferences.getFloat("WXOGL" + numberOfPanes + "_X" + index, 0.0 ),
                                      preferences.getFloat("WXOGL" + numberOfPanes + "_Y" + index, 0.0 ))
                    $1.product = preferences.getString("WXOGL" + numberOfPanes + "_PROD" + index, radarProduct)
                    $1.rid = preferences.getString("WXOGL" + numberOfPanes + "_RID" + index, Location.rid)
                    $1.setParent(self)
                }
            }
        } else {
            oglrArr.forEach {
                $0.setView()
                $0.rid = Location.rid
                $0.setParent(self)
            }
        }
        productButton.enumerated().forEach {$1.title = oglrArr[$0].product}
        radarsiteButton.title = oglrArr[0].rid
        if !RadarPreferences.dualpaneshareposn {
            siteButton.enumerated().forEach {$1.title = oglrArr[$0].rid}
        }
        glviewArr.enumerated().forEach {
            $1.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            $1.context = context!
            $1.drawableDepthFormat = .format24
            $1.delegate = oglrArr[$0].self
            $1.tag = $0
            oglrArr[$0].gl = glviewArr[$0]
            self.view.addSubview($1)
            let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(WXOGLOpenGLMultiPane.tapGesture(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            $1.addGestureRecognizer(gestureRecognizer)
            let gestureRecognizer2 = UITapGestureRecognizer(
                target: self,
                action: #selector(WXOGLOpenGLMultiPane.tapGesture(_:double:))
            )
            gestureRecognizer2.numberOfTapsRequired = 2
            //needed to distingish singletap/doubletap
            gestureRecognizer.require(toFail: gestureRecognizer2)
            gestureRecognizer.delaysTouchesBegan = true
            gestureRecognizer2.delaysTouchesBegan = true
            $1.addGestureRecognizer(gestureRecognizer2)
            $1.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                           action: #selector(WXOGLOpenGLMultiPane.gesturePan(_:))))
            $1.addGestureRecognizer(UIPinchGestureRecognizer(target: self,
                                                             action: #selector(WXOGLOpenGLMultiPane.gestureZoom(_:))))
            $1.addGestureRecognizer(
                UILongPressGestureRecognizer(
                    target: self,
                    action: #selector(WXOGLOpenGLMultiPane.gestureLongPress(_:))
                )
            )
        }
        self.view.addSubview(toolbar)
        if !RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            self.view.addSubview(toolbarTop)
        }
        self.setupGL()
        if RadarPreferences.locdotFollowsGps {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 10
            }
        }
        oglrArr.enumerated().forEach {
            $1.localSetup()
            $1.idxStr = String($0)
            $1.getRadar("")
            showTimeToolbar($1)
            if $0 == 0 {
                screenScale = Double(UIScreen.main.scale)
                textObj = WXGLTextObject(self, numberOfPanes,
                                         Double(view.frame.width),
                                         Double(view.frame.height),
                                         oglrArr[0],
                                         screenScale)
                textObj.initTV()
                textObj.addTV()
            }
        }
        updateColorLegend()
        getPolygonWarnings()
        if RadarPreferences.wxoglRadarAutorefresh {
            oneMinRadarFetch = Timer.scheduledTimer(timeInterval: 60.0,
                                                    target: self,
                                                    selector: #selector(WXOGLOpenGLMultiPane.getRadarEveryMinute),
                                                    userInfo: nil,
                                                    repeats: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate { // type CLLocationCoordinate2D
            oglrArr.forEach {
                $0.gpsLocation = LatLon(Double(locValue.latitude), Double(locValue.longitude) * -1.0)
                $0.constructLocationDot()
                $0.gl.setNeedsDisplay()
            }
        }
    }

    @objc func getRadarEveryMinute() {
        oglrArr.forEach {$0.getRadar("")}
        getPolygonWarnings()
    }

    func setupGL() {
        EAGLContext.setCurrent(self.context)
        if self.loadShaders() == false {print("Failed to load shaders")}
        self.effect = GLKBaseEffect()
        oglrArr.forEach {_ = $0.loadShaders()}
    }

    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        self.effect = nil
        if program != 0 {
            glDeleteProgram(program)
            program = 0
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

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return UtilityMap.mapView(mapView, annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {self.ridChanged((annotationView.annotation!.title!)!, mapIndex)}

    func changeRidInRenderer(_ rid: String, _ glk: WXGLRender) {glk.ridChanged(rid)}

    func ridChanged(_ rid: String, _ index: Int) {
        stopAnimate()
        UtilityFileManagement.deleteAllFiles()
        if RadarPreferences.dualpaneshareposn {
            oglrArr.forEach {changeRidInRenderer(rid, $0)}
            radarsiteButton.title = rid
        } else {
            changeRidInRenderer(rid, oglrArr[index])
        }
        if !RadarPreferences.dualpaneshareposn {siteButton.enumerated().forEach {$1.title = oglrArr[$0].rid}}
        self.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        getPolygonWarnings()
        textObj = WXGLTextObject(self, numberOfPanes,
                                 Double(view.frame.width),
                                 Double(view.frame.height),
                                 oglrArr[0], screenScale)
        textObj.initTV()
        textObj.addTV()
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        width = Double(self.view.bounds.size.width)
        height = Double(self.view.bounds.size.height)
        var glvIdx = 0
        var yModified = Double(y)
        var xModified = Double(x)
        // see if y is in the bottom pane, if adjust
        if numberOfPanes != 1 {
            if y > self.view.frame.height / 2.0 {
                yModified -= Double(self.view.frame.height) / 2.0
                glvIdx = 1
            }
        }
        if numberOfPanes == 4 {
            if x > self.view.frame.width / 2.0 {
                xModified -= Double(self.view.frame.width) / 2.0
            }
        }
        var density = Double(oglrArr[0].ortInt * 2) / width
        if numberOfPanes == 4 {
            density = 2.0 * Double(oglrArr[0].ortInt * 2.0) / width
        }
        var yMiddle = 0.0
        var xMiddle = 0.0
        if numberOfPanes == 1 {
            yMiddle = height / 2.0
        } else {
            yMiddle = height / 4.0
        }
        if numberOfPanes == 4 {
            xMiddle = width / 4.0
        } else {
            xMiddle = width / 2.0
        }
        let glv = oglrArr[glvIdx]
        let diffX = density * (xMiddle - xModified) / glv.zoom
        let diffY = density * (yMiddle - yModified) / glv.zoom
        let radarLocation = LatLon(preferences.getString("RID_" + oglrArr[0].rid + "_X", "0.00"),
                                   preferences.getString("RID_" + oglrArr[0].rid + "_Y", "0.00"))
        let ppd = glv.oneDegreeScaleFactor
        let newX = radarLocation.lon + (Double(glv.x) / glv.zoom + diffX) / ppd
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4 + radarLocation.lat * (Double.pi / 180) / 2.0))
        var newY = test2 + (Double(-glv.y) / glv.zoom + diffY) / ppd
        newY = (180.0 / Double.pi * (2 * atan(exp(newY * Double.pi / 180.0)) - Double.pi / 2.0))
        let ridNearbyList = UtilityLocation.getNearestRadarSites(LatLon.reversed(newX, newY), 5)
        let pointerLocation = LatLon.reversed(newX, newY)
        let dist = LatLon.distance(Location.latlon, pointerLocation, .MILES)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: oglrArr[0].rid)
        let distRid = LatLon.distance(radarSiteLocation, LatLon.reversed(newX, newY), .MILES)
        var alertMessage = preferences.getString("WX_RADAR_CURRENT_INFO", "")
            + MyApplication.newline
            + String(dist.roundTo(places: 2))
            + " miles from location" + ", "
            + String(distRid.roundTo(places: 2)) + " miles from " + oglrArr[0].rid
        if glv.gpsLocation.latString != "0.0" && glv.gpsLocation.lonString != "0.0" {
            alertMessage += MyApplication.newline + "GPS: "
                + glv.gpsLocation.latString.truncate(10)
                + ", -"
                + glv.gpsLocation.lonString.truncate(10)
        }
        let alert = UIAlertController(title: "Select closest radar site:",
                                      message: alertMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        ridNearbyList.forEach { rid in
            let radarDescription = rid.name
                + ": "
                +  preferences.getString("RID_LOC_" + rid.name, "")
                + " (" + String(rid.distance) + " mi)"
            alert.addAction(UIAlertAction(radarDescription, { _ in self.ridChanged(rid.name, index)}))
        }
        alert.addAction(UIAlertAction(
            "Show warning text", {_ in UtilityRadarUI.showPolygonText(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show nearest observation", {_ in UtilityRadarUI.getMetar(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show nearest forecast", {_ in UtilityRadarUI.getForecast(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show nearest meteogram", {_ in UtilityRadarUI.getMeteogram(pointerLocation, self)})
        )
        alert.addAction(UIAlertAction(
            "Show radar status message", {_ in UtilityRadarUI.getRadarStatus(self, self.oglrArr[0].rid)})
        )
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismiss)
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = radarsiteButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    func productChanged(_ index: Int, _ product: String) {
        stopAnimate()
        oglrArr[index].product = product
        self.oglrArr[index].getRadar("")
        updateColorLegend()
        productButton.enumerated().forEach {$1.title = oglrArr[$0].product}
        getPolygonWarnings()
    }

    @objc func productClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Select radar product:", productButton[0])
        if WXGLNexrad.isRidTdwr(oglrArr[0].rid) {
            WXGLNexrad.radarProductListTDWR.forEach {product in
                alert.addAction(UIAlertAction(title: product, style: .default, handler: {_ in
                    self.productChanged(sender.tag, product.split(":")[0])}))
            }
        } else {
            WXGLNexrad.radarProductList.forEach {product in
                alert.addAction(UIAlertAction(title: product, style: .default, handler: {_ in
                    self.productChanged(sender.tag, product.split(":")[0])}))
            }
        }
        alert.finish()
    }

    @objc func willEnterForeground() {
        if RadarPreferences.locdotFollowsGps {
            resumeGPS()
        }
        stopAnimate()
        oglrArr.forEach {$0.getRadar("")}
        getPolygonWarnings()
    }

    @objc func animateClicked() {
        if !inOglAnim {
            _ = ObjectPopUp(self,
                            "Select number of animation frames:",
                            animateButton,
                            [5, 10, 20, 30, 40, 50, 60],
                            self.animateFrameCntClicked(_:)
            )
        } else {
            stopAnimate()
        }
    }

    func stopAnimate() {
        inOglAnim = false
        animateButton.setImage(UIImage(named: "ic_play_arrow_24dp")!, for: .normal)
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
            self.oglrArr.forEach {animArray.append($0.rdDownload.getRadarFilesForAnimation(frameCnt))}
            self.oglrArr.enumerated().forEach { idx, _ in
                animArray[idx].indices.forEach {
                    UtilityFileManagement.deleteFile(String(idx) + "nexrad_anim" + String($0))
                    UtilityFileManagement.moveFile(animArray[idx][$0], String(idx)  + "nexrad_anim" + String($0))
                }
            }
            var scaleFactor = 1
            while self.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.inOglAnim {
                        self.oglrArr.enumerated().forEach { idx, glv in
                            let buttonText = " (\(String(frame+1))/\(frameCnt))"
                            glv.getRadar(String(idx) + "nexrad_anim" + String(frame), buttonText)
                            self.view.setNeedsDisplay()
                            if self.oglrArr[idx].product.contains("L2") {
                                scaleFactor = 3
                            } else {
                                scaleFactor = 1
                            }
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

    func getPolygonWarnings() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityPolygons.getData()
            DispatchQueue.main.async {
                self.oglrArr.enumerated().forEach {
                    $1.constructAlertPolygons()
                    self.glviewArr[$0].setNeedsDisplay()
                }
                self.view.setNeedsDisplay()
            }
        }
    }

    func loadShaders() -> Bool {
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        var vertShaderPathname: String
        var fragShaderPathname: String
        program = glCreateProgram()
        vertShaderPathname = Bundle.main.path(forResource: "Shader", ofType: "vsh")!
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false {
            print("Failed to compile vertex shader")
            return false
        }
        fragShaderPathname = Bundle.main.path(forResource: "Shader", ofType: "fsh")!
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
            print("Failed to compile fragment shader")
            return false
        }
        glAttachShader(program, vertShader)
        glAttachShader(program, fragShader)
        glBindAttribLocation(program, GLuint(GLKVertexAttrib.position.rawValue), "position")
        glBindAttribLocation(program, GLuint(GLKVertexAttrib.color.rawValue), "a_Color")
        if !self.linkProgram(program) {
            print("Failed to link program: \(program)")
            if vertShader != 0 {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0 {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if program != 0 {
                glDeleteProgram(program)
                program = 0
            }
            return false
        }
        uniforms[uniformModelViewProjectionMatrix] = glGetUniformLocation(program, "mtrxProjectionAndView")
        if vertShader != 0 {
            glDetachShader(program, vertShader)
            glDeleteShader(vertShader)
        }
        if fragShader != 0 {
            glDetachShader(program, fragShader)
            glDeleteShader(fragShader)
        }
        return true
    }

    func compileShader(_ shader: inout GLuint, type: GLenum, file: String) -> Bool {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch {
            print("Failed to load vertex shader")
            return false
        }
        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }

    func linkProgram(_ prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        return true
    }

    func validateProgram(prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](repeating: 0, count: Int(logLength))
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(log)")
        }
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0 {
            returnVal = false
        }
        return returnVal
    }

    func update() {}

    func showTimeToolbar(_ glv: WXGLRender) {}

    func updateColorLegend() {
        if RadarPreferences.radarShowLegend && numberOfPanes==1 {
            colorLegend.removeFromSuperview()
            colorLegend = UIColorLegend(oglrArr[0].product,
                                        CGRect(x: 0,
                                               y: UIPreferences.statusBarHeight,
                                               width: 100,
                                               height: self.view.frame.size.height
                                                - UIPreferences.toolbarHeight
                                                - UIPreferences.statusBarHeight))
            colorLegend.backgroundColor = UIColor.clear
            colorLegend.isOpaque = false
            self.view.addSubview(colorLegend)
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
}
