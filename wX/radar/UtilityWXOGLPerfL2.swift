/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

class UtilityWXOGLPerfL2 {

    static let fileHeaderSize = 24

    static func level2Decompress (_ radarBuffers: ObjectOglRadarBuffers) {
        let destinationPath = radarBuffers.fileName + ".decomp" + radarBuffers.rd.index
        let disFirst = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        var loopCntBreak = 11
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
            if bytesWritten < 0 { print("write failure") }
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        if radarBuffers.rd.productCode == 153 {loopCntBreak = 5}
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
            BZ2_bzBuffToBuffDecompress(MemoryBuffer.getPointer(oBuff), &retSize,
                                       MemoryBuffer.getPointerAndAdvance(disFirst.array, by: disFirst.position),
                                       UInt32(numCompBytes), 1, 0)
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
            if loopCnt>loopCntBreak {
                break
            }
        }
    }
}
