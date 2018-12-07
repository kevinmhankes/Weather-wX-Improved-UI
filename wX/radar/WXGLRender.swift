/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import GLKit
import OpenGLES

final class WXGLRender: NSObject, GLKViewDelegate {

    var gl = GLKView()
    var oldScale: Float = 0.0
    private var program: GLuint = 0
    private var projectionMatrix: GLKMatrix4 = GLKMatrix4Identity
    private var mtrxProjectionAndView: GLKMatrix4 = GLKMatrix4Identity
    private var uniforms = [GLint](repeating: 0, count: 2)
    private let uniformModelViewProjectionMatrix = 0
    private var rotation: Float = 0.0
    private var vertexArray: GLuint = 0
    private var vertexBuffer: GLuint = 0
    private var effect: GLKBaseEffect?
    let ortInt: Float = 250.0
    private let provider: ProjectionType = .wxOgl
    private var width: Float = 0.0
    private var height: Float = 0.0
    private var parent: WXOGLOpenGLMultiPane?
    private var radarBuffers = ObjectOglRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    private var triangleIndexBuffer = MemoryBuffer()
    private var lineIndexBuffer = MemoryBuffer()
    private var stateLineBuffers = ObjectOglBuffers(GeographyType.stateLines, scaleCutOff: 0.0)
    private var countyLineBuffers = ObjectOglBuffers(GeographyType.countyLines, scaleCutOff: 0.75)
    private var hwBuffers = ObjectOglBuffers(GeographyType.highways, scaleCutOff: 0.45)
    private var hwExtBuffers = ObjectOglBuffers(GeographyType.highwaysExtended, scaleCutOff: 3.00)
    private var lakeBuffers = ObjectOglBuffers(GeographyType.lakes, scaleCutOff: 0.30)
    private var stiBuffers = ObjectOglBuffers(PolygonType.STI)
    private var wbBuffers = ObjectOglBuffers(PolygonType.WIND_BARB)
    private var wbGustsBuffers = ObjectOglBuffers(PolygonType.WIND_BARB_GUSTS)
    private var mpdBuffers = ObjectOglBuffers(PolygonType.MPD)
    private var hiBuffers = ObjectOglBuffers(PolygonType.HI)
    private var tvsBuffers = ObjectOglBuffers(PolygonType.TVS)
    private var warningTstBuffers = ObjectOglBuffers(PolygonType.TST)
    private var warningTorBuffers = ObjectOglBuffers(PolygonType.TOR)
    private var warningFfwBuffers = ObjectOglBuffers(PolygonType.FFW)
    private var watchBuffers = ObjectOglBuffers(PolygonType.WATCH)
    private var watchTornadoBuffers = ObjectOglBuffers(PolygonType.WATCH_TORNADO)
    private var mcdBuffers = ObjectOglBuffers(PolygonType.MCD)
    private var swoBuffers = ObjectOglBuffers()
    private var locdotBuffers = ObjectOglBuffers(PolygonType.LOCDOT)
    private var locCircleBuffers = ObjectOglBuffers()
    private var wbCircleBuffers = ObjectOglBuffers(PolygonType.WIND_BARB_CIRCLE)
    private var spotterBuffers = ObjectOglBuffers(PolygonType.SPOTTER)
    private var lineCnt = 0
    private let breakSizeLine = 30000
    private var breakSize15 = 15000
    private var chunkCount = 0
    private var radarChunkCnt = 0
    private var totalBins = 0
    private var totalBinsOgl = 0
    private var scaledLen = 0.0
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
    private let breakSizeRadar = 15000
    private let defaultLineWidth: Float = 3.0
    var rdDownload = WXGLDownload()
    private var radarProduct = "N0Q"
    private var ridStr = "DTX"
    private var TDWR = false
    var idxStr = "0"
    private var ridPrefixGlobal = "0"
    private final var l3BaseFn = "nids"
    private final var stiBaseFn = "nids_sti_tab"
    private final var hiBaseFn = "nids_hi_tab"
    private final var tvsBaseFn = "nids_tvs_tab"
    private var surfaceRatio: Float = 0.0
    private var positionX: Float = 0.0
    private var positionY: Float = 0.0
    private var scaleFactor: Float = 1.0
    var pn = ProjectionNumbers()
    private var positionHandle: GLuint = 0
    private var colorHandle: GLuint = 0
    private var timeButton: ObjectToolbarIcon
    private var productButton: ObjectToolbarIcon

    init(_ timeButton: ObjectToolbarIcon, _ productButton: ObjectToolbarIcon) {
        self.timeButton = timeButton
        self.productButton = productButton
        lineIndexBuffer = MemoryBuffer(4 * breakSizeLine)
        UtilityWXOGLPerf.genIndexLine(lineIndexBuffer)
        triangleIndexBuffer = MemoryBuffer(12 * breakSize15)
        UtilityWXOGLPerf.genIndex(triangleIndexBuffer)
    }

    func localSetup() {
        loadGeometry()
        constructAlertPolygons()
    }

    func constructAlertPolygons() {
        [warningTstBuffers, warningTorBuffers, warningFfwBuffers].forEach {constructGenericLines($0)}
        [mcdBuffers, watchBuffers, watchTornadoBuffers, mpdBuffers].forEach {constructGenericLines($0)}
    }

    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        self.effect?.prepareToDraw()
        glUseProgram(program)
        surfaceRatio = Float(gl.bounds.size.width)/Float(gl.bounds.size.height)
        let projectionMatrix = GLKMatrix4MakeOrtho(-1.0 * ortInt, ortInt,
                                                   -1.0 * ortInt * (1.0 / surfaceRatio),
                                                   ortInt * (1 / surfaceRatio), 1.0, -1.0)
        let mtrxView: GLKMatrix4 = GLKMatrix4MakeLookAt(0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
        mtrxProjectionAndView = GLKMatrix4Multiply(projectionMatrix, mtrxView)
        mtrxProjectionAndView = GLKMatrix4Translate(mtrxProjectionAndView, positionX, positionY, 0)
        mtrxProjectionAndView = GLKMatrix4Scale(mtrxProjectionAndView, scaleFactor, scaleFactor, 1.0)
        withUnsafePointer(to: &mtrxProjectionAndView, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(uniforms[uniformModelViewProjectionMatrix], 1, 0, $0)
            })
        })
        self.effect?.transform.projectionMatrix = mtrxProjectionAndView
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        positionHandle = GLuint(GLKVertexAttrib.position.rawValue)
        colorHandle = GLuint(GLKVertexAttrib.color.rawValue)
        glEnableVertexAttribArray(colorHandle)
        updateScene()
    }

    func updateScene() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        self.effect?.prepareToDraw()
        glClearColor(radarBuffers.colorRF, radarBuffers.colorGF, radarBuffers.colorBF, 1.0)
        (0..<chunkCount).forEach {
            if $0 < (chunkCount - 1) {
                radarChunkCnt = breakSizeRadar * 6
            } else {
                radarChunkCnt = 6 * (totalBinsOgl - ($0 * breakSizeRadar))
            }
            radarBuffers.floatBuffer.position = $0 * breakSizeRadar * 32
            radarBuffers.colorBuffer.position = $0 * breakSizeRadar * 12
            triangleIndexBuffer.position = 0
            glVertexAttribPointer(positionHandle, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, radarBuffers.floatBuffer.address)
            glVertexAttribPointer(colorHandle, 3, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, radarBuffers.colorBuffer.address)
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(radarChunkCnt), GLenum(GL_UNSIGNED_SHORT), triangleIndexBuffer.array)
        }
        glLineWidth(2.0)
        [countyLineBuffers, stateLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if scaleFactor > $0.scaleCutOff {drawElement($0)}
        }
        glLineWidth(Float(RadarPreferences.radarWarnLinesize))
        [warningTstBuffers, warningFfwBuffers, warningTorBuffers].forEach {drawPolygons($0, 8)}
        glLineWidth(defaultLineWidth)
        [spotterBuffers, hiBuffers, tvsBuffers].forEach {drawTriangles($0)}
        [stiBuffers, wbGustsBuffers, wbBuffers].forEach {drawPolygons($0, 16)}
        drawTriangles(wbCircleBuffers)
        glLineWidth(Float(RadarPreferences.radarWatmcdLinesize))
        [mpdBuffers, mcdBuffers, watchBuffers, watchTornadoBuffers, swoBuffers].forEach {drawPolygons($0, 8)}
        glLineWidth(defaultLineWidth)
        drawTriangles(locdotBuffers)
        if RadarPreferences.locdotFollowsGps {
            locCircleBuffers.chunkCount = 1
            drawPolygons(locCircleBuffers, 16)
        }
    }

    func loadGeometry() {
        pn = ProjectionNumbers(rid, .wxOgl)
        [stateLineBuffers, countyLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {if $0.geotype.display {constructGenericGeographic($0)}}
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {constructLocationDot()}
    }

    func deconstructGenericGeographic(buffers: ObjectOglBuffers) {buffers.isInitialized = false}

    func constructLocationDot() {
        locmarkerAl = []
        locdotBuffers.lenInit = PolygonType.LOCDOT.size
        if PolygonType.LOCDOT.display {locmarkerAl = UtilityLocation.getLatLonAsDouble()}
        if RadarPreferences.locdotFollowsGps {
            locmarkerAl.append(gpsLocation.lat)
            locmarkerAl.append(gpsLocation.lon)
        }
        locdotBuffers.latList = locmarkerAl.enumerated().filter {idx, _ in idx & 1 == 0}.map { _, value in Double(value)}
        locdotBuffers.lonList = locmarkerAl.enumerated().filter {idx, _ in idx & 1 != 0}.map { _, value in Double(value)}
        locdotBuffers.triangleCount = 12
        constructTriangles(locdotBuffers)
        locCircleBuffers.triangleCount = 18
        locCircleBuffers.initialize(32 * locCircleBuffers.triangleCount, 8 * locCircleBuffers.triangleCount, 6 * locCircleBuffers.triangleCount, PolygonType.LOCDOT.color)
        UtilityWXOGLPerf.colorGen(locCircleBuffers.colorBuffer, 2 * locCircleBuffers.triangleCount, locCircleBuffers.getColorArray())
        if RadarPreferences.locdotFollowsGps {
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXOGLPerf.genCircleLocdot(locCircleBuffers, pn, gpsLocation)
        }
        locdotBuffers.isInitialized = true
        locCircleBuffers.isInitialized = true
    }

    func getRadar(_ url: String, _ additionalText: String="") {
        DispatchQueue.global(qos: .userInitiated).async {
            if url=="" {
                self.ridPrefixGlobal = self.rdDownload.getRadarFile(url, self.rid, self.radarProduct, self.idxStr, self.TDWR)
                if !self.radarProduct.contains("L2") {
                    self.radarBuffers.fileName = self.l3BaseFn + self.idxStr
                } else {
                    self.radarBuffers.fileName = "l2" + self.idxStr
                }
            } else {
                self.radarBuffers.fileName = url
            }
            if ActVars.WXOGLPaneCnt == "1" {
                [PolygonType.STI, PolygonType.TVS, PolygonType.HI].forEach { if $0.display {self.constructLevel3TextProduct($0)}}
                if PolygonType.SPOTTER.display {self.constructSpotters()}
                if PolygonType.OBS.display || PolygonType.WIND_BARB.display {UtilityMetar.getStateMetarArrayForWXOGL(self.rid)}
                if PolygonType.WIND_BARB.display {self.constructWBLines()}
                if PolygonType.SWO.display {
                    UtilitySWOD1.getSWO()
                    self.constructSWOLines()
                } else {
                    self.deconstructSWOLines()
                }
            }
            DispatchQueue.main.async {
                self.constructPolygons()
                self.showTimeToolbar(additionalText)
                self.showProductText(self.radarProduct)
            }
        }
    }

    func ridChanged(_ rid: String) {
        self.rid = rid
        zoom = 1.0
        x = 0.0
        y = 0.0
        loadGeometry()
        constructAlertPolygons()
        self.getRadar("")
    }

    func setZoom() {
        [hiBuffers, spotterBuffers, tvsBuffers, wbCircleBuffers, locdotBuffers].forEach {
            $0.lenInit = scaleLength($0.type.size)
            $0.draw(pn)
        }
        if locdotBuffers.isInitialized && RadarPreferences.locdotFollowsGps {
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            UtilityWXOGLPerf.genCircleLocdot(locCircleBuffers, pn, gpsLocation)
        }
        gl.setNeedsDisplay()
    }

    func constructPolygons() {
        self.radarBuffers.rd = WXGLNexradLevelData(self.radarProduct, self.radarBuffers, self.idxStr)
        self.radarBuffers.rd.decode()
        self.radarBuffers.initialize()
        switch self.radarBuffers.rd.productCode {
        case 153, 154, 30, 56: self.totalBins = UtilityWXOGLPerf.genRadials(self.radarBuffers)
        case 0: break
        default: self.totalBins = UtilityWXOGLPerf.decode8BitAndGenRadials(self.radarBuffers)
        }
        self.breakSize15 = 15000
        self.chunkCount = 1
        if self.totalBins<self.breakSize15 {
            self.breakSize15 = self.totalBins
        } else {
            self.chunkCount = self.totalBins/self.breakSize15
            self.chunkCount += 1
        }
        self.radarBuffers.setToPositionZero()
        self.totalBinsOgl = self.totalBins
        parent?.updateColorLegend()
        gl.setNeedsDisplay()
    }

    func constructLevel3TextProduct(_ type: PolygonType) {
        switch type.string {
        case "HI": constructHI()
        case "TVS": constructTVS()
        case "STI": constructSTILines()
        default: break
        }
    }

    func constructSTILines() {
        fSti = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, stiBaseFn + idxStr)
        constructGenericLinesShort(stiBuffers, fSti)
    }

    func constructTVS() {
        tvsBuffers.lenInit = tvsBuffers.type.size
        let stormList = WXGLNexradLevel3TVS.decocodeAndPlotNexradTVS(pn, tvsBaseFn + idxStr)
        tvsBuffers.setXYList(stormList)
        constructTriangles(tvsBuffers)
    }

    func constructHI() {
        hiBuffers.lenInit = hiBuffers.type.size
        let stormList = WXGLNexradLevel3HailIndex.decocodeAndPlotNexradHailIndex(pn, hiBaseFn + idxStr)
        hiBuffers.setXYList(stormList)
        constructTriangles(hiBuffers)
    }

    func constructSpotters() {
        spotterBuffers.isInitialized = false
        spotterBuffers.lenInit = spotterBuffers.type.size
        spotterBuffers.triangleCount = 6
        _ = UtilitySpotter.getSpotterData()
        spotterBuffers.latList = UtilitySpotter.lat
        spotterBuffers.lonList = UtilitySpotter.lon
        constructTriangles(spotterBuffers)
    }

    func showTimeToolbar(_ additionalText: String) {
        var timeStr = preferences.getString("WX_RADAR_CURRENT_INFO", "").split(" ")
        if timeStr.count>1 {
            let text = timeStr[1].replace(MyApplication.newline + "Mode:", "") + additionalText
            timeButton.title = text
        } else {
            timeButton.title = ""
        }
    }

    func showProductText(_ product: String) {
        productButton.title = product
    }

    func constructWBLines() {
        let fWb = WXGLNexradLevel3WindBarbs.decocodeAndPlot(pn, isGust: false)
        constructGenericLinesShort(wbBuffers, fWb)
        constructWBLinesGusts()
        constructWBCircle()
    }

    func constructWBLinesGusts() {
        fWbGusts = WXGLNexradLevel3WindBarbs.decocodeAndPlot(pn, isGust: true)
        constructGenericLinesShort(wbGustsBuffers, fWbGusts)
    }

    func deconstructWBLines() {
        wbBuffers.isInitialized = false
        deconstructWBLinesGusts()
        deconstructWBCircle()
    }

    func deconstructWBLinesGusts() {wbGustsBuffers.isInitialized = false}

    func constructWBCircle() {
        wbCircleBuffers.lenInit = PolygonType.WIND_BARB.size
        wbCircleBuffers.latList = UtilityMetar.obsArrX
        wbCircleBuffers.lonList = UtilityMetar.obsArrY
        wbCircleBuffers.colorIntArray = UtilityMetar.getObsArrAviationColor()
        wbCircleBuffers.setCount(wbCircleBuffers.latList.count)
        wbCircleBuffers.triangleCount = 6
        wbCircleBuffers.initialize(24 * wbCircleBuffers.count * wbCircleBuffers.triangleCount,
                                   12 * wbCircleBuffers.count * wbCircleBuffers.triangleCount, 9 * wbCircleBuffers.count * wbCircleBuffers.triangleCount)
        wbCircleBuffers.lenInit = scaleLength(wbCircleBuffers.lenInit)
        ObjectOglBuffers.redrawCircleWithColor(wbCircleBuffers, pn)
        wbCircleBuffers.isInitialized = true
    }

    func deconstructWBCircle() {
        wbCircleBuffers.isInitialized = false
    }

    func constructSWOLines() {
        colorSwo = []
        colorSwo.append(Color.MAGENTA)
        colorSwo.append(Color.RED)
        colorSwo.append(wXColor.colorsToInt(255, 140, 0))
        colorSwo.append(Color.YELLOW)
        colorSwo.append(wXColor.colorsToInt(0, 100, 0))
        var tmpCoords = (0.0, 0.0)
        var fSize = 0
        (0...4).forEach {
            if let flArr = UtilitySWOD1.hashSwo[$0] {fSize += flArr.count}
        }
        swoBuffers.breakSize = 15000
        swoBuffers.chunkCount = 1
        let totalBinsSwo: Int = fSize / 4
        swoBuffers.initialize(4 * 4 * totalBinsSwo, 0, 3 * 2 * totalBinsSwo)
        if totalBinsSwo < swoBuffers.breakSize {
            swoBuffers.breakSize = totalBinsSwo
        } else {
            swoBuffers.chunkCount = (totalBinsSwo/swoBuffers.breakSize)
            swoBuffers.chunkCount += 1
        }
        (0...4).forEach { z in
            if let flArr = UtilitySWOD1.hashSwo[z] {
                stride(from: 0, to: flArr.count-1, by: 4).forEach { j in
                    (0...1).forEach {_ in
                        self.swoBuffers.colorBuffer.put(Color.red(self.colorSwo[z]))
                        self.swoBuffers.colorBuffer.put(Color.green(self.colorSwo[z]))
                        self.swoBuffers.colorBuffer.put(Color.blue(self.colorSwo[z]))
                    }
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(Double(flArr[j]), Double(flArr[j+1]) * -1.0, pn)
                    swoBuffers.floatBuffer.putFloat(tmpCoords.0)
                    swoBuffers.floatBuffer.putFloat(tmpCoords.1 * -1.0)
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(Double(flArr[j+2]), Double(flArr[j+3]) * -1.0, pn)
                    swoBuffers.floatBuffer.putFloat(tmpCoords.0)
                    swoBuffers.floatBuffer.putFloat(tmpCoords.1 * -1.0)
                }
            }
        }
    }

    func deconstructSWOLines() {
        swoBuffers.isInitialized = false
    }

    func drawElement(_ buffers: ObjectOglBuffers) {
        if buffers.isInitialized {
            (0..<buffers.chunkCount).forEach {
                if $0 < (buffers.chunkCount - 1) {
                    lineCnt = breakSizeLine * 2
                } else {
                    lineCnt = 2 * (buffers.count / 4 - ($0 * breakSizeLine))
                }
                buffers.floatBuffer.position = $0 * 480000
                buffers.colorBuffer.position = $0 * 240000
                lineIndexBuffer.position = 0
                glVertexAttribPointer(positionHandle, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, buffers.floatBuffer.address)
                glVertexAttribPointer(colorHandle, 3, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, buffers.colorBuffer.array)
                glDrawElements(GLenum(GL_LINES), GLsizei(lineCnt-1), GLenum(GL_UNSIGNED_SHORT), lineIndexBuffer.array)
            }
        }
    }

    func constructGenericGeographic(_ buffers: ObjectOglBuffers) {
        buffers.setCount(buffers.geotype.count)
        buffers.breakSize = 30000
        if !buffers.isInitialized {
            buffers.initialize(4 * buffers.count, 0, 3 * buffers.breakSize * 2, buffers.geotype.color)
            UtilityWXOGLPerf.colorGen(buffers.colorBuffer, buffers.breakSize * 2, buffers.getColorArray())
            buffers.isInitialized = true
        }
        JNI_GenMercato(MemoryBuffer.getPointer(buffers.geotype.relativeBuffer.array),
                       MemoryBuffer.getPointer(buffers.floatBuffer.array), pn.xFloat,
                       pn.yFloat, pn.xCenterFloat, pn.yCenterFloat, pn.oneDegreeScaleFactorFloat, Int32(buffers.count))
        buffers.setToPositionZero()
        buffers.computeBreakSize()
    }

    func drawPolygons(_ buffers: ObjectOglBuffers, _ countDivisor: Int) {
        (0..<buffers.chunkCount).forEach { _ in
            buffers.setToPositionZero()
            lineIndexBuffer.position = 0
            glVertexAttribPointer(positionHandle, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, buffers.floatBuffer.address)
            glVertexAttribPointer(colorHandle, 3, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, buffers.colorBuffer.address)
            glDrawElements(GLenum(GL_LINES), GLsizei(buffers.floatBuffer.capacity/countDivisor), GLenum(GL_UNSIGNED_SHORT), lineIndexBuffer.array)
        }
    }

    func constructGenericLines(_ buffers: ObjectOglBuffers) {
        var fList = [Double]()
        switch buffers.type.string {
        case "MCD": fList = UtilityWat.addWat(pn, buffers.type)
        case "MPD": fList = UtilityWat.addWat(pn, buffers.type)
        case "WATCH": fList = UtilityWat.addWat(pn, buffers.type)
        case "WATCH_TORNADO": fList = UtilityWat.addWat(pn, buffers.type)
        case "TST": fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "TOR": fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "FFW": fList = WXGLPolygonWarnings.addWarnings(pn, buffers.type)
        case "STI": fList = WXGLNexradLevel3StormInfo.decocodeAndPlotNexradStormMotion(pn, idxStr)
        default: break
        }
        buffers.breakSize = 15000
        buffers.chunkCount = 1
        let totalBinsGeneric: Int = fList.count / 4
        var remainder: Int
        if totalBinsGeneric < buffers.breakSize {
            buffers.breakSize = totalBinsGeneric
            remainder = buffers.breakSize
        } else {
            buffers.chunkCount = (totalBinsGeneric / buffers.breakSize)
            remainder = totalBinsGeneric - buffers.breakSize * buffers.chunkCount
            buffers.chunkCount += 1
        }
        buffers.initialize(4 * 4 * totalBinsGeneric, 0, 3 * 4 * totalBinsGeneric, buffers.type.color)
        UtilityWXOGLPerf.colorGen(buffers.colorBuffer, 4 * totalBinsGeneric, buffers.getColorArray())
        var vList = 0
        (0..<buffers.chunkCount).forEach {
            if $0 == (buffers.chunkCount - 1) {
                buffers.breakSize = remainder
            }
            (0..<buffers.breakSize).forEach { _ in
                buffers.putFloat(fList[vList])
                buffers.putFloat(fList[vList+1] * -1)
                buffers.putFloat(fList[vList+2])
                buffers.putFloat(fList[vList+3] * -1)
                vList += 4
            }
        }
        buffers.isInitialized = true
    }

    func constructGenericLinesShort(_ buffers: ObjectOglBuffers, _ f: [Double]) {
        var remainder: Int
        buffers.initialize(4 * 4 * f.count, 0, 3 * 4 * f.count, buffers.type.color)
        UtilityWXOGLPerf.colorGen(buffers.colorBuffer, 4 * f.count, buffers.getColorArray())
        buffers.breakSize = 15000
        buffers.chunkCount = 1
        let totalBinsSti: Int = f.count / 4
        if totalBinsSti < buffers.breakSize {
            buffers.breakSize = totalBinsSti
            remainder = buffers.breakSize
        } else {
            buffers.chunkCount = totalBinsSti / buffers.breakSize
            remainder = totalBinsSti - buffers.breakSize * buffers.chunkCount
            buffers.chunkCount += 1
        }
        var vList = 0
        (0..<buffers.chunkCount).forEach {
            if $0 == (buffers.chunkCount - 1) {
                buffers.breakSize = remainder
            }
            (0..<buffers.breakSize).forEach { _ in
                buffers.putFloat(f[vList])
                buffers.putFloat(f[vList+1] * -1.0)
                buffers.putFloat(f[vList+2])
                buffers.putFloat(f[vList+3] * -1.0)
                vList += 4
            }
        }
        buffers.isInitialized = true
    }

    func drawTriangles(_ buffers: ObjectOglBuffers) {
        if buffers.isInitialized {
            buffers.setToPositionZero()
            glVertexAttribPointer(positionHandle, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, buffers.floatBuffer.address)
            glVertexAttribPointer(colorHandle, 3, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, buffers.colorBuffer.address)
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(buffers.floatBuffer.capacity/8), GLenum(GL_UNSIGNED_SHORT), buffers.indexBuffer.array)
        }
    }

    func constructTriangles(_ buffers: ObjectOglBuffers) {
        buffers.setCount(buffers.latList.count)
        switch buffers.type.string {
        case "LOCDOT": buffers.initialize(24 * buffers.count * buffers.triangleCount, 12 * buffers.count * buffers.triangleCount, 9 * buffers.count * buffers.triangleCount, buffers.type.color)
        case "SPOTTER": buffers.initialize(24 * buffers.count * buffers.triangleCount, 12 * buffers.count * buffers.triangleCount, 9 * buffers.count * buffers.triangleCount, buffers.type.color)
        default: buffers.initialize(4 * 6 * buffers.count, 4 * 3 * buffers.count, 9 * buffers.count, buffers.type.color)
        }
        buffers.lenInit = scaleLength(buffers.lenInit)
        buffers.draw(pn)
        buffers.isInitialized = true
    }

    func scaleLength(_ currentLength: Double) -> Double {
        if zoom > 1.01 {
            return (currentLength / zoom) * 2
        } else {return currentLength}
    }

    var oldZoom: Double {
        get {return Double(oldScale)}
        set {self.oldScale = Float(newValue)}
    }

    var zoom: Double {
        get {return Double(scaleFactor)}
        set {self.scaleFactor = Float(newValue)}
    }

    var x: Float {
        get {return positionX}
        set {positionX = newValue}
    }

    var y: Float {
        get {return positionY}
        set {positionY = newValue}
    }

    var rid: String {
        get {return ridStr}
        set {
            self.ridStr = newValue
            checkIfTDWR()
        }
    }

    var product: String {
        get {return radarProduct}
        set {
            self.radarProduct = newValue
            checkIfTDWR()
        }
    }

    var oneDegreeScaleFactor: Double {return pn.oneDegreeScaleFactor}

    func setParent(_ parent: WXOGLOpenGLMultiPane?) {self.parent = parent}

    func setView(_ zoom: Double, _ x: Double, _ y: Double) {
        self.zoom *= zoom
        self.x *= Float(x)
        self.y *= Float(y)
    }

    func setView(_ multiplier: Double) {
        self.zoom *= multiplier
        self.x *= Float(multiplier)
        self.y *= Float(multiplier)
    }

    func setView(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }

    func setView() {
        self.zoom = 1.0
        self.x = 0.0
        self.y = 0.0
    }

    func setViewInitial(_ zoom: Double, _ x: Float, _ y: Float) {
        self.zoom = zoom
        self.x = x
        self.y = y
    }

    func checkIfTDWR() {
        let ridIsTdwr = WXGLNexrad.isRidTdwr(self.rid)
        if self.product=="TV0" || self.product=="TZL" {
            self.TDWR = true
        } else {self.TDWR = false}
        if (self.product=="N0Q"||self.product=="N1Q"||self.product=="N2Q"||self.product=="N3Q"||self.product=="L2REF") && ridIsTdwr {
            self.radarProduct = "TZL"
            self.TDWR = true
        }
        if self.product=="TZL" && !ridIsTdwr {
            self.radarProduct = "N0Q"
            self.TDWR = false
        }
        if (self.product=="N0U"||self.product=="N1U"||self.product=="N2U"||self.product=="N3U"||self.product=="L2VEL") && ridIsTdwr {
            self.radarProduct = "TV0"
            self.TDWR = true
        }
        if self.product=="TV0" && !ridIsTdwr {
            self.radarProduct = "N0U"
            self.TDWR = false
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
        if status == 0 {return false}
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
        if status == 0 {returnVal = false}
        return returnVal
    }
}
