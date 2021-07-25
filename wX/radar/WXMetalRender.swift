/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import QuartzCore
import Metal
import simd
import UIKit

final class WXMetalRender {

    private let radarType = "WXMETAL"
    private let device: MTLDevice
    var projectionNumbers = ProjectionNumbers()
    private var ridStr = "DTX"
    private var radarProduct = "N0Q"
    private var tiltInt = 0
    private let initialRadarProducts = ["N0Q", "N0U", "EET", "DVL"]
    var xPos: Float = 0.0
    var yPos: Float = 0.0
    let zPos: Float = -7.0
    var zoom: Float = 1.0
    var lastPanLocation: CGPoint!
    var isTdwr = false
    #if !targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.5
    #endif
    #if targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.2
    #endif
    var displayHold = false
    private var stateLineBuffers = ObjectMetalBuffers(GeographyType.stateLines, 0.0)
    private var countyLineBuffers = ObjectMetalBuffers(GeographyType.countyLines, 0.75)
    private var hwBuffers = ObjectMetalBuffers(GeographyType.highways, zoomToHideMiscFeatures)
    private let hwExtBuffers = ObjectMetalBuffers(GeographyType.highwaysExtended, 3.00)
    private let lakeBuffers = ObjectMetalBuffers(GeographyType.lakes, zoomToHideMiscFeatures)
    private let stiBuffers = ObjectMetalBuffers(PolygonType.STI, zoomToHideMiscFeatures)
    private let wbBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB, zoomToHideMiscFeatures)
    private let wbGustsBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_GUSTS, zoomToHideMiscFeatures)
    private let mpdBuffers = ObjectMetalBuffers(PolygonType.MPD)
    private let hiBuffers = ObjectMetalBuffers(PolygonType.HI, zoomToHideMiscFeatures)
    private let tvsBuffers = ObjectMetalBuffers(PolygonType.TVS, zoomToHideMiscFeatures)
    private let warningTstBuffers = ObjectMetalBuffers(PolygonType.TST)
    private let warningTorBuffers = ObjectMetalBuffers(PolygonType.TOR)
    private let warningFfwBuffers = ObjectMetalBuffers(PolygonType.FFW)
    private let warningSmwBuffers = ObjectMetalBuffers(PolygonType.SMW)
    private let warningSqwBuffers = ObjectMetalBuffers(PolygonType.SQW)
    private let warningDswBuffers = ObjectMetalBuffers(PolygonType.DSW)
    private let warningSpsBuffers = ObjectMetalBuffers(PolygonType.SPS)
    private let watchBuffers = ObjectMetalBuffers(PolygonType.WATCH)
    private let watchTornadoBuffers = ObjectMetalBuffers(PolygonType.WATCH_TORNADO)
    private let mcdBuffers = ObjectMetalBuffers(PolygonType.MCD)
    private let swoBuffers = ObjectMetalBuffers(PolygonType.SWO)
    private let locdotBuffers = ObjectMetalBuffers(PolygonType.LOCDOT)
    private let locCircleBuffers = ObjectMetalBuffers(PolygonType.LOCDOT_CIRCLE)
    private let wbCircleBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_CIRCLE, zoomToHideMiscFeatures)
    private let spotterBuffers = ObjectMetalBuffers(PolygonType.SPOTTER, zoomToHideMiscFeatures)
    private var wpcFrontBuffersList = [ObjectMetalBuffers]()
    private var wpcFrontPaints = [Int]()
    private var colorSwo = [Int]()
    var gpsLocation = LatLon(0.0, 0.0)
    private var geographicBuffers = [ObjectMetalBuffers]()
    private var ridPrefixGlobal = "0"
    private var indexString = "0"
    var radarBuffers = ObjectMetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    private var totalBins = 0
    private let timeButton: ToolbarIcon
    private let productButton: ToolbarIcon
    private var radarLayers = [ObjectMetalBuffers]()
    var gpsLatLonTransformed: (Float, Float) = (0.0, 0.0)
    private let paneNumber: Int
    let numberOfPanes: Int
    var wxMetalTextObject: WXMetalTextObject
    private var renderFn: ((Int) -> Void)?
    private var isAnimating = false
    var fileStorage = FileStorage()
    // need a copy of this list here in addition to WXGLNexrad
    var radarProductList = [
        "N0Q: Base Reflectivity",
        "N0U: Base Velocity",
        "L2REF: Level 2 Reflectivity",
        "L2VEL: Level 2 Velocity",
        "EET: Enhanced Echo Tops",
        "DVL: Vertically Integrated Liquid",
        "N0X: Differential Reflectivity",
        "N0C: Correlation Coefficient",
        "N0K: Specific Differential Phase",
        "H0C: Hydrometer Classification",
        "DSP: Digital Storm Total Precipitation",
        "DAA: Digital Accumulation Array",
        "N0S: Storm Relative Mean Velocity",
        "NSW: Base Spectrum Width",
        "NCR: Composite Reflectivity 124nm",
        "NCZ: Composite Reflectivity 248nm"
    ]

    init(_ device: MTLDevice,
         _ wxMetalTextObject: WXMetalTextObject,
         _ timeButton: ToolbarIcon,
         _ productButton: ToolbarIcon,
         paneNumber: Int,
         _ numberOfPanes: Int
    ) {
        self.wxMetalTextObject = wxMetalTextObject
        self.device = device
        self.timeButton = timeButton
        self.productButton = productButton
        self.paneNumber = paneNumber
        indexString = String(paneNumber)
        self.numberOfPanes = numberOfPanes
        radarBuffers.fileStorage = fileStorage
        readPreferences()
        regenerateProductList()
        radarLayers = [radarBuffers]
        geographicBuffers = []
        [countyLineBuffers, stateLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geoType.display {
                geographicBuffers.append($0)
            }
        }
        [countyLineBuffers, stateLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geoType.display {
                radarLayers.append($0)
            }
        }
        [
            warningTstBuffers,
            warningTorBuffers,
            warningFfwBuffers,
            warningSmwBuffers,
            warningSqwBuffers,
            warningDswBuffers,
            warningSpsBuffers,
            mcdBuffers,
            watchBuffers,
            watchTornadoBuffers,
            mpdBuffers
            ].forEach {
            if $0.type.display {
                radarLayers.append($0)
            }
        }
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {
            radarLayers.append(locdotBuffers)
        }
        if PolygonType.SPOTTER.display {
            radarLayers.append(spotterBuffers)
        }
        if RadarPreferences.locdotFollowsGps {
            radarLayers.append(locCircleBuffers)
        }
        if PolygonType.WIND_BARB.display {
            radarLayers += [wbCircleBuffers, wbGustsBuffers, wbBuffers]
        }
        if PolygonType.SWO.display {
            radarLayers.append(swoBuffers)
        }
        radarLayers += [stiBuffers, hiBuffers, tvsBuffers]
        if numberOfPanes == 1 || !RadarPreferences.dualpaneshareposn {
            loadGeometry()
        }
    }

    func render(
        commandQueue: MTLCommandQueue,
        pipelineState: MTLRenderPipelineState,
        drawable: CAMetalDrawable,
        parentModelViewMatrix: float4x4,
        projectionMatrix: float4x4
        // clearColor: MTLClearColor?
    ) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: Double(Color.red(radarBuffers.bgColor)) / 255.0,
            green: Double(Color.green(radarBuffers.bgColor)) / 255.0,
            blue: Double(Color.blue(radarBuffers.bgColor)) / 255.0,
            alpha: 1.0
        )
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        // For now cull mode is used instead of depth buffer
        renderEncoder!.setCullMode(MTLCullMode.front)
        renderEncoder!.setRenderPipelineState(pipelineState)
        var projectionMatrixRef = projectionMatrix
        radarLayers.enumerated().forEach { index, vbuffer in
            if vbuffer.vertexCount > 0 {
                if vbuffer.scaleCutOff < zoom {
                    if !(vbuffer.honorDisplayHold && displayHold) || !vbuffer.honorDisplayHold {
                        renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                        var nodeModelMatrix = modelMatrix()
                        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
                        let uniformBuffer = device.makeBuffer(
                            length: MemoryLayout<Float>.size * float4x4.numberOfElements() * 2,
                            options: []
                        )
                        let bufferPointer = uniformBuffer?.contents()
                        memcpy(
                            bufferPointer,
                            &nodeModelMatrix,
                            MemoryLayout<Float>.size * float4x4.numberOfElements()
                        )
                        memcpy(
                            bufferPointer! + MemoryLayout<Float>.size * float4x4.numberOfElements(),
                            &projectionMatrixRef,
                            MemoryLayout<Float>.size * float4x4.numberOfElements()
                        )
                        renderEncoder!.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
                        renderEncoder!.drawPrimitives(type: vbuffer.shape, vertexStart: 0, vertexCount: vbuffer.vertexCount)
                    }
                }
            }
        }
        if RadarPreferences.radarShowWpcFronts {
            if zoom < WXMetalRender.zoomToHideMiscFeatures {
                wpcFrontBuffersList.enumerated().forEach { index, vbuffer in
                    if vbuffer.vertexCount > 0 {
                        if vbuffer.scaleCutOff < zoom {
                            if !(vbuffer.honorDisplayHold && displayHold) || !vbuffer.honorDisplayHold {
                                renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                                var nodeModelMatrix = modelMatrix()
                                nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
                                let uniformBuffer = device.makeBuffer(
                                    length: MemoryLayout<Float>.size * float4x4.numberOfElements() * 2,
                                    options: []
                                )
                                let bufferPointer = uniformBuffer?.contents()
                                memcpy(
                                    bufferPointer,
                                    &nodeModelMatrix,
                                    MemoryLayout<Float>.size * float4x4.numberOfElements()
                                )
                                memcpy(
                                    bufferPointer! + MemoryLayout<Float>.size * float4x4.numberOfElements(),
                                    &projectionMatrixRef,
                                    MemoryLayout<Float>.size * float4x4.numberOfElements()
                                )
                                renderEncoder!.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
                                renderEncoder!.drawPrimitives(type: .line, vertexStart: 0, vertexCount: vbuffer.vertexCount)
                            }
                        }
                    }
                }
            }
        }
        renderEncoder!.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }

    func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(0.0, y: 0.0, z: 0.0)
        matrix.rotateAroundX(0.0, y: 0.0, z: 0.0)
        matrix.scale(1.0, y: 1.0, z: 1.0)
        return matrix
    }

    func constructAlertPolygonsByType(_ type: PolygonTypeGeneric) {
        switch type {
        case .TOR:
            if warningTorBuffers.type.display {
                constructGenericLines(warningTorBuffers)
                warningTorBuffers.generateMtlBuffer(device)
            }
        case .TST:
            if warningTstBuffers.type.display {
                constructGenericLines(warningTstBuffers)
                warningTstBuffers.generateMtlBuffer(device)
            }
        case .FFW:
            if warningFfwBuffers.type.display {
                constructGenericLines(warningFfwBuffers)
                warningFfwBuffers.generateMtlBuffer(device)
            }
        default:
            break
        }

    }
    
    func constructAlertPolygons() {
        [
            warningSmwBuffers,
            warningSqwBuffers,
            warningDswBuffers,
            warningSpsBuffers
            ].forEach {
                if $0.type.display {
                    constructGenericLines($0)
                    $0.generateMtlBuffer(device)
                }
        }
        if renderFn != nil {
            renderFn!(paneNumber)
        }
    }

    func constructWatchPolygonsByType(_ type: PolygonEnum) {
        if type == PolygonEnum.SPCMCD {
            if mcdBuffers.type.display {
                constructGenericLines(mcdBuffers)
                mcdBuffers.generateMtlBuffer(device)
            }
        } else if type == PolygonEnum.WPCMPD {
            if mpdBuffers.type.display {
                constructGenericLines(mpdBuffers)
                mpdBuffers.generateMtlBuffer(device)
            }
        } else if type == PolygonEnum.SPCWAT {
            if watchBuffers.type.display {
                constructGenericLines(watchBuffers)
                watchBuffers.generateMtlBuffer(device)
                
                constructGenericLines(watchTornadoBuffers)
                watchTornadoBuffers.generateMtlBuffer(device)
            }
        }
        if renderFn != nil {
            renderFn!(paneNumber)
        }
    }

    func constructGenericLines(_ buffers: ObjectMetalBuffers) {
        var list: [Double]
        switch buffers.typeEnum {
        case .SPCMCD, .WPCMPD, .SPCWAT, .SPCWAT_TORNADO:
            list = UtilityWatch.add(projectionNumbers, buffers.typeEnum)
        case .TST, .TOR, .FFW:
            list = WXGLPolygonWarnings.add(projectionNumbers, buffers.typeEnum)
        case .SMW:
            list = WXGLPolygonWarnings.addGeneric(projectionNumbers, ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!)
        case .SQW:
            list = WXGLPolygonWarnings.addGeneric(projectionNumbers, ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!)
        case .DSW:
            list = WXGLPolygonWarnings.addGeneric(projectionNumbers, ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!)
        case .SPS:
            list = WXGLPolygonWarnings.addGeneric(projectionNumbers, ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!)
        case .STI:
            WXGLNexradLevel3StormInfo.decode(projectionNumbers, fileStorage)
            list = fileStorage.stiList
        default:
            list = [Double]()
        }
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        stride(from: 0, to: list.count, by: 4).forEach { vList in
            buffers.putFloat(list[vList])
            buffers.putFloat(list[vList+1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(list[vList+2])
            buffers.putFloat(list[vList+3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
        }
        buffers.count = list.count
    }

    func constructGenericGeographic(_ buffers: ObjectMetalBuffers) {
        buffers.setCount(buffers.geoType.count)
        buffers.initialize(4 * buffers.count, buffers.geoType.color)
        let colors = buffers.getColorArrayInFloat()
        JNI_GenMercato(
            MemoryBuffer.getPointer(buffers.geoType.relativeBuffer.array),
            MemoryBuffer.getPointer(buffers.floatBuffer.array),
            projectionNumbers.xFloat,
            projectionNumbers.yFloat,
            projectionNumbers.xCenterFloat,
            projectionNumbers.yCenterFloat,
            projectionNumbers.oneDegreeScaleFactorFloat,
            Int32(buffers.count)
        )
        buffers.setToPositionZero()
        var i = 0
        // TODO use stride
        (0..<(buffers.count / 2)).forEach { _ in
            buffers.metalBuffer[i] = buffers.floatBuffer.getCGFloatNative()
            buffers.metalBuffer[i + 1] = buffers.floatBuffer.getCGFloatNative()
            buffers.metalBuffer[i + 2] = colors[0]
            buffers.metalBuffer[i + 3] = colors[1]
            buffers.metalBuffer[i + 4] = colors[2]
            i += 5
        }
    }

    func loadGeometry() {
        projectionNumbers = ProjectionNumbers(rid, .wxOgl)
        geographicBuffers.forEach {
            constructGenericGeographic($0)
            $0.generateMtlBuffer(device)
        }
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {
            constructLocationDot()
        }
        setZoom()
        if renderFn != nil {
            renderFn!(paneNumber)
        }
    }

    func writePreferences() {
        let numberOfPanesString = to.String(numberOfPanes)
        let index = String(paneNumber)
        Utility.writePref(radarType + numberOfPanesString + "_ZOOM" + index, zoom)
        Utility.writePref(radarType + numberOfPanesString + "_X" + index, xPos)
        Utility.writePref(radarType + numberOfPanesString + "_Y" + index, yPos)
        Utility.writePref(radarType + numberOfPanesString + "_RID" + index, rid)
        Utility.writePref(radarType + numberOfPanesString + "_PROD" + index, product)
        Utility.writePref(radarType + numberOfPanesString + "_TILT" + index, tiltInt)
    }

    // This method is called between the transition from single to dual pane
    // It saves the current specifics about the single pane radar save the product itself
    func writePreferencesForSingleToDualPaneTransition() {
        let numberOfPanes = "2"
        ["0", "1"].forEach {
            Utility.writePref(radarType + numberOfPanes + "_ZOOM" + $0, zoom)
            Utility.writePref(radarType + numberOfPanes + "_X" + $0, xPos)
            Utility.writePref(radarType + numberOfPanes + "_Y" + $0, yPos)
            Utility.writePref(radarType + numberOfPanes + "_RID" + $0, rid)
            Utility.writePref(radarType + numberOfPanes + "_TILT" + $0, tiltInt)
        }
    }

    func readPreferences() {
        let numberOfPanesString = to.String(numberOfPanes)
        let index = String(paneNumber)
        if RadarPreferences.wxoglRememberLocation {
            zoom = Utility.readPref(radarType + numberOfPanesString + "_ZOOM" + index, 1.0)
            xPos = Utility.readPref(radarType + numberOfPanesString + "_X" + index, 0.0)
            yPos = Utility.readPref(radarType + numberOfPanesString + "_Y" + index, 0.0)
            product = Utility.readPref(radarType + numberOfPanesString + "_PROD" + index, initialRadarProducts[paneNumber])
            rid = Utility.readPref(radarType + numberOfPanesString + "_RID" + index, Location.rid)
            tiltInt = Utility.readPref(radarType + numberOfPanesString + "_TILT" + index, 0)
        } else {
            rid = Location.rid
            product = Utility.readPref(radarType + numberOfPanesString + "_PROD" + index, initialRadarProducts[paneNumber])
        }
    }

    func cleanup() {
        radarLayers = []
        geographicBuffers = []
        stateLineBuffers = ObjectMetalBuffers(GeographyType.stateLines, 0.0)
        countyLineBuffers = ObjectMetalBuffers(GeographyType.countyLines, 0.75)
        hwBuffers = ObjectMetalBuffers(GeographyType.highways, 0.45)
        radarBuffers.rd.radarBuffers = nil
        radarBuffers.rd.radialStartAngle = MemoryBuffer()
        radarBuffers.rd.binWord = MemoryBuffer()
        radarBuffers.rd = WXMetalNexradLevelData()
        radarBuffers.metalBuffer = []
        radarBuffers = ObjectMetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    }
    // TODO rename to radarSite
    var rid: String {
        get { ridStr }
        set {
            ridStr = newValue
            checkIfTdwr()
        }
    }

    var product: String {
        get { radarProduct }
        set {
            radarProduct = newValue
            checkIfTdwr()
        }
    }

    func checkIfTdwr() {
        let ridIsTdwr = WXGLNexrad.isRidTdwr(rid)
        if product.hasPrefix("TV") || product == "TZL" || product.hasPrefix("TZ") {
            isTdwr = true
        } else {
            isTdwr = false
        }
        if (product.matches(regexp: "N[0-3]Q") || product == "L2REF") && ridIsTdwr {
            radarProduct = "TZL"
            isTdwr = true
        }
        if (product == "TZL" || product.hasPrefix("TR") || product.hasPrefix("TZ")) && !ridIsTdwr {
            radarProduct = "N0Q"
            isTdwr = false
        }
        if (product.matches(regexp: "N[0-3]U") || product == "L2VEL") && ridIsTdwr {
            radarProduct = "TV0"
            isTdwr = true
        }
        if product.hasPrefix("TV") && !ridIsTdwr {
            radarProduct = "N0U"
            isTdwr = false
        }
    }

    func getRadar(_ url: String, _ additionalText: String = "") {
        _ = FutureVoid({ self.downloadRadar(url) }, { self.updateRadar(additionalText) })
        
        if url == "" { // not animating
            [stiBuffers, tvsBuffers, hiBuffers].forEach {
                if $0.type.display {
                    let item = $0
                    _ = FutureVoid({ self.constructLevel3TextProduct(item.typeEnum) }, {})
                }
            }
            if PolygonType.SPOTTER.display || PolygonType.SPOTTER_LABELS.display {
                _ = FutureVoid(constructSpotters, {})
            }
            if PolygonType.OBS.display || PolygonType.WIND_BARB.display {
                _ = FutureVoid(downloadObs, renderIt)
            }
//            if PolygonType.WIND_BARB.display {
//                _ = FutureVoid(constructWBLines, {})
//            }
            if PolygonType.SWO.display {
                _ = FutureVoid(UtilitySwoD1.get, constructSwoLines)
                
            }
            if RadarPreferences.radarShowWpcFronts {
                _ = FutureVoid(UtilityWpcFronts.get, constructWpcFronts)
            }
        }
    }
    
    private func downloadObs() {
        if PolygonType.OBS.display || PolygonType.WIND_BARB.display {
            UtilityMetar.getStateMetarArrayForWXOGL(rid, fileStorage)
        }
        if PolygonType.WIND_BARB.display {
            constructWBLines()
        }
    }
    
    private func downloadRadar(_ url: String) {
        if url == "" {
            ridPrefixGlobal = WXGLDownload.getRadarFile(url, rid, product, indexString, isTdwr, fileStorage)
            if !radarProduct.contains("L2") {
                radarBuffers.fileName = "nids" + indexString
            } else {
                radarBuffers.fileName = "l2" + indexString
            }
        } else {
            // url will contain "nexrad_anim" with old method
            if url.contains("nexrad_anim") {
                isAnimating = true
                radarBuffers.fileName = url
            } else {
                isAnimating = true
                let index = to.Int(url)
                fileStorage.memoryBuffer = fileStorage.animationMemoryBuffer[index]
            }
        }
    }
    
    private func renderIt() {
        if renderFn != nil {
            renderFn!(paneNumber)
        }
        if !isAnimating &&  PolygonType.OBS.display {
            wxMetalTextObject.removeTextLabels()
            wxMetalTextObject.addTextLabels()
        }
    }
    
    private func updateRadar(_ additionalText: String) {
        constructPolygons()
        showTimeToolbar(additionalText, isAnimating)
        showProductText(product)
        if renderFn != nil {
            renderFn!(paneNumber)
        }
        if !isAnimating {
            wxMetalTextObject.removeTextLabels()
            wxMetalTextObject.addTextLabels()
        }
    }

    func setRenderFunction(_ fn: @escaping (Int) -> Void) {
        renderFn = fn
    }

    func demandRender() {
        if renderFn != nil {
            renderFn!(paneNumber)
        }
    }

    func constructPolygons() {
        radarBuffers.metalBuffer = []
        radarBuffers.rd = WXMetalNexradLevelData(radarProduct, radarBuffers, indexString, fileStorage)
        radarBuffers.rd.decode()
        radarBuffers.initialize()
        totalBins = radarBuffers.generateRadials()
        radarBuffers.setToPositionZero()
        radarBuffers.setCount()
        radarBuffers.generateMtlBuffer(device)
    }

    func updateTimeToolbar() {
        showTimeToolbar("", false)
    }

    func showTimeToolbar(_ additionalText: String, _ isAnimating: Bool) {
        let timeString = fileStorage.radarInfo.split(" ")
        if timeString.count > 1 {
            var replaceToken = "Mode:"
            if product.hasPrefix("L2") {
                replaceToken = "Product:"
            }
            let text = timeString[1].replace(GlobalVariables.newline + replaceToken, "") + additionalText
            timeButton.title = text
            if UtilityTime.isRadarTimeOld(text) && !isAnimating {
                timeButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
            } else {
                timeButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            }
        } else {
            timeButton.title = ""
        }
    }

    func showProductText(_ product: String) {
        productButton.title = product
    }

    // TODO rename vars
    func constructLocationDot() {
        var locmarkerAl = [Double]() // locmarkerAl = []
        locdotBuffers.lenInit = PolygonType.LOCDOT.size
        if PolygonType.LOCDOT.display { locmarkerAl = UtilityLocation.getLatLonAsDouble() }
        if RadarPreferences.locdotFollowsGps {
            locmarkerAl.append(gpsLocation.lat)
            locmarkerAl.append(gpsLocation.lon)
        }
        // get even and odd values and put in separate lists
        locdotBuffers.latList = locmarkerAl.enumerated().filter { index, _ in index & 1 == 0 }.map { _, value in Double(value) }
        locdotBuffers.lonList = locmarkerAl.enumerated().filter { index, _ in index & 1 != 0 }.map { _, value in Double(value) }
        locdotBuffers.triangleCount = 24
        locdotBuffers.count = locmarkerAl.count
        locdotBuffers.lenInit = scaleLengthLocationDot(locdotBuffers.type.size)
        constructTriangles(locdotBuffers)
        locCircleBuffers.triangleCount = 24
        locCircleBuffers.initialize(32 * locCircleBuffers.triangleCount, PolygonType.LOCDOT.color)
        if RadarPreferences.locdotFollowsGps {
            let gpsCoords = UtilityCanvasProjection.computeMercatorNumbers(gpsLocation.lat, gpsLocation.lon, projectionNumbers)
            gpsLatLonTransformed = (Float(-gpsCoords[0]), Float(gpsCoords[1]))
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXMetalPerf.genCircleLocationDot(locCircleBuffers, projectionNumbers, gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        locdotBuffers.generateMtlBuffer(device)
        locCircleBuffers.generateMtlBuffer(device)
        if renderFn != nil {
            setZoom()
            renderFn!(paneNumber)
        }
    }

    func constructTriangles(_ buffers: ObjectMetalBuffers) {
        buffers.setCount(buffers.latList.count)
        switch buffers.typeEnum {
        case .LOCDOT:
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        case .SPOTTER:
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        default:
            buffers.initialize(4 * 6 * buffers.count, buffers.type.color)
        }
        buffers.lenInit = scaleLengthLocationDot(buffers.lenInit)
        buffers.draw(projectionNumbers)
    }

    func constructGenericLinesShort(_ buffers: ObjectMetalBuffers, _ list: [Double]) {
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        stride(from: 0, to: list.count, by: 4).forEach { vList in
            buffers.putFloat(list[vList])
            buffers.putFloat(list[vList+1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(list[vList+2])
            buffers.putFloat(list[vList+3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
        }
        buffers.count = list.count
    }

    func constructWBLines() {
        constructGenericLinesShort(wbBuffers, WXGLNexradLevel3WindBarbs.decodeAndPlot(projectionNumbers, isGust: false, fileStorage))
        constructWBLinesGusts()
        constructWBCircle()
        wbBuffers.generateMtlBuffer(device)
    }

    func constructWBLinesGusts() {
        constructGenericLinesShort(wbGustsBuffers, WXGLNexradLevel3WindBarbs.decodeAndPlot(projectionNumbers, isGust: true, fileStorage))
        wbGustsBuffers.generateMtlBuffer(device)
    }

    func constructLevel3TextProduct(_ type: PolygonEnum) {
        switch type {
        case .HI:
            constructHi()
        case .TVS:
            constructTvs()
        case .STI:
            constructStiLines()
        default:
            break
        }
    }

    func constructStiLines() {
        WXGLNexradLevel3StormInfo.decode(projectionNumbers, fileStorage)
        constructGenericLinesShort(stiBuffers, fileStorage.stiList)
        stiBuffers.generateMtlBuffer(device)
    }

    // TODO the 2 methods below can go generic
    func constructTvs() {
        tvsBuffers.lenInit = tvsBuffers.type.size
        tvsBuffers.triangleCount = 1
        tvsBuffers.metalBuffer = []
        tvsBuffers.vertexCount = 0
        WXGLNexradLevel3TVS.decode(projectionNumbers, fileStorage)
        tvsBuffers.setXYList(fileStorage.tvsData)
        constructTriangles(tvsBuffers)
        tvsBuffers.generateMtlBuffer(device)
    }

    func constructHi() {
        hiBuffers.lenInit = hiBuffers.type.size
        hiBuffers.triangleCount = 1
        hiBuffers.metalBuffer = []
        hiBuffers.vertexCount = 0
        WXGLNexradLevel3HailIndex.decode(projectionNumbers, fileStorage)
        hiBuffers.setXYList(fileStorage.hiData)
        constructTriangles(hiBuffers)
        hiBuffers.generateMtlBuffer(device)
    }

    func constructWBCircle() {
        wbCircleBuffers.lenInit = PolygonType.WIND_BARB.size
        wbCircleBuffers.latList = fileStorage.obsArrX
        wbCircleBuffers.lonList = fileStorage.obsArrY
        wbCircleBuffers.colorIntArray = fileStorage.obsArrAviationColor
        wbCircleBuffers.setCount(wbCircleBuffers.latList.count)
        wbCircleBuffers.triangleCount = 6
        wbCircleBuffers.initialize(24 * wbCircleBuffers.count * wbCircleBuffers.triangleCount)
        wbCircleBuffers.lenInit = scaleLengthLocationDot(wbCircleBuffers.lenInit) // was scaleLength
        ObjectMetalBuffers.redrawCircleWithColor(wbCircleBuffers, projectionNumbers)
        wbCircleBuffers.generateMtlBuffer(device)
    }

    func constructSpotters() {
        spotterBuffers.lenInit = PolygonType.SPOTTER.size
        spotterBuffers.triangleCount = 6
        _ = UtilitySpotter.get()
        spotterBuffers.latList = UtilitySpotter.lat
        spotterBuffers.lonList = UtilitySpotter.lon
        constructTriangles(spotterBuffers)
        spotterBuffers.lenInit = scaleLengthLocationDot(spotterBuffers.type.size)
        spotterBuffers.draw(projectionNumbers)
        spotterBuffers.generateMtlBuffer(device)
    }

    func constructWpcFronts() {
        wpcFrontBuffersList = []
        wpcFrontPaints = []
        UtilityWpcFronts.fronts.forEach { _ in
            let buff = ObjectMetalBuffers()
            buff.initialize(2, Color.MAGENTA)
            wpcFrontBuffersList.append(buff)
        }
        UtilityWpcFronts.fronts.indices.forEach { z in
            let front = UtilityWpcFronts.fronts[z]
            switch front.type {
            case FrontTypeEnum.COLD:
                wpcFrontPaints.append(wXColor.colorsToInt(0, 127, 255))
            case FrontTypeEnum.WARM:
                wpcFrontPaints.append(wXColor.colorsToInt(255, 0, 0))
            case FrontTypeEnum.STNRY:
                wpcFrontPaints.append(wXColor.colorsToInt(0, 127, 255))
            case FrontTypeEnum.STNRY_WARM:
                wpcFrontPaints.append(wXColor.colorsToInt(255, 0, 0))
            case FrontTypeEnum.OCFNT:
                wpcFrontPaints.append(wXColor.colorsToInt(255, 0, 255))
            case FrontTypeEnum.TROF:
                wpcFrontPaints.append(wXColor.colorsToInt(254, 216, 177))
            }
            for j in stride(from: 0, to: front.coordinates.count - 1, by: 2) {
                var tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(front.coordinates[j].lat, front.coordinates[j].lon, projectionNumbers)
                wpcFrontBuffersList[z].putFloat(tmpCoords[0])
                wpcFrontBuffersList[z].putFloat(tmpCoords[1] * -1.0)
                wpcFrontBuffersList[z].putColor(Color.red(wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.green(wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.blue(wpcFrontPaints[z]))
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(front.coordinates[j + 1].lat, front.coordinates[j + 1].lon, projectionNumbers)
                wpcFrontBuffersList[z].putFloat(tmpCoords[0])
                wpcFrontBuffersList[z].putFloat(tmpCoords[1] * -1.0)
                wpcFrontBuffersList[z].putColor(Color.red(wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.green(wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.blue(wpcFrontPaints[z]))
            }
            wpcFrontBuffersList[z].count = Int(Double(wpcFrontBuffersList[z].metalBuffer.count) * 0.4)
            wpcFrontBuffersList[z].generateMtlBuffer(device)
        }
    }

    // TODO rename vars
    func constructSwoLines() {
        swoBuffers.initialize(2, Color.MAGENTA)
        colorSwo = []
        colorSwo.append(Color.MAGENTA)
        colorSwo.append(Color.RED)
        colorSwo.append(wXColor.colorsToInt(255, 140, 0))
        colorSwo.append(Color.YELLOW)
        colorSwo.append(wXColor.colorsToInt(0, 100, 0))
        var fSize = 0
        (0...4).forEach { z in
            if let flArr = UtilitySwoD1.hashSwo[z] {
                fSize += flArr.count
            }
        }
        swoBuffers.metalBuffer = []
        (0...4).forEach { z in
            if let flArr = UtilitySwoD1.hashSwo[z] {
                stride(from: 0, to: flArr.count - 1, by: 4).forEach { j in
                    var tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(Double(flArr[j]), Double(flArr[j+1]) * -1.0, projectionNumbers)
                    swoBuffers.putFloat(tmpCoords[0])
                    swoBuffers.putFloat(tmpCoords[1] * -1.0)
                    swoBuffers.putColor(Color.red(colorSwo[z]))
                    swoBuffers.putColor(Color.green(colorSwo[z]))
                    swoBuffers.putColor(Color.blue(colorSwo[z]))
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(Double(flArr[j+2]), Double(flArr[j+3]) * -1.0, projectionNumbers)
                    swoBuffers.putFloat(tmpCoords[0])
                    swoBuffers.putFloat(tmpCoords[1] * -1.0)
                    swoBuffers.putColor(Color.red(colorSwo[z]))
                    swoBuffers.putColor(Color.green(colorSwo[z]))
                    swoBuffers.putColor(Color.blue(colorSwo[z]))
                }
            }
        }
        swoBuffers.count = Int(Double(swoBuffers.metalBuffer.count) * 0.4)
        swoBuffers.generateMtlBuffer(device)
    }

    func scaleLengthLocationDot(_ currentLength: Double) -> Double {
        (currentLength / Double(zoom)) * 2.0
    }

    func setZoom() {
        [locdotBuffers, wbCircleBuffers, spotterBuffers, hiBuffers, tvsBuffers].forEach {
            $0.lenInit = scaleLengthLocationDot($0.type.size)
            $0.draw(projectionNumbers)
            $0.generateMtlBuffer(device)
        }
        if RadarPreferences.locdotFollowsGps {
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXMetalPerf.genCircleLocationDot(locCircleBuffers, projectionNumbers, gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        if renderFn != nil {
            renderFn!(paneNumber)
        }
    }

    func resetRid(_ rid: String, isHomeScreen: Bool = false) {
        self.rid = rid
        xPos = 0.0
        yPos = 0.0
        let prefFactor = (Float(RadarPreferences.wxoglSize) / 10.0)
        zoom = 1.0 / prefFactor
        if UtilityUI.isLandscape() {
            zoom = 0.60 / prefFactor
        }
        #if targetEnvironment(macCatalyst)
        zoom = 0.40 / prefFactor
        if isHomeScreen {
            zoom = 0.70 / prefFactor
        }
        #endif
        loadGeometry()
    }

    func resetRidAndGet(_ rid: String, isHomeScreen: Bool = false) {
        self.rid = rid
        xPos = 0.0
        yPos = 0.0
        let prefFactor = (Float(RadarPreferences.wxoglSize) / 10.0)
        zoom = 1.0 / prefFactor
        if UtilityUI.isLandscape() {
            zoom = 0.60 / prefFactor
        }
        #if targetEnvironment(macCatalyst)
        zoom = 0.40 / prefFactor
        if isHomeScreen {
            zoom = 0.70 / prefFactor
        }
        #endif
        loadGeometry()
        getRadar("")
    }

    func changeProduct(_ product: String) {
        self.product = product
        getRadar("")
        productButton.title = product
    }

    func getGpsString() -> String {
        let truncateAmount = 7
        return gpsLocation.latString.truncate(truncateAmount) + ", -" + gpsLocation.lonString.truncate(truncateAmount)
    }

    var tilt: Int {
        get { tiltInt }
        set {
            tiltInt = newValue
            let middleValue = product[product.index(after: product.startIndex)]
            if middleValue == "0" || middleValue == "1" || middleValue == "2" || middleValue == "3" {
                let firstValue = product[product.startIndex]
                let lastValue = product[product.index(before: product.endIndex)]
                var newProduct = ""
                newProduct.append(firstValue)
                newProduct.append(String(tiltInt))
                newProduct.append(lastValue)
                product = newProduct
                regenerateProductList()
            }
            if product.hasPrefix("TV") || product.hasPrefix("TZ") {
                let firstValue = product[product.startIndex]
                let middleValue = product[product.index(product.startIndex, offsetBy: 1)]
                var newProduct = ""
                newProduct.append(firstValue)
                newProduct.append(middleValue)
                newProduct.append(String(tiltInt))
                product = newProduct
                regenerateProductList()
            }
        }
    }

    func regenerateProductList() {
        radarProductList.enumerated().forEach { index, productString in
            let firstValue = productString[productString.startIndex]
            let middleValue = productString[productString.index(after: productString.startIndex)]
            if firstValue != "L"
                && (middleValue == "0" || middleValue == "1" || middleValue == "2" || middleValue == "3") {
                let firstValue = productString[product.startIndex]
                let afterTiltIndex = productString.index(productString.startIndex, offsetBy: 2)
                let endIndex = productString.index(before: productString.endIndex)
                let stringEnd = productString[afterTiltIndex...endIndex]
                var newProduct = ""
                newProduct.append(firstValue)
                newProduct += String(tiltInt) + stringEnd
                radarProductList[index] = newProduct
            }
        }
    }
}
