/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Location {

    private static var locations = [ObjectLocation]()
    static var listOf = [String]()
    static var numberOfLocations = 1
    // as implied by initial values currentLocation is an index starting at 0
    // while Str version is starting at "1"
    private static var currentLocation = 0
    private static var currentLocationStr = "1"
    private static let addLocationLabel = "Add Location..."
    
    static func updateObservation(_ index: Int, _ obs: String) {
        locations[index].updateObservation(obs)
    }

    static func addToListOfNames(_ name: String) {
        listOf.append(name)
    }

    static func checkCurrentLocationValidity() {
        if getCurrentLocation() >= locations.count {
            setCurrentLocation(locations.count - 1)
            setCurrentLocationStr(String(currentLocation + 1))
        }
    }

    static func clearListOfNames() {
        listOf = []
    }

    static func initNumLocations() {
        numLocations = Utility.readPref("LOC_NUM_INT", 1)
    }

    static var numLocations: Int {
        get { numberOfLocations }
        set {
            Location.numberOfLocations = newValue
            Utility.writePref("LOC_NUM_INT", newValue)
        }
    }

    static func getCurrentLocation() -> Int {
        currentLocation
    }

    static func setCurrentLocation(_ currentLocation: Int) {
        Location.currentLocation = currentLocation
    }

    static func getCurrentLocationStr() -> String {
        currentLocationStr
    }

    static func setCurrentLocationStr(_ currentLocationStr: String) {
        self.currentLocationStr = currentLocationStr
        currentLocation = Int(currentLocationStr)! - 1
    }

    static func us(_ xStr: String) -> Bool { !xStr.contains("CANADA") }

    static var state: String { locations[getCurrentLocation()].state }

    static var name: String { locations[getCurrentLocation()].name }

    static func getName(_ locNum: Int) -> String { locations[locNum].name }
    
    static func getLatLon(_ locNum: Int) -> LatLon { LatLon(locations[locNum].lat, locations[locNum].lon) }

    static func getX(_ locNum: Int) -> String { locations[locNum].lat }

    static func getY(_ locNum: Int) -> String { locations[locNum].lon }

    static func getRid(_ locNum: Int) -> String { locations[locNum].rid }

    static func getWfo(_ locNum: Int) -> String { locations[locNum].wfo }

    static func getObservation(_ locNum: Int) -> String { locations[locNum].observation }
    
    static func getProv(_ locNum: Int) -> String { locations[locNum].prov }

    static var rid: String { locations[getCurrentLocation()].rid }

    static var wfo: String { locations[getCurrentLocation()].wfo }

    static var x: String { locations[getCurrentLocation()].lat }

    static var xDbl: Double { Double(Location.x) ?? 0.0 }

    static var y: String { locations[getCurrentLocation()].lon }

    static var yDbl: Double { Double(Location.y) ?? 0.0 }

    static var getLocationIndex: Int { Location.getCurrentLocation() }

    static func isUS(_ locationNumber: Int) -> Bool {
        // FIXME bounds check or safeGet
        if locationNumber == -1 {
            return true
        }
        return locations[locationNumber].isLocationUS
    }

    static var isUS: Bool { locations[Location.getLocationIndex].isLocationUS }

    static var latLon: LatLon { LatLon(Location.xDbl, Location.yDbl) }

    static func refreshLocationData() {
        initNumLocations()
        locations = []
        clearListOfNames()
        (0..<numLocations).forEach {locations.append(ObjectLocation($0))}
        addToListOfNames(addLocationLabel)
        checkCurrentLocationValidity()
    }

    static private func getWfoRadarSiteFromPoint(_ latLon: LatLon) -> [String] {
        let pointData = ("https://api.weather.gov/points/" + latLon.latString + "," + latLon.lonString).getNwsHtml()
        // "cwa": "IWX",
        // "radarStation": "KGRR"
        let wfo = pointData.parse("\"cwa\": \"(.*?)\"")
        var radarStation = pointData.parse("\"radarStation\": \"(.*?)\"")
        radarStation = UtilityString.getLastXChars(radarStation, 3)
        return [wfo, radarStation]
    }

    // used in adhoc location
    static func save(_ latLon: LatLon) -> String {
        save(String(Location.numLocations + 1), latLon, latLon.prettyPrint())
    }

    static func save(_ locNum: String, _ latLon: LatLon, _ labelStr: String) -> String {
        let locNumInt = Int(locNum) ?? 0
        let locNumToSave = locNumInt == (Location.numLocations + 1) ? locNumInt : Location.numLocations
        Utility.writePref("LOC" + locNum + "_X", latLon.latString)
        Utility.writePref("LOC" + locNum + "_Y", latLon.lonString)
        Utility.writePref("LOC" + locNum + "_LABEL", labelStr)
        var wfo = ""
        var radarSite = ""
        if Location.us(latLon.latString) {
            Location.numLocations = locNumToSave
            let wfoAndRadar = getWfoRadarSiteFromPoint(latLon)
            wfo = wfoAndRadar[0]
            radarSite = wfoAndRadar[1]
            if wfo == "" {
                wfo = UtilityLocation.getNearestOffice("WFO", latLon).lowercased()
            }
            if radarSite == "" {
                radarSite = UtilityLocation.getNearestOffice("RADAR", latLon)
            }
            Utility.writePref("RID" + locNum, radarSite.uppercased())
            Utility.writePref("NWS" + locNum, wfo.uppercased())
        } else {
            var tempLatLon = LatLon()
            if latLon.latString.count < 12 {
                if UtilityCanada.isLabelPresent(labelStr) {
                    tempLatLon = UtilityCanada.getLatLonFromLabel(labelStr)
                }
            }
            var prov = ""
            let parseProv = latLon.latString.split(":")
            if parseProv.count > 0 {
                prov = parseProv[1]
            }
            var id = ""
            let parseId = latLon.lonString.split(":")
            if parseId.count > 0 {
                id = parseId[0]
            }
            if latLon.latString.count > 12 {
                tempLatLon.latString = parseProv[2]
                tempLatLon.lonString = parseId[1]
            }
            Utility.writePref("LOC" + locNum + "_X", "CANADA" + ":" + prov + ":" + tempLatLon.latString)
            Utility.writePref("LOC" + locNum + "_Y", id + ":" + tempLatLon.lonString)
            Location.numLocations = locNumToSave
            radarSite = UtilityCanada.getRadarSite(latLon.latString, latLon.lonString)
            Utility.writePref("RID" + locNum, rid.uppercased())
            Utility.writePref("NWS" + locNum + "_STATE", prov)
            Utility.writePref("ZONE" + locNum, "")
            Utility.writePref("COUNTY" + locNum, "")
            Utility.writePref("NWS" + locNum, "")
        }
        Location.refreshLocationData()
        Utility.writePref("CURRENT_LOC_FRAGMENT", locNum)
        Location.setCurrentLocationStr(locNum)
        return "Saving location " + locNum + " as " + labelStr
            + " ("  + latLon.latString
            + "," + latLon.lonString
            + ") " + "/" + " "
            + wfo.uppercased()
            + "(" + radarSite.uppercased() + ")"
    }

    static func delete(_ locToDeleteStr: String) {
        let locToDeleteInt = Int(locToDeleteStr) ?? 0
        let locNumIntCurrent = Location.numLocations
        if locToDeleteInt > locNumIntCurrent {
            return
        }
        if locToDeleteInt == locNumIntCurrent {
            Location.numLocations = locNumIntCurrent - 1
        } else {
            (locToDeleteInt..<locNumIntCurrent).forEach { index in
                let jIndex = index + 1
                let jStr = String(jIndex)
                let iStr = String(index)
                let locObsCurrent = Utility.readPref("LOC" + jStr + "_OBSERVATION", "")
                let locXCurrent = Utility.readPref("LOC" + jStr + "_X", "")
                let locYCurrent = Utility.readPref("LOC" + jStr + "_Y", "")
                let locLabelCurrent = Utility.readPref("LOC" + jStr + "_LABEL", "")
                let countyCurrent = Utility.readPref("COUNTY" + jStr, "")
                let zoneCurrent = Utility.readPref("ZONE" + jStr, "")
                let nwsCurrent = Utility.readPref("NWS" + jStr, "")
                let ridCurrent = Utility.readPref("RID" + jStr, "")
                let nwsStateCurrent = Utility.readPref("NWS" + jStr + "_STATE", "")
                Utility.writePref("LOC" + iStr + "_OBSERVATION", locObsCurrent)
                Utility.writePref("LOC" + iStr + "_X", locXCurrent)
                Utility.writePref("LOC" + iStr + "_Y", locYCurrent)
                Utility.writePref("LOC" + iStr + "_LABEL", locLabelCurrent)
                Utility.writePref("COUNTY" + iStr, countyCurrent)
                Utility.writePref("ZONE" + iStr, zoneCurrent)
                Utility.writePref("NWS" + iStr, nwsCurrent)
                Utility.writePref("RID" + iStr, ridCurrent)
                Utility.writePref("NWS" + iStr + "_STATE", nwsStateCurrent)
                Location.numLocations = locNumIntCurrent - 1
            }
        }
        let locFragCurrentInt = Location.getCurrentLocation() + 1
        if locToDeleteInt == locFragCurrentInt {
            Utility.writePref("CURRENT_LOC_FRAGMENT", "1")
            Location.setCurrentLocationStr("1")
        } else if locFragCurrentInt > locToDeleteInt {
            let shiftNum = String(locFragCurrentInt - 1)
            Utility.writePref("CURRENT_LOC_FRAGMENT", shiftNum)
            Location.setCurrentLocationStr(shiftNum)
        }
        let widgetLocNum = Utility.readPref("WIDGET_LOCATION", "1")
        let widgetLocNumInt = Int(widgetLocNum) ?? 0
        if locToDeleteInt == widgetLocNumInt {
            Utility.writePref("WIDGET_LOCATION", "1")
        } else if widgetLocNumInt > locToDeleteInt {
            let shiftNum = String(widgetLocNumInt - 1)
            Utility.writePref("WIDGET_LOCATION", shiftNum)
        }
        Location.refreshLocationData()
    }
}
