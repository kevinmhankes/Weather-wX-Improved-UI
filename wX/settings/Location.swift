/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
    var observation = ""
    private let prefNumberString: String

    init(_ locNumInt: Int) {
        let jStr = String(locNumInt + 1)
        prefNumberString = jStr
        lat = Utility.readPref("LOC" + jStr + "_X", "")
        lon = Utility.readPref("LOC" + jStr + "_Y", "")
        name = Utility.readPref("LOC" + jStr + "_LABEL", "")
        countyCurrent = Utility.readPref("COUNTY" + jStr, "")
        zoneCurrent = Utility.readPref("ZONE" + jStr, "")
        wfo = Utility.readPref("NWS" + jStr, "")
        rid = Utility.readPref("RID" + jStr, "")
        nwsStateCurrent = Utility.readPref("NWS" + jStr + "_STATE", "")
        state = Utility.getRadarSiteName(rid).split(",")[0]
        observation = Utility.readPref("LOC" + jStr + "_OBSERVATION", "")
        isLocationUS = Location.us(lat)
        Location.addToListOfNames(name)
    }

    func saveLocationToNewSlot(_ newLocNumInt: Int) {
        let iStr = String(newLocNumInt + 1)
        Utility.writePref("LOC" + iStr + "_X", lat)
        Utility.writePref("LOC" + iStr + "_Y", lon)
        Utility.writePref("LOC" + iStr + "_LABEL", name)
        Utility.writePref("COUNTY" + iStr, countyCurrent)
        Utility.writePref("ZONE" + iStr, zoneCurrent)
        Utility.writePref("NWS" + iStr, wfo)
        Utility.writePref("RID" + iStr, rid)
        Utility.writePref("NWS" + iStr + "_STATE", nwsStateCurrent)
        Utility.writePref("LOC" + iStr + "_OBSERVATION", observation)
        Location.refreshLocationData()
    }

    func updateObservation(_ observation: String) {
        self.observation = observation
        Utility.writePref("LOC" + prefNumberString + "_OBSERVATION", observation)
    }

    static func addToListOfNames(_ name: String) {
        listOf.append(name)
    }

    static func checkCurrentLocationValidity() {
        if getCurrentLocation() >= MyApplication.locations.count {
            setCurrentLocation(MyApplication.locations.count - 1)
            setCurrentLocationStr(String(currentLocation + 1))
        }
    }

    static func clearListOfNames() {
        listOf = []
    }

    static func initNumLocations() {
        numLocations = Utility.readPref( "LOC_NUM_INT", 1)
    }

    static var numLocations: Int {
        get {
            return numberOfLocations
        }
        set {
            Location.numberOfLocations = newValue
            Utility.writePref("LOC_NUM_INT", newValue)
        }
    }

    static func getCurrentLocation() -> Int { currentLocation }

    static func setCurrentLocation(_ currentLocation: Int) {
        Location.currentLocation = currentLocation
    }

    static func getCurrentLocationStr() -> String { currentLocationStr }

    static func setCurrentLocationStr(_ currentLocationStr: String) {
        self.currentLocationStr = currentLocationStr
        self.currentLocation = Int(currentLocationStr)! - 1
    }

    static func us(_ xStr: String) -> Bool { !xStr.contains("CANADA") }

    // Class specific getters
    static var state: String { MyApplication.locations[getCurrentLocation()].state }

    static var name: String { MyApplication.locations[getCurrentLocation()].name }

    static func getName(_ locNum: Int) -> String { MyApplication.locations[locNum].name }

    static var rid: String { MyApplication.locations[getCurrentLocation()].rid }

    static var wfo: String { MyApplication.locations[getCurrentLocation()].wfo }

    static var x: String { MyApplication.locations[getCurrentLocation()].lat }

    static var latLon: LatLon {
        LatLon( MyApplication.locations[getCurrentLocation()].lat,
                       MyApplication.locations[getCurrentLocation()].lon)
    }

    static func getX(_ locNum: Int) -> String { MyApplication.locations[locNum].lat }

    static func getLatLon(_ locNum: Int) -> LatLon { LatLon(MyApplication.locations[locNum].lat, MyApplication.locations[locNum].lon) }

    static var xDbl: Double { Double(Location.x) ?? 0.0 }

    static var y: String { MyApplication.locations[getCurrentLocation()].lon }

    static func getY(_ locNum: Int) -> String { MyApplication.locations[locNum].lon }

    static var yDbl: Double { Double(Location.y) ?? 0.0 }

    static var getLocationIndex: Int { Location.getCurrentLocation() }

    static func isUS(_ locationNumber: Int) -> Bool {
        // FIXME bounds check or safeGet
        if locationNumber == -1 {
            return true
        }
        return MyApplication.locations[locationNumber].isLocationUS
    }

    static var isUS: Bool { MyApplication.locations[Location.getLocationIndex].isLocationUS }

    var prov: String { lat.split(":")[1] }

    static var latlon: LatLon { LatLon(Location.xDbl, Location.yDbl) }

    static func refreshLocationData() {
        initNumLocations()
        MyApplication.locations = []
        clearListOfNames()
        (0..<numLocations).forEach {MyApplication.locations.append(Location($0))}
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

    static func locationSave(_ locNum: String, _ latLon: LatLon, _ labelStr: String) -> String {
        var locNumToSave: Int
        let locNumInt = Int(locNum) ?? 0
        let locNumIntCurrent = Location.numLocations
        if locNumInt == (locNumIntCurrent + 1) {
            locNumToSave = locNumInt
        } else {
            locNumToSave = locNumIntCurrent
        }
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
            var tmpLatlon = LatLon()
            if latLon.latString.count < 12 {
                if UtilityCanada.isLabelPresent(labelStr) {
                    tmpLatlon = UtilityCanada.getLatLonFromLabel(labelStr)
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
                tmpLatlon.latString = parseProv[2]
                tmpLatlon.lonString = parseId[1]
            }
            Utility.writePref("LOC" + locNum + "_X", "CANADA" + ":" + prov + ":" + tmpLatlon.latString)
            Utility.writePref("LOC" + locNum + "_Y", id + ":" + tmpLatlon.lonString)
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
                let locObsCurrent = Utility.readPref("LOC" + jStr + "_OBSERVATION", "")
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
