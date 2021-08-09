// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

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
    let goesUrl: String
    var stormPrefix = "MIATCP"

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
        _ status: String,
        _ stormPrefix: String
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
        self.stormPrefix = stormPrefix
        center = lat + " " + lon
        dateTime = lastUpdate
        movement = UtilityMath.convertWindDir(to.Double(movementDir)) + " at " + movementSpeed + " mph"
        var modBinNumber = binNumber.substring(0, 2) + id.substring(2, 4)
        if modBinNumber.count == 3 {
            modBinNumber = modBinNumber.insert(2, "0")
        }

        // TODO HFO storm used URL https://www.nhc.noaa.gov/storm_graphics/EP09/EP092021_5day_cone_with_line_and_wind_sm2.png
//        "activeStorms": [
//            {
//                "id": "ep092021",
//                "binNumber": "CP2",
//                "name": "Jimena",
//                "classification": "PTC",
//                "intensity": "30",
//                "pressure": "1009",
//                "latitude": "17.9N",
//                "longitude": "140.8W",
//                "latitudeNumeric": 17.9,
//                "longitudeNumeric": -140.8,
        
        baseUrl = "https://www.nhc.noaa.gov/storm_graphics/" + modBinNumber + "/" + id.uppercased()
        goesUrl = "https://cdn.star.nesdis.noaa.gov/FLOATER/data/" + id.uppercased() + "/GEOCOLOR/latest.jpg"
    }
}
