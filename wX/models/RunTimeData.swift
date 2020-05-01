/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final public class RunTimeData {

    var listRun = [String]()
    var mostRecentRun = ""
    var imageCompleteInt = 0
    var imageCompleteStr = ""
    var timeStrConv = ""
    var validTime = ""

    func appendListRun(_ value: String) { listRun.append(value) }

    func appendListRun(_ values: [String]) { listRun += values }
}
