/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class FutureBytes {
    
    private let url: String
    private let updateFunc: (Bitmap) -> Void

    init(_ url: String, _ updateFunc: @escaping (Bitmap) -> Void) {
        self.url = url
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(self.url)
            DispatchQueue.main.async { self.updateFunc(bitmap) }
        }
    }
}
