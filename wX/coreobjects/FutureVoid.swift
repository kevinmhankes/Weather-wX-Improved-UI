// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class FutureVoid {
    
    private let downloadFunc: () -> Void
    private let updateFunc: () -> Void

    init(_ downloadFunc: @escaping () -> Void, _ updateFunc: @escaping () -> Void) {
        self.downloadFunc = downloadFunc
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            self.downloadFunc()
            DispatchQueue.main.async { self.updateFunc() }
        }
    }
}
