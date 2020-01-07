/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectNhcStormInfo {

    var title = ""
    var summary = ""
    var url = ""
    var img1 = ""
    var img2 = ""
    var wallet = ""

    init(_ title: String, _ summary: String, _ url: String, _ img1: String, _ img2: String, _ wallet: String) {
        self.title = title
        self.summary = summary
        self.url = url
        self.img1 = img1
        self.img2 = img2
        self.wallet = wallet
    }
}
