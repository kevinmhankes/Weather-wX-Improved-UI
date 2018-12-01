/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityPref2 {

	static func prefInitSetDefaults() {
		let value = preferences.getString("COD_WARNINGS_DEFAULT", "")
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
			editor.putString("UI_ICONS_EVENLY_SPACED", "false")
			editor.putString("ALERT_ONLYONCE", "true")
			editor.putString("ALERT_AUTOCANCEL", "true")
			editor.putInt("RADAR_WARN_LINESIZE", 4)
			editor.putInt("RADAR_WATMCD_LINESIZE", 4)
			editor.putInt("WXOGL_SIZE", 13)
			editor.putString("LOCK_TOOLBARS", "true")
			editor.putString("RADAR_SHOW_COUNTY", "true")
			editor.putInt("RADAR_COLOR_HW", Color.rgb(135, 135, 135))
			editor.putInt("RADAR_COLOR_STATE", Color.rgb(255, 255, 255))
			editor.putInt("REFRESH_MAIN_MIN", refreshMainMinDefault)
			editor.putInt("LOC_NUM_INT", locNumIntDefault)
			editor.putInt("REFRESH_SPC_MIN", refreshSpcMinDefault)
			editor.putString("LOC1_X", loc1XDefault)
			editor.putString("LOC1_Y", loc1YDefault)
			editor.putString("LOC1_NWS", loc1NwsDefault)
			editor.putString("LOC1_LABEL", loc1LabelDefault)
			editor.putString("COUNTY1", county1Default)
			editor.putString("ZONE1", zone1Default)
			editor.putString("SIMPLE_MODE", simpleModeDefault)
			editor.putString("LOC_DISPLAY_IMG", locDisplayImgDefault)
			editor.putString("CURRENT1", current1Default)
			editor.putString("MD_SHOW", mdDefault)
			editor.putString("MD_CNT", mdCntDefault)
			editor.putString("WATCH_SHOW", watchDefault)
			editor.putString("WATCH_CNT", watchCntDefault)
			editor.putString("STATE", stateDefault)
			editor.putString("STATE_CODE", stateCodeDefault)
			editor.putString("ZIPCODE1", zipcodeDefault)
			editor.putString("NWS1", nws1Default)
			editor.putString("RID1", rid1Default)
			editor.putString("NWS1_STATE", nws1DefaultDtate)
			editor.putString("THEME_BLUE", themeBlueDefault)
			editor.putString("NWS_RADAR_BG_BLACK", nwsRadarBgBlack)
			editor.putString("COD_WARNINGS_DEFAULT", codWarningsDefault)
			editor.putString("COD_CITIES_DEFAULT", codCitiesDefault)
			editor.putString("CARDS_MAIN_SCREEN", "true")
			editor.putInt("ELEVATION_PREF", 10)
		}
	}
}
