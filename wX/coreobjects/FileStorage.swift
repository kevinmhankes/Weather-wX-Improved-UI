/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class FileStorage {
    

}

//class FileStorage:
//    def __init__(self) -> None:
//        self.byteArray: bytes = b""
//        self.memoryBuffer: MemoryBuffer = MemoryBuffer(0)
//        self.level3TextProductMap: Dict[str, str] = {}
//        self.animationByteArray: List[array] = []
//        self.animationMemoryBuffer: List[MemoryBuffer] = []
//        self.stiList: List[float] = []
//        self.hiData: List[float] = []
//        self.tvsData: List[float] = []
//        self.radarInfo: str = ""
//        self.radarDate: str = ""
//        self.radarVcp: str = ""
//        self.radarAgeMilli: int = 0
//        # wind barb
//        self.obsArr: List[str] = []
//        self.obsArrExt: List[str] = []
//        self.obsArrWb: List[str] = []
//        self.obsArrWbGust: List[str] = []
//        self.obsArrX: List[float] = []
//        self.obsArrY: List[float] = []
//        self.obsArrAviationColor: List[int] = []
//        self.obsOldRadarSite: str = ""
//        self.obsDownloadTimer: DownloadTimer = DownloadTimer("OBS_AND_WIND_BARBS" + to.StringFromFloat(UtilityTime.currentTimeMillis()))
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
