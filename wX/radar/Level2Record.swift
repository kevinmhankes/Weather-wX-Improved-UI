/*
 * Copyright 1998-2009 University Corporation for Atmospheric Research/Unidata
 *
 * Portions of this software were developed by the Unidata Program at the
 * University Corporation for Atmospheric Research.
 *
 * Access and use of this software shall impose the following obligations
 * and understandings on the user. The user is granted the right, without
 * any fee or cost, to use, copy, modify, alter, enhance and distribute
 * this software, and any derivative works thereof, and its supporting
 * documentation for any purpose whatsoever, provided that this entire
 * notice appears in all copies of the software, derivative works and
 * supporting documentation.  Further, UCAR requests that the user credit
 * UCAR/Unidata in any publications that result from the use of this
 * software or in any product that includes this software. The names UCAR
 * and/or Unidata, however, may not be used in any advertising or publicity
 * to endorse or promote any products or commercial entity unless specific
 * written permission is obtained from UCAR/Unidata. The user also
 * understands that UCAR/Unidata is not obligated to provide the user with
 * any support, consulting, training or assistance of any kind with regard
 * to the use, operation and performance of this software nor to provide
 * the user with any updates, revisions, new versions or "bug fixes."
 *
 * THIS SOFTWARE IS PROVIDED BY UCAR/UNIDATA "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL UCAR/UNIDATA BE LIABLE FOR ANY SPECIAL,
 * INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
 * FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
 * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
 * WITH THE ACCESS, USE OR PERFORMANCE OF THIS SOFTWARE.
 */

// Note, this software was ported from the Java version and thus I am retaining the copyright of the Java version

import Foundation

final public class Level2Record {

    /* added for high resolution message type 31 */
    static let reflectivityHigh = 5

    /**
     * High Resolution Radial Velocity moment identifier
     */
    static let velocityHigh = 6

    /**
     * Size of the CTM record header
     */
    static let ctmHeaderSize = 12

    /**
     * Size of the the message header, to start of the data message
     */
    static let messageHeaderSize = 28

    /**
     * Size of the entire message, if its a radar data message
     */
    static let radarDataSize = 2432

    /**
     * Size of the file header, aka title
     */
    static let fileHeaderSize = 24

    var messageOffset: CLong = 0 // offset of start of message
    var hasHighResREFData = false
    var hasHighResVELData = false

    // message header
    var messageSize: Int16 = 0
    var messageType: Int8 = 0
    var dataMsecs = 0
    var dataJulianDate: Int16  = 0
    var elevationNum: Int16  = 0
    var vcp: Int16  = 0
    var azimuth: Float = 0.0
    var dbp1 = 0
    var dbp4 = 0
    var dbp5 = 0
    var dbp6 = 0
    var dbp7 = 0
    var dbp8 = 0
    var dbp9 = 0
    var reflectHROffset: Int16 = 0
    var velocityHROffset: Int16 = 0

    static func factory(_ din: MemoryBuffer, _ record: Int, _  messageOffset31: CLong) -> Level2Record? {
        let offset: CLong = record * radarDataSize + fileHeaderSize + messageOffset31
        if offset >= din.length {
            return nil
        } else {
            return Level2Record(din, record, messageOffset31)
        }
    }

    init() {}

    init(_ din: MemoryBuffer, _ record: Int, _ messageOffset31: CLong) {
        messageOffset = record * Level2Record.radarDataSize + Level2Record.fileHeaderSize + messageOffset31
        din.seek(messageOffset)
        din.skipBytes(Level2Record.ctmHeaderSize)
        messageSize = din.getShort() // size in "halfwords" = 2 bytes
        din.skipBytes(1)
        messageType = Int8(bitPattern: UInt8(din.get()))
        din.skipBytes(12)
        if messageType == 1 {
            dataMsecs = din.getInt()
            dataJulianDate = din.getShort()
            din.skipBytes(10)
            elevationNum = din.getShort()
            din.skipBytes(26)
            vcp = din.getShort()
            din.skipBytes(20)
        } else if messageType == 31 {
            din.skipBytes(4)
            dataMsecs = din.getInt()
            dataJulianDate = din.getShort()
            din.skipBytes(2)
            azimuth = din.getFloat()
            din.skipBytes(6)
            elevationNum = Int16(din.get())
            din.skipBytes(9)
            dbp1 = din.getInt()
            din.skipBytes(8)
            dbp4 = din.getInt()
            dbp5 = din.getInt()
            dbp6 = din.getInt()
            dbp7 = din.getInt()
            dbp8 = din.getInt()
            dbp9 = din.getInt()
            vcp = getDataBlockValue(din, Int16(dbp1), 40)
            var dbpp4 = 0
            var dbpp5 = 0
            if dbp4 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp4), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp4
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp4
                }
            }
            if dbp5 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp5), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp5
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp5
                }
            }
            if dbp6 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp6), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp6
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp6
                }
            }
            if dbp7 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp7), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp7
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp7
                }
            }
            if dbp8 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp8), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp8
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp8
                }
            }
            if dbp9 > 0 {
                let tname = getDataBlockStringValue(din, Int16(dbp9), 1, 3)
                if tname.hasPrefix("REF") {
                    hasHighResREFData = true
                    dbpp4 = dbp9
                } else if tname.hasPrefix("VEL") {
                    hasHighResVELData = true
                    dbpp5 = dbp9
                }
            }
            if hasHighResREFData {
                reflectHROffset = Int16(dbpp4 + 28)
            }
            if hasHighResVELData {
                velocityHROffset = Int16(dbpp5 + 28)
            }
        }
    }

    func getDataOffset(datatype: Int) -> Int16 {
        switch datatype {
        case Level2Record.reflectivityHigh: return reflectHROffset
        case Level2Record.velocityHigh: return velocityHROffset
        default: break
        }
        return -32767 // Java Short.MIN_VALUE
    }

    func getDataBlockValue(_ raf: MemoryBuffer, _ offset: Int16, _ skip: Int) -> Int16 {
        let off: CLong = Int(offset) + messageOffset + Level2Record.messageHeaderSize
        raf.seek(off)
        raf.skipBytes(skip)
        return raf.getShort()
    }

    func getDataBlockStringValue(_ raf: MemoryBuffer, _ offset: Int16, _ skip: Int, _ size: Int) -> String {
        let off: CLong = Int(offset) + messageOffset + Level2Record.messageHeaderSize
        raf.seek(off)
        raf.skipBytes(skip)
        var bytes: [UInt8] = []
        (0..<size).forEach {_ in bytes.append(raf.get())}
        return String(bytes: bytes, encoding: String.Encoding.utf8)!
    }

    func readData(_ raf: MemoryBuffer, _ datatype: Int, _ binWord: MemoryBuffer) {
        var offset: CLong = messageOffset
        offset += Level2Record.messageHeaderSize
        offset += Int(getDataOffset(datatype: datatype))
        raf.seek(offset)
        (0..<916).forEach {_ in binWord.put(UInt8(raf.get()))}
    }
}
