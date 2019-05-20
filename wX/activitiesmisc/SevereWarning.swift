/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {

    var text = ""
    private var type = ""
    private var count = 0

    init(_ type: String) {
        self.type = type
    }

    func generateString(_ html: String) {
        var nwsOfficeArr = [String]()
        var nwsOffice = ""
        var nwsLoc = ""
        let warningArr = textTor.parseColumn(WXGLPolygonWarnings.pVtec)
        warningArr.forEach {
            count += 1
            text += $0
            nwsOfficeArr = $0.split(".")
            if nwsOfficeArr.count > 1 {
                nwsOffice = nwsOfficeArr[2]
                nwsOffice = nwsOffice.replaceAllRegexp("^[KP]", "")
                nwsLoc = Utility.readPref("NWS_LOCATION_" + nwsOffice, "")
            }
            text += "  " + nwsLoc + MyApplication.newline
        }
    }
}
