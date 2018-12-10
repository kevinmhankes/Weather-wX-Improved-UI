/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final public class StormReport {

    var text = ""
    var lat = ""
    var lon = ""
    private var time = ""
    private var state = ""

    init(_ text: String, _ lat: String, _ lon: String, _ time: String, _ state: String) {
        self.text = text
        self.lat = lat
        self.lon = lon
        self.time = time
        self.state = state
	  }
}
