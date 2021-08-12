// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import Metal
import simd

final class NexradTab {
    
    var wxMetal = [WXMetalRender?]()
    var uiv: vcTabLocation!
    private var metalLayer = [CAMetalLayer?]()
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var projectionMatrix: float4x4!
    private let ortInt: Float = 350.0
    private let numberOfPanes = 1
    private var wxMetalTextObject = WXMetalTextObject()
    private var longPressCount = 0

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
        wxMetal[0]!.setRenderFunction(render)
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
    
    func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureDouble))
        gestureRecognizer2.numberOfTapsRequired = 2
        uiv.stackViewRadar.addGesture(gestureRecognizer)
        uiv.stackViewRadar.addGesture(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        uiv.stackViewRadar.addGesture(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress)))
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.singleTap(uiv, wxMetal, wxMetalTextObject, gestureRecognizer)
    }

    @objc func tapGestureDouble(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.doubleTap(uiv, wxMetal, wxMetalTextObject, numberOfPanes, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXMetalSurfaceView.gestureLongPress(uiv.stackViewRadar.get(), wxMetal, longPressCount, longPressAction, gestureRecognizer)
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        let pointerLocation = UtilityRadarUI.getLatLonFromScreenPosition(uiv.stackViewRadar.get(), wxMetal[index]!, numberOfPanes, ortInt, x, y)
        let ridNearbyList = UtilityLocation.getNearestRadarSites(pointerLocation, 5)
        let dist = LatLon.distance(Location.latLon, pointerLocation, .MILES)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: wxMetal[index]!.radarSite)
        let distRid = LatLon.distance(radarSiteLocation, pointerLocation, .MILES)
        let radarInfo = wxMetal[0]!.fileStorage.radarInfo
        var alertMessage = radarInfo + GlobalVariables.newline
            + String(dist.roundTo(places: 2)) + " miles from location"
            + ", " + String(distRid.roundTo(places: 2)) + " miles from "
            + wxMetal[index]!.radarSite
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
            alert.addAction(UIAlertAction("Show Warning text", { _ in UtilityRadarUI.showPolygonText(pointerLocation, self.uiv) }))
        }
        if RadarPreferences.watMcd {
            alert.addAction(UIAlertAction("Show Watch text", { _ in UtilityRadarUI.showNearestWatch(.SPCWAT, pointerLocation, self.uiv) }))
            alert.addAction(UIAlertAction("Show MCD text", { _ in UtilityRadarUI.showNearestWatch(.SPCMCD, pointerLocation, self.uiv) }))
        }
        if RadarPreferences.mpd {
            alert.addAction(UIAlertAction("Show MPD text", { _ in UtilityRadarUI.showNearestWatch(.WPCMPD, pointerLocation, self.uiv) }))
        }
        let obsSite = UtilityMetar.findClosestObservation(pointerLocation)
        alert.addAction(UIAlertAction("Nearest observation: " + obsSite.name, { _ in UtilityRadarUI.getMetar(pointerLocation, self.uiv) }))
        alert.addAction(UIAlertAction(
            "Nearest forecast: " + pointerLocation.latString.truncate(6) + ", " + pointerLocation.lonString.truncate(6), { _ in
                UtilityRadarUI.getForecast(pointerLocation, self.uiv)})
        )
        alert.addAction(UIAlertAction("Nearest meteogram: " + obsSite.name, { _ in UtilityRadarUI.getMeteogram(pointerLocation, self.uiv) }))
        alert.addAction(UIAlertAction("Radar status message: " + wxMetal[index]!.radarSite, { _ in UtilityRadarUI.getRadarStatus(self.uiv, self.wxMetal[index]!.radarSite) }))
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(dismiss)
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = uiv.menuButton
        }
        uiv.present(alert, animated: true, completion: nil)
    }
    
    func ridChanged(_ rid: String) {
        getPolygonWarnings()
        wxMetal[0]!.resetRidAndGet(rid, isHomeScreen: true)
    }
}
