/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectLocation {

    let lat: String
    let lon: String
    let name: String
    private let countyCurrent: String
    private let zoneCurrent: String
    let wfo: String
    let rid: String
    private let nwsStateCurrent: String
    let state: String
    let isLocationUS: Bool
    var observation: String
    private let prefNumberString: String

    init(_ locNumAsInt: Int) {
        let locNumAsString = String(locNumAsInt + 1)
        prefNumberString = locNumAsString
        lat = Utility.readPref("LOC" + locNumAsString + "_X", "")
        lon = Utility.readPref("LOC" + locNumAsString + "_Y", "")
        name = Utility.readPref("LOC" + locNumAsString + "_LABEL", "")
        countyCurrent = Utility.readPref("COUNTY" + locNumAsString, "")
        zoneCurrent = Utility.readPref("ZONE" + locNumAsString, "")
        wfo = Utility.readPref("NWS" + locNumAsString, "")
        rid = Utility.readPref("RID" + locNumAsString, "")
        nwsStateCurrent = Utility.readPref("NWS" + locNumAsString + "_STATE", "")
        state = Utility.getRadarSiteName(rid).split(",")[0]
        observation = Utility.readPref("LOC" + locNumAsString + "_OBSERVATION", "")
        isLocationUS = Location.us(lat)
        Location.addToListOfNames(name)
    }

    func saveToNewSlot(_ newLocNumInt: Int) {
        let locNumAsString = String(newLocNumInt + 1)
        Utility.writePref("LOC" + locNumAsString + "_X", lat)
        Utility.writePref("LOC" + locNumAsString + "_Y", lon)
        Utility.writePref("LOC" + locNumAsString + "_LABEL", name)
        Utility.writePref("COUNTY" + locNumAsString, countyCurrent)
        Utility.writePref("ZONE" + locNumAsString, zoneCurrent)
        Utility.writePref("NWS" + locNumAsString, wfo)
        Utility.writePref("RID" + locNumAsString, rid)
        Utility.writePref("NWS" + locNumAsString + "_STATE", nwsStateCurrent)
        Utility.writePref("LOC" + locNumAsString + "_OBSERVATION", observation)
        Location.refreshLocationData()
    }

    func updateObservation(_ observation: String) {
        self.observation = observation
        Utility.writePref("LOC" + prefNumberString + "_OBSERVATION", observation)
    }

    var prov: String { lat.split(":")[1] }
}
