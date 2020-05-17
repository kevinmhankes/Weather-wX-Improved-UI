/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectNhcStormDetails {
    
    let center: String
    let classification: String
    let name: String
    let binNumber: String
    let id: String
    let dateTime: String
    let movement: String
    let movementDir: String
    let movementSpeed: String
    let pressure: String
    let intensity: String
    let status: String
    let baseUrl: String
    let lastUpdate: String
    let lat: String
    let lon: String
    
    init(
        _ name: String,
        _ movementDir: String,
        _ movementSpeed: String,
        _ pressure: String,
        _ binNumber: String,
        _ id: String,
        _ lastUpdate: String,
        _ classification: String,
        _ lat: String,
        _ lon: String,
        _ intensity: String,
        _ status: String
    ) {
        self.name = name
        self.movementDir = movementDir
        self.movementSpeed = movementSpeed
        self.pressure = pressure
        self.binNumber = binNumber
        self.id = id
        self.lastUpdate = lastUpdate
        self.classification = classification
        self.lat = lat
        self.lon = lon
        self.intensity = intensity
        self.status = status
        center = lat + " " + lon
        dateTime = lastUpdate
        movement = UtilityMath.convertWindDir(Double(movementDir) ?? 0.0) + " at " + movementSpeed + " mph"
        var modBinNumber = binNumber
        if modBinNumber.count == 3 { modBinNumber = modBinNumber.insert(2, "0") }
        baseUrl = "https://www.nhc.noaa.gov/storm_graphics/" + modBinNumber + "/" + id.uppercased()
    }
    
    func forTopHeader() -> String { movement + ", " + pressure + ", " + intensity }
}
