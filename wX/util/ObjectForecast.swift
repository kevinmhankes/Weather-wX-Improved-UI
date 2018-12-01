/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectForecast {

    var name = ""
    private var temperature = ""
    private var windSpeed = ""
    private var windDirection = ""
    private var icon = ""
    private var shortForecast = ""
    var detailedForecast = ""

    init(_ name: String, _ temperature: String, _ windSpeed: String, _ windDirection: String,
         _ icon: String, _ shortForecast: String, _ detailedForecast: String) {
        self.name = name
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.icon = icon
        self.shortForecast = shortForecast
        self.detailedForecast = detailedForecast
    }
}
