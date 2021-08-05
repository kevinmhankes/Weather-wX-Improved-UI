// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class FileStorage {
    
    var memoryBuffer = MemoryBuffer()
    var memoryBufferL2 = MemoryBuffer()
    var level3TextProductMap = [String: String]()
    var animationMemoryBuffer = [MemoryBuffer]()
    var animationMemoryBufferL2 = [MemoryBuffer]()
    var stiList = [Double]()
    var hiData = [Double]()
    var tvsData = [Double]()
    var radarInfo = ""
    var radarDate = ""
    var radarVcp = ""
    var radarAgeMilli: Int64 = 0
    // wind barbs
    var obsArr = [String]()
    var obsArrExt = [String]()
    var obsArrWb = [String]()
    var obsArrWbGust = [String]()
    var obsArrX = [Double]()
    var obsArrY = [Double]()
    var obsArrAviationColor = [Int]()
    var obsOldRadarSite = ""
    var obsDownloadTimer = DownloadTimer("OBS_AND_WIND_BARBS" + String(UtilityTime.currentTimeMillis()))
    
    func setMemoryBufferForL3TextProducts(_ product: String, _ byteArray: Data) {
        var data = ""
        if let retStr1 = String(data: byteArray, encoding: .ascii) {
            data = retStr1
        }
        level3TextProductMap[product] = data
    }
}
