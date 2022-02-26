* [ADD] detect if primary OBS is reporting bad data (but still with timely timestamp), if so, fallover to next closest
* [FIX] spc meso fix from wx
* [REF] wXColor -> WXColor
* [REF] move LatLon to coreobjects and use less direct String conversion
* [REF] remove unused imports
* [ADD] use more func in to.
* [REF] rename to to To and func to lowercase
* [FIX] GOES GLM for new sectors res is to low
* [FIX] settings locations -- macOS popup menu is outside window
* [ADD] wrapper for alert action cancel
* [ADD] mainscreen nexrad long press distance to obs
* [REF] why is handling of submenu different between vcTabParent and other tabs (object tile matrix)?
* [ADD] use route in object tile matrix
* [BUG] playlist, play audio, sleep device, wait 30 min, unlick, audio briefly plays and quits
* [ADD] parallel download for nexrad
* [FIX] dual pane does not show radar time for both panes
* [ADD] text labels in multipane nexrad
* [FIX] quad pane runs out of room when warnings selected
* [FIX] rotate main screen on phone results in whitespace due to shrinking bottom nav bar
* OPC Grib2 https://ocean.weather.gov/lightning/lightning_pdd.php
* SPC HREF - cache base layer images
* [FIX] main screen images, if no image, don't show
* [FIX] remove CLI in WFO Text
* [FIX] scan for Future not being used
* [REF] Utility has a function related to hazards
* [REF] remove import UIKit when not needed (ex utilIO / utilLog)
* [REF] LatLon needs import Foundation for math
* [REF] UtilityDownloadNWS has a local appCreateEmail var declared, use GlobalVariables
* [REF] move all IO into utilIO

FYI - FoundationNetworking added in later Swift release

old:
button.addTarget(self, action: #selector(test(sender:)), for: .touchUpInside)
@objc func test(sender: UIButton){}

iOS 14 onwards
button.addAction(UIAction(title: "Test Button", handler: { _ in  print("Test")}), for: .touchUpInside)
