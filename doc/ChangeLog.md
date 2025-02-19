
56143 2021_03_05 (release should not be used for production yet due to N0B/N0G integration)
* [ADD] ObjectDateTime and detect if location obs is more then 2 hours out of date, if so , show next closest
* [ADD] utilHourly - add manual retry for API hourly which often needs it
* [ADD] Models NCEP NAM, add sector "CONUS"
* [FIX] GOES GLM (lightning) animation was not working
* [FIX] bottom tab bar layout issue on larger devices
  - modified bottom padding on anchor in two files
  - wX/fragments/VcTabLocation.swift
  - wX/ui/ScrollStackView.swift
* [FIX] remove observation point KSTF (Starkville, MS) as it's impacting users.
* [FIX] remove decomissioned text products
  - "mimpac: Marine Weather disc for N PAC Ocean"
  - "mimatn: Marine disc for N Atlantic Ocean"
* [ADD] NXB and NXG framework, Level3 super-res
  - https://www.weather.gov/media/notification/pdf2/scn21-96_sbn_super-res.pdf
  - only at KRAX so far https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.00n1b/ missing lowest tilt
  - changes in the following to accommodate: 
	modified:   ../wX/global/ColorPalettes.swift
	modified:   ../wX/global/GlobalDictionaries.swift
	modified:   ../wX/radar/ObjectMetalRadarBuffers.swift
	modified:   ../wX/radar/UtilityWXMetalPerf.swift
	modified:   ../wX/radar/WXGLNexrad.swift
	modified:   ../wX/radar/WXMetalNexradLevelData.swift
	modified:   ../wX/radar/WXMetalRender.swift

56142 2021_11_27
* [FIX] GOES Viewer, eep Eastern East Pacific image was not working after NOAA changed image resolution
* [ADD] National Images - add "_conus" to end of filename for SNOW/ICE Day1-3 for better graphic
* [ADD] SPC HRRR - add back SCP/STP param
* [ADD] first build with Mac M1
* [ADD] switch to non-experimental WPC winter weather forecasts day 4-7
* [ADD] SPC Meso in "Multi-Parameter Fields" add "Bulk Shear - Sfc-3km / Sfc-3km MLCAPE"
* [FIX] SPC Meso in "Upper Air" change ordering for "Sfc Frontogenesis" to match SPC website

56141 2021_10_23
* [FIX] possible fix for toolbar issue on ios15 large iphones compiled with xcode13

56140 2021_10_21 [ADD] Add additional GOES products FireTemperature, Dust, GLM
		 [FIX] NWS Icons not working after NWS html change
		 [FIX] xcode13 + ios15 caused nav controller to be black on first launch, add background set
		 [FIX] TOR/TST/FFW warning was listed twice in Settings -> Colors
		 [REF] use trailing closure syntax when possible
		 [REF] radar Perf - remove references to data stored in files
		 [FIX] re-architect SPC SWO Summary in response to crash reports (speculated on what the problem was)
   *public release
56139 2021_09_14 [FIX] secondary roads were not showing correctly 
   *public release
56138 2021_08_30 [ADD] AWC Radar Mosaic - animation now downloads files in parallel 
	 	 [ADD] AWC Radar Mosaic - remove sectors no longer working: AK/HA/CARIB
		 [ADD] AWC Radar Mosaic - you can now swipe left/right on image to change sector
		 [ADD] AWC Radar Mosaic - ordering of sectors in menu has changed to make more sense with left/right wipe motion
	 	 [ADD] GOES Vis - animation now downloads files in parallel
	 	 [ADD] NCEP GFS - add sector "CONUS"
	 	 [FIX] NHC Storm - images were not expanding to correct image
	 	 [ADD] change Lightning icon to now point to GOES GLM https://www.star.nesdis.noaa.gov/GOES/conus_band.php?sat=G16&band=EXTENT&length=12
			 the provider used previously has had issues with reliability and is not part of NOAA.
	 	 [FIX] crash in certain situations when using text to speech after speech is done
	 	 [ADD] SPC Soundings, add "TEXT" button to show raw text for sounding
		 [ADD] SPC Convective outlook - disable screen timeout in case TTS is used
		 [ADD] only show the program version in settings -> about, not all settings screens
	 	 [ADD] Provide more data in Alert detail screen (vtec, storm motion, headline, max hail/wind, etc)
	 	 [FIX] Settings -> C to F Table, use fixed width font
	 	 [ADD] prelim support for NHC Storms supported out of HFO
	 	 [ADD] Alert detail - if specific windGust or Hail size noted display in toolbar. Radar Indicated unless mentioned otherwise.
   *public release
56137 2021_08_05 [FIX] url had changed in OPC for Alaska/Arctic Analysis Latest SST/Ice Edge Analysis
		 [ADD] OPC - add 72 hour charts for most products
		 [ADD] OPC - add lightning strike density - 15min for multiple sectors (bottom of list)
		 [FIX] Nexrad text labels (cities, etc) were not working correctly on higher res devices such as Max and Plus phones
   *public release
56136 2021_08_04 [ADD] NSSL WRF_3KM has been discontinued by the upstream provider https://cams.nssl.noaa.gov/
		 [FIX] SPC HRRR is now working again
		 [FIX] NCEP - rename WW3 to GFS-WAVE and add additional sectors/products
		 [FIX] NCEP - adjust NMB time periods, remove params that aren't working
		 [FIX] NCEP - correct 2 sectors in ESTOFS and sort list
                 [FIX] remove 4 outdated images in National Images
                            "https://www.weather.gov/images/cle/ICE/dist9_concentration.jpg",
                            "https://www.weather.gov/images/cle/ICE/dist9_thickness.jpg",
                            "https://www.weather.gov/images/cle/ICE/egg_west.jpg",
                            "https://www.weather.gov/images/cle/ICE/egg_east.jpg",
56135 2021_08_01 [ADD] update ESRL HRRR/RAP after NOAA changes
		 [ADD] Rainfall outlook - disable screen timeout in case TTS is used
		 [FIX] National images first three aviation images don’t work
		 [ADD] National images add summary aviation image for all SIGMETs
		 [FIX] National Text - some of the open lake forecasts products were not working
		 [FIX] Show any non-TDWR radar product on nexrad and then switch to TDWR would continue to show old data
		 [ADD] Level 2 animation performance improved
		 [FIX] accuracy of long press on main screen nexrad
56134 2021_07_24 [ADD] long press nexrad radar - show how many miles away closest observation point is
		 [ADD] long press nexrad radar - reduce uncessary text
		   Show Warning text -> Show Warning
		   Show Watch text -> Show Watch
		   Show MCD text -> Show MCD
		   Show MPD text -> Show MPD
		   Nearest observation: -> Observation: 
		   Nearest meteogram -> Meteogram:
56133 2021_07_22 [ADD] nexrad warnings is now enabled by default for new installs
56132 2021_07_20 [REF] use new class Switch in settings
		 [ADD] in settings, alphabetize entries
56131 2021_07_20 [FIX] WPC Forecast chart day1-3 URL has changed
		 [REF] ObjectSlider in UI/Radar
56130 2021_07_18 [ADD] better response via parallel downloads
56129 2021_07_16 [ADD] if warnings enabled and data fails to download, show "-" instead of a number in the statusbar
		 [ADD] ObjectPolygonWarning - if data fails to download, reset the timer
		 [ADD] UtilityGoes functions to support Nhc floater images
		 [ADD] NhcStorm cloud icon
		 [ADD] better response via parallel downloads
56128 2021_07_14 [ADD] NCEP MAG (main NWS production model display) has replaced HRW-NMMB with HRW-FV3. This is accessible via MISC tab, top left corner
                 [ADD] Settings->Radar - show radar when pan/drag. On by default, allows one to see polygons more clearly when off.
                 [ADD] About->Help - remove keyboard shortcuts in doc that no longer exist
                 [ADD] additional download threads in Severe Dashboard and SWO
                 [ADD] a dedicated and more standard activity to handle single MPD/MCD/Watch: vcSpcMcdWatchMpdViewer.swift
                 [ADD] additional download threads in WPC Rainfall Outlook and SPC Fire Outlook
                 [ADD] to.swift for compat with desktop ports
                 [FIX] SPS was not showing in Nexrad correctly (special weather statement)
                 [ADD] Future* and test in WpcImg and Hourly, wpcText
                 [ADD] to.swift for compat with desktop ports
                 [ADD] DownloadTimer - hardcode warn/watch max to 3/6
                 [ADD] NAMER domain to RAP Model in NCEP
                 [ADD] Alask domain to HRRR Model in NCEP
		 [ADD] Accumulated Maximum Updraft Helicity (accu_max_updraft_hlcy) to HRRR model (NCEP)
		 [ADD] prob_cref_40dbz and prob_max_hlcy_75 to HREF model (NCEP)
	renamed:    ObjectScrollStackView.swift -> ScrollStackView.swift
	renamed:    ObjectTextView.swift -> Text.swift
	renamed:    ObjectToolbarIcon.swift -> ToolbarIcon.swift
	renamed:    ObjectToolbarItems.swift -> ToolbarItems.swift

56127 2021_05_21 [FIX] remove Canada radar as EC is no longer offering static images
		 [FIX] SPC SREF was not showing old runs after SPC made a minor change to their HTML code
		 [FIX] Nexrad vertical pan with finger was not dragging correctly (screen was not in sync with finger location)
		 [FIX] Nexrad radar would crash on Level 2 data files that were malformed
		 [REF] refactor getClosestRadar in CapAlert and ObjectWarning
		 [ADD] NOAA has made changes to GLCFS https://www.glerl.noaa.gov/res/glcfs which required changes to wX
56126 2021_04_05 [FIX] lint
		 [REF] avoid using str and string as var names
		 [ADD] if only 2 images showing in severe dashboard, make them larger
		 [ADD] AK and Hawaii images for AWC Radar mosaic
                 [FIX] SPC Meso - the following image products were not working correctly "temp_chg" "dwpt_chg" "mixr_chg" "thte_chg"
                 [FIX] is certain warnings are enabled and active, in somes cases long press in nexrad was not showing "show warnings", quick fix is to show the item all the time
		 [FIX] some forecasts icons showing "0%"
		 [FIX] SevereDashboard status bar warning count did not always match displayed warnings - refactored with ObjectWarning used in SevDash and Nexrad
		 [FIX] location fragment - globalTextViewFontSize not initialized properly causing data to load twice on initial load (hazards would duplicate)
56125 2021_02_27 [FIX] UtilityWXOGL and CapAlert to make use of the new API URL for alerts starting with urn:oid
		 [FIX] In UsAlerts, do not show radar icon if WFO/Radar Site can't be detected
		 [REF] code cleanup
		 [FIX] crash in severedash when tapping on alert
56124 2021_02_24 [REF] move more stuff out of myapp, add ObjectLocation
		 [FIX] make AWC radar mosaic the only option for radar mosaic as NWS has removed a timeframe for the traditional radar mosaic
		 [FIX] make the older NWS API the default for 7 day forecast
56123 2021_02_20 [FIX] SPC MCD regexp was not correct
		 [ADD] SPC Meso - move VTP Violent Tornado from Beta into Composite Indices to match SPC website
		 [ADD] SPC Meso - add Tornadic 0-1km EHI to Beta to match SPC website
		 [ADD] SPC Meso - add Tornadic Tilting & Stretching to Beta to match SPC website
		 [ADD] SPC Meso - remove Enhanced EHI from Beta as it's no longer present on the SPC website
		 [ADD] print for download methods
		 [REF] add commented code to deal with UI deprecations
		 [ADD] add option to use old NWS API for 7day - WIP
56122 2021_01_23 [FIX] remove "pmdhmd: Model Diagnostics Discussion" from National Text Products as the NWS no longer provides this product
		 [FIX] corrected URLs for 2 Space Weather images in National Images
		 [FIX] on a fresh install, county lines were not turned on by default in nexrad radar as they should
		 [FIX] if an NWS issue was preventing 7 day from updating, once issue is restored, allow refresh to populate new cards
56121 2020_08_25 take 3 for apple app store approval
56120 2020_08_25 take 3 for apple app store approval
56108 2020_07_10 
56107 2020_07_10 [FIX] remove draw tool from settings -> colors
		 [FIX] remove beta label from spotters in settings after apple rejected last release
56106 2020_07_10 [FIX] NHC Storm graphics
56105 2020_06_13 [ADD] additional local text products HLS, MWW, CFW, FFA
		 [ADD] continued work on radar icon in severe dash, usalerts, and mcd/mpd/watch viewer
		 [ADD] nexrad radar: don't show warning count in bottom toolbar when animating - not enough space on smaller phones
		 [ADD] nexrad radar: remove useless title from menu opened when "long press"
		 [ADD] nexrad radar: minor formatting changes in menu opened when "long press" to reduce space used and clutter
		 [ADD] nhc - minor verbiage change in bottom toolbar labels
		 [ADD] in submenus where the title is redundant or obvious, removed it
		 [ADD] GOES - add 2 additional products (GLM FED and DMW) for CONUS/FD sectors in both GOES-16 and GOES-17
		 [ADD] GOES products DayCloudPhase NightMicrophysics, see https://www.star.nesdis.noaa.gov/GOES/index.php for description
		 [ADD] WXGL polygons and severe dash - add check if vtect is current
		 [FIX] SPC Mesoanalys - animation was skipping most current frame, off by one
		 [ADD] UtilityDownloadRadar.getWatch - don't fetch initital watch data, go straight to aviation
56104 2020_06_08 [REF] colormap optimizations
		 [REF] use Int instead of String for productCode in colorpal stuff
		 [ADD] radar icon in usalerts detail
		 [ADD] Canadian observations image
		 [REF] add PolygonEnum and refactor SevereNotice/Warning, severeDash, nexrad radar mainscreen/dedicated utilRadarUi, ObjectSPC to use it
		 [FIX] minor formatting change in USAlerts detail
		 [FIX] remove HTML tags from text that is used for TTS in USAlerts detail
		 [ADD] NHC Storm detail text products, use National text viewer instead of generic text viewer
		 [FIX] SPC Meso - fix region/sector display in lower right corner
		 [ADD] additional NHC text products that require fixed width
                 [ADD] SPC HREF 24-hr STP Calibrated: Tornado
                 [ADD] 1-hr HREF Calibrated: Thunder
                 [ADD] 24-hr HREF Calibrated: Thunder
		 [ADD] NHC text products MIATWSAT / EP are now fixed-width font with newlines not stripped
		 [ADD] new SPC Meso param SR Helicity - Sfc-500m (srh5)
		 [ADD] new SPC Meso param Sgfnt Tornado (0-500m SRH) (stpc5)
		 [FIX] in SPC SWO summary must have tablet in landscape to show 4 images across, shows 2 now
// App Store Release
56103 2020_05_20 [REF] misc
		 [REF] rename patterns in model util files
		 [FIX] in homescreen remove the 2km on the Radar Mosaic label
		 [FIX] in homescreen unify the label for CONUS WV and VIS
		 [FIX] in some submenus, make the text less verbose so it's not small
	         [FIX] default aviation size for tablet, move from 1 to 2
	         [ADD] NHC Storm move images to top and show multiple per row
	         [ADD] NHC Storm structural changes based off Flutter port
		 [ADD] NHC Storm move to json data source per https://www.weather.gov/media/notification/scn20-25tropical_javascrpt.pdf
56102 2020_05_16 [REF] misc
		 [ADD] from adhoc location allow to save location
		 [FIX] WFO text / WFO LSR - resize map on screen rotate
		 [REF] remove inout if possible
		 [FIX] dual pane shows same prods when remember location not on
		 [ADD] in color picker if tap "set to default", immediately exit to prior screen
		 [FIX] no share in canada radar
		 [ADD] in Spotter activity remove phone number/email as they are not available on https://www.spotternetwork.org/ w/o member login
		 [FIX] nexrad radar screen rotation with text labels did not reposition them
56101 2020_05_11 [REF] misc
		 [REF] location save, don't save notification pref since notifs not used
		 [REF] remove unused prefs in UtilityStorePreferences
                 [ADD] GOES sea cak
                 [REF] add UtilityNetworkIO and move some stuff from UtilityDownload
		 [ADD] in ui/CustomTabBarVC remove custom font for tab labels
	 	 [FIX] MacOS - quad pane long press in polygon in bottom 2 panes does not work
	 	 [REF] WXGLDownload - convert to all static methods/vars
		 [REF] remove UtilityColorPalette57
		 [REF] remove UtilityHelp
		 [FIX] color picker is to slow on large screens
		 [REF] implement class to handle routing
		 [ADD] vtec check in UtilityTime but don't yet use in SevereWarning
		 [FIX] in some views that show web content, clicking on the external browser button was not working
56100 2020_05_01 [REF] misc
	         [ADD] If jump to nexrad from US Alerts or Severe Dashboard, don't save radar prererences on exit
		 [ADD] NCEP MAG comp ref change in nam-hires firewx hrrr rap hrw-nmmb hrw-arw hrw-arw2
	         [FIX] nearest forecast from main screen nexrad as not showing lat/lon even thought it worked
	         [FIX] NCEP MAG remove WW3-ENP WW3-WNA
	         [ADD] nexrad long press - if not warnings don't show option for text
	         [ADD] nexrad long press - if not mcd don't show option for text
	         [ADD] nexrad long press - if not mpd don't show option for text
	         [ADD] nexrad long press - if not watch don't show option for text
	         [FIX] nexrad background color was only partially working
		 [FIX] if display nexrad on main screen, long press did not show options to show MPD/MCD/Watch text if those features were enabled
56099 2020_04_10 [REF] misc
56098 2020_04_10 [FIX] SPC Storm reports was not working on MacOS due to illegal customizations of data picker
		 [ADD] add radar icon in severe dashboard warning cards that lead to nexrad
		 [FIX] disable keyboard shorts in fragments as they are doing odd things
56097 2020_04_05 [FIX] state detection in Locations was not working in some cases
		 [FIX] SPC SWO state graphic - if HI or AK force to AL as it's lower 48 only
		 [FIX] SPC Watches - remove HTML tags that occasionally show up
		 [REF] enhance code formatting
56096 2020_03_15 [FIX] text products start RWRMX and starting with TPT and 5 characters long were not working
		 [ADD] national text - for some text products use fixed width
		 [REF] add named arg for all forEach {}
		 [REF] cleanup un utilSwoD1 and other refactors in radar code
		 [REF] fix utilRadar / utilRadarUI
		 [REF] misc for code reability and ongoing maintenance
56095 2020_03_09 [FIX] crash in storm tracks due to index error conflict
56094 2020_03_08 [ADD] use ObjectImageSummary in SPC SWO, Fire, Tstorm, WPC Rainfall
		 [REF] ObjectScrollStackView - use properties in main viewController
		 [ADD] move willEnterForeground and getContent into parent view controller, override as needed
		 [REF] move call to refreshViews into displayContent when applicable
		 [REF] many VCs had uneeded call to add toolbar to parent view
		 [REF] ObjectPopup - add title as named arg with default
		 [FIX] Canada warnings format improvements
		 [ADD] forecast zone url to settings -> about
		 [REF] remove City class and UtilityMap
		 [FIX] setting homescreen labels were not correct for QPF1 and possibly others with shared prefix
		 [REF] remove unused UtilityCanvas.swift UtilityCanvasGeneric.swift UtilityCanvasMain.swift
		 [ADD] potential minor Level 2 performance enhancement (backed out)
		 [FIX] homescreen tokens that included a -, such as QPF, were not working
		 [FIX] when adding canada location does not show on map at first
56093 2020_03_02 [ADD] label in status bar in SPC Fire Weather Outlooks
		 [FIX] PlayList: nation text add menu was not working and both adds allowed duplicate entries
		 [REF] PlayList: use enum for icons in toolbar
		 [FIX] US Alerts needed width constraint for text cards
		 [FIX] if in US Alerts don't rotate warning images but instead do image view with CONUS image
		 [FIX] if in US Alerts and rotate screen while filter is not standard it resets
		 [FIX] playlist: save after each add or mod
		 [REF] ObjectFab add method to set image
		 [ADD] Playlist remove play icon and use Fab instead
		 [REF] move audio stuff from UtilityAction to UtilityAudio
		 [REF] use IconType in ObjectFab
		 [REF] use enum for icon type 
		 [FIX] homescreen - save to disk after every change
		 [FIX] adhoc location layout was not working
		 [ADD] add framework in playlist prebuild menus but don't use (to slow init load)
		 [ADD] onrestart to SPC SWO and SPC Fire
		 [ADD] share button to Canada location hourly
		 [ADD] ObjectImageAndText and use in SPC Fire and WPC Excessive Rainfall, SPC Convective Outlook
56092 2020_02_28 [FIX] lighter background behind cards
		 [FIX] objectTextView rationalization
		 [FIX] remove option UIPreferences.nwsTextRemovelinebreaks - not needed
		 [FIX] remove option to use Farenheit vs Celsius as it was implemeneted in only one spot
		 [FIX] remove ability to tap text in settings in help screens as information was not helpful
		 [ADD] improve existings labels in settings
		 [ADD] main screen verbiage enhancement for Hourly and Alerts to US Alerts and Hourly Forecast
		 [FIX] vc GOES and Global don' t have properties marked as private
		 [FIX] Canadian Hourly
		 [FIX] in nexrad radar if spotter labels chosen but not spotters then labels would not show
		 [ADD] in playlist change newlines to spaces and show 400 characters instead of 200
		 [FIX] fix duplicate spaces by translate in String extension for line breaks
		 [FIX] TextViewer move share icon to far right for consistency
		 [ADD] UIwXViewControllerWithAudio for superclass supporting TTS and playlist
		 [ADD] in NHC have text products go to vcWpcText instead of textviewer
		 [ADD] SPC fire outlook add Day # in toolbar
		 [ADD] WPC Excessive rainfall add Day # in toolbar
56091 2020_02_26 [FIX] crash in WatMcdMpd if any icon was tapped when no products were loaded
		 [ADD] NHC refactor code
		 [ADD] change default nws icon size from 80 to 68
		 [FIX] homescreen image on size change
		 [ADD] in WfoText don't display code name
		 [ADD] in NationalText don't display code name
		 [FIX] formatting enhancement for PMDTHR
		 [REF] work towards standardizing on uppercase for all text products from data source
	       	 [ADD] in wfo,radar,sounding cutover to new map class
	       	 [ADD] better support for rotation in VCs with single image
		 [FIX] SPC Meso image cutoff at top due to top toolbar
		 [ADD] in UIPreferences use flutter/dart blue for highlight
  		 [FIX] SPC Meso - don't show codes in bottom menus
  		 [FIX] Severe Dashboard warning card width in landscape
56090 2020_02_20 [FIX] support NWS icon size in new framework
		 [ADD] state level RWR
		 [ADD] WatMcdMpd leave screen on for TTS and reset TTS on exit
		 [FIX] support auto rotation of other views with constraints and not reload views
56089 2020_02_20 [FIX] animating L2 was not showing frame count
		 [FIX] animating L2 - slow down anim interval otherwise it just doesn't work
		 [FIX] force additional WFO text prod to fixed width no newline replace
		 [FIX] support auto rotation of main screen *HIGH IMPACT*
		 [FIX] support auto rotation of other views with constraints and not reload views
56088 2020_02_16 [ADD] code for navigationController but do not use yet
		 [ADD] optimize SPC Fire / Tstorm outlook for large screen
		 [ADD] add title in toolbar for SPC SWO
		 [ADD] MCD/MPD/WAT viewer - if tap on image show image in dedicated viewer
		 [ADD] MCD/MPD/WAT viewer - if in summary mode and tap on image show image/text instead of just text
		 [REF] in VCs mark vars private if can
		 [ADD] NHC: have multiples images per row
		 [REF] remove files that are no longer in the project
		 [FIX] zoom level for WPC fronts text vs lines was not the same
		 [REF] misc lint and code refactor
		 [ADD] swipe screen edge left to go back (does not work in nexrad radar or when zoomed in on images)
		 [FIX] nexrad radar map selection was not working, pins were not present
		 [ADD] dedicated SPC Fire outlook viewer with text and image side by side
		 [ADD] optimize SPC Convective outlook if in landscape and tablet
		 [FIX] minor formatting issue in SPC Convective Outlooks
56087 2020_02_11 [REF] remove the need for storyboards as much as possible
		 [REF] remove the need for ActVars as much as possible
		 [FIX] spotter report map not working
		 [ADD] in text activities swap the share and add to playlist icons
		 [ADD] in settings - location, increase font size and spacing for location name
56086 2020_02_10 [FIX] icons per row now changes dynamically after setting in Settings -> UI
		 [ADD] re-architect Severe Dashboard image handling, if Landscape show 3 images per row
		 [ADD] WPC Rainfall disc optimize for landscape mode on big screens
		 [REF] rename ViewControllers to start with vc instead WIP
		 [REF] reorg SevereNotice and SevereDashboard
		 [REF] rename remaining viewControllers ( NHC/Fragment )
56085 2020_02_09 [ADD] continued work on SpcMcdWatchShowActivity
		 [ADD] CPC 3 month temp/precip outlook in WPC Images
		 [ADD] add aditional products in WFO Text viewer
		 [ADD] substantial revamp of utilDownload, WFO text, national text with regards to data download and presentation
56084 2020_02_08 [FIX] update google doc links to point to published versions in settings -> about
		 [FIX] if tablet make radar circles smaller
		 [ADD] WIP - SpcMcdWatchShowActivity - if tablet in landscape change orientation of linearLayout
		 [ADD] SevereDashboard - add count data to status area in bottom toolbar
		 [ADD] In nexrad radar only show long press items for warn/mcd/wat/mpd if they are configured to be shown
		 [FIX] tablet wind barb size on zoom
		 [FIX] decrease spotter/wind barb size in catalyst
		 [FIX] hourly now has quotes around temp
		 [FIX] landscape WAT/MPD/MCD display not working
		 [REF] WIP - combine WAT/MCD/MPD and when multiple images and tap image show image/text not just text
		 [FIX] use alternative sources for text products: WFO: AFD, SPC Convective Outlooks, Short Range disc
56083 2020_02_01 [ADD] move to WXGLNexrad: Utility.readPref("WX_RADAR_CURRENT_INFO", "")
		 [FIX] severedash onrestart mcd: does not clear images and later crashes
		 [REF] move off disk storage for various things like wfo/radar x/y/name
		 [ADD] revamp twitter stuff.
56082 2020_01_30 [ADD] WFO Text - make RWR and RTP fixed width
                 [ADD] WFO text - fix RTP formatting
                 [FIX] ESRL - HRRR was still listed as default - change to HRRR_NCEP
		 [ADD] WPC Text - add hazards 3-7
		 [ADD] sync kbd shortcuts between iOS and Android version
		 [ADD] additional graphics for SPC Convective Outlook Day 2
56081 2020_01_25 [REF] simplication in UtilityDownload*
		 [FIX] TTS was not working well in WFO
		 [ADD] in WFO alphabetize menu 
		 [ADD] enhanced settings -> about with faq/release notes link
		 [ADD] hide wpc fronts at certain zoom level
		 [FIX] obs that show XX Inches of Snow on Ground
		 [FIX] TTS was not working well in WPC Text and others
		 [FIX] TTS was not working well in Playlist (wip)
		 [ADD] in WFO text viewer prevent screen from going off
		 [ADD] in WPC text viewer prevent screen from going off
		 [FIX] three PMD text products that were not working 30/90 day CPC, etc
		 [ADD] allow to zoom out further in nexrad
		 [FIX] Catalyst - wxoglsize does not appear to work
		 [FIX] RWR in WFO Text
		 [ADD] RadarFile class from flutter/dart port (wip)
		 [ADD] onrestart in playlist
		 [ADD] In national text activity combine the first two subsections into one section as they are basically the same
		 [REF] misc rafactor - ie var rename, etc
		 [REF] UtilityMetar - move to common method and global vars for obs data
		 [FIX] WPC storm summary text product was not working
56080 2020_01_11 [ADD] help button in location -> edit
		 [FIX] in settings main remove version from about wxl23 (since it's in toolbar)
		 [ADD] *add to UtilDownload* wpc day 1 -3 image + text (rainfall outlook)
		 [ADD] *add playlist support* wpc day 1 -3 image + text (rainfall outlook)
		 [ADD] After add location make it the current one
		 [REF] camelCase and reduce global vars
		 [ADD] DownloadTimer ( to be used in UtilityDownload* mcd/wat/warn/swo/spotter etc )
		 [ADD] DownloadTimer use in most radar download areas
56079 2020_01_08 [FIX] wpc fronts - render had index off by one
		 [FIX] wpc fronts - few for loop bugs on cold/warm front creation
		 [FIX] wpc fronts - make blue lighter
		 [FIX] wpc fronts - trof is now dashed line
		 [REF] various lint cleanup
		 [ADD] onrestart in spotter activity
		 [REF] update copyright in all files
		 [FIX] homescreen Meso widgets do not open correct image on tap
		 [FIX] some Canada radar code names have changed
		 [ADD] in settings location when choosing candian city exit to prior screen after city selected
		 [ADD] in settings location edit once you long press on the map it saves automatically
		 [ADD] in settings location edit if saving location via map use name of format "CA, Palm Springs" (as example)
		 [ADD] in settings location edit if using gps to save location use lat/lon lookup to formulate name
		 [ADD] framework for WPC Excessive Rainfall Discussion
56078 2020_01_04 [ADD] refresh homescreen if homescreen widgets have changed
		 [FIX] remove sun/moon data as homescreen widget choice
		 [ADD] use fixed width font for hourly homescreen widget
		 [FIX] macOS version was not expanding textual homescreen widgets
		 [FIX] homescreen widget for awc radar no longer shows national but shows regional
		 [FIX] prevent adding duplicate homescreen widgets
		 [FIX] after leaving settings -> radar download fresh warning data in nexrad regardless
		 [FIX] if settings -> UI has updated text size reload data on main screen, impacts text widgets only 
		 [FIX] standard homescreen objects do not reflect text size immediately
		 [FIX] better support for dynamic text size
		 [FIX] don't show labels in SPC Storm reports if no reports
		 [FIX] settings homescreen - trim lead/trail whitespace for labels
		 [ADD] wpc fronts feature
56076 2020_01_01 [ADD] shortcuts: s, e, n, h, t, l, i, z
56075 2020_01_01 [ADD] Additions to Homescreen and WPC Images for WPC Forecast charts
		 [FIX] WPC Fmap Day1 was not working in homescreen
		 [FIX] Hourly was not correct during week of new years
		 [ADD] USWarn as homescreen option
		 [FIX] Fulldisk global viewer - remove first four images (2 are stale)
		 [FIX] make sure homescreen images go to correct viewer (esp WPCImaegs)
		 [ADD] shortcuts for 2,4,w
		 [REF] Move GlobalVariables into an actual GlobalVariables class for scope reasons
56074 2019_12_20 [ADD] WFO warnings image to homescreen
		 [ADD] better obs data in us_metar3.txt stations_us4.txt via getObs.py
56073 2019_12_17 [ADD] TDWR 180 to replace 181 (16 to 256 bits for color)
56072 2019_12_01 [ADD] new goes product 
		 [FIX] Canada text product viewer was not clearing views when changing text product
		 [FIX] Canada alerts were not selectable on MacOS
		 [FIX] program was crashing when saving canada location
		 [FIX] Canada text product FXCN01 was not working, not broken down into 4 text products east/west, d1-3 and d4-7
		 [FIX] Canada radar animation not working
		 [REF] Canada radar var names
		 [FIX] Canada GOES animation was not working
		 [FIX] AWC radar - make animation work for all radar products
56071 2019_11_29 [FIX] gmt time was not updating on main screen
56070 2019_11_12 [FIX] change ObjectCardPlayListItem,ObjectCardLocationItem to match ObjectSpotterCard
		 [FIX] home screen nexrad on MacOS is too big
56069 2019_11_10 [FIX] nexrad on homescreen bugs
56068 2019_11_07 [ADD] macOS: From other tabs, hit esc and goes to main screen
		 [FIX] in obs, launch browser now works
56067 2019_11_07 [ADD] reduce spacing and change background color to more closely mimic iOS design 
		 [FIX] CA locations not showing on map in location edit
		 [FIX] few icons missing for SF Symbols, optimize code to support
56066 2019_11_05 [FIX] nexrad keyboard zoom in and out did not keep center
		 [FIX] wind barb gusts were not working
		 [FIX] San Fran text label not correct - 37.787239,-122.4581,805235
		 [FIX] obs did not show on init radar load
		 [FIX] no back button twitter
		 [FIX] nexrad radar restart - textViews would keep stacking up
		 [ADD] ability to configure text size in nexrad
		 [ADD] SPC HREF update part 1
		 [ADD] location -> edit, after save center map/zoom
		 [ADD] add map link form Obs activity
		 [ADD] condense location card in settings location, remove state
		 [FIX] bug related to radar text size shown via enable/disable cities
56065 2019_10_21 [ADD] radar autorefresh by default
		 [FIX] pane detection in multipane nexrad
56064 2019_10_18 [FIX] main screen toolbar fix for notch phones
		 [FIX] top toolbar in models
		 [FIX] code cleanup
56063 2019_10_17 [ADD] more autolayout constraints esp for toolbar to help MacOS port
		 [FIX] UI consistency enhancements in SPC stuff
		 [FIX] radar was not consulting fetch interval
		 [ADD] macOS main screen refreshes 
56062 2019_10_16 [ADD] catalyst work - wip
		 [FIX] hazards show up twice after screen on - not so when switching locations
		 [FIX] text in nexrad is off
		 [ADD] key shortcuts in nexrad - arrows and keypad for movement
		 [ADD] macOS - change init zoom level when change radar site in nexrad
56061 2019_10_13 [FIX] main screen location button and settings buttons were not working on MacOS, need to mark self.objLabel.tv.isSelectable = false
		 [ADD] catalyst specific bounds code in utilUI
		 [ADD] catalyst work - wip

// appstore release 10/10/1029 56060
56060 2019_10_10 [FIX] colors on pre iOS 13 in Color Compat
56059 2019_10_08 [ADD] use simd float4x4 instead of Matrix4
		 [ADD] enable macOS as a target

// appstore release 10/8/1029 56058
Added support for iOS 13 darkmode. In settings -> radar add option to center radar on GPS location if GPS location is enabled. Add SPC Meso pw3k PW * 3kmRH under Beta. In nexrad radar add warning count in lower toolbar if enabled. Remove TDWR products 78, 80 which are being phased out.  Add dawn/dusk times in bottom most card on main screen, remove from main sub-menu. Bugfixes

56058 2019_10_08 [ADD] playlist add product label for long press
		 [ADD] dawn/dusk to card at bottom of main screen, remove dedicated view from submenu
56057 2019_10_05 [ADD] change highlight text color to "link"
	 	 [ADD] continued dark mode support for dynamic transitions
		 [ADD] add onRestart to adhoc location, hourly, observations, severe dashboard, sounding
		 [ADD] add onRestart to usalerts, usalerts detail, cawarn, nhc, spc compmap, spc firesummary
		 [ADD] add onRestart to spc state, spc summary, spc tstorm summary, goes global, wpc img
		 [ADD] UI refinement and darkmode transition in Loction Edit
56056 2019_10_04 [ADD] attempt to add code in UIwXViewController for dark mode change
56055 2019_10_03 [FIX] nexrad location dot circle size issue on start
		 [FIX] screen is not staying on when configured to do so ( when jumping to dual pane and back )
		 [FIX] double-tap radar ipad not quite working (partial fix between phone and tablet)
		 [ADD] remove TDWR 78/80 N1P NTP per notice
		 [ADD] ColorCompatibility.swift and start to migrate to it
		 [FIX] in nexrad trigger popup and then tap back button, any action after causes crash
		 [FIX] landscape radar initial view to zoomed in
56054 2019_09_29 [ADD] minor change to default blue theme to more closely match other ports
		 [ADD] modernize severe dashboard
		 [ADD] in nexrad radar add warning count in lower toolbar if enabled
		 [ADD] option to center radar on location
		 [ADD] in radar if map is shown, hide when back button is pressed
		 [ADD] SPC Meso pw3k PW * 3kmRH
		 [ADD] use 4bit colorpal init like flutter
56053 2019_09_27 [FIX] force light mode in plist info
56052 2019_09_25 [FIX] build script
56050 2019_09_25 [ADD] xcode 11 produced first release
		 [ADD] lint cleanup from new dev environment esp var to let
		 [FIX] UtilityActions - nextViewController.modalPresentationStyle = .fullScreen (ipados 13)
56046 2019_09_06 [FIX] hurricane icon
		 [ADD] NHC - add more verbiage in storm card
		 [ADD] NHC Storm - move path grapgic to top, add qpf and arrival graphics
		 [FIX] Level 2 download size check was not working

// appstore release August 21, 2019 56044
In SPC Storm reports allow filtering by state. In long-press in radar show VCP in menu. Better tilt management in nexrad radar. Fix SPS warning in US Alerts. Fix issue with long press inside special weather statements in Nexrad radar, was not always showing correct text. Fix heat index from showing when approximately equal to temperature. Better sizing or GPS Location circle in Nexrad radar.

56044 2019_08_21 [ADD] WPC Analysis to homescreen
		 [FIX] better sizing for gps location circle
		 [FIX] fix rounding display error related to heat index
		 [ADD] allow storm reports filter by state
		 [FIX] fix SPS formatting in uswarn
		 [FIX] UtilityWXOGL.showTextProducts filter out SPS with no polygon
		 [ADD] in radar long press - minor formatting change and show VCP
56043 2019_08_03 code cleanup
56042 2019_07_27 better tilt management


// appstore release July 24, 2019 56035
In radar, add products for TDWR: TR0, N1P, and NTP. Add tilts for TR0/TV0. In radar, add Level 3 product composite reflectivity for 124nm and 128nm. Bugfixes: warning polygons were not also being removed correctly. WPC GEFS parametars/labels were off by one near the end of the list. Reminder: In Nexrad radar you can press and hold to bring up a contextual menu for additional selections. Also, if your radar site is presenting old radar data the timestamp font color will change to red.

56041 2019_07_24 [FIX] fix for ghost tor warnings
56039 2019_07_21 [FIX] tilts for TDWR TV/TR
		 [FIX] if TDWR show only 3 tilts otherwise show 4
56038 2019_07_20 [ADD] init work on radar comp ref
56037 2019_07_20 [FIX] crash in radar if network is down and access 4bit products like N0S or TR0
56037 2019_07_19 [FIX] Settings -> UI, remove unused option show metar in CC, for text size change max/min to something more reasonable
		 [ADD] for TDWR add TR0, N1P, NTP
56036 2019_07_14 [FIX] wxmetalradar - add semaphore to protect getPolygonWarnings() when auto update is turned on and onrestart()
		 [FIX] wpc gefs other index off by one

// appstore release July 13, 2019 56035
Improve download/display of NHC data. NHC Storm screen now properly supports screen rotation. Bugfixes in SPC HREF, NCEP NAM-HIRES, and ESRL (remove poorly performing experimental models).

56035 2019_07_13 [FIX] NHC Storm not properly rotates
		 [FIX] Spec href end at 84
		 [FIX] Namhires start at one not zero
		 [FIX] iOS remove ESRL hrrrx and RAP
56034 2019_07_12 [ADD] break up download/display in NHC
56033 2019_07_04 [FIX] visibility typo in ObjFcstCC
		 [FIX] in objectSlider several min were changed to 1 from 0

// appstore release July 1, 2019
Add heat index. Improve formatting of NHC storm cards. In severe dashboard show 2 images per row. Bugfixes

56031 2019_07_01 [FIX] in info.plist add CFBundleDisplayName which now is required for app store submission
56030 2019_07_01 [FIX] Text products: remove broken canada product and fix formatting for NFD*
		 [FIX] lint cleanup
		 [FIX] migrate from UIWebView to WKWebView
		 [FIX] in memory buffer move off deprecated data.withUnsafeBytes
		 [FIX] in homescreen and playlist use utilWcpcText instead of global array
		 [ADD] heat index
		 [ADD] severe dashboard 2 icons per row and whitebg
56029 2019_06_26 [ADD] NHC - add formatted card like android version

// appstore release June 22, 2019
In SPC Convctive Outlooks condense images, tap on image to show full screen.
Remove moon rise/set times until an accurate replacement is found.
In NCEP Models alphatize list.

56028 2019_06_22 [FIX] remove moon data until an accurace replacement can be found
		 [FIX] NCEP Models, alphabetize list of models
56026 2019_06_15 [IMP] SPC SWO Summary/daily show 2 imaegs per row
		 [IMP] move to whitebg for scrollview in SPC SWO screens
		 [IMP] SPC SWO Summary support rotation properly

56026 2019_06_15 
// appstore release June 15, 2019
Add Central Pacific in NHC screen (3 images, 1 text product)
Updates to NCEP models in response to website change. 
- Add new models: HRW-ARW2, HREF, NBM
- SREF/GEFS-MEAN-SPRD adad precip_ptot Total Accumulated Precipitation of Period
- HRRR add 300_wnd, fix to 250_wnd,
- RAP add 200_wnd_ht
- HRRR add 850_temp_mslp_precip
- NAM-HIRES add ceiling
- Rename the following areas:
  ATLPAC -> ATL-PAC
  NPAC -> NORTH-PAC
  EPAC -> EAST-PAC
  SPAC -> SOUTH-PAC
  WNATL -> WN-ATL
  WGOA -> WEST-GOA
  EGOA -> EAST-GOA
  NCAL-> NORTH-CAL
  SCAL -> SOUTH-CAL
  SREF: Change prob_precip_25 to prob_precip_0.25in
- Remove sim_radar_comp from the following models
  NAM-HIRES
  FIREWX
  HRRR
  RAP
  HRW-NMMB
  HRW-ARW
- Remove sim_radar_max from the following models
  FIREWX
  HRW-NMMB
  HRW-ARW

// appstore release June 12, 2019
Updates to NCEP models in response to website change. More updates to come in future changes
- fix run time latest detection
- add new sectors US-NW, US-SW, US-NC, US-SC, US-NE and US-SE to  NAM-HIRES, HRRR, HRW-ARW, HRW-NMMB and HREF
- add American Samoa (US-SAMOA) to GFS.
- NCEP HRW-ARW, HRW-NMMB, NAM-HIRES, RAP and HRRR: Change echotop to echo_top

56025 2019_06_12    [FIX] NCEP work - fix run time latest detection
                    [ADD] NCEP add new sectors US-NW, US-SW, US-NC, US-SC, US-NE and US-SE to  NAM-HIRES, HRRR, HRW-ARW, HRW-NMMB and HREF
                    [ADD] NCEP Add American Samoa (US-SAMOA) to GFS.
                    [FIX] NCEP HRW-ARW, HRW-NMMB, NAM-HIRES, RAP and HRRR: Change echotop to echo_top

2019_06_05 56022	[FIX] remove some retired observation sites 
			[FIX] update to https in UtilityGoesFullDisk, ObjectAlertSummary, UtilityDownload, UtilityLightning (and others, numerous)

// appstore release June 8, 2019
- enhanced iOS voiceover support in MCD/Watch/MPD/Severe dashboad and Homescreen textual widgets
- add option in settings -> UI to use full resolution GOES images
- bugfixes: remove obsolete obs site KIGX, in settings->location current conditions was not updating correctly after adding new location

2019_06_05 56020	[FIX] remove obs site KIGX
			[FIX] when add new location and navigate back to list it shows condition from 1st location
2019_06_05 56014	[ADD] add option in settings -> UI to use full resolution GOES images
2019_06_04 56013	[IMP] voice over enhancements in mcd/watch/severe dashboard and us alerts detail, main screen cc 7day

// appstore release June 2, 2019
- enhanced iOS voiceover support in MCD/Watch/MPD/Severe dashboad and Homescreen textual widgets
- don't hide GPS circle when panning in nexrad radar
- in NHC activity if no current storms display a textual label stating such
- in data fetch for watches and warnings if a network issue keep current data instead of showing nothing

2019_06_02 56012	[IMP] for watch/warn data if no data is returned don't update var
			[IMP] If not storms in NHC show card stating such (like Android/Kotlin)
			[IMP] SPC MCD - play button now TTS all text available
			[IMP] SPC Watch - add TTS Play
			[IMP] don't hide GPS when pan
			[IMP] radar refresh interval make min 1 not 0
			[IMP] voiceover enhance in SPC MCD/Wat/Fireoutlook
			[IMP] improve voiceover in Severe dashbard, MPD, and SWO

// appstore release June 1, 2019
Changes since last release:
- initial iOS voiceover support
- if nexrad radar data is old show timestamp text as red
- in single pane nexrad radar if tap timestamp convert to dual pane radar
- CPC/WPC 3-7 and 7-14 day outlooks were broken
- in nexrad radar when long press show beam height
- images are now scaled properly in landscape mode, no excessing cropping
- add 850mb (version 2) product to SPC Mesoanalysis
- in settings use slider instead of number picker when possible
- in nexrad radar when tap stop button in animation show latest frame
- add moon data to main screen

2019_06_01 56011	[IMP] initial voiceover support
2019_05_27 56009 	[REF] camelCase vars/methods
			[IMP] in radar display existing polygons first
			[IMP} enhancements in dual-pane landscape radar
2019_05_26 56008 	[IMP] move slider below textual label with width anchor
2019_05_25 56007 	[REF] camelCase numerous util* files
2019_05_24 56006 	[IMP] more slider work
			[FIX] animating nexrad was showing red text for older radar timestamp
			[IMP] when hit stop button after animating show latest frame
2019_05_24 56005 	[FIX] fix time in radar multipane (partial)
			[IMP] enhance landscape dual pane to center correctly
			[IMP] add 850mb2 to SPC Meso
			[IMP] images are now scaled properly when in landscape
			[FIX] nexrad radar rotation issue on phone
2019_05_23 56004 	[ADD] ObjectSlider and test in settings -> radar
2019_05_21 56003 	[IMP] dual pane radar in portrait now shows panes left to right
			[FIX] NHC Storm images were showing as blank (86 in size)
2019_05_20 56002 	[FIX] long press in radar in watch box was not working correctly
			[REF] better var naming
			[FIX] fix drought monitor img in wpcImg
			[FIX] watch data was not showing correct text ( was showing status )
2019_05_20 56001 	[REF] use static instead of class for static methods
			[IMP] radar - save pref before jumping to dual pane
			[FIX] WPC Img - CPC 3-7 and 7-14 outlooks were broke
2019_05_19 56000 	[ADD] add radar beam in long press
			[IMP] WPC Images - remove experimental forecast characters
			[FIX] nexrad radar long press, if select a different type of polygon don't show anything
			[FIX] dedicated SPC MCD tap action shows image not text
2019_05_19 55999 	[REF] refactor cc,7day,haz objects
			[IMP] if radar is old show timestamp as red
			[IMP] in radar tap time text to invoke dual pane
2019_05_19 55998 	[REF] refactor cc,7day,haz objects
			[REF] camelCase and better naming
2019_05_16 55995 	test new cert, misc refactor
2019_05_11 55993 	build was freezing: fix Exclusive Access to Memory ( compile time enforcement only ) - was full enforcement run time checks in all builds
			swift 5.0 conversion, recommended locale changes in project
			add moon data to main screen
                        ran: brew install swiftlint
			for archive had to set compile mode for release to incremental (from whole something), also had to set the access to memory again

Xcode 10.2.1 migration


2019_05_04 55990 	[BUG] wpc mpd long press was not working
			[ADD] enhance wpc mpd formatting
			[ADD] add PolygonTypeGeneric
			[ADD] settings -> radar, settings -> color - add new polygons
			[ENH] restrict some goes16/17 images to certain sizes
2019_05_02 55980 	resubmit
2019_05_02 55970 	
			save location - determine wfo/radarSite from NWS API
2019_05_02 55960 	support long press for mcd/mpd/wat, settings -> location show current conditions (wip)
			update uswarn icon in misc tab
2019_05_01 55950 NWS change below, additional GOES product and additional GOES sectors
		 remove KVVG
// TODO HIGH IMPACT CHANGE REQUIRED BY June 24, 2019 for Service Change Notice 19-35
// https://api.weather.gov/points/38.8904,-77.032/forecast -> https://api.weather.gov/gridpoints/LWX/96,70/forecast
// https://api.weather.gov/points/38.8904,-77.032/forecast/hourly -> https://api.weather.gov/gridpoints/LWX/96,70/forecast/hourly
// Details: https://www.weather.gov/documentation/services-web-api
//
// Example: https://api.weather.gov/points/39.7456,-97.0892
//         "forecastOffice": "https://api.weather.gov/offices/TOP",
//        "forecast": "https://api.weather.gov/gridpoints/TOP/31,80/forecast",
//        "forecastHourly": "https://api.weather.gov/gridpoints/TOP/31,80/forecast/hourly",
//        "forecastGridData": "https://api.weather.gov/gridpoints/TOP/31,80",
//        "forecastZone": "https://api.weather.gov/zones/forecast/KSZ009",

2019_04_09 XXXXX Add code in utility from flutter port to not use pref data for various lookup of data
				 various URL https fixes
				 
2019_02_12 55802 upper case hazards on main screen
2019_02_12 55801 add code in UtilityUI to detect ipad or iphone
		 add 3 additional items in utilMetarConditions
		[BUG] AWC Mosaic was missing one token
		add LatLon for AWC Mosaic locations
		AWC Mosaic - if from submenu choose closest location
		more work on nws color palette
		remove file LatLonStr (LatLon has everything)
		replace withVisualFormat with constraints
		fix imageview size in VCs with toptoolbar - model/spc meso
		in settings location support Canada location *display* in map
		[BUG] fix incorrect map repositioning in settings location edit
		add Tilt support in radar
		playlist - download all on entrance to VC

AppStore writeup:

Add new options in Settings -> UI to use AWC Radar Mosaics instead of the main NWS Radar Mosaics. Change Level 2 radar to use HTTPS after NWS disabled HTTP access.

2019_02_06 55800 MCD/MPD tap image goes to dedicated imageviewer now
		 add Awc mosaic radar option (incl homescreen support)
		 misc code refactor
		 add new colormap nws
		 main screen tap on sunrise scroll to top
		[BUG] level2 radar and CPC needed to be changed to HTTPS
		[BUG] space weather graphics were not available in WCP Img
2019_01_29 55700 add UI_MAIN_SCREEN_CONDENSE option
		 add NWS_ICON_SIZE_PREF option
		 change text color of sunrise card on locfrag from gray to black
		 cleanup in UI
		 minor formatting enhancements in settings
		 move Storm reports to custom UI card
		 mapkit vc - add lat/lon to toolbar and on tap open dedicated mapping app
		 custom uswarn card
		[BUG] formatting issue in hourly with temp in negative double digits
2019_01_25 55600 more work on apple map in location edit
		 severe dashboard - add share option
		 add Fab in settings -> location
		 model generic - truncate product button less
		[BUG] backout locfrag screen rotation code as 7day not always showing
		[BUG] fix radar mosaic in homescreen
		add spotters back in
		[BUG] in playlist viewer set product before going to text viewer
2019_01_23 55500 more work on apple map in location edit
		 add missing nws icon for winter conditions
		[BUG] if edit location and change name, return to main screen does not show new name
		add share icon to sun/moon
		have SPC Storm reports use Apple MapKit
		add support for WPC MPD screen rotation
		SPC MCD - add text to share
		locfrag - add rotation support
		model generic - add left/right FAB
2019_01_22 55400 fixes in rotation/map and add share/play to various vcs ( like hourly )
		 [BUG] fix layout for webview for iphone X
		 NWS OBS: add last used
		 LOC FRAG: change tap on CC text goto hourly
		 [BUG] nexrad radar: if map open single tap also zooms out radar
		 add apple map in locations setting (WIP)
2019_01_20 55300 UIwXVC/wfo - add code to better support rotation
2019_01_19 55000 playlist - update view after each download
	         playlist - add ObjectCardPLayListItem for custom card
		 location items - add ObjectCardLocationItem for custom card
		 remove glkit view from storyboard
		 iphone X/XS/XR formatting enhancements - safearea stuff
2019_01_16 54900 remove "Solar" code now that SunCalc has replaced
2019_01_16 54900 remove "Solar" code now that SunCalc has replaced
		 remove remnants of radar line width from OpenGL
	 	 ObjectImage - move setImageAnchors into class
		 [BUG] metal - location dot was not updating quickly - only on refresh
		 mosaic radar - move conus to top of choices
		 remove Drawable
		 [BUG] Homescreen "VIS CONUS" was not working both with image and on tap
		 [BUG] metal radar would allow single/double tap zoom to exceed max/min
		 [BUG] usalerts was not sharing all detail via email
		 [BUG] AFD viewer was not scrolling to top when changing location
		 remove PlayList from settings as it's already in main submenu
		 playlist: don't turn off screen ( to allow TTS to keep going )
		 playlist: add size to playlist entries to see which ones are not working
		 [BUG] fix QPFPFD
2019_01_12 54800 metal - change zoom level for hiding gps location circle
		 move sun/moon to main submenu
	  	 convert bottom time card to use new SunCalc for sunrise/sunset
		 remove OpenGL radar code
2019_01_12 54700 metal - if autoupdate on keep screen on
		 redo sun/moon to use local calculations
		 cc/7day reorg classes
2019_01_10 54600 metal - black bg and correct screen rotation
		 metal is now the default radar
2019_01_05 54500 misc code refactor
2018_12_31 54300 convert metal radar from continuous to onDemand render
2018_12_25 53900 main screen metal radar framework and cleanup
                 [BUG] AWC forecast image URLs had changed
2018_12_24 53600 main screen metal radar framework
2018_12_23 53500 main screen radar fab using floaty
2018_12_22 53400 [BUG] quad pane lat lon issue fixed
2018_12_22 53300 redo main screen processing
2018_12_21 53200 [BUG] WPC MPD didn't have TTS setup
2018_12_15 53100 [BUG] GOES16
  	         add extension to UIAlertAction
		 change toolbar text color from light gray to white
		 disable img posn save/restore in goes16
2018_12_09 53000 integrate for testing: https://github.com/eldade/PageAlignedArray (code was removed, to slow to allocate mem in testing)
2018_12_01 52800 code cleanup and continued metal radar dev
2018_12_01 51100 metal: add autorefresh and center on double tap zoom
		 [BUG] fix wind barbs with multiple values (utilMetar)
		 [BUG] NSSL WRF was not initializing properly
		 [BUG] nhi_tsra icon was not working
2018_11_28 50900 metal: 
2018_11_28 50800 metal: respect remember location, fix zoom issues due to 3d
2018_11_28 50700 metal, bugfix on clicking icons in non-locfrag tab
2018_11_25 50540 metal, add anim 
2018_11_25 50520 metal, add -Ounchecked compiler option
2018_11_24 50510 metal
		 (bugfix) dup card in locfrag
2018_11_24 50500 metal
2018_11_23 50490 refactor object package to match android
2018_11_17 50480 lint cleanup and bugfixes
2018_11_15 50470 lint cleanup
2018_11_14 50460 lint cleanup
2018_11_12 50452 revamp NSSL WRF
2018_11_08 50451 SPC Meso - update few parms
		 add global vars for WPC/SPC HTTPS prefix
	         install swiftlint with brew and make numerous lint corrections
2018_10_30 50450 update project settings and remove uneeded files
		 set objc inference to default, modify spc tab to accomdate
2018_09_16 50401 if haz card not in homescreen do not download data
		 (bugfix) fix smoke, hurr, and ts icons
2018_06_17 50310 upadate font in icon code for IOS12 ( 12 dropped helvetica bold )
2018_06_13 50304 cg
2018_06_12 50301 add "Nexrad Test" for coregraphics test
2018_05_31 50300 force GOES16 to use 1200x1200
		 GOES16 remove timestamp in toolbar
		 NHC storm - remove cloud icon
		 fix canada typo in about
2018_05_05 50292 (bugfix) severedash warnings was not show issuing office
		 (bugfix) equalize height of radar in dual/quad pane
2018_04_15 50290 in ObjectMetar add "Light Drizzle, Snow And Mist" to "snow",
		 SPC MESO - add "Violent Tornado Parameter (VTP)"  - vtp ( Beta last one )
                 SPC Meso - add mlcp_eshr "100mb Mixed-Layer CAPE / Effective Bulk Shear"
                 SPC MESO - rename label to "Sfc Frontogenesis"
                 SPC MESO - add pwtr2 "Precipitable Water (w/850mb Moisture Transport Vector)"
                 SPC MESO - rename label to "Near-Freezing Surface Temp."
                 SPC MESO - rename label to "Surface Wet-Bulb Temp"
                 SPC MESO - rename label to "Freezing Level"
                 SPC MESO - rename label to "Sfc RH, Temp, Wind"
                 SPC MESO - rename label to "Lower Atmospheric Severity Index"
                 SPC HREF - add "Fixed-Layer STP mean", "Fixed-Layer STP P[>1]", "Fixed-Layer STP P[>3]"
                 SPC HREF - add "1-hr Snowfall: P[>2\"]",
                 SPC HREF - add "1-hr QPF: P[>1\"]", "6-hr QPF: P[>1\"]", "6-hr QPF: P[>2\"]", "6-hr QPF: P[>3\"]",
                 Hourly - translate T-storms to Tst
2018_02_21 50281 add local forecast back to submenu
2018_02_20 50279 add auto day/night detection via obs lat/lon sunrise/sunset
2018_02_20 50278 add GPS lat/lon to radar long press, more conditions table improvements
2018_02_18 50277 add "Fog" in conditions table
2018_02_18 50276 add minus_ra icon
2018_02_18 50275 on main screen use obs closest to LAT/LON
2018_02_17 50274 use metar for icon determination
2018_02_17 50273 GOES-16 back to 1200x1200 for few products
		 put framework in place to not use API for Obs at all (needs refinement)
2018_02_15 50272 add option in UI to show Metar in CC
		 remove NCAR Ensemble from credits
2018_02_14 50271 (bugfix) fix crash in locfrag when metar is lacking data ( Reno, NV )
                 support degree/pressure unit conversions in current conditions 
2018_02_13 50270 change refreshLocMin from 30 to 10min
		 convert all Metar to localtime
2018_02_13 50269 CC metar - add wind gust
		 if wind is calm set to 0
		 temp/dewpt round and remove fraction
		 add ObjectMetar
2018_02_11 50267 Hourly abbreviation: Likely
		 Add abbreviations table at bottom of Hourly
		 partial convert of CC to Metar as source
2018_02_11 50266 (bugfix) GOES16 change to 600x600 from 1200x1200
2018_02_08 50265 Hourly change Isolated to Iso
		 SPC HREF show sector labels instead of codes
2018_02_07 50264 ObjectAlertDetail: change from start to issued
                                    add extension and use removeSingleLineBreaks()
2018_02_05 50263 update about to show copyright through 2018, show appName/vers in main submenu
		 (bugfix) SPC HREF time detection not working
		 radar - hide/show textview on pinch zoom similar to pan
2018_02_03 50262 (bugfix) update GOES16 sectors/sizes for ATL
		 change formatting in radar long press
2018_02_02 50261 (bugfix) update GOES16 sectors/sizes for ATL
2018_02_01 50260 update goes wv icon for misc tab
		 SPC Meso: add "Enhanced EHI" and "EL Temp/MUCAPE/MUCIN"
2018_01_18 50257 1024 pixel image - remove alpha channel and transparency
2018_01_18 50256 update 1024 pixel app icon after playstore rejection
2018_01_14 50255 remove unused spotter VC code ( no plans to use on iOS )
2018_01_14 50254 remove legacy GOES-13 stuff
2018_01_13 50253 remove legacy GOES-13 stuff
		 homescreen CONUSWV fix
		 homescreen - better support for phantom goes-13 stuff ( to see and delete )
		 goes-16: show best res for 5 products in regional
2018_01_13 50252 add to hourly  .replaceAll("Light", "Lgt")
		 add to GOES16: NotificationCenter.default.addObserver
2018_01_10 50251 updates for GOES16
2018_01_04 50250 cleanup and itunes release
2018_01_02 50231 locfrag - scrollToTop in willEnterForeground
2018_01_02 50230 cleanup
		 change storyboard color to default blue
		 rename methods in UtilityUSImgNWSGOES, UtilityNWSGOESFullDisk
		 camelCase various methods
2018_01_01 50229 add GOES16 to homescreen
	         add status time in GOES16
	         cleanup
2018_01_01 50228 hourly formatting tweak
		 update copyright to include 2018
		 move to extension: getHtmlSep
		 settings - location - capitalize first word in label after search
2017_12_31 50227 code cleanup
2017_12_30 50226 modify submenu data to not inlcude start index
		 WPC Img - add ice analysis
2017_12_30 50225 in radar show and then hide object when pan (perf improvement to match Android)
2017_12_29 50224 (bugfix) pinch zoom in radar was not working correctly
		 GOES16 - add animation frame count
2017_12_24 50223 cleanup
2017_12_23 50222 locfrag - move more logic to UI classes
2017_12_23 50221 convert more foreach-append to map
		 adhoc location - move more logic to UI classes
2017_12_23 50220 cleanup
2017_12_23 50219 move editor and pref to global var
		 camelCase radargeom const
2017_12_23 50218 convert MyApp.radarColorPalette* to map of String:String
		 create new RadarPrefences and UIPreferences to offload from MyApp
2017_12_23 50217 rename colorpal and radargeom to remove myapp from filename
		 move many items from myApp to radargeom
		 (bugfix) polygon color changes not taking effect immediately
2017_12_23 50216 cleanup
		 add coreobject/DataStorage to encapsulate severeDashboard stuff
		 add global/AppColors to offload from MyApp
2017_12_22 50215 move towards extensions for various string manip and download things
		 new init for Bitmap class
2017_12_22 50214 use of new String extensions and cleanup
2017_12_21 50213 more use of LatLon
		 cleanup
2017_12_20 50212 more icon work with Enum
2017_12_20 50211 (bugfix) GOES16 animations in NON GEOCOLOR for FD/CONUS not working
		 use LatLon in locationSave
		 add IconType Enum
2017_12_20 50210 GOES16 - add CONUS, FD
2017_12_19 50209 update GOES16 labels
		 use more LatLon in UtilityLocation
2017_12_19 50208 goes16 - add to misc and add anim support
		 cleanup
		 add firstToken String type extension
2017_12_19 50207 add LatLon.reversed
		 update GOES16 to new site (WIP)
2017_12_18 50206 more work on LatLon including convert from class to struct
2017_12_18 50205 more work on LatLon and move MyApp loccreate method to Location class
2017_12_18 50204 add IAD as sounding site ( for DC )
		 (bugfix) utilPref2 was checking on non-existing pref so IAD change overwrote location data #
2017_12_17 50203 locfrag - change label immediately when location changed
		 use LatLon more
2017_12_17 50202 cleanup
		 (bugfix) double tap was now 4x after change in last release
2017_12_17 50201 cleanup
		 double tap no longer zooms out then in
2017_12_17 50200 cleanup
2017_12_17 50199 (bugfix) location index change after delete was not working as intended - off by one
2017_12_17 50198 cleanup
		 change toolbarHeight from 48 to 44
2017_12_17 50197 cleanup
2017_12_16 50196 more remaining gesture code into WXGLSurfaceView to match Android arch
2017_12_16 50195 remove auroral forecast files
		 (bugfix) double tap in radar working on more devices with respect to centering
		 move some gesture code into WXGLSurfaceView to match Android arch
2017_12_16 50194 remove token "cod" from various vars in MyApp
2017_12_16 50193 added scrolltop gesture to 7day small text
		 WPC Img - add experimental Day1-3
2017_12_16 50192 add ObjectStackView
		 add Poly/Geo Type to ObjectOglBuffers and make use of in WXGLRender
2017_12_15 50191 cleanup
2017_12_15 50190 cleanup
		 (bugfix) save/restore was not working correctly for all radar cases
2017_12_14 50189 cleanup
2017_12_14 50188 modify constructors for ObjectTextView and ObjectImage to not use view controller
		 (bugfix) NWS API changed image icon from https to http breaking 7day/cc icons
2017_12_14 50187 (bugfix) add enhanced error checking in 7 day
		 (bugfix) added enhanced icon parsing for NWS inconsistencties ( night// instead of night/ )
2017_12_13 50186 cleanup
2017_12_12 50185 radar cleanup
2017_12_11 50184 more cleanup in radar 
2017_12_11 50183 more cleanup in radar 
2017_12_11 50182 more cleanup in radar - use pn directly
2017_12_10 50181 more work in level 3 text products to leverage pn from renderer
2017_12_10 50180 more work in level 3 text products to leverage pn from renderer
2017_12_10 50179 move UtilityCanvasProjection.getProjectionNumbers to initializer in ProjectionNumbers
		 cleanup
2017_12_10 50178 cleanup
2017_12_10 50177 more work on ObjectModel ( remove anim in each util file )
		 change class func to static func
2017_12_10 50176 more work on ObjectModel ( remove anim in each util file )
2017_12_09 50175 more work on ObjectModel
2017_12_09 50174 remove StringBuilder, cleanup
		 SPCSREF - use objectModel in func signature
2017_12_09 50173 cleanup
2017_12_08 50172 cleanup in radar incl var rename
2017_12_08 50172 cleanup in radar incl var rename
		 in single pane radar if not share posn don't show top toolbar
		 (bugfix) in radar animation stop/play icon was not toggling
2017_12_07 50171 var rename
2017_12_07 50170 var rename
2017_12_06 50169 release
2017_12_04 50168 more work from 167
2017_12_04 50167 add sideSwipe to UtilityUI, reduce use of global bitmap vars, add bitmap to TouchImage
2017_12_04 50166 remove NCAR ens ( being retired at end of year: http://ensemble.ucar.edu/shutdown.php )
		 convert more VC to wXVC
2017_12_04 50165 convert locfrag to normal view controller
		 remove uneeded source code files
		 change tabs to use normal background instead of black
		 remove ncar ens from misc tab ( but save source cleanup for later )
2017_12_03 50164 cleanup and enhance the way swipes are handled in images
		 use full labels for NWS radar mosaic
2017_12_03 50163 settings -> homescreen, if radar was configured don't crash. Also show label in popup, change verbiage in popups at bottom
		 add textual label in color picker
2017_12_02 50162 perm disable radar on main screen
2017_12_02 50161 temp disable radar on main screen
2017_12_01 50160 cleanup - remove uneeded files
		 remove init(){} in some cases
		 optimize in Location class
		 (bugfix) change GOES sector e to eepac and add logic in UtilityUSImgNWSGOES.getGOESMosaic
		 add initializer in ObjectToolbarIcon to handle text buttons with initial labels of ""
2017_12_01 50159 move WPCGEFS to MISC and out of hourly
2017_12_01 50158 WPCGEFS - completely revamp params/labels from web after major changes noted
2017_12_01 50157 WPCGEFS - add params, change to submenu
		 remove GOES16 link for now
2017_11_30 50156 change ibuff/obuff to iBuff/oBuff to match Android
		 add ObjectCardHazard
		 (bugfix) settings->location was not working
2017_11_30 50155 cleanup
		 add NEXRAD_PRODUCT_STRING and change in WXGLNexradLevelData
		 (bugfix) L2 radar product code was not showing up when long press in radar
		 move numRadials into LevelData
2017_11_29 50154 fold Level Data under radar Buffers similar to Android
2017_11_28 50153 more work on radar
2017_11_27 50152 consolidate down to WXGLNexradLevelData from 2/3
2017_11_26 50151 more conversion to subscript
		 rename ByteBuffer to MemoryBuffer
2017_11_26 50150 comment cleanup
		 use subscript in ByteBuffers and OpenGLBuffers
2017_11_25 50149 convert to UIwXViewController
2017_11_24 50148 add new super for VCs UIwXViewController ( test in WPCText and WPCImg )
		 in many VCs move pref save out of done and over to getContent
2017_11_24 50147 remove ByteBufferNative
		 transition to more computed properties
		 convert many global properties in viewControllers to let such as stackview and scrollview
2017_11_23 50146 cleanup
2017_11_23 50145 cleanup
2017_11_23 50144 cleanup, more use of idices
		 (bugfix) soundings was not using location properly to determine closest data
2017_11_22 50143 optimizations in WXGLDownload and WXGLNexrad
		 add ObjectTextViewSmallGray
		 add ObjectTextViewLarge
		 add ObjectCardImage
		 add ObjectCardStackView
2017_11_22 50142 radar refinements in L2/L3 class and WXGLNexrad TDWR func
2017_11_20 50140 CC and 7day card - shrink font of top line instead of truncate
2017_11_20 50139 more radar enhancements
		 add L2 size check for download file from Android version
2017_11_19 50138 more radar enhancements
2017_11_19 50137 SPC Meso truncate sector to not crowd bottom toolbar
		 ObjectOglRadarBuffers.swift added
2017_11_18 50136 (bugfix) normal vs terminal radar switching was broken
		 switch to ObjectOglBuffers for radar float/color
2017_11_18 50135 (bugfix) textual overlays were broken in radar
		 radar refactoring and optimizations
2017_11_17 50133 optimize radar 
2017_11_16 50132 release
2017_11_15 50131 WXGL fold rid/product into WXGLRender class
2017_11_15 50130 hourly formatting
		 usAlerts - do not show image after filtered
		 code optimizations in WXOGLOpenGLMultiPane
2017_11_14 50129 cleanup
2017_11_13 50128 retire SPC SSEO in favor of SPC HREF
2017_11_12 50127 SPC HREF - conver to submenu
2017_11_12 50126 SPC HREF
2017_11_12 50125 add sunrise/sunset to bottom card main screen
2017_11_12 50124 hourly formatting
2017_11_11 50123 more work on SPC HREF
		 add GMT card to bottom
2017_11_11 50122 more hourly abbreviations
		 more work on SPC HREF
2017_11_10 50121 SPC HREF init framework
2017_11_06 50120 code cleanup
2017_11_03 50117 cleanup
2017_11_01 50116 cleanup incl removal of deprecated String.characters after update to xCode 9.1
		 move more mapView to Utility
		 LSR by WFO - use text instead of map icon in toolbar
		 wxglrender add setView
2017_10_28 50114 cleanup
2017_10_28 50113 move location stuff from Utility to Location
2017_10_28 50112 enhancements in storm info/windbarb/ObjectColorPalette
2017_10_24 50109 cleanup
2017_10_23 50108 cleanup
2017_10_21 50106 convert many radar objects from float to double
2017_10_20 50105 cleanup 
2017_10_19 50104 cleanup 
2017_10_19 50103 cleanup 
		 (bugfix) obssite was crashing
		 (bugfix) SPC SREF was only extending to 81 and not 87
2017_10_18 50100 cleanup 
2017_10_17 50097 cleanup Util
2017_10_15 50096 remove LayerDrawable class
2017_10_11 50095 (bugfix) quad pane crashed when terminal radar was chosen
2017_10_06 50092 (bugfix) add condition on CC icon main screen
2017_09_23 50091 rescale app logo images per lint
2017_09_22 50090 add 1024x1024 marketing image
2017_09_22 50089 lint warnings
2017_09_21 50088 turn swift3 objc interface to default
2017_09_21 50087 shrink icon size for triple dot and back arrow
2017_09_21 50086 convert to Swift 4 via XCode 9
2017_09_16 50084 add additional CPC images and remove test auroral forecast (for now)
2017_09_09 50082 enhance formatting for data for full moon schedule
2017_09_07 50081 add more data for full moon schedule
2017_09_05 50079 add Full moon times
2017_08_30 50077 WPC MPD share both image list and text
		 (bugfix) fix tropical storm icon main screen
2017_08_26 50075 twitter - save last used
2017_08_23 50074 goes16 add swipe left/right
2017_08_22 50073 cleanup
2017_08_20 50070 dedicated beta GOES16 activity - part1
2017_08_20 50069 add exper GOES16 in lightning
2017_08_19 50068 (bugfix) wxtextObs fixes from Android
2017_08_19 50067 (bugfix) NHC Pac storm VIS not working
2017_08_16 50064 (bugfix) ESRL RAP sectors were not working correctly
2017_08_16 50063 cleanup
2017_08_14 50062 cleanup
		 switch ordering of top toolbar icons
		 (bugfix) NHC storm GOES not working
2017_08_11 50061 cleanup
2017_08_10 50060 cleanup
2017_07_31 50056 cleanup
2017_07_26 50052 add new colormaps
2017_07_25 50050 add Auroral Model
2017_07_24 50049 code cleanup and add more space weather products
2017_07_23 50047 code cleanup
		 (bugfix) L2 anim was not working
2017_07_23 50046 bugfix for remember location
2017_07_22 50044 SPC other VCs clickthrough to zoom in
2017_07_22 50043 SPC Tstorm clickthrough to zoom in
2017_07_19 50040 add some space weather stuff in txt,img
2017_07_18 50039 (bugfix) settings -> radar geography changes take effect now w/o restart
		 remove launch to radar setting ( will not implement )
2017_07_17 50038 wxglrender - refinements
2017_07_16 50037 cleanup
2017_07_16 50035 add config for Nexrad Radar background in settings->color
2017_07_16 50034 moon/sun data formatting
		 remove ImpactGraphic.swift as not used
2017_07_16 50033 hourly: enhance formattingm,add abbreviated conditions, add tap action to scroll back to top on tap
2017_07_16 50032 in radar show TDWR products if radar is TDWR
2017_07_15 50030 add adhoc location by long press in radar
		 add array size check in utilNWS Icon code like Android
2017_07_13 50027 NSSL WRF - add WFO sectors
2017_07_13 50026 minor UI refinements
2017_07_12 50023 cleanup
2017_07_12 50022 cleanup
2017_07_11 50019 FP and cleanup through ??
2017_07_10 50018 FP and cleanup through Models
2017_07_08 50016 UI enhancements - moon data and SPC Meso
2017_07_06 50014 FP and cleanup into ""
		 settings color - show as sorted
		 settings color - have changes take effect immediately
		 settings location - click GPS and have save if lat/lon valid
2017_07_06 50012 FP and cleanup into "radar"
2017_07_05 50011 FP and cleanup through "global"
2017_07_04 50009 one line if consolidation and FP
2017_07_03 50008 one line if consolidation and FP
2017_07_03 50007 one line if consolidation and FP
2017_07_03 50006 one line if consolidation and forEach
2017_07_02 50005 utilShare remove need for labels, more use of forEach
2017_07_02 50004 switch statement cleanup through wpc
2017_07_02 50003 switch statement cleanup through ?
2017_07_02 50002 switch statement cleanup through nhc
2017_07_02 50001 switch statement cleanup
2017_07_02 50000 version bump & cleanup
2017_07_01 38440 cleanup
2017_06_30 38439 (bugfix) settings homescreen delete was causing crash
2017_06_24 38438 NHC fix when storm advisories no longer being issued
2017_06_23 38437 (bugfix) ESRL sectors not working
2017_06_22 38435 add ObjectScrollStackView , ObjectToast
2017_06_21 38433 add genMercato to UtilityWXOGLPerf and test in WXGLRender with geom
2017_06_20 38431 code cleanup
2017_06_19 38430 code cleanup
2017_06_15 38427 remove legacy getter/setter to match Kotlin
2017_06_14 38426 move some map code to UtilityMap
		 start removing legacy getter/setter to match Kotlin
2017_06_13 38425 code cleanup
2017_06_12 38424 code cleanup till ui
2017_06_10 38423 code cleanup till radar
2017_06_04 38420 code cleanup
2017_06_03 38418 code cleanup
2017_06_02 38417 code cleanup
		 (bugfix) prevent crash when longpress in radar outside CONUS for obs/metar
2017_06_01 38416 code cleanup
2017_05_31 38415 add ObjectNHC
2017_05_29 38408 (HIGH IMPACT) more arg removal for methods with few parms - prefs
2017_05_29 38407 more arg removal for methods with few parms
		 add more NHC images to main screen
		 deprecate legacy SPC SWO image url getter
2017_05_29 38406 more arg removal for methods with few parms
2017_05_28 38405 more arg removal for methods with few parms
2017_05_28 38403 update af ref cm
2017_05_15 38400 add ObjectWatchProduct.swift
		 add UtilitySPC.getTstormOutlookImages()
2017_05_14 38399 minor reorder in radar prod submenu
		 (bugfix) DSP colormap was not showing up
2017_05_14 38398 add arg locNum in utilHourly and use Location object in Forecast instead of x/y
2017_05_14 38397 (VERY HIGH IMPACT) move to Location object for all location management
2017_05_13 38394 UtilityWXOGLPerf.genCircleLocdot - convert args to Double instead of Float
		 WXGLSurfaceView - make all properties private
		 remove named args in much of UtilMath
2017_05_13 38393 ObjectOglBuffers - make all properties private
2017_05_12 38392 refactor UIColorLegend
		 (bugfix) N0C colorlegend was not showing up
2017_05_12 38391 remove named arg for additional extensions
		 add new AF colormap for prod99
2017_05_12 38390 remove named arg for additional string extensions
		 add addPeriodBeforeLastTwoChars()
		 add getRidPrefix() in WXGLDownload
2017_05_11 38389 remove named arg for equals/contains ( String )
2017_05_11 38388 remove named arg for startsWith , replaceAll
2017_05_11 38387 refactor wxogltext
2017_05_11 38387 remove named arg for split String extension
2017_05_10 38385 ByteBuffer remove named args
2017_05_10 38384 wxglrender,utilwxoglperf - significant refactor based on Android wX
2017_05_10 38383 wxglrender - significant refactor based on Android wX
2017_05_09 38382 wxglrender - significant refactor based on Android wX
2017_05_09 38381 wxglrender - significant refactor based on Android wX
2017_05_09 38380 wxglrender - significant refactor based on Android wX
2017_05_07 38378 wxglrender - simplify scaleChanged - phase2
2017_05_07 38377 wxglrender - simplify scaleChanged
2017_05_07 38376 start using enhanced ObjectOglBuffers with solidColor - phase2
2017_05_07 38375 start using enhanced ObjectOglBuffers with solidColor ( spotters, locdot, etc )
2017_05_06 38374 enhance ObjectOglBuffers to store RGB for solid color ( do not implement yet )
2017_05_06 38373 colormap fix for 134
2017_05_06 38372 colormap fix for 165,19
2017_05_06 38371 implement ObjectColorPalette
2017_05_06 38370 (bugfix) fix colormap issue caused by Color.HSVToColor
2017_05_06 38369 look into color
2017_05_06 38368 use ObjectOglBuffers in UtilityWXOGLPerf
2017_05_06 38367 add ObjectOglBuffers
		 add AF colormap
2017_05_03 38366 add enums in global for projection,polygonType/GeographicType
2017_05_03 38365 utilCanvas rename to remove v2
		 utilCanvas have MPD use WAT/MCD code
2017_05_02 38363 add Legal card in CAHourly and CAText
		 redo switch statements for tabs to use strings instead of numbers
		 reorder tiles
2017_05_02 38362 add ObjectCAWARN
2017_05_01 38361 UtilityWat - use ProjectionNumbers directly
		 WXGLRender - use ProjectionNumbers directly
2017_05_01 38360 WXGLPolygon - use ProjectionNumbers directly
2017_05_01 38359 utilwxoglPerf - use projectionNumbers directly
2017_05_01 38358 add getter/setter in various radar objects - finish model/ObjectModel
		 enhance ProjectNumbers and pass object instead of individual items
2017_05_01 38357 add getter/setter in various radar objects - model/ObjectModel
2017_05_01 38356 add getter/setter in various radar objects - Bitmap and other coreobjects
2017_05_01 38355 add getter/setter in various radar objects - model/RunTimeData
2017_05_01 38354 add getter/setter in various radar objects - phase4
2017_04_30 38353 add getter/setter in various radar objects - phase3
2017_04_30 38352 add getter/setter in various radar objects - phase2
2017_04_30 38351 add getter/setter in various radar objects - phase1
2017_04_30 38350 cleanup in coreobject
2017_04_30 38349 cleanup ( remove uneeded Context object from Android ), camelCase
2017_04_29 38348 cleanup
2017_04_29 38346 add ObjectNHCStormInfo.swift
2017_04_28 38345 add more SPCMESO favorites
		 usAlerts - add a supporting class and add top text summary card
2017_04_28 38344 settings location add bottom toolbar as well to more closelt match Android
2017_04_28 38343 toolbar back to top in settings location
2017_04_28 38342 revamp tab VC classes with superclass and UI object
2017_04_27 38341 (bugfix) locFrag OGL was not processing MPD/WAT/MCD causing polygons to be in wrong spot
		migrate VC Alert detail to CAPAlert and off of util 
		add new object ObjectAlertDetail
2017_04_26 38340 cleanup
2017_04_26 38339 move fcstList for 7day into 7day class
		 move more CC Processing to CC class out of UI
                 enhance 7day class to have native lists for Icon and DetailedForecast
2017_04_26 38338 add ObjectForecastPackage and associated classes bundled with it - PHASE3 ( locfrag )
2017_04_26 38337 add ObjectForecastPackage and associated classes bundled with it - PHASE2 ( CA ) 
2017_04_26 38336 add ObjectForecastPackage and associated classes bundled with it - PHASE1
		 add icon snow_sleet and nsnow_sleet
2017_04_26 38335 (bugfix) Radar msg not working for terminal radars
2017_04_26 38334 convert GLF text product to new API , "PMD30D" "PMD90D" "PMDHCO"
2017_04_25 38333 add setting to remember WFO
2017_04_25 38332 merge method for closest RID and WFO
2017_04_25 38331 convert locationSave to use computed closest RID/WFO
2017_04_25 38330 add VIS_CONUS and 3 SPCMESO to homescreen
		 (bugfix) IMG tab did not support help
		 SPC MESO add topo layer
2017_04_24 38328 mark class as final in many cases, make more classes have getter/setter 
2017_04_24 38327 migrate from MercatoNumbers to ProjectionNumbers and delete the former
2017_04_24 38326 mark class as final in core objects
2017_04_24 38325 mark class as final in many cases, make more classes have getter/setter incl projectionNum
2017_04_23 38324 use Utility getX/Y/WFO in more places
2017_04_23 38323 make vars private in RID LatLon and Spotters - add getter/setter as needed
2017_04_23 38322 (bugfix) NCEP Models complete str was never working
2017_04_22 38321 (bugfix) weather story URL
		 NCAR ENS from 36 to 48
		 SPC HRRR add few prod
2017_04_22 38319 NWS Goes - use txtfile for anim if cnt less then size
2017_04_22 38318 (bugfix) settings -> location crash
2017_04_22 38317 have usalerts format match Android
		 WPCMPD - show individual MPD when called from severe dash
2017_04_21 38316 SPC SREF Interface - remove legacy labels
2017_04_21 38315 NWS Goes - change method to get overlays ( performance issue )
2017_04_20 38314 switch back to L3 radar @ http://tgftp.nws.noaa.gov/
		 nexrad long press add miles from current loc and rid
2017_04_20 38313 NHC fixes
2017_04_20 38312 cleanup
2017_04_19 38311 wxogl - add miles in long press for closest radar
2017_04_17 38309 reinit utilPolygon on exit of settings->radar ( in case user changes polygon related settings )
2017_04_15 38308 add SPC SWO state graphic
2017_04_15 38307 add hourly using Gridpoint but do not use it yet ( issues with incomplete data )
		 remove location county/zone definitions
2017_04_14 38306 (bugfix) move tor in front of tst/ffw for long press in polygon - nexrad
2017_04_14 38305 fix WXGLPolygon to match Android with regards to VTEC check of EXP CAN
2017_04_13 38304 fix WXGLPolygon to match Android with regards to LAT LON ordering
2017_04_12 38303 add UtilityDownloadNWS.getCAP to match Android
2017_04_10 38301 warning polygons - use new API (utilWXOGL and WXGLPolygon,SevereWarning)
2017_04_10 38300 usAlerts - move to new API but still use XML
2017_04_08 38298 SSEO - move to submenu and add CAPE
2017_04_08 38297 prelim add of Caleb's SSEO new products
2017_04_08 38296 cleanup, colorpicker add RGB
2017_04_07 38295 hrrr/sseo anim method - comply with design pattern
2017_04_07 38294 utilModel - have anim method use getImage
2017_04_04 38293 re-cleanup: audio,canada,coreobjects,fragments,global
2017_04_04 38292 cleanup: audio,canada,coreobjects,fragments,global
2017_04_03 38291 add prefs to change forecast icon text color and bottom bar
2017_04_03 38290 cleanup: activitiesmisc
2017_04_02 38288 hail markers to use triangles right side up
		 (bugfix) hail marker decodingnot working properly
2017_04_02 38287 (bugfix) change regexp to get spc swo img
		 redo SPC SWO Summary to use utilSPCSWO
2017_04_01 38286 lightning - don't zoom out on prod/time change
		 spc swo - new framework for getting images
2017_03_31 38285 move NCEP updates from March 2017 change
2017_03_30 38282 add more 7day temp extraction matches
2017_03_30 38281 cleanup
		 (bugfix)playlist would not play new TTS after first one started
2017_03_29 38280 disable spotters from submenu - too slow for now
2017_03_29 38279 camelCase and cleanup
		 add Utility.getLocationIndex
		 remove TTS infrastructure from CA Warn
		 playlist - modernize playbutton infra
		 usalertsdetail - modernize playbutton infra
2017_03_28 38278 radar - delete tmp files on exit
		 radar - stop anim when return from background
2017_03_28 38277 radar  swo day 1 lat/lon bugfix
2017_03_28 38276 code cleanup
		 on initial program load at first use, in radar use radar site of first location used
2017_03_27 38273 code cleanup
		 remove temp forecast website link from main submenu
		 spotters and spotter reports - add count in toolbar
2017_03_26 38272 code cleanup
2017_03_26 38269 code cleanup
2017_03_26 38268 rename VC Settings Main/Location/LocationEdit to match naming standard convention
		 (bugfix) settings edit - if location not saved and hit delete would cause crash
		 settings edit - search popup now has no text to delete
		 code cleanup in radar
		 (bugfix) found one Level2 file where highReflectivity.count was not numberOfRadials
		 (HIGH IMPACT) fix memory leak in radar
2017_03_25 38267 (bugfix) fix location dot in vis
		 cleanup
		 more movement towards UIGraphicsImageRenderer
2017_03_25 38265 (bugfix) not all layers were working in nws mosaic anim
		 add green colormap for ref
2017_03_25 38262 move NWS mosaic anim to android method - overlays not working yet
2017_03_25 38261 (bugfix) tst wat was showing color of tor watch
		 move WFOText to generic UtilityShare method for text
		 move nws mosaic to android method with canvas overlays ( beta )
2017_03_24 38260 remove unused swift source files ( notif, some canvas radar, etc )
2017_03_24 38259 (bugfix) severe dashboard
		 add config for data refresh interval in settings->radar
                 update polygon when rid changed
2017_03_24 38258 remove unneeded source files ( notifications, radar canvas, utilFav )
2017_03_24 38257 use UIGrapahicsImagerRender in UtilityNWS and UtilityImg ( mergeImage method )
                 canvasMain - reenable MPD/MCD/WAT ( for Vis and in future for NWS Mosaic )(data is not yet pulled in goes viewcontroller)
		 add framework in canvas main/generic and utilNWSMosaic to support NWS Mosaic like android with blackBG and customer overlays
2017_03_23 38255 change buildit script following name change to wXL23
		 wxogl add anim frames when animating like android
2017_03_23 38254 (bugfix) missing thunderstorm icon
		 (bugfix) WAT/MCD had issues around lon 100.0
2017_03_23 38253 (bugfix) main submenu help mode was not working correctly
		 helpmode - add toast like android - rework methods in utilityActions to support
2017_03_23 38252 NCEP - add new FIREWX model
		 WPC GEFS - move from main submenu to hourly like android
2017_03_22 38250 spotter reports - fix UI and add option to show on map
		 wxglrender - have mpd polygon use mpd color
2017_03_21 38249 move radar warning to new framework with mpd/mcd/wat
                 NCEP March changes part 1
2017_03_21 38248 bugfix in framework wat/mpd/mcd in radar
2017_03_21 38247 init framework wat/mpd/mcd in radar
2017_03_21 38245 add map selection to spotters activity
		 add initial framework for MCD/MPD/WAT in radar
2017_03_20 38244 cleanup in radar files
2017_03_19 38243 add viewcontroller for spotterreports
                 add Local Forecast entry to submenu
2017_03_19 38242 add viewcontroller for spotters
2017_03_18 38241 GOES Vis show (on) if overlay or meso selected
2017_03_18 38240 SPC Meso show (on) in menu if prod selected
2017_03_18 38239 WPC MPD - if only one show text as well
		 SPC Compmap show (on) in menu if prod selected
2017_03_18 38238 SPC Meso , more work 
2017_03_18 38237 SPC Meso , more work incl cleanup
2017_03_18 38236 SPCMCD enhancements to match Android
                 convert SPC Meso to new submenu framekwork and add new params
2017_03_17 38235 ObjectLocationCard spacing changes
		 location edit, move status below lat/lon and remove uncessary code from when switches were present
2017_03_16 38234 add ObjectLocationCard for settings->Location as a start to look like Android
2017_03_16 38233 rename WXOGLGLKit.swift to WXGLRender.swift
2017_03_15 38232 (bugfix) was missing         "tsra_hi.png":R.drawable.hi_tsra,
		 (bugfix) ObjectTileImage - was not working correctly for images tab with regard to swipe left/right
		 (bugfix) Obs act was not restoring title correctly
		 (bugfix) sounding on homescreen had transparent background
2017_03_15 38231 (bugfix) homescreen text widgets expansion was not working due to parallelism
                 (bugfix) submenu items weren't respecting animation off setting
		 NHC - don't show product code in text menu
2017_03_15 38230 (bugfix) not all widgets on homescreen were honoring viewOrder esp cc, 7day, haz
		 (bugfix) UtilityLocation.getNearestSnd caused crash
2017_03_14 38229 add option to show dual pane radar from lightning icon
		 complete adding pref for backArrowAnim to all view controllers
                 settings UI/Radar move one method to utilSettings after subclass NSObject in objectSwitch 
2017_03_13 38228 modify and use ObjectNumberPicker
		 wxogl - remove memory low method
		 add C to F table in settings
		 add pref for backArrowAnim ( not implemented in all view controllers yet )
2017_03_13 38227 (bugfix) mslp in in not showing correctly
		 add UtilitySettings.swift and add common methods between settingsUI/Radar
		 settings->UI add generic method to generate picker values
2017_03_13 38226 settings->colors , remove save button and save color on exit
		 add playlist to settings
		 rearrange settings order to match Android
                 (bugfix) settings->UI not saving changes correctly do to not sorting on keys
2017_03_12 38225 cleanup
2017_03_12 38223/24 add ObjectToolbarIcon ( handle play icon )
                 (bugfix) SPC SWO TTS not working
2017_03_12 38222 add ObjectToolbarIcon
2017_03_12 38221 add ObjectPopUp and use throughout app
                 remove unused overriden didReceiveMemoryWarning
2017_03_12 38220 add ObjectPopUp and use in all WPC* viewContollers
2017_03_12 38219 add ObjectToolbar
2017_03_12 38218 add ObjectToolbarItems
		 (bugfix) modelGeneric , NCEP was not showing runTimes
2017_03_11 38217 in all DispatchQueue change qos from .background to .userInitiated
                 remove model viewcontroller code no longer needed after conversion to generic
2017_03_11 38216 in wxglrender add spottersInit=false at top of spotter data construction like in Android
		 (bugfix) NCEP GFS time array was not resetting on model switch
                 change SSEO times based on run time
2017_03_10 38215 cleanup, enable SPC Meso Fav1 in homescreen
                 WPC Text - don't show code in submenu for PROD
2017_03_09 38214 enhance SPC MCD to more closely match Android
2017_03_09 38212 add windChill, heatIndex for new NWS API
2017_03_08 38210 vis - put toolbars on top, utilUSv2 RH has bug for null detect
2017_03_07 38209 icon fix new API, cleanup in icon code utilNWS
                 utilUSv2 getHazards, return String instead of string array
2017_03_06 38208 new API truncate lat/lon to 2 spaces after dec ( loc save, hourly, cc, etc )
2017_03_06 38207 new API 7day truncate lat/lon to 2 spaces after dec
2017_03_06 38206 more cleanup, click anywhere in 7day card to scrollTop
                 use ObjectTextView in NHC
2017_03_05 38204 more cleanup of old API, move CA to new ICON support
2017_03_05 38203 remove old NWS API support
2017_03_05 38202 camelCase and cleanup
2017_03_04 38201 enhance formatting for new API text products ( match android )
                 icon enhancementes - new NWS
2017_03_04 38200 enhance robustness in icon handling
2017_03_04 38199 tap 7day icon to scroll to top
2017_03_04 38198 camelCase
2017_03_04 38197 camelCase
                 after location search automatically save
2017_03_01 38194 (bugfix) new api location save change http to https for api server
                 camelcaseStuff
2017_03_01 38193 camelCase stuff, cleanup
2017_03_01 38192 camelCase stuff, cleanup 
                 new API fix, icons now at api not api-v1
2017_02_28 38190 camelCase stuff, cleanup 
                 NCAR ensemble further nesting
2017_02_26 38187 camelCase stuff, cleanup 
2017_02_26 38186 camelCase stuff, cleanup 
                 prevent certain radar elements from bein displayed in multipane ( obs , spotter, etc )
                 add weather story as homescreen widget
2017_02_25 38185 camelCase stuff, cleanup - implment System.currentTimeMilli
2017_02_25 38184 camelCase radar stuff
2017_02_24 38183 camelCase model stuff, cleanup
2017_02_23 38182 cleanup
2017_02_23 38181 remove old model code
2017_02_23 38180 SPC SREF - convert to new submenu and to generic activity
                 bugfix
2017_02_22 38179 move WPC GEFS to generic activity and bugfixs
2017_02_22 38178 move all but SPC SREF and WPC GEFS to generic activity
2017_02_22 38177 move SPCSREF/HRRR/SSEO to ObjectModel
2017_02_22 38176 move WPCGEFS to ObjectModel
2017_02_22 38175 move NCEP to ObjectModel
2017_02_22 38174 prep move NCEP to ObjectModel
2017_02_21 38173 move GLCFS to ObjectModel
2017_02_21 38172 move ESRL to ObjectModel
2017_02_21 38171 cleanup after last change, camelCase model util methods for upcoming ObjectModel conversion
                 move more code into ObjectModel
2017_02_21 38170 move NSSL/NCAR more fully to ObjectModel and handle more things in that Object
2017_02_20 38169 (bugfix) NCAR Ens day1/day2 was not working
                 finish migrating NCAR and NSSL to ObjectModel
2017_02_20 38168 add ObjectModel and make NCAR submenu nested
2017_02_20 38167 hourlyv2 - translate to weekday/hour
                 cleanup
2017_02_19 38166 code cleanup
2017_02_19 38165 HRRR fixes after upstream ESRL changes
2017_02_19 38164 HRRR fixes after upstream ESRL changes
2017_02_19 38163 add code to handle new API for warning polygons
2017_02_19 38162 UIScrollView - add extension to scroll to top and use in WFO / WPC Text
                 convert WPC Text to new subMenu model
                 change ordering of play button in WPC Text
2017_02_19 38161 WPC Img to submenu using new UI objects
2017_02_19 38160 (bugfix) settings location tablet crash
                 (bugfix) settings location was showing move up/down if only one location
                 add classes for submenu support
2017_02_19 38159 cleanup in models
2017_02_18 38158 cleanup and enhance crash prevention ( models )
2017_02_18 38157 spc storm reports - convert to ObjectTextView
                 add test code in UtilityDownloadRadar for new warning polygons
                 add data picker UI object and use in spc storm reports
2017_02_18 38156 more object unification ( AFD,WPC TXT, CA TXT ), cleanup
2017_02_18 38155 usutilv2  - if mslp is null show as "NA", cleanup
2017_02_18 38152 add version to settings->main, cleanup
2017_02_17 38151 remove hourly graphic, support new NWS API text products
2017_02_17 38150 spc meso/sref - use dual dialogues instead of existing submenu that does not work
2017_02_17 38148 additional optim/cleanup related to UI/Radar NP code
                 cleanup in locfrag
2017_02_17 38147 locfrag cleanup, add setting to control homeScreen text len
                 revamp numberPickers in settingsUI to be like settingsRadar
2017_02_16 38146 camelCase for GlobalArrays, locationCA convert to UI objects
2017_02_16 38145 settings->location , redo to use standard stackview/scrollview/ObjectTextView
                 UI refinements and code cleanup
2017_02_15 38144 convert to new UI objects for textview, image, and touchimage, cleanup
2017_02_15 38142 misc enhancements
2017_02_14 38140 update settings UI with new UI object for switch
                 nws api , tweak get status - make city before code for obs site
                 for nws api - add user agent using Just
2017_02_14 38139 update settings radar with new UI object for switch
2017_02_14 38138 add more UI Objects and use in locfrag and other places
2017_02_14 38137 (bugfix) misc, add object for tv
2017_02_13 38136 nws api - hazards locfrag
2017_02_13 38135 nws api - integrate code to save locations
2017_02_13 38134 nws api - integrate code to save obssite and obssite loc
                 add HWO to homescreen widget choice
2017_02_11 38133 integrate code for NWS API change ( hourly )

2017_02_11 38130 integrate code for NWS API change
2017_02_02 38129 (bugfix) fix issue with showing NWS Obs in radar
2017_02_01 38128 add 2 new NWS Obs sites 
                 (bugfix) radar settings would crash
2017_01_28 38127 fix padding issue on tabs
2017_01_26 38126 camelCase and code cleanup ( including core radar stuff )
2017_01_25 38124 camelCase and code cleanup ( including core radar stuff )
2017_01_24 38123 camelCase and code cleanup ( including core radar stuff )
                 resolve bug with sharing multiple images
2017_01_23 38122 camelCase and code cleanup ( including core radar stuff )
2017_01_22 38121 camelCase and code cleanup ( including core radar stuff )
2017_01_21 38120 camelCase and code cleanup ( including core radar stuff )
2017_01_20 38119 radar SWO color enhancements
2017_01_20 38118 camelCase and code cleanup
2017_01_19 38117 camelCase and code cleanup
2017_01_18 38116 camelCase and code cleanup
2017_01_17 38115 remove all semi-colons
                 disable background data fetch in plist
                 camelCase and code cleanup
2017_01_16 38114 camelCase and code cleanup
2017_01_15 38112 continued reduction in boilerplate UI code
2017_01_14 38111 continued reduction in boilerplate UI code
2017_01_13 38110 (bugfix) GOES - don't crash if overlay not present
                 camelCase and cleanup
                 disable checkSPC from updating mains tabs as background fetch not supported
                 add UtilityShare and test in SPC Compmap
                 add UtilityUI.setupButton and test in SPC TST
                 add UtilityUI.setupToolbar and test in SPC TST
                 add UtilityUI.setupToolbarTop and test in SPC MESO
                 add UtilityUI.setupScrollAndStackView and test in SPC TST
                 add UtilityUI.setupScrollAndStackViewWithImage and test in SPC MESO
2017_01_12 38109 camelCase and cleanup
                 WFOTXT , attempt to set email subject in share ( needs testing )
                 CA radar - add short and long options
                 disable color pal editor in settingsMain for now
                 ESRLmodel ( and various others ) - status was bringing up model choice
2017_01_10 38108 camelCase methods and cleanup
2017_01_09 38107 camelCase methods and cleanup
2017_01_08 38106 add homescreen sunmoon option
                 camelCase methods
2017_01_07 38105 camelCase code style
2017_01_04 38105 camelCase code style
2017_01_02 38104 code and lint cleanup
                 add fix for MCD - need to left pad zeros like watch
2017_01_01 38103 wpc gefs - add sector support
                 standardize names for model interface - sectors,params,labels ( start to )
2016_12_31 38102 code and lint cleanup, clean project and recompile 
		 (bugfix) level3 4bit SRM (56) was not displaying status info or showing frame time in anim
		 remove 4bit ref from prod list in radar ( deprecated this year )
		 NWS Mosaic was not using utility method for main image fetch
		 (bugfix) NWS Mosaic fix utility method which homescreen was using
		 WPC Images , change labels and add some more images
2016_12_30 38101 fix time display in SPC HRRR/SSEO
                 hide status in SSEO
                 fix a few broken text products ( see android changelog for details )
2016_12_29 38100 bump version number closer to android version
                 CA Radar: add mosaic animations
                 Homescreen: add local CA radar
2016_12_29 1.0.39 organize source files into groups and real folders
2016_12_28 1.0.38 minor fixes on NCEP models
                  SWO summary bugfix ( case sensitive ) for D1
2016_12_27 1.0.38 add animation to all models
2016_12_27 1.0.37 SPC SSEO - add back beta 
                  enhance stormtrack with 0 tickmark and dual lines for tickmarks
2016_12_25 Sun 1.0.37 CA radar - add vis
                      MyApp RefreshLocData was being called before prefinit so no LOCs were present until 2nd launch
2016_12_24 Sat 1.0.37 CA 7day, CC, and location save
2016_12_24 Sat 1.0.37 add util Canada files
2016_12_23 Fri 1.0.37 complete work to add license data to file header
2016_12_23 Fri 1.0.36 add NCAR Ensemble now that license is permissive
2016_12_23 Fri 1.0.36 add lighting now that license is permissive
                      add skeletal ncar wrf now that license is permissive
2016_12_22 Wed 1.0.36 add copyright info
2016_12_21 Wed 1.0.36 WPC IMG fix NFDB images
                      add GNU GPLv3 to main dir and start to add to files
                      remove unused files in top level
                      settings edit - remove notification perm check
2016_12_13 Tue 1.0.33 add markers to storm tracks for 15min
                      cleanup - remove uneeded source files
                      locfrag - change NWS images to align to top of card view UIStackView alignment
2016_12_10 Sat 1.0.32 (bugfix) NCEP model time arr not cleared between model chg
2016_12_07 Mon 1.0.31 (bugfix) SPC Day 1 broke due to lowercase conversion
2016_12_05 Mon 1.0.30 radar - add swo d1
2016_12_05 Mon 1.0.30 settings->radar add setting for detailed METAR zoom
2016_12_05 1.0.29 wind barb - add gust
2016_12_04 1.0.29 refinement to windbarbs and obs
                  wxogl - correct text size scaling issue
2016_12_03 1.0.28 disable MCD/WAT/MPD in radar canvas
                  wind barb work
2016_11_30 1.0.27 in settings->Locations add ability to move up/down and delete
2016_11_26 1.0.25 updates to PlayList ( add WFO and Text pro buttons ), decrease text preview size
                  add support for color legend for precip dereived radars
2016_10_30 1PM changes to support multipane radar with lat/lon not shared
2016_10_30 10AM rename files comprising tabs
2016_10_29 AM fix bugs in NWS Mosaic and Model time transalation
              test stackview spacing in SPC storm reports
2016_10_28 7am storm reports map and code cleanup, more work on NCEP run status but no success
2016_10_04 add rough CC to FirstViewController
