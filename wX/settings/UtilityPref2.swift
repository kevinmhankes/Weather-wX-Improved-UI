/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityPref2 {

	static func prefInitSetDefaults() {
		let value = Utility.readPref("COD_WARNINGS_DEFAULT", "")
		if value == "" {
			let stateDefault = "Oklahoma"
			let simpleModeDefault = "false"
			let themeBlueDefault = "white"
			let refreshMainMinDefault = 15
			let locNumIntDefault = 1
			let refreshSpcMinDefault = 15
			let loc1LabelDefault = "home"
			let zipcodeDefault = "73069"
			let locDisplayImgDefault = "true"
			let current1Default = "true"
			let mdDefault = "true"
			let mdCntDefault = "2"
			let watchDefault = "true"
			let watchCntDefault = "2"
			let county1Default = "Cleveland"
			let zone1Default = "OKC027"
			let stateCodeDefault = "OK"
			let loc1XDefault = "35.231"
			let loc1YDefault = "-97.451"
			let loc1NwsDefault = "OUN"
			let nws1Default = "OUN"
			let rid1Default = "TLX"
			let nws1DefaultDtate = "OK"
			let nwsRadarBgBlack = "true"
			let codWarningsDefault = "false"
			let codCitiesDefault = "false"
			Utility.writePref("UI_ICONS_EVENLY_SPACED", "false")
			Utility.writePref("ALERT_ONLYONCE", "true")
			Utility.writePref("ALERT_AUTOCANCEL", "true")
			Utility.writePref("RADAR_WARN_LINESIZE", 4)
			Utility.writePref("RADAR_WATMCD_LINESIZE", 4)
			Utility.writePref("WXOGL_SIZE", 13)
			Utility.writePref("LOCK_TOOLBARS", "true")
			Utility.writePref("RADAR_SHOW_COUNTY", "true")
			Utility.writePref("RADAR_COLOR_HW", Color.rgb(135, 135, 135))
			Utility.writePref("RADAR_COLOR_STATE", Color.rgb(255, 255, 255))
			Utility.writePref("REFRESH_MAIN_MIN", refreshMainMinDefault)
			Utility.writePref("LOC_NUM_INT", locNumIntDefault)
			Utility.writePref("REFRESH_SPC_MIN", refreshSpcMinDefault)
			Utility.writePref("LOC1_X", loc1XDefault)
			Utility.writePref("LOC1_Y", loc1YDefault)
			Utility.writePref("LOC1_NWS", loc1NwsDefault)
			Utility.writePref("LOC1_LABEL", loc1LabelDefault)
			Utility.writePref("COUNTY1", county1Default)
			Utility.writePref("ZONE1", zone1Default)
			Utility.writePref("SIMPLE_MODE", simpleModeDefault)
			Utility.writePref("LOC_DISPLAY_IMG", locDisplayImgDefault)
			Utility.writePref("CURRENT1", current1Default)
			Utility.writePref("MD_SHOW", mdDefault)
			Utility.writePref("MD_CNT", mdCntDefault)
			Utility.writePref("WATCH_SHOW", watchDefault)
			Utility.writePref("WATCH_CNT", watchCntDefault)
			Utility.writePref("STATE", stateDefault)
			Utility.writePref("STATE_CODE", stateCodeDefault)
			Utility.writePref("ZIPCODE1", zipcodeDefault)
			Utility.writePref("NWS1", nws1Default)
			Utility.writePref("RID1", rid1Default)
			Utility.writePref("NWS1_STATE", nws1DefaultDtate)
			Utility.writePref("THEME_BLUE", themeBlueDefault)
			Utility.writePref("NWS_RADAR_BG_BLACK", nwsRadarBgBlack)
			Utility.writePref("COD_WARNINGS_DEFAULT", codWarningsDefault)
			Utility.writePref("COD_CITIES_DEFAULT", codCitiesDefault)
			Utility.writePref("CARDS_MAIN_SCREEN", "true")
			Utility.writePref("ELEVATION_PREF", 10)
		}
	}
}
