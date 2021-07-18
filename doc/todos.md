nexrad state
FileStorage
objectWatch - if html == "" don't save, reset timer
rationalize all the Enums, etc
create/use FutureVoid FutureText FutureBytes
objectPolygonWaring download - add a timerReset if failure on http and a 2nd try
wxRender - add more threads for metar, spc swo, wpc fronts

// [REF] RadarPref shorten names
// [FIX] alerts no way back to image after set filter
// [REF] overall logic/consistency of zoom in nexrad with regards to triangles/circles
// [FIX] dual pane does not show radar time for both panes
// [ADD] spc storm reports - landscape optimization
// [ADD] spotters - show on radar option, search, mark fav, contact
// [FIX] should not need to restart app when changing NWS icon size
// [ADD] more robust handling network issues (cc,7day,radar)
// [ADD] onrestart spc mcd wat mpd
// [ADD] text labels in multipane nexrad
// [FIX] does radar product chosen impact radar on main screen
// [FIX] MacOS nexrad county labels truncate second line
// [FIX] MacOS nexrad colormap legend does not show text labels
// [ADD] nexrad dual pane - tap on time go to quad
// [FIX] quad pane runs out of room when warnings selected
// [FIX] in nexrad radar if tr0 selected, exit and enter radar will then show tzl instead (need 4char radar first)
// [ADD] Add 4th char to all radar sites
// [FIX] rotate main screen on phone results in whitespace due to shrinking bottom nav bar
// [ADD] onrestart SPCStormReports
// [REF] spc storm reports refactor like kotlin
// [ADD] usalerts filter by state
// [ADD] test all SPCMPD/WAT/MPD products including severe dash, long press radar 
// [REF] objectModel _loadTimeList3(from: 0, to: 90, by: 3) instead of stride
// [FIX] nexrad timestamp is slightly offset higher then other text
// [ADD] LSR by WFO - download and show one at a time
// [FIX] long press nexrad does not reset zoom (catalyst)
// [REF] FileStorage 
// [REF] reduction in chained replace
// [REF] add extension for parseLastMatch
// [REF] move and rename UtilitySunMoon (now now in misc)
// [REF] in GeographyType/PolygonType rename string
// [REF] externPoly - remove underscores
// [FIX] access text from NHC changes stored pref in WPC Text
// [ADD] nexrad - add more parallelism for polygon downloads
// [REF] scan for closure without proper spaces
// [REF] remove -> Void from closures
// [FIX] pan motion behaves differently on different classes of device (tracks 1:1 on 2018 base ipad, etc)



