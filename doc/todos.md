* FileStorage
    - level 2
* rationalize all the Enums, etc
* deploy new copyright header to all files
* radar colors are in RadarGeom?
* nexrad state
* move some radar methods into separate file if possible
* main screen - use download Timer
* bug - Show Dvl then switch to airport radar
* fragment  alert.addAction(UIAlertAction(title: "Add location..", style: .default, handler: { _ in self.locationChanged(Location.numLocations) }))
dedicated method to handle add


fragment:
func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            Utility.writePref("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))

why does writePref not happen in location?

* iOS text no Great Lakes open water not working ( lake SC and st law rv)
  https://tgftp.nws.noaa.gov/data/raw/fz/fzus63.kdtx.glf.sc.txt
  https://forecast.weather.gov/product.php?site=NWS&product=GLF&issuedby=SL

* iOS awc longer animations
* iOS text products most recent MCD no longer works
* iOS radar to severe dash disables screen timeout
* iOS wpc rainfall screen on for tts
* https://tgftp.nws.noaa.gov/data/raw/ac/acus01.kwns.swo.dy1.txt

* [FIX] dual pane does not show radar time for both panes
* [FIX] should not need to restart app when changing NWS icon size
* [ADD] onrestart spc mcd wat mpd
* [ADD] text labels in multipane nexrad
* [FIX] does radar product chosen impact radar on main screen
* [FIX] quad pane runs out of room when warnings selected
* [FIX] in nexrad radar if tr0 selected, exit and enter radar will then show tzl instead (need 4char radar first)
* [ADD] Add 4th char to all radar sites
* [FIX] rotate main screen on phone results in whitespace due to shrinking bottom nav bar
* [ADD] onrestart SPCStormReports
* [ADD] test all SPCMPD/WAT/MPD products including severe dash, long press radar 
* [REF] objectModel _loadTimeList3(from: 0, to: 90, by: 3) instead of stride
* [FIX] nexrad timestamp is slightly offset higher then other text
* [REF] reduction in chained replace
* [REF] in GeographyType/PolygonType rename string
