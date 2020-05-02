/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityStorePreferences {

	static func setDefaults() {
		let value = Utility.readPref("COD_WARNINGS_DEFAULT", "")
		if value == "" {
			let stateDefault = "Oklahoma"
			let refreshMainMinDefault = 15
			let locNumIntDefault = 1
			let loc1LabelDefault = "home"
			let zipcodeDefault = "73069"
			let current1Default = "true"
			let county1Default = "Cleveland"
			let zone1Default = "OKC027"
			let stateCodeDefault = "OK"
			let loc1XDefault = "35.231"
			let loc1YDefault = "-97.451"
			let loc1NwsDefault = "OUN"
			let nws1Default = "OUN"
			let rid1Default = "TLX"
			let nws1DefaultState = "OK"
			let codWarningsDefault = "false"
			let codCitiesDefault = "false"
			Utility.writePref("RADAR_WARN_LINESIZE", 4)
			Utility.writePref("RADAR_WATMCD_LINESIZE", 4)
			Utility.writePref("WXOGL_SIZE", 13)
			Utility.writePref("RADAR_SHOW_COUNTY", "true")
			Utility.writePref("RADAR_COLOR_HW", Color.rgb(135, 135, 135))
			Utility.writePref("RADAR_COLOR_STATE", Color.rgb(255, 255, 255))
			Utility.writePref("REFRESH_MAIN_MIN", refreshMainMinDefault)
			Utility.writePref("LOC_NUM_INT", locNumIntDefault)
			Utility.writePref("LOC1_X", loc1XDefault)
			Utility.writePref("LOC1_Y", loc1YDefault)
			Utility.writePref("LOC1_NWS", loc1NwsDefault)
			Utility.writePref("LOC1_LABEL", loc1LabelDefault)
			Utility.writePref("COUNTY1", county1Default)
			Utility.writePref("ZONE1", zone1Default)
			Utility.writePref("CURRENT1", current1Default)
			Utility.writePref("STATE", stateDefault)
			Utility.writePref("STATE_CODE", stateCodeDefault)
			Utility.writePref("ZIPCODE1", zipcodeDefault)
			Utility.writePref("NWS1", nws1Default)
			Utility.writePref("RID1", rid1Default)
			Utility.writePref("NWS1_STATE", nws1DefaultState)
			Utility.writePref("COD_WARNINGS_DEFAULT", codWarningsDefault)
			Utility.writePref("COD_CITIES_DEFAULT", codCitiesDefault)
		}
	}
}
