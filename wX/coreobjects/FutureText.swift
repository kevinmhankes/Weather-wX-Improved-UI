/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class FutureText {
    
    private let arg1: String
    private let updateFunc: (String) -> Void

    init(_ arg1: String, _ updateFunc: @escaping (String) -> Void) {
        self.arg1 = arg1
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            let s = UtilityDownload.getTextProduct(self.arg1)
            DispatchQueue.main.async { self.updateFunc(s) }
        }
    }
}
