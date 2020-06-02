/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Metal

class ObjectMetalBuffers {
    
    var metalBuffer = [Float]()
    var floatBuffer = MemoryBuffer()
    var colorIntArray = [Int]()
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var count = 0
    var lenInit = 7.5
    var latList = [Double]()
    var lonList = [Double]()
    var triangleCount = 0
    var scaleCutOff: Float = 0.0
    var type: PolygonType = .NONE
    var typeEnum: PolygonEnum = .NONE
    var geoType: GeographyType = .NONE
    let floatCountPerVertex = 5 // x y r g b a ( last 4 bytes )
    var vertexCount = 0
    var mtlBuffer: MTLBuffer?
    var shape: MTLPrimitiveType = .triangle
    var honorDisplayHold = false
    
    init() {}
    
    convenience init (_ type: PolygonType) {
        self.init()
        self.type = type
        setTypeEnum()
        self.shape = .line
        if type.string == "WIND_BARB_CIRCLE" || type.string == "LOCDOT" || type.string == "SPOTTER" || type.string == "HI" || type.string == "TVS" {
            self.shape = .triangle
        }
    }
    
    convenience init (scaleCutOff: Float) {
        self.init()
        self.scaleCutOff = scaleCutOff
    }
    
    convenience init (_ geoType: GeographyType, _ scaleCutOff: Float) {
        self.init()
        self.geoType = geoType
        self.scaleCutOff = scaleCutOff
        self.shape = .line
    }
    
    convenience init (_ type: PolygonType, _ scaleCutOff: Float) {
        self.init()
        self.type = type
        setTypeEnum()
        self.scaleCutOff = scaleCutOff
        self.honorDisplayHold = true
        self.shape = .line
        if type.string == "WIND_BARB_CIRCLE" || type.string == "LOCDOT" || type.string == "SPOTTER" || type.string == "HI" || type.string == "TVS" {
            self.shape = .triangle
        }
        if type.string == "LOCDOT_CIRCLE" || type.string == "LOCDOT" { self.honorDisplayHold = false }
    }
    
    func setTypeEnum() {
        switch type.string {
        case "MCD":
            typeEnum = .SPCMCD
        case "MPD":
            typeEnum = .WPCMPD
        case "WATCH":
            typeEnum = .SPCWAT
        case "WATCH_TORNADO":
            typeEnum = .SPCWAT_TORNADO
        case "TOR":
            typeEnum = .TOR
        case "TST":
            typeEnum = .TST
        case "FFW":
            typeEnum = .FFW
        case "SMW":
            typeEnum = .SMW
        case "SQW":
            typeEnum = .SQW
        case "DSW":
            typeEnum = .DSW
        case "SPS":
            typeEnum = .SPS
        case "STI":
            typeEnum = .STI
        default:
            typeEnum = .NONE
        }
    }
    
    func generateMtlBuffer(_ device: MTLDevice) {
        if count > 0 {
            let dataSize = metalBuffer.count * MemoryLayout.size(ofValue: metalBuffer[0])
            mtlBuffer = device.makeBuffer(bytes: metalBuffer, length: dataSize, options: [])!
            if type.string == "LOCDOT" || type.string == "WIND_BARB_CIRCLE" || type.string == "SPOTTER" || type.string == "HI" || type.string == "TVS" {
                vertexCount = triangleCount * 3 * count
            } else {
                vertexCount = count / 2
            }
        } else {
            if type.string != "" { vertexCount = 0 }
        }
    }
    
    func initialize(_ floatCount: Int) {
        floatBuffer = MemoryBuffer(floatCount)
        metalBuffer = Array(repeating: 0.0, count: floatCountPerVertex * (count * 2)) // x y  r g b
        setToPositionZero()
    }
    
    func initialize(_ floatCount: Int, _ solidColor: Int) {
        self.initialize(floatCount)
        red = solidColor.red()
        green = solidColor.green()
        blue = solidColor.blue()
    }
    
    func setToPositionZero() {
        floatBuffer.position = 0
    }
    
    func putFloat(_ newValue: Float) {
        metalBuffer.append(newValue)
    }
    
    func putFloat(_ newValue: Double) {
        metalBuffer.append(Float(newValue))
    }
    
    func putColor(_ byte: UInt8) {
        metalBuffer.append(Float(Float(byte)/Float(255.0)))
    }
    
    func putColorFloat(_ color: Float) {
        metalBuffer.append(color)
    }
    
    func getColorArray() -> [UInt8] { [red, green, blue] }
    
    func getColorArrayInFloat() -> [Float] { [red.toColor(), green.toColor(), blue.toColor()] }
    
    func putColors() {
        putColor(red)
        putColor(green)
        putColor(blue)
    }
    
    func setCount(_ count: Int) {
        self.count = count
    }
    
    func setXYList(_ combinedLatLonList: [Double]) {
        latList = [Double](repeating: 0, count: combinedLatLonList.count / 2)
        lonList = [Double](repeating: 0, count: combinedLatLonList.count / 2)
        stride(from: 0, to: combinedLatLonList.count, by: 2).forEach { index in
            latList[index / 2] = combinedLatLonList[index]
            lonList[index / 2] = combinedLatLonList[index + 1]
        }
    }
    
    func draw(_ pn: ProjectionNumbers) {
        switch type.string {
        case "HI":
            ObjectMetalBuffers.redrawTriangleUp(self, pn)
        case "SPOTTER":
            ObjectMetalBuffers.redrawCircle(self, pn)
        case "TVS":
            ObjectMetalBuffers.redrawTriangleUp(self, pn)
        case "LOCDOT":
            ObjectMetalBuffers.redrawCircle(self, pn)
        case "WIND_BARB_CIRCLE":
            ObjectMetalBuffers.redrawCircleWithColor(self, pn)
        default:
            ObjectMetalBuffers.redrawTriangle(self, pn)
        }
    }
    
    static func redrawTriangle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genTriangle(buffers, pn)
    }
    
    static func redrawTriangleUp(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genTriangleUp(buffers, pn)
    }
    
    static func redrawCircle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genCircle(buffers, pn)
    }
    
    static func redrawCircleWithColor(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genCircleWithColor(buffers, pn)
    }
}
