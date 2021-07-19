/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityWXMetalPerfL2 {

    private static let fileHeaderSize = 24

    static func decompress (_ radarBuffers: ObjectMetalRadarBuffers, _ fileStorage: FileStorage) {
        let destinationPath = radarBuffers.fileName + ".decomp" + radarBuffers.rd.index
        // let disFirst = UtilityIO.readFileToByteBuffer(radarBuffers.fileName)
        
        let disFirst: MemoryBuffer
        if RadarPreferences.useFileStorage {
            disFirst = fileStorage.memoryBuffer
        } else {
            disFirst = UtilityIO.readFileToByteBuffer(radarBuffers.fileName)
        }
        disFirst.position = 0
        
        let refDecompSize = 827040
        let velDecompSize = 460800
        var loopCnt = 0
        var bytesWritten = 0
        let bytesWritten2 = 0
        UtilityFileManagement.deleteFile(destinationPath)
        let fileURL = UtilityFileManagement.getFullPathUrl(destinationPath)
        disFirst.skipBytes(fileHeaderSize)
        if let outputStream = OutputStream(url: fileURL, append: true) {
            outputStream.open()
            let bytesWritten = outputStream.write(UnsafePointer(disFirst.array), maxLength: fileHeaderSize)
            if bytesWritten < 0 {
                print("write failure")
            }
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        let loopCntBreak = radarBuffers.rd.productCode == 153 ? 5 : 11
        let outputBufferSize: UInt32 = 2000000
        var retSize: UInt32 = 2000000
        let oBuff = [UInt8](repeating: 1, count: Int(outputBufferSize))
        while !disFirst.eof {
            var numCompBytes = disFirst.getInt()
            if numCompBytes == -1 || numCompBytes == 0 {
                break
            }
            if numCompBytes < 0 {
                numCompBytes = -numCompBytes
            }
            retSize = outputBufferSize
            BZ2_bzBuffToBuffDecompress(
                MemoryBuffer.getPointer(oBuff),
                &retSize,
                MemoryBuffer.getPointerAndAdvance(disFirst.array, by: disFirst.position),
                UInt32(numCompBytes),
                1,
                0
            )
            disFirst.skipBytes(numCompBytes)
            let size = Int(retSize)
            if let outputStream = OutputStream(url: fileURL, append: true) {
                outputStream.open()
                let bytesWritten = outputStream.write(UnsafePointer(oBuff), maxLength: size)
                if bytesWritten < 0 {
                    print("write failure")
                }
                outputStream.close()
            } else {
                print("Unable to open file")
            }
            bytesWritten = bytesWritten2 + bytesWritten
            if bytesWritten2 == refDecompSize || bytesWritten2 == velDecompSize {
                loopCnt += 1
            }
            if loopCnt > loopCntBreak {
                break
            }
        }
    }
}
