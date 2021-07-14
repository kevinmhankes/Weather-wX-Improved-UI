game mode for multipane
rationalize all the Enums, etc
create/use FutureVoid FutureText FutureBytes
animate icon change
objectPolygonWaring download - add a timerReset if failure on http and a 2nd try

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



In conjunction with GFS v16-Wave model upgrade, the following new products are added to GFS-WAVE:
wsea_wv_ht
swell1_wv_ht
swell1_dir_per
swell1_dir_per
swell2_wv_ht
swell2_dir_per
Added the following domains to GFS-WAVE:
ALASKA
HAWAII
ARCTIC
NE-COAST
SE-COAST
WA-OR
GOM (Gulf of Mexico)
SOUTH-CAL (southern California)
NORTH-CAL (northern California)
PAC-REGION (including regions in the far South Pacific)
Added the following domains to GEFS Storm Tracks:
CONUS
ATLANTIC
ASIA
NORTH-PAC (northern Pacific)
Europe
Added Probabilistic Storm Tracks for GEFS for the following domains:
CONUS
ATLANTIC
ASIA
NORTH-PAC (northern Pacific)
EUROPE
Added prob_cref_40dbz and prob_max_hlcy_75 to HREF model.
Added Alaska domain to HRRR model.
Added precip type to HREF pmm_refd_max and pmm_refd_1km.
Added the NAMER domain to RAP model.
Added the model name to titles.
Added 1000-500mb thickness field to precipitation products.

https://mag.ncep.noaa.gov/version_updates.php
