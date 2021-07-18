/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class FileStorage {
    
    var memoryBuffer = MemoryBuffer()
    var level3TextProductMap = [String: String]()
    // var animationByteArray: List[array] = []
    var animationMemoryBuffer = [MemoryBuffer]()
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
    
}

//
//    def setMemoryBuffer(self, byteArrayF: bytes) -> None:
//        data: array = array("B")
//        data.frombytes(byteArrayF)
//        self.memoryBuffer.fromFile(data)
//
//    def setMemoryBufferForAnimation(self, index: int, byteArrayF: bytes) -> None:
//        data: array = array("B")
//        data.frombytes(byteArrayF)
//        # self.animationByteArray.insert(index, data)
//        self.animationByteArray[index] = data
//        # self.animationMemoryBuffer.insert(index, MemoryBuffer.fromArray(self.animationByteArray[index]))
//        self.animationMemoryBuffer[index] = MemoryBuffer.fromArray(self.animationByteArray[index])
//
//    def setMemoryBufferForL3TextProducts(self, product: str, byteArrayF: bytes) -> None:
//        dataAsQString: str = byteArrayF.decode('iso-8859-1')
//        self.level3TextProductMap[product] = dataAsQString
//
//    def clear(self):
//        self.animationMemoryBuffer.clear()
//        self.animationByteArray.clear()
