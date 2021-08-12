// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class RadarGeometryFile {
    
    let fileName: String
    let count: Int
    let relativeBuffer: MemoryBuffer
    let showItem: Bool
    let fileAdd: Bool

    init(_ fileName: String, _ count: Int, _ relativeBuffer: MemoryBuffer, _ showItem: Bool, _ fileAdd: Bool) {
        self.relativeBuffer = relativeBuffer
        self.fileName = fileName
        self.count = count
        self.showItem = showItem
        self.fileAdd = fileAdd
    }
}
