/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public final class CityExt {

	var name = ""
	var latitude = 0.0
	var longitude = 0.0
	private var population = 0

	init(_ name: String, _ lat: Double, _ lon: Double, _ population: String) {
		self.name = name
		self.latitude = lat
		self.longitude = lon
		if population == "" {
			self.population = 0
		} else {
			self.population = Int(population) ?? 0
		}
	}
}
