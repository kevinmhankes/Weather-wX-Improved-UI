/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityModelSpcSrefInputOutput {

    static let pattern1 = "([0-9]{10}z</a>&nbsp in through <b>f[0-9]{3})"
    static let pattern2 = "<tr><td class=.previous.><a href=sref.php\\?run=[0-9]{10}&id=SREF_H5__>([0-9]{10}z)</a></td></tr>"

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/exper/sref/").getHtml()
        var tmpTxt = html.parse(pattern1)
        let results = html.parseColumn(pattern2)
        let latestRun = tmpTxt.split("</a>")[0]
        runData.appendListRun(latestRun.replace("z", ""))
        results.forEach { runData.appendListRun($0.replace("z", "")) }
        tmpTxt = tmpTxt.parse(pattern1).parse("(f[0-9]{3})")
        runData.imageCompleteStr = tmpTxt
        if runData.listRun.count > 0 {
            runData.mostRecentRun = runData.listRun[0]
        }
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/exper/sref/gifs/" + om.run.replace("z", "") + "/" + om.param + "f0" + om.time + ".gif"
        return UtilityImg.getBitmapAddWhiteBackground(imgUrl)
    }
}
