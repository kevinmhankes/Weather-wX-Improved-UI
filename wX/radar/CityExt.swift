/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class CityExt {

    let name: String
    let latitude: Double
    let longitude: Double

    init(_ name: String, _ lat: Double, _ lon: Double) {
		self.name = name
		latitude = lat
		longitude = lon
	}
}
