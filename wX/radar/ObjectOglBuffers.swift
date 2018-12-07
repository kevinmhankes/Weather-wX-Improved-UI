/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class ObjectOglBuffers {

    var floatBuffer = MemoryBuffer()
    var indexBuffer = MemoryBuffer()
    var colorBuffer = MemoryBuffer()
    var colorIntArray = [Int]()
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var breakSize = 30000
    var chunkCount = 0
    var count = 0
    private var initialized = false
    var lenInit = 7.5
    var latList = [Double]()
    var lonList = [Double]()
    var triangleCount = 0
    var scaleCutOff: Float = 0.0
    var type: PolygonType = .NONE
    var geotype: GeographyType = .NONE

    init() {}

    convenience init (_ type: PolygonType) {
        self.init()
        self.type = type
    }

    convenience init (scaleCutOff: Float) {
        self.init()
        self.scaleCutOff = scaleCutOff
    }

    convenience init (_ geotype: GeographyType, scaleCutOff: Float) {
        self.init()
        self.geotype = geotype
        self.scaleCutOff = scaleCutOff
    }

    func initialize(_ floatCount: Int, _ indexCount: Int, _ colorCount: Int) {
        floatBuffer = MemoryBuffer(floatCount)
        indexBuffer = MemoryBuffer(indexCount)
        colorBuffer = MemoryBuffer(colorCount)
        setToPositionZero()
    }

    func initialize(_ floatCount: Int, _ indexCount: Int, _ colorCount: Int, _ solidColor: Int) {
        self.initialize(floatCount, indexCount, colorCount)
        red = Color.red(solidColor)
        green = Color.green(solidColor)
        blue = Color.blue(solidColor)
    }

    func setToPositionZero() {
        floatBuffer.position = 0
        indexBuffer.position = 0
        colorBuffer.position = 0
    }

    func putFloat(_ newValue: Float) {
        floatBuffer.putFloat(newValue)
    }

    func putFloat(_ newValue: Double) {
        floatBuffer.putFloat(Float(newValue))
    }

    func putIndex(_ newValue: UInt16) {
        indexBuffer.putShort(newValue)
    }

    func putColor(_ byte: UInt8) {
        colorBuffer.put(byte)
    }

    func getColorArray() -> [UInt8] {
        return [red, green, blue]
    }

    func setCount(_ count: Int) {
        self.count = count
        chunkCount = 1
        let totalBinsCounty: Int = count / 4
        if totalBinsCounty < breakSize {
            breakSize = totalBinsCounty
        } else if breakSize != 0 {
            chunkCount = totalBinsCounty / breakSize
            chunkCount += 1
        }
    }

    func computeBreakSize() {
        chunkCount = 1
        let totalBinsCounty: Int = count / 4
        if totalBinsCounty < breakSize {
            breakSize = totalBinsCounty
        } else {
            chunkCount = totalBinsCounty / breakSize
            chunkCount += 1
        }
    }

    var isInitialized: Bool {
        get {return initialized}
        set {
            initialized = newValue
            if !initialized {chunkCount = 0}
        }
    }

    func setXYList(_ combinedLatLonList: [Double]) {
        latList = [Double](repeating: 0, count: combinedLatLonList.count/2)
        lonList = [Double](repeating: 0, count: combinedLatLonList.count/2)
        for index in stride(from: 0, to: combinedLatLonList.count, by: 2) {
            latList[index/2] = combinedLatLonList[index]
            lonList[index/2] = combinedLatLonList[index+1]
        }
    }

    func draw(_ pn: ProjectionNumbers) {
        switch type.string {
        case "HI": ObjectOglBuffers.redrawTriangleUp(self, pn)
        case "SPOTTER": ObjectOglBuffers.redrawCircle(self, pn)
        case "TVS": ObjectOglBuffers.redrawTriangleUp(self, pn)
        case "LOCDOT": ObjectOglBuffers.redrawCircle(self, pn)
        case "WIND_BARB_CIRCLE": ObjectOglBuffers.redrawCircleWithColor(self, pn)
        default:  ObjectOglBuffers.redrawTriangle(self, pn)
        }
    }

    class func redrawTriangle(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        UtilityWXOGLPerf.genTriangle(buffers, pn)
    }

    class func redrawTriangleUp(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        UtilityWXOGLPerf.genTriangleUp(buffers, pn)
    }

    class func redrawCircle(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        UtilityWXOGLPerf.genCircle(buffers, pn)
    }

    class func redrawCircleWithColor(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        UtilityWXOGLPerf.genCircleWithColor(buffers, pn)
    }
}
