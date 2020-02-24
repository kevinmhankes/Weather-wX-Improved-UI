/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import QuartzCore
import Metal
import simd
import UIKit

class WXMetalRender {

    private let device: MTLDevice
    private var time: CFTimeInterval = 0.0
    private var positionX: Float = 0.0
    private var positionY: Float = 0.0
    private var positionZ: Float = 0.0
    private var rotationX: Float = 0.0
    private var rotationY: Float = 0.0
    private var rotationZ: Float = 0.0
    private var scale: Float = 1.0
    var pn = ProjectionNumbers()
    private var ridStr = "DTX"
    var rdDownload = WXGLDownload()
    private var radarProduct = "N0Q"
    private var tiltInt = 0
    private var initialRadarProducts = ["N0Q", "N0U", "EET", "DVL"]
    var xPos: Float = 0.0
    var yPos: Float = 0.0
    var zPos: Float = -7.0
    var zoom: Float = 1.0
    var lastPanLocation: CGPoint!
    var tdwr = false
    #if !targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.5
    #endif
    #if targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.2
    #endif
    var displayHold: Bool = false
    private var stateLineBuffers = ObjectMetalBuffers(GeographyType.stateLines, 0.0)
    private var countyLineBuffers = ObjectMetalBuffers(GeographyType.countyLines, 0.75)
    private var hwBuffers = ObjectMetalBuffers(GeographyType.highways, zoomToHideMiscFeatures)
    private var hwExtBuffers = ObjectMetalBuffers(GeographyType.highwaysExtended, 3.00)
    private var lakeBuffers = ObjectMetalBuffers(GeographyType.lakes, zoomToHideMiscFeatures)
    private var stiBuffers = ObjectMetalBuffers(PolygonType.STI, zoomToHideMiscFeatures)
    private var wbBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB, zoomToHideMiscFeatures)
    private var wbGustsBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_GUSTS, zoomToHideMiscFeatures)
    private var mpdBuffers = ObjectMetalBuffers(PolygonType.MPD)
    private var hiBuffers = ObjectMetalBuffers(PolygonType.HI, zoomToHideMiscFeatures)
    private var tvsBuffers = ObjectMetalBuffers(PolygonType.TVS, zoomToHideMiscFeatures)
    private var warningTstBuffers = ObjectMetalBuffers(PolygonType.TST)
    private var warningTorBuffers = ObjectMetalBuffers(PolygonType.TOR)
    private var warningFfwBuffers = ObjectMetalBuffers(PolygonType.FFW)
    private var warningSmwBuffers = ObjectMetalBuffers(PolygonType.SMW)
    private var warningSqwBuffers = ObjectMetalBuffers(PolygonType.SQW)
    private var warningDswBuffers = ObjectMetalBuffers(PolygonType.DSW)
    private var warningSpsBuffers = ObjectMetalBuffers(PolygonType.SPS)
    private var watchBuffers = ObjectMetalBuffers(PolygonType.WATCH)
    private var watchTornadoBuffers = ObjectMetalBuffers(PolygonType.WATCH_TORNADO)
    private var mcdBuffers = ObjectMetalBuffers(PolygonType.MCD)
    private var swoBuffers = ObjectMetalBuffers(PolygonType.SWO)
    private var locdotBuffers = ObjectMetalBuffers(PolygonType.LOCDOT)
    private var locCircleBuffers = ObjectMetalBuffers(PolygonType.LOCDOT_CIRCLE)
    private var wbCircleBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_CIRCLE, zoomToHideMiscFeatures)
    private var spotterBuffers = ObjectMetalBuffers(PolygonType.SPOTTER, zoomToHideMiscFeatures)
    private var wpcFrontBuffersList = [ObjectMetalBuffers]()
    private var wpcFrontPaints = [Int]()
    private var colorSwo = [Int]()
    private var fFfw = [Double]()
    private var fTst = [Double]()
    private var fTor = [Double]()
    private var fMpd = [Double]()
    private var fWatAll = [Double]()
    private var fWatMcd = [Double]()
    private var fWatTor = [Double]()
    private var fSti = [Double]()
    private var fWb = [Double]()
    private var fWbGusts = [Double]()
    private var locmarkerAl = [Double]()
    private var locdotXArr = [Double]()
    private var locdotYArr = [Double]()
    private var tvsXArr = [Double]()
    private var tvsYArr = [Double]()
    private var hiXArr = [Double]()
    private var hiYArr = [Double]()
    private var spotterXArr = [Double]()
    private var spotterYArr = [Double]()
    private var wbCircleXArr = [Double]()
    private var wbCircleYArr = [Double]()
    var gpsLocation = LatLon(0.0, 0.0)
    private var geographicBuffers = [ObjectMetalBuffers]()
    private var ridPrefixGlobal = "0"
    private var indexString = "0"
    var radarBuffers = ObjectMetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    private final var l3BaseFn = "nids"
    private final var stiBaseFn = "nids_sti_tab"
    private final var hiBaseFn = "nids_hi_tab"
    private final var tvsBaseFn = "nids_tvs_tab"
    private var totalBins = 0
    private var timeButton: ObjectToolbarIcon
    private var productButton: ObjectToolbarIcon
    private var radarLayers = [ObjectMetalBuffers]()
    var gpsLatLonTransformed: (Float, Float) = (0.0, 0.0)
    private var paneNumber = 0
    var numberOfPanes = 0
    var textObj: WXMetalTextObject
    private var renderFn: ((Int) -> Void)?
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
         _ textObj: WXMetalTextObject,
         _ timeButton: ObjectToolbarIcon,
         _ productButton: ObjectToolbarIcon,
         paneNumber: Int,
         _ numberOfPanes: Int
    ) {
        self.textObj = textObj
        self.device = device
        self.timeButton = timeButton
        self.productButton = productButton
        self.paneNumber = paneNumber
        self.indexString = String(paneNumber)
        self.numberOfPanes = numberOfPanes
        readPrefs()
        regenerateProductList()
        radarLayers = [radarBuffers]
        geographicBuffers = []
        [countyLineBuffers, stateLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geotype.display {
                geographicBuffers.append($0)
            }
        }
        [countyLineBuffers, stateLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geotype.display {
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
        projectionMatrix: float4x4,
        clearColor: MTLClearColor?
    ) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        //For now cull mode is used instead of depth buffer
        renderEncoder!.setCullMode(MTLCullMode.front)
        renderEncoder!.setRenderPipelineState(pipelineState)
        var projectionMatrixRef = projectionMatrix
        //var modelViewMatrixRef = modelViewMatrix
        radarLayers.enumerated().forEach { index, vbuffer in
            if vbuffer.vertexCount > 0 {
                if vbuffer.scaleCutOff < zoom {
                    if !(vbuffer.honorDisplayHold && displayHold) ||  !vbuffer.honorDisplayHold {
                        renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                        var nodeModelMatrix = self.modelMatrix()
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
                        renderEncoder!.drawPrimitives(
                            type: vbuffer.shape,
                            vertexStart: 0,
                            vertexCount: vbuffer.vertexCount
                        )
                    }
                }
            }
        }
        if RadarPreferences.radarShowWpcFronts {
            if zoom < WXMetalRender.zoomToHideMiscFeatures {
                wpcFrontBuffersList.enumerated().forEach { index, vbuffer in
                    if vbuffer.vertexCount > 0 {
                        if vbuffer.scaleCutOff < zoom {
                            if !(vbuffer.honorDisplayHold && displayHold) ||  !vbuffer.honorDisplayHold {
                                renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                                var nodeModelMatrix = self.modelMatrix()
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
                                renderEncoder!.drawPrimitives(
                                    type: .line,
                                    vertexStart: 0,
                                    vertexCount: vbuffer.vertexCount
                                )
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
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }

    func updateWithDelta(delta: CFTimeInterval) {
        time += delta
    }

    func constructAlertPolygons() {
        [
            warningTstBuffers,
            warningTorBuffers,
            warningFfwBuffers,
            warningSmwBuffers,
            warningSqwBuffers,
            warningDswBuffers,
            warningSpsBuffers
        ].forEach {
            constructGenericLines($0)
            $0.generateMtlBuffer(device)
        }
        if self.renderFn != nil {
            self.renderFn!(paneNumber)
        }
        [mcdBuffers, watchBuffers, watchTornadoBuffers, mpdBuffers].forEach {
            constructGenericLines($0)
            $0.generateMtlBuffer(device)
        }
        if self.renderFn != nil {
            self.renderFn!(paneNumber)
        }
    }

    func constructGenericLines(_ buffers: ObjectMetalBuffers) {
        var fList = [Double]()
        switch buffers.type.string {
        case "MCD":
            fList = UtilityWatch.add(pn, buffers.type)
        case "MPD":
            fList = UtilityWatch.add(pn, buffers.type)
        case "WATCH":
            fList = UtilityWatch.add(pn, buffers.type)
        case "WATCH_TORNADO":
            fList = UtilityWatch.add(pn, buffers.type)
        case "TST":
            fList = WXGLPolygonWarnings.add(pn, buffers.type)
        case "TOR":
            fList = WXGLPolygonWarnings.add(pn, buffers.type)
        case "FFW":
            fList = WXGLPolygonWarnings.add(pn, buffers.type)
        case "SMW":
            fList = WXGLPolygonWarnings.addGeneric(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!
            )
        case "SQW":
            fList = WXGLPolygonWarnings.addGeneric(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!
            )
        case "DSW":
            fList = WXGLPolygonWarnings.addGeneric(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!
            )
        case "SPS":
            fList = WXGLPolygonWarnings.addGeneric(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!
            )
        case "STI":
            fList = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, indexString)
        default:
            break
        }
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        var vList = 0
        while vList < fList.count {
            buffers.putFloat(fList[vList])
            buffers.putFloat(fList[vList+1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(fList[vList+2])
            buffers.putFloat(fList[vList+3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            vList += 4
        }
        buffers.count = vList
    }

    func constructGenericGeographic(_ buffers: ObjectMetalBuffers) {
        buffers.setCount(buffers.geotype.count)
        buffers.initialize(4 * buffers.count, buffers.geotype.color)
        let colors = buffers.getColorArrayInFloat()
        JNI_GenMercato(
            MemoryBuffer.getPointer(buffers.geotype.relativeBuffer.array),
            MemoryBuffer.getPointer(buffers.floatBuffer.array),
            pn.xFloat,
            pn.yFloat,
            pn.xCenterFloat,
            pn.yCenterFloat,
            pn.oneDegreeScaleFactorFloat,
            Int32(buffers.count)
        )
        buffers.setToPositionZero()
        var i = 0
        (0..<(buffers.count / 2)).forEach { _ in
            let f1 = Float(buffers.floatBuffer.getCGFloatNative())
            let f2 = Float(buffers.floatBuffer.getCGFloatNative())
            buffers.metalBuffer[i] = f1
            buffers.metalBuffer[i + 1] = f2
            buffers.metalBuffer[i + 2] = colors[0]
            buffers.metalBuffer[i + 3] = colors[1]
            buffers.metalBuffer[i + 4] = colors[2]
            i += 5
        }
    }

    func loadGeometry() {
        pn = ProjectionNumbers(rid, .wxOgl)
        geographicBuffers.forEach {
            constructGenericGeographic($0)
            $0.generateMtlBuffer(device)
        }
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {
            constructLocationDot()
        }
        setZoom()
        if self.renderFn != nil {
            self.renderFn!(paneNumber)
        }
    }

    func writePrefs() {
        let numberOfPanes = String(self.numberOfPanes)
        let index = String(paneNumber)
        let radarType = "WXMETAL"
        Utility.writePref(radarType + numberOfPanes + "_ZOOM" + index, zoom)
        Utility.writePref(radarType + numberOfPanes + "_X" + index, xPos)
        Utility.writePref(radarType + numberOfPanes + "_Y" + index, yPos)
        Utility.writePref(radarType + numberOfPanes + "_RID" + index, rid)
        Utility.writePref(radarType + numberOfPanes + "_PROD" + index, product)
        Utility.writePref(radarType + numberOfPanes + "_TILT" + index, tiltInt)
    }

    // This method is called between the transition from single to dual pane
    // It saves the current specifics about the single pane radar save the product itself
    func writePrefsForSingleToDualPaneTransition() {
        let numberOfPanes = "2"
        let radarType = "WXMETAL"
        ["0", "1"].forEach {
            Utility.writePref(radarType + numberOfPanes + "_ZOOM" + $0, zoom)
            Utility.writePref(radarType + numberOfPanes + "_X" + $0, xPos)
            Utility.writePref(radarType + numberOfPanes + "_Y" + $0, yPos)
            Utility.writePref(radarType + numberOfPanes + "_RID" + $0, rid)
            Utility.writePref(radarType + numberOfPanes + "_TILT" + $0, tiltInt)
        }
    }

    func writePrefsForSingleToQuadPaneTransition() {
        let numberOfPanes = "4"
        let radarType = "WXMETAL"
        ["0", "1", "2", "3"].forEach {
            Utility.writePref(radarType + numberOfPanes + "_ZOOM" + $0, zoom)
            Utility.writePref(radarType + numberOfPanes + "_X" + $0, xPos)
            Utility.writePref(radarType + numberOfPanes + "_Y" + $0, yPos)
            Utility.writePref(radarType + numberOfPanes + "_RID" + $0, rid)
            Utility.writePref(radarType + numberOfPanes + "_TILT" + $0, tiltInt)
        }
    }

    func readPrefs() {
        if RadarPreferences.wxoglRememberLocation {
            let numberOfPanes = String(self.numberOfPanes)
            let index = String(paneNumber)
            let radarType = "WXMETAL"
            zoom = Utility.readPref(radarType + numberOfPanes + "_ZOOM" + index, 1.0)
            xPos = Utility.readPref(radarType + numberOfPanes + "_X" + index, 0.0)
            yPos = Utility.readPref(radarType + numberOfPanes + "_Y" + index, 0.0)
            product = Utility.readPref(
                radarType + numberOfPanes + "_PROD" + index,
                initialRadarProducts[paneNumber]
            )
            rid = Utility.readPref(radarType + numberOfPanes + "_RID" + index, Location.rid)
            tiltInt = Utility.readPref(radarType + numberOfPanes + "_TILT" + index, 0)
        } else {
            rid = Location.rid
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

    var rid: String {
        get {
            return ridStr
        }
        set {
            self.ridStr = newValue
            checkIfTdwr()
        }
    }

    var product: String {
        get {
            return radarProduct
        }
        set {
            self.radarProduct = newValue
            checkIfTdwr()
        }
    }

    func checkIfTdwr() {
        let ridIsTdwr = WXGLNexrad.isRidTdwr(self.rid)
        if self.product.hasPrefix("TV") || self.product == "TZL" || self.product.hasPrefix("TR") || self.product.hasPrefix("TZ") {
            self.tdwr = true
        } else {
            self.tdwr = false
        }
        if (self.product == "N0Q"
            || self.product == "N1Q"
            || self.product == "N2Q"
            || self.product == "N3Q"
            || self.product == "L2REF") && ridIsTdwr {
            self.radarProduct = "TZL"
            self.tdwr = true
        }
        if (self.product == "TZL" || self.product.hasPrefix("TR") || self.product.hasPrefix("TZ")) && !ridIsTdwr {
            self.radarProduct = "N0Q"
            self.tdwr = false
        }
        if (self.product == "N0U"
            || self.product == "N1U"
            || self.product == "N2U"
            || self.product == "N3U"
            || self.product == "L2VEL") && ridIsTdwr {
            self.radarProduct = "TV0"
            self.tdwr = true
        }
        if self.product.hasPrefix("TV") && !ridIsTdwr {
            self.radarProduct = "N0U"
            self.tdwr = false
        }
    }

    func getRadar(_ url: String, _ additionalText: String = "") {
        var isAnimating = false
        DispatchQueue.global(qos: .userInitiated).async {
            if url == "" {
                self.ridPrefixGlobal = self.rdDownload.getRadarFile(
                    url,
                    self.rid,
                    self.radarProduct,
                    self.indexString,
                    self.tdwr
                )
                if !self.radarProduct.contains("L2") {
                    self.radarBuffers.fileName = self.l3BaseFn + self.indexString
                } else {
                    self.radarBuffers.fileName = "l2" + self.indexString
                }
            } else {
                isAnimating = true
                self.radarBuffers.fileName = url
            }
            if url == "" {  // not anim
                [PolygonType.STI, PolygonType.TVS, PolygonType.HI].forEach {
                    if $0.display {
                        self.constructLevel3TextProduct($0)
                    }
                }
                if PolygonType.SPOTTER.display {
                    self.constructSpotters()
                }
                if PolygonType.OBS.display || PolygonType.WIND_BARB.display {
                    UtilityMetar.getStateMetarArrayForWXOGL(self.rid)
                }
                if PolygonType.WIND_BARB.display {
                    self.constructWBLines()
                }
                if PolygonType.SWO.display {
                    UtilitySwoD1.get()
                    self.constructSwoLines()
                }
                if RadarPreferences.radarShowWpcFronts {
                    UtilityWpcFronts.get()
                    self.constructWpcFronts()
                }
            }
            DispatchQueue.main.async {
                self.constructPolygons()
                self.showTimeToolbar(additionalText, isAnimating)
                self.showProductText(self.radarProduct)
                if self.renderFn != nil {
                    self.renderFn!(self.paneNumber)
                }
                if !isAnimating {
                    self.textObj.removeTextLabels()
                    self.textObj.addTextLabels()
                }
            }
        }
    }

    func setRenderFunction(_ fn: @escaping (Int) -> Void) {
        self.renderFn = fn
    }

    func demandRender() {
        if self.renderFn != nil {
            self.renderFn!(paneNumber)
        }
    }

    func constructPolygons() {
        self.radarBuffers.metalBuffer = []
        self.radarBuffers.rd = WXMetalNexradLevelData(self.radarProduct, self.radarBuffers, self.indexString)
        self.radarBuffers.rd.decode()
        self.radarBuffers.initialize()
        switch self.radarBuffers.rd.productCode {
        case 37, 38:
            self.totalBins = UtilityWXMetalPerfRaster.generate(self.radarBuffers)
        case 153, 154, 30, 56, 78, 80, 181:
            self.totalBins = UtilityWXMetalPerf.genRadials(self.radarBuffers)
        case 0:
            break
        default:
            self.totalBins = UtilityWXMetalPerf.decode8BitAndGenRadials(self.radarBuffers)
        }
        self.radarBuffers.setToPositionZero()
        self.radarBuffers.count = (self.radarBuffers.metalBuffer.count / self.radarBuffers.floatCountPerVertex) * 2
        self.radarBuffers.generateMtlBuffer(device)
    }

    func updateTimeToolbar() {
        showTimeToolbar("", false)
    }

    func showTimeToolbar(_ additionalText: String, _ isAnimating: Bool) {
        let timeStr = WXGLNexrad.getRadarInfo("").split(" ")
        if timeStr.count > 1 {
            var replaceToken = "Mode:"
            if product.hasPrefix("L2") {
                replaceToken = "Product:"
            }
            let text = timeStr[1].replace(MyApplication.newline + replaceToken, "") + additionalText
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

    func constructLocationDot() {
        locmarkerAl = []
        locdotBuffers.lenInit = PolygonType.LOCDOT.size
        if PolygonType.LOCDOT.display {
            locmarkerAl = UtilityLocation.getLatLonAsDouble()
        }
        if RadarPreferences.locdotFollowsGps {
            locmarkerAl.append(gpsLocation.lat)
            locmarkerAl.append(gpsLocation.lon)
        }
        locdotBuffers.latList = locmarkerAl.enumerated().filter { idx, _ in
            idx & 1 == 0}.map { _, value in Double(value)}
        locdotBuffers.lonList = locmarkerAl.enumerated().filter { idx, _ in
            idx & 1 != 0}.map { _, value in Double(value)}
        locdotBuffers.triangleCount = 24
        locdotBuffers.count = locmarkerAl.count
        locdotBuffers.lenInit = scaleLengthLocationDot(locdotBuffers.type.size)
        constructTriangles(locdotBuffers)
        locCircleBuffers.triangleCount = 24
        locCircleBuffers.initialize(32 * locCircleBuffers.triangleCount, PolygonType.LOCDOT.color)
        if RadarPreferences.locdotFollowsGps {
            let gpsCoords = UtilityCanvasProjection.computeMercatorNumbers(
                gpsLocation.lat,
                gpsLocation.lon,
                pn
            )
            gpsLatLonTransformed = (Float(-gpsCoords.lat), Float(gpsCoords.lon))
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXMetalPerf.genCircleLocdot(locCircleBuffers, pn, gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        locdotBuffers.generateMtlBuffer(device)
        locCircleBuffers.generateMtlBuffer(device)
        if self.renderFn != nil {
            setZoom()
            self.renderFn!(self.paneNumber)
        }
    }

    func constructTriangles(_ buffers: ObjectMetalBuffers) {
        buffers.setCount(buffers.latList.count)
        switch buffers.type.string {
        case "LOCDOT":
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        case "SPOTTER":
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        default:
            buffers.initialize(4 * 6 * buffers.count, buffers.type.color)
        }
        buffers.lenInit = scaleLengthLocationDot(buffers.lenInit) // was scaleLength
        buffers.draw(pn)
    }

    func constructGenericLinesShort(_ buffers: ObjectMetalBuffers, _ fList: [Double]) {
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        var vList = 0
        while vList < fList.count {
            buffers.putFloat(fList[vList])
            buffers.putFloat(fList[vList+1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(fList[vList+2])
            buffers.putFloat(fList[vList+3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            vList += 4
        }
        buffers.count = vList
    }

    func constructWBLines() {
        let fWb = WXGLNexradLevel3WindBarbs.decocodeAndPlot(pn, isGust: false)
        constructGenericLinesShort(wbBuffers, fWb)
        constructWBLinesGusts()
        constructWBCircle()
        wbBuffers.generateMtlBuffer(device)
    }

    func constructWBLinesGusts() {
        fWbGusts = WXGLNexradLevel3WindBarbs.decocodeAndPlot(pn, isGust: true)
        constructGenericLinesShort(wbGustsBuffers, fWbGusts)
        wbGustsBuffers.generateMtlBuffer(device)
    }

    func constructLevel3TextProduct(_ type: PolygonType) {
        switch type.string {
        case "HI":
            constructHi()
        case "TVS":
            constructTvs()
        case "STI":
            constructStiLines()
        default: break
        }
    }

    func constructStiLines() {
        fSti = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, stiBaseFn + indexString)
        constructGenericLinesShort(stiBuffers, fSti)
        stiBuffers.generateMtlBuffer(device)
    }

    func constructTvs() {
        tvsBuffers.lenInit = tvsBuffers.type.size
        tvsBuffers.triangleCount = 1
        tvsBuffers.metalBuffer = []
        tvsBuffers.vertexCount = 0
        let stormList = WXGLNexradLevel3TVS.decocodeAndPlotNexradTVS(pn, tvsBaseFn + indexString)
        tvsBuffers.setXYList(stormList)
        constructTriangles(tvsBuffers)
        tvsBuffers.generateMtlBuffer(device)
    }

    func constructHi() {
        hiBuffers.lenInit = hiBuffers.type.size
        hiBuffers.triangleCount = 1
        hiBuffers.metalBuffer = []
        hiBuffers.vertexCount = 0
        let stormList = WXGLNexradLevel3HailIndex.decocodeAndPlotNexradHailIndex(pn, hiBaseFn + indexString)
        hiBuffers.setXYList(stormList)
        constructTriangles(hiBuffers)
        hiBuffers.generateMtlBuffer(device)
    }

    func constructWBCircle() {
        wbCircleBuffers.lenInit = PolygonType.WIND_BARB.size
        wbCircleBuffers.latList = UtilityMetar.obsArrX
        wbCircleBuffers.lonList = UtilityMetar.obsArrY
        wbCircleBuffers.colorIntArray = UtilityMetar.getObsArrAviationColor()
        wbCircleBuffers.setCount(wbCircleBuffers.latList.count)
        wbCircleBuffers.triangleCount = 6
        wbCircleBuffers.initialize(24 * wbCircleBuffers.count * wbCircleBuffers.triangleCount)
        wbCircleBuffers.lenInit = scaleLengthLocationDot(wbCircleBuffers.lenInit) // was scaleLength
        ObjectMetalBuffers.redrawCircleWithColor(wbCircleBuffers, pn)
        wbCircleBuffers.generateMtlBuffer(device)
    }

    func constructSpotters() {
        //spotterBuffers.lenInit = spotterBuffers.type.size
        spotterBuffers.lenInit = PolygonType.SPOTTER.size
        //spotterBuffers.lenInit = scaleLengthLocationDot(spotterBuffers.lenInit)
        spotterBuffers.triangleCount = 6
        _ = UtilitySpotter.getSpotterData()
        spotterBuffers.latList = UtilitySpotter.lat
        spotterBuffers.lonList = UtilitySpotter.lon
        constructTriangles(spotterBuffers)
        //spotterBuffers.setCount(spotterBuffers.latList.count)
        //spotterBuffers.initialize(24 * spotterBuffers.count * spotterBuffers.triangleCount, spotterBuffers.type.color)
        spotterBuffers.lenInit = scaleLengthLocationDot(spotterBuffers.type.size)
        spotterBuffers.draw(pn)
        spotterBuffers.generateMtlBuffer(device)
    }

    func constructWpcFronts() {
        wpcFrontBuffersList = []
        wpcFrontPaints = []
        var tmpCoords = (0.0, 0.0)
        UtilityWpcFronts.fronts.forEach { _ in
            let buff = ObjectMetalBuffers()
            buff.initialize(2, Color.MAGENTA)
            wpcFrontBuffersList.append(buff)
        }
        UtilityWpcFronts.fronts.enumerated().forEach { z, _ in
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
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(front.coordinates[j].lat, front.coordinates[j].lon, pn)
                wpcFrontBuffersList[z].putFloat(tmpCoords.0)
                wpcFrontBuffersList[z].putFloat(tmpCoords.1 * -1.0)
                wpcFrontBuffersList[z].putColor(Color.red(self.wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.green(self.wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.blue(self.wpcFrontPaints[z]))
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(front.coordinates[j + 1].lat, front.coordinates[j + 1].lon, pn)
                wpcFrontBuffersList[z].putFloat(tmpCoords.0)
                wpcFrontBuffersList[z].putFloat(tmpCoords.1 * -1.0)
                wpcFrontBuffersList[z].putColor(Color.red(self.wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.green(self.wpcFrontPaints[z]))
                wpcFrontBuffersList[z].putColor(Color.blue(self.wpcFrontPaints[z]))
            }
            wpcFrontBuffersList[z].count = Int(Double(wpcFrontBuffersList[z].metalBuffer.count) * 0.4)
            wpcFrontBuffersList[z].generateMtlBuffer(device)
        }
    }

    func constructSwoLines() {
        swoBuffers.initialize(2, Color.MAGENTA)
        colorSwo = []
        colorSwo.append(Color.MAGENTA)
        colorSwo.append(Color.RED)
        colorSwo.append(wXColor.colorsToInt(255, 140, 0))
        colorSwo.append(Color.YELLOW)
        colorSwo.append(wXColor.colorsToInt(0, 100, 0))
        var tmpCoords = (0.0, 0.0)
        var fSize = 0
        (0...4).forEach {
            if let flArr = UtilitySwoD1.hashSwo[$0] {
                fSize += flArr.count
            }
        }
        swoBuffers.metalBuffer = []
        (0...4).forEach { z in
            if let flArr = UtilitySwoD1.hashSwo[z] {
                stride(from: 0, to: flArr.count-1, by: 4).forEach { j in
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(
                        Double(flArr[j]),
                        Double(flArr[j+1]) * -1.0,
                        pn
                    )
                    swoBuffers.putFloat(tmpCoords.0)
                    swoBuffers.putFloat(tmpCoords.1 * -1.0)
                    swoBuffers.putColor(Color.red(self.colorSwo[z]))
                    swoBuffers.putColor(Color.green(self.colorSwo[z]))
                    swoBuffers.putColor(Color.blue(self.colorSwo[z]))
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(
                        Double(flArr[j+2]),
                        Double(flArr[j+3]) * -1.0,
                        pn
                    )
                    swoBuffers.putFloat(tmpCoords.0)
                    swoBuffers.putFloat(tmpCoords.1 * -1.0)
                    swoBuffers.putColor(Color.red(self.colorSwo[z]))
                    swoBuffers.putColor(Color.green(self.colorSwo[z]))
                    swoBuffers.putColor(Color.blue(self.colorSwo[z]))
                }
            }
        }
        swoBuffers.count = Int(Double(swoBuffers.metalBuffer.count) * 0.4)
        swoBuffers.generateMtlBuffer(device)
    }

    /*func scaleLength(_ currentLength: Double) -> Double {
        if zoom > 1.01 {
            return (currentLength / Double(zoom)) * 2.0
        } else {
            return currentLength
        }
    }*/

    func scaleLengthLocationDot(_ currentLength: Double) -> Double {
        return (currentLength / Double(zoom)) * 2.0
    }

    func setZoom() {
        // wbCircleBuffers used to be in the first forEach
        [hiBuffers, tvsBuffers].forEach {
            $0.lenInit = scaleLengthLocationDot($0.type.size) // was scaleLength
            $0.draw(pn)
            $0.generateMtlBuffer(device)
        }
        [locdotBuffers, wbCircleBuffers, spotterBuffers].forEach {
            $0.lenInit = scaleLengthLocationDot($0.type.size)
            $0.draw(pn)
            $0.generateMtlBuffer(device)
        }
        if  RadarPreferences.locdotFollowsGps {
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXMetalPerf.genCircleLocdot(locCircleBuffers, pn, gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        if self.renderFn != nil {
            self.renderFn!(paneNumber)
        }
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
        let truncateAmount = 10
        return gpsLocation.latString.truncate(truncateAmount)
            + ", -"
            + gpsLocation.lonString.truncate(truncateAmount)
    }

    var tilt: Int {
        get {
            return tiltInt
        }
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
            if product.hasPrefix("TR") || product.hasPrefix("TV") || product.hasPrefix("TZ") {
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
