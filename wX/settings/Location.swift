/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Location {

    public static var listOf = [String]()
    static var numberOfLocations = 1
    // as implied by initial values currentLocation is an index starting at 0
    // while Str version is starting at "1"
    private static var currentLocation = 0
    private static var currentLocationStr = "1"
    private static let addLocationLabel = "Add Location..."
    var lat = ""
    var lon = ""
    var name = ""
    private var countyCurrent = ""
    private var zoneCurrent = ""
    var wfo = ""
    var rid = ""
    private var nwsStateCurrent = ""
    var state = ""
    private var isLocationUS: Bool

    init(_ locNumInt: Int) {
        let jStr = String(locNumInt+1)
        lat = Utility.readPref("LOC" + jStr + "_X", "")
        lon = Utility.readPref("LOC" + jStr + "_Y", "")
        name = Utility.readPref("LOC" + jStr + "_LABEL", "")
        countyCurrent = Utility.readPref("COUNTY" + jStr, "")
        zoneCurrent = Utility.readPref("ZONE" + jStr, "")
        wfo = Utility.readPref("NWS" + jStr, "")
        rid = Utility.readPref("RID" + jStr, "")
        nwsStateCurrent = Utility.readPref("NWS" + jStr + "_STATE", "")
        state = Utility.readPref("NWS_LOCATION_" + rid, "").split(",")[0]
        isLocationUS = Location.us(lat)
        Location.addToListOfNames(name)
    }

    func saveLocationToNewSlot(_ newLocNumInt: Int) {
        let iStr = String(newLocNumInt+1)
        Utility.writePref("LOC" + iStr + "_X", lat)
        Utility.writePref("LOC" + iStr + "_Y", lon)
        Utility.writePref("LOC" + iStr + "_LABEL", name)
        Utility.writePref("COUNTY" + iStr, countyCurrent)
        Utility.writePref("ZONE" + iStr, zoneCurrent)
        Utility.writePref("NWS" + iStr, wfo)
        Utility.writePref("RID" + iStr, rid)
        Utility.writePref("NWS" + iStr + "_STATE", nwsStateCurrent)
        Location.refreshLocationData()
    }

    class func addToListOfNames(_ name: String) {
        listOf.append(name)
    }

    class func checkCurrentLocationValidity() {
        if getCurrentLocation() >= MyApplication.locations.count {
            setCurrentLocation(MyApplication.locations.count-1)
            setCurrentLocationStr(String(currentLocation+1))
        }
    }

    class func clearListOfNames() {
        listOf = []
    }

    class func initNumLocations() {
        numLocations = Utility.readPref( "LOC_NUM_INT", 1)
    }

    class var numLocations: Int {
        get {
            return numberOfLocations
        }
        set {
            Location.numberOfLocations = newValue
            Utility.writePref("LOC_NUM_INT", newValue)
        }
    }

    class func getCurrentLocation() -> Int {
        return currentLocation
    }

    class func setCurrentLocation(_ currentLocation: Int) {
        Location.currentLocation = currentLocation
    }

    class func getCurrentLocationStr() -> String {
        return currentLocationStr
    }

    class func setCurrentLocationStr(_ currentLocationStr: String) {
        self.currentLocationStr = currentLocationStr
        self.currentLocation = Int(currentLocationStr)! - 1
    }

    class func us(_ xStr: String) -> Bool {
        return !xStr.contains("CANADA")
    }

    // Class specific getters
    static var state: String {return MyApplication.locations[getCurrentLocation()].state}

    static var name: String {return MyApplication.locations[getCurrentLocation()].name}

    class func getName(_ locNum: Int) -> String {
        return MyApplication.locations[locNum].name
    }

    static var rid: String {return MyApplication.locations[getCurrentLocation()].rid}

    static var wfo: String {return MyApplication.locations[getCurrentLocation()].wfo}

    static var x: String {return MyApplication.locations[getCurrentLocation()].lat}

    static var latLon: LatLon {
        return LatLon( MyApplication.locations[getCurrentLocation()].lat,
                       MyApplication.locations[getCurrentLocation()].lon)
    }

    class func getX(_ locNum: Int) -> String {
        return MyApplication.locations[locNum].lat
    }

    class func getLatLon(_ locNum: Int) -> LatLon {
        return LatLon(MyApplication.locations[locNum].lat, MyApplication.locations[locNum].lon)
    }

    static var xDbl: Double {return Double(Location.x) ?? 0.0}

    static var y: String {return MyApplication.locations[getCurrentLocation()].lon}

    class func getY(_ locNum: Int) -> String {
        return MyApplication.locations[locNum].lon
    }

    static var yDbl: Double {return Double(Location.y) ?? 0.0}

    static var getLocationIndex: Int {return Location.getCurrentLocation()}

    class func isUS(_ locationNumber: Int) -> Bool {
        if locationNumber == -1 {
            return true
        }
        return MyApplication.locations[locationNumber].isLocationUS
    }

    static var isUS: Bool {return MyApplication.locations[Location.getLocationIndex].isLocationUS}

    var prov: String {return lat.split(":")[1]}

    static var latlon: LatLon {return LatLon(Location.xDbl, Location.yDbl)}

    static func refreshLocationData() {
        initNumLocations()
        MyApplication.locations = []
        clearListOfNames()
        (0..<numLocations).forEach {MyApplication.locations.append(Location($0))}
        addToListOfNames(addLocationLabel)
        checkCurrentLocationValidity()
    }

    static func locationSave(_ locNum: String, _ location: LatLon, _ labelStr: String) -> String {
        var locNumToSave: Int
        let locNumInt = Int(locNum) ?? 0
        let locNumIntCurrent = Location.numLocations
        if locNumInt == (locNumIntCurrent + 1) {
            locNumToSave = locNumInt
        } else {
            locNumToSave = locNumIntCurrent
        }
        Utility.writePref("LOC" + locNum + "_X", location.latString)
        Utility.writePref("LOC" + locNum + "_Y", location.lonString)
        Utility.writePref("LOC" + locNum + "_LABEL", labelStr)
        var nwsOfficeShortLower = ""
        var rid = ""
        if Location.us(location.latString) {
            Location.numLocations = locNumToSave
            nwsOfficeShortLower = UtilityLocation.getNearestOffice("WFO", location).lowercased()
            rid = UtilityLocation.getNearestOffice("RADAR", location)
            if rid == "" {
                rid = Utility.readPref("NWS_RID_" + nwsOfficeShortLower.uppercased(), "")
            }
            Utility.writePref("RID" + locNum, rid.uppercased())
            Utility.writePref("NWS" + locNum, nwsOfficeShortLower.uppercased())
        } else {
            var tmpLatlon = LatLonStr()
            if location.latString.count < 12 {
                if UtilityCanada.isLabelPresent(labelStr) {
                    tmpLatlon = UtilityCanada.getLatLonFromLabel(labelStr)
                }
            }
            var prov = ""
            var parseProv = location.latString.split(":")
            if parseProv.count > 0 {
                prov = parseProv[1]
            }
            var id = ""
            var parseId = location.lonString.split(":")
            if parseId.count > 0 {
                id = parseId[0]
            }
            if location.latString.count > 12 {
                tmpLatlon.latStr = parseProv[2]
                tmpLatlon.lonStr = parseId[1]
            }
            Utility.writePref("LOC" + locNum + "_X", "CANADA" + ":" + prov + ":" + tmpLatlon.latStr)
            Utility.writePref("LOC" + locNum + "_Y", id + ":" + tmpLatlon.lonStr)
            Location.numLocations = locNumToSave
            rid = UtilityCanada.getRid(location.latString, location.lonString)
            Utility.writePref("RID" + locNum, rid.uppercased())
            Utility.writePref("NWS" + locNum + "_STATE", prov)
            Utility.writePref("ZONE" + locNum, "")
            Utility.writePref("COUNTY" + locNum, "")
            Utility.writePref("NWS" + locNum, "")
        }
        Location.refreshLocationData()
        return "Saving location " + locNum + " as " + labelStr
            + " ("  + location.latString
            + "," + location.lonString
            + ") " + "/" + " "
            + nwsOfficeShortLower.uppercased()
            + "(" + rid.uppercased() + ")"
    }

    static func deleteLocation(_ locToDeleteStr: String) {
        let locToDeleteInt = Int(locToDeleteStr) ?? 0
        let locNumIntCurrent = Location.numLocations
        let locNumIntCurrentStr = String(locNumIntCurrent)
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
                let locXCurrent = Utility.readPref("LOC" + jStr + "_X", "")
                let locYCurrent = Utility.readPref("LOC" + jStr + "_Y", "")
                let locLabelCurrent = Utility.readPref("LOC" + jStr + "_LABEL", "")
                let countyCurrent = Utility.readPref("COUNTY" + jStr, "")
                let zoneCurrent = Utility.readPref("ZONE" + jStr, "")
                let nwsCurrent = Utility.readPref("NWS" + jStr, "")
                let ridCurrent = Utility.readPref("RID" + jStr, "")
                let nwsStateCurrent = Utility.readPref("NWS" + jStr + "_STATE", "")
                let alertNotificationCurrent = Utility.readPref("ALERT" + jStr + "_NOTIFICATION", "false")
                let alertNotificationRadarCurrent = Utility.readPref("ALERT_NOTIFICATION_RADAR" + jStr, "false")
                let alertCcNotificationCurrent = Utility.readPref("ALERT_CC" + jStr + "_NOTIFICATION", "false")
                let alert7day1NotificationCurrent = Utility.readPref("ALERT_7DAY_" + jStr + "_NOTIFICATION",
                                                                          "false")
                let alertNotificationSoundCurrent = Utility.readPref("ALERT_NOTIFICATION_SOUND" + jStr, "false")
                let alertNotificationMcdCurrent = Utility.readPref("ALERT_NOTIFICATION_MCD" + jStr, "false")
                let alertNotificationSwoCurrent = Utility.readPref("ALERT_NOTIFICATION_SWO" + jStr, "false")
                let alertNotificationSpcfwCurrent = Utility.readPref("ALERT_NOTIFICATION_SPCFW" + jStr, "false")
                let alertNotificationWpcmpdCurrent = Utility.readPref("ALERT_NOTIFICATION_WPCMPD" + jStr, "false")
                Utility.writePref("ALERT" + iStr + "_NOTIFICATION", alertNotificationCurrent)
                Utility.writePref("ALERT_CC" + iStr + "_NOTIFICATION", alertCcNotificationCurrent)
                Utility.writePref("ALERT_7DAY_" + iStr + "_NOTIFICATION", alert7day1NotificationCurrent)
                Utility.writePref("ALERT_NOTIFICATION_SOUND" + iStr, alertNotificationSoundCurrent)
                Utility.writePref("ALERT_NOTIFICATION_MCD" + iStr, alertNotificationMcdCurrent)
                Utility.writePref("ALERT_NOTIFICATION_SWO" + iStr, alertNotificationSwoCurrent)
                Utility.writePref("ALERT_NOTIFICATION_SPCFW" + iStr, alertNotificationSpcfwCurrent)
                Utility.writePref("ALERT_NOTIFICATION_WPCMPD" + iStr, alertNotificationWpcmpdCurrent)
                Utility.writePref("ALERT_NOTIFICATION_RADAR" + iStr, alertNotificationRadarCurrent)
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
        Utility.writePref("ALERT" + locNumIntCurrentStr + "_NOTIFICATION", "false")
        Utility.writePref("ALERT_CC" + locNumIntCurrentStr + "_NOTIFICATION", "false")
        Utility.writePref("ALERT_7DAY_" + locNumIntCurrentStr + "_NOTIFICATION", "false")
        Utility.writePref("ALERT_NOTIFICATION_SOUND" + locNumIntCurrentStr, "false")
        Utility.writePref("ALERT_NOTIFICATION_RADAR" + locNumIntCurrentStr, "false")
        Utility.writePref("ALERT_NOTIFICATION_MCD" + locNumIntCurrentStr, "false")
        Utility.writePref("ALERT_NOTIFICATION_SWO" + locNumIntCurrentStr, "false")
        Utility.writePref("ALERT_NOTIFICATION_SPCFW" + locNumIntCurrentStr, "false")
        Utility.writePref("ALERT_NOTIFICATION_WPCMPD" + locNumIntCurrentStr, "false")
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
    }}
