// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class FutureBytes2 {
    
    private let downloadFunc: () -> Bitmap
    private let updateFunc: (Bitmap) -> Void

    init(_ downloadFunc: @escaping () -> Bitmap, _ updateFunc: @escaping (Bitmap) -> Void) {
        self.downloadFunc = downloadFunc
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = downloadFunc()
            DispatchQueue.main.async { self.updateFunc(bitmap) }
        }
    }
}
