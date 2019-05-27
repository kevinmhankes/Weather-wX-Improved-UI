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
        var wfos = [String]()
        var wfo = ""
        var location = ""
        let warnings = html.parseColumn(WXGLPolygonWarnings.vtecPattern)
        warnings.forEach {
            count += 1
            text += $0
            wfos = $0.split(".")
            if wfos.count > 1 {
                wfo = wfos[2]
                wfo = wfo.replaceAllRegexp("^[KP]", "")
                location = Utility.readPref("NWS_LOCATION_" + wfo, "")
            }
            text += "  " + location + MyApplication.newline
        }
    }
}
