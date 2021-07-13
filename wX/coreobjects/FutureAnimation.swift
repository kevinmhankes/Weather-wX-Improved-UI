/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class FutureAnimation {
    
    private let downloadFunc: () -> AnimationDrawable
    private let updateFunc: (AnimationDrawable) -> Void

    init(_ downloadFunc: @escaping () -> AnimationDrawable, _ updateFunc: @escaping (AnimationDrawable) -> Void) {
        self.downloadFunc = downloadFunc
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            let animationDrawable = downloadFunc()
            DispatchQueue.main.async { self.updateFunc(animationDrawable) }
        }
    }
}
