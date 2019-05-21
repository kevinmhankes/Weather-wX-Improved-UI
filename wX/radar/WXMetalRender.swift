/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import QuartzCore
import Metal

class WXMetalRender {

    let device: MTLDevice
    var time: CFTimeInterval = 0.0
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0
    var pn = ProjectionNumbers()
    var ridStr = "DTX"
    var rdDownload = WXGLDownload()
    var radarProduct = "N0Q"
    var tiltInt = 0
    var initialRadarProducts = ["N0Q", "N0U", "EET", "DVL"]
    var xPos: Float = 0.0
    var yPos: Float = 0.0
    var zPos: Float = -7.0
    var zoom: Float = 1.0
    var lastPanLocation: CGPoint!
    var TDWR = false
    private static let zoomToHideMiscFeatures: Float = 0.5
    var displayHold: Bool = false
    private var stateLineBuffers = ObjectMetalBuffers(GeographyType.stateLines, 0.0)
    private var countyLineBuffers = ObjectMetalBuffers(GeographyType.countyLines, 0.75)
    private var hwBuffers = ObjectMetalBuffers(GeographyType.highways, zoomToHideMiscFeatures)
    private var hwExtBuffers = ObjectMetalBuffers(GeographyType.highwaysExtended, 3.00)
    private var lakeBuffers = ObjectMetalBuffers(GeographyType.lakes, zoomToHideMiscFeatures)
    private var stiBuffers = ObjectMetalBuffers(PolygonType.STI, zoomToHideMiscFeatures)
    private var wbBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB, zoomToHideMiscFeatures)
    private var wbGustsBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_GUSTS)
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
    private var locdotBuffers = ObjectMetalBuffers(PolygonType.LOCDOT, zoomToHideMiscFeatures / 2.0)
    private var locCircleBuffers = ObjectMetalBuffers(PolygonType.LOCDOT_CIRCLE, zoomToHideMiscFeatures / 2.0)
    private var wbCircleBuffers = ObjectMetalBuffers(PolygonType.WIND_BARB_CIRCLE, zoomToHideMiscFeatures)
    private var spotterBuffers = ObjectMetalBuffers(PolygonType.SPOTTER, zoomToHideMiscFeatures)
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
    var idxStr = "0"
    var radarBuffers = ObjectMetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    private final var l3BaseFn = "nids"
    private final var stiBaseFn = "nids_sti_tab"
    private final var hiBaseFn = "nids_hi_tab"
    private final var tvsBaseFn = "nids_tvs_tab"
    private var totalBins = 0
    private var timeButton: ObjectToolbarIcon
    private var productButton: ObjectToolbarIcon
    private var radarLayers = [ObjectMetalBuffers]()
    var paneNumber = 0
    var numberOfPanes = 0
    var renderFn: ((Int) -> Void)?
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
        "NSW: Base Spectrum Width"
    ]

    init(_ device: MTLDevice,
         _ timeButton: ObjectToolbarIcon,
         _ productButton: ObjectToolbarIcon,
         paneNumber: Int,
         _ numberOfPanes: Int
    ) {
        self.device = device
        self.timeButton = timeButton
        self.productButton = productButton
        self.paneNumber = paneNumber
        self.idxStr = String(paneNumber)
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
        parentModelViewMatrix: Matrix4,
        projectionMatrix: Matrix4,
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
        radarLayers.enumerated().forEach { index, vbuffer in
            if vbuffer.vertexCount > 0 {
                if vbuffer.scaleCutOff < zoom {
                    if !(vbuffer.honorDisplayHold && displayHold) ||  !vbuffer.honorDisplayHold {
                        renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                        let nodeModelMatrix = self.modelMatrix()
                        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
                        let uniformBuffer = device.makeBuffer(
                            length: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2,
                            options: []
                        )
                        let bufferPointer = uniformBuffer?.contents()
                        memcpy(
                            bufferPointer,
                            nodeModelMatrix.raw(),
                            MemoryLayout<Float>.size * Matrix4.numberOfElements()
                        )
                        memcpy(
                            bufferPointer! + MemoryLayout<Float>.size * Matrix4.numberOfElements(),
                            projectionMatrix.raw(),
                            MemoryLayout<Float>.size * Matrix4.numberOfElements()
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
        renderEncoder!.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }

    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
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
            fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "TOR":
            fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "FFW":
            fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "SMW":
            fList = WXGLPolygonWarnings.addGenericWarnings(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!
            )
        case "SQW":
            fList = WXGLPolygonWarnings.addGenericWarnings(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!
            )
        case "DSW":
            fList = WXGLPolygonWarnings.addGenericWarnings(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!
            )
        case "SPS":
            fList = WXGLPolygonWarnings.addGenericWarnings(
                pn,
                ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!
            )
        case "STI":
            fList = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, idxStr)
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
        //let index = "0"
        let radarType = "WXMETAL"
        ["0", "1"].forEach {
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
            checkIfTDWR()
        }
    }

    var product: String {
        get {
            return radarProduct
        }
        set {
            self.radarProduct = newValue
            checkIfTDWR()
        }
    }

    func checkIfTDWR() {
        let ridIsTdwr = WXGLNexrad.isRidTdwr(self.rid)
        if self.product == "TV0" || self.product == "TZL" {
            self.TDWR = true
        } else {
            self.TDWR = false
        }
        if (self.product == "N0Q"
            || self.product == "N1Q"
            || self.product == "N2Q"
            || self.product == "N3Q"
            || self.product == "L2REF") && ridIsTdwr {
            self.radarProduct = "TZL"
            self.TDWR = true
        }
        if self.product == "TZL" && !ridIsTdwr {
            self.radarProduct = "N0Q"
            self.TDWR = false
        }
        if (self.product == "N0U"
            || self.product == "N1U"
            || self.product == "N2U"
            || self.product == "N3U"
            || self.product == "L2VEL") && ridIsTdwr {
            self.radarProduct = "TV0"
            self.TDWR = true
        }
        if self.product == "TV0" && !ridIsTdwr {
            self.radarProduct = "N0U"
            self.TDWR = false
        }
    }

    func getRadar(_ url: String, _ additionalText: String = "") {
        DispatchQueue.global(qos: .userInitiated).async {
            if url == "" {
                self.ridPrefixGlobal = self.rdDownload.getRadarFile(
                    url,
                    self.rid,
                    self.radarProduct,
                    self.idxStr,
                    self.TDWR
                )
                if !self.radarProduct.contains("L2") {
                    self.radarBuffers.fileName = self.l3BaseFn + self.idxStr
                } else {
                    self.radarBuffers.fileName = "l2" + self.idxStr
                }
            } else {
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
                    UtilitySWOD1.getSWO()
                    self.constructSWOLines()
                }
            }
            DispatchQueue.main.async {
                self.constructPolygons()
                self.showTimeToolbar(additionalText)
                self.showProductText(self.radarProduct)
                if self.renderFn != nil {
                    self.renderFn!(self.paneNumber)
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
        self.radarBuffers.rd = WXMetalNexradLevelData(self.radarProduct, self.radarBuffers, self.idxStr)
        self.radarBuffers.rd.decode()
        self.radarBuffers.initialize()
        switch self.radarBuffers.rd.productCode {
        case 153, 154, 30, 56:
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

    func showTimeToolbar(_ additionalText: String) {
        var timeStr = Utility.readPref("WX_RADAR_CURRENT_INFO", "").split(" ")
        if timeStr.count > 1 {
            let text = timeStr[1].replace(MyApplication.newline + "Mode:", "") + additionalText
            timeButton.title = text
            if UtilityTime.isRadarTimeOld(text) {
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
        constructTriangles(locdotBuffers)
        locCircleBuffers.triangleCount = 24
        locCircleBuffers.initialize(32 * locCircleBuffers.triangleCount, PolygonType.LOCDOT.color)
        if RadarPreferences.locdotFollowsGps {
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXMetalPerf.genCircleLocdot(locCircleBuffers, pn, gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        locdotBuffers.generateMtlBuffer(device)
        locCircleBuffers.generateMtlBuffer(device)
        if self.renderFn != nil {
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
        buffers.lenInit = scaleLength(buffers.lenInit)
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
        wbBuffers.generateMtlBuffer(device)
    }

    func constructWBCircle() {
        wbCircleBuffers.lenInit = PolygonType.WIND_BARB.size
        wbCircleBuffers.latList = UtilityMetar.obsArrX
        wbCircleBuffers.lonList = UtilityMetar.obsArrY
        wbCircleBuffers.colorIntArray = UtilityMetar.getObsArrAviationColor()
        wbCircleBuffers.setCount(wbCircleBuffers.latList.count)
        wbCircleBuffers.triangleCount = 6
        wbCircleBuffers.initialize(24 * wbCircleBuffers.count * wbCircleBuffers.triangleCount)
        wbCircleBuffers.lenInit = scaleLength(wbCircleBuffers.lenInit)
        ObjectMetalBuffers.redrawCircleWithColor(wbCircleBuffers, pn)
        wbCircleBuffers.generateMtlBuffer(device)
    }

    func constructLevel3TextProduct(_ type: PolygonType) {
        switch type.string {
        case "HI":
            constructHI()
        case "TVS":
            constructTVS()
        case "STI":
            constructSTILines()
        default: break
        }
    }

    func constructSTILines() {
        fSti = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, stiBaseFn + idxStr)
        constructGenericLinesShort(stiBuffers, fSti)
        stiBuffers.generateMtlBuffer(device)
    }

    func constructTVS() {
        tvsBuffers.lenInit = tvsBuffers.type.size
        tvsBuffers.triangleCount = 1
        tvsBuffers.metalBuffer = []
        tvsBuffers.vertexCount = 0
        let stormList = WXGLNexradLevel3TVS.decocodeAndPlotNexradTVS(pn, tvsBaseFn + idxStr)
        tvsBuffers.setXYList(stormList)
        constructTriangles(tvsBuffers)
        tvsBuffers.generateMtlBuffer(device)
    }

    func constructHI() {
        hiBuffers.lenInit = hiBuffers.type.size
        hiBuffers.triangleCount = 1
        hiBuffers.metalBuffer = []
        hiBuffers.vertexCount = 0
        let stormList = WXGLNexradLevel3HailIndex.decocodeAndPlotNexradHailIndex(pn, hiBaseFn + idxStr)
        hiBuffers.setXYList(stormList)
        constructTriangles(hiBuffers)
        hiBuffers.generateMtlBuffer(device)
    }

    func constructSpotters() {
        spotterBuffers.lenInit = spotterBuffers.type.size
        spotterBuffers.triangleCount = 6
        _ = UtilitySpotter.getSpotterData()
        spotterBuffers.latList = UtilitySpotter.lat
        spotterBuffers.lonList = UtilitySpotter.lon
        constructTriangles(spotterBuffers)
        spotterBuffers.generateMtlBuffer(device)
    }

    func constructSWOLines() {
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
            if let flArr = UtilitySWOD1.hashSwo[$0] {
                fSize += flArr.count
            }
        }
        swoBuffers.metalBuffer = []
        (0...4).forEach { z in
            if let flArr = UtilitySWOD1.hashSwo[z] {
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

    func scaleLength(_ currentLength: Double) -> Double {
        if zoom > 1.01 {
            return (currentLength / Double(zoom)) * 2.0
        } else {
            return currentLength
        }
    }

    func setZoom() {
        [hiBuffers, spotterBuffers, tvsBuffers, wbCircleBuffers, locdotBuffers].forEach {
            $0.lenInit = scaleLength($0.type.size)
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

    func resetRidAndGet(_ rid: String) {
        self.rid = rid
        loadGeometry()
        xPos = 0.0
        yPos = 0.0
        zoom = 1.0
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
                //print(newProduct)
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
                //print(newProduct)
            }
        }
    }
}
