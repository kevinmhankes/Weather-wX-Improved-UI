// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class RadarGeometryFile {
    
    let fileID: String
    let count: Int
    let bb: MemoryBuffer
    let pref: Bool
    let addData: Bool

    init(_ fileID: String, _ count: Int, _ bb: MemoryBuffer, _ pref: Bool, _ addData: Bool) {
        self.bb = bb
        self.fileID = fileID
        self.count = count
        self.pref = pref
        self.addData = addData
    }
}
