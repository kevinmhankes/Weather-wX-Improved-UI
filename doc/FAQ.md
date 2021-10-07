
# “wX” FAQ covering Android’s “wX” and iOS “wXL23”

Last updated: 2021-10-07

Helpful Links to check status from NWS if I am on vacation or not able to respond quickly to update the FAQ:
* [https://radar3pub.ncep.noaa.gov/](https://radar3pub.ncep.noaa.gov/)
* [https://www.nco.ncep.noaa.gov/status/messages/](https://radar3pub.ncep.noaa.gov/)

**Versions of Android prior to Android 6.0 will no longer supported after October 1, 2022.**

[wX (Android) ChangeLog](https://gitlab.com/joshua.tee/wx/-/blob/master/doc/ChangeLog_User.md)

[wXL23 (iOS) ChangeLog](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/ChangeLog_User.md)

Questions, suggestions, comments - please send to: joshua.tee@gmail.com
wX is now in its 9th year of active development. Thank-you for all the encouragement, thanks, bug reports, and suggestions along the way.

Please see “Settings -> About” for wX/wXL23 disclaimer. The Android wX version is as follows, the wXL23 is mostly the same:

*wX is an efficient and configurable method to access weather content from the NWS, Environment Canada, NSSL WRF, and blitzortung.org. Additional software and tools are used from Telecine, GraphView, bzip2, TouchImageView, OkHttp, ImageMap, HoloColorPicker, and OpenStreetMaps. Software is provided "as is". Use at your own risk. Use for educational purposes and non-commercial purposes only. Do not use it for operational purposes. Copyright 2013-2021 joshua.tee@gmail.com .*

**wX is licensed under the GNU GPLv3 license. For more information on the license please go here:**
[http://www.gnu.org/licenses/gpl-3.0.en.html](http://www.gnu.org/licenses/gpl-3.0.en.html)

Privacy Policy: this app does not collect any data from the user or the user’s device.

Please report bugs or suggestions via email to me as opposed to app store reviews.

[[_TOC_]]

### What are the numbers in the tab title area for SPC and MISC (Android only)?

If in settings you have “Check for SPC MCD/W”, “Check for WPC MPD”, and “Check for TOR,TST,FFW” enabled as an example you will see “SPC W(1)  M(2) P(2)” and “MISC (6,1,3)”. In this example across the US there is currently one watch, two SPC Mesoscale Discussions, and 2 WPC Mesoscale Precipitation discussions. In addition there are 6 severe thunderstorm warnings, 1 tornado warning, and 3 flash flood warnings. These numbers are updated according to the notification interval in Settings->Notifications ( default: 12min )

### Why is my location not auto-detected after I install the program?

I’ve seen a few weather apps do this and cause the app to hang or crash. The bottomline is the diversity in hardware and software in the Android ecosystem makes implementing this correctly difficult and I’ve chosen to invest my time elsewhere. I only have 2 physical devices at my disposal as a hobbyist. It should take less than 30 seconds to set your location and thus I won’t risk the integrity of the program ( for anyone ) for a very minor inconvenience. Please email me if you need additional support. 

### How do I delete the default “Home” location or modify it?

The default location can only be deleted after another location is added. To add a new location tape the location label on the main screen and select “Add Location..”. This will take you to the location management screen and you can find information on how to use it in the “Help” item in the submenu at bottom right. Once you have added a new location you can then go to “Settings->Location” from the main screen and then tap the trash icon and then tap the “Home” location. Another alternative is to just modify the “Home” location by going to “Settings->Location” and then just tapping on the “Home” location and selecting “Edit” which will take you to the location management screen.

### Why is Level 2 radar not the default?

In a complex scene Level 2 radar data can be as large as ~ 3.0MB. In fact the entire file is not downloaded ( they can come close to 14MB ) as only the first portion is needed for the lowest tilt of reflectivity and velocity. In contrast Level 3 usually does not exceed 100kb ~ 3-4% the size of the Level 2. In general, with my program I recommend you use Level 3 unless you are specifically looking for fine storm features such as a hook echo. Nonetheless, Level 2 is provided for completeness although it’s not as solid as Level 3 support, the NWS documentation provided to decode is not as complete as Level 3. Also,  in some cases if your hardware does not have sufficient resources it will not animate properly, it will animate slowly, it will not allow many frames to animate, and occasionally it will be distorted. In addition the Level 2 files on the publicly accessible NWS servers are not always as current as the Level 3 files.  In general if you feel the need to use Level 2 the majority of the time I would recommend a radar viewer that has Level 2 as the default.

### Can the tile icons be arranged on the MISC and SPC Tabs(Android only)?

Yes, just long-press (press and hold) on the icon until the border changes and then drag it to where you would like. The other icons will adjust as needed.

### In the radar activity, how does one move around?

You can double tap on a specific spot to zoom in, single tap to zoom out, pan to move in any direction, and pinch-zoom is available as well. In addition if you long-press (press and hold) on a location a popup will come up allowing one to switch radars, show the nearest observation, or the text for a warning if one long presses inside a warning polygon.

For activities besides the radar activity that have images, can you zoom in or pan?
Yes, all activities from Model, SPC Mesoanalysis, and Visible satellite allow one to double tap or ping drag to zoom and pan to move around. Unlike the radar activity a double tap will zoom in but another double tap will zoom out ( in radar another double tap would zoom in further and a single tap is used to zoom out ).

### In the Model activities if the images are not zoomed in can I drag left or right to advance in time?

Yes

### Why is no image shown in weather model activities at times?

If the upstream model provider has not generated all images for a particular run and your time is beyond what is generated a blank screen is shown. You can see how far the run is progressed in the submenu - look for “in through 120” as an example (provided the model provider provides this status information). If can select an older model run to see a complete set of images. Please note that the image time translation to local time and day of week is only valid for the most current run. Additionally, sometimes regardless of what time or products are shown, no image is visible. There seems to be a bug ( which I continue to track down ) that causes this. If you pinch zoom on the screen even though nothing is present this will most likely resolve that bug. When you exit the model activity it saves your zoom and x,y positions and so most likely the bug is related to that.

### On the main screen showing current conditions and forecast what items will show more information if tapped on?

If you tap on the icon to the left of the current conditions a popup will come up allowing one to control any radars ( if configured ) along with editing the current location. In addition if you see blue text right below current conditions ( such as hazardous weather outlook or some sort of warning ) this text can be tapped on to expand it to show the entire alert or detail.

### How else can I get help?

For Android, you can long press on any toolbar icon to show a brief description. This is not specific to wX but rather a feature available in any Android app if the developer so chooses to include the text. Finally, some key activities (nexrad radar, color palette editor, and location editor) like the one to create a new location  have a dedicated help area accessible from the submenu.  Additionally, in various settings screens you can tap on the labels for more detailed information.

### Why do some activities show an icon with three horizontal lines instead of a back arrow(Android only)?

This indicates a pull out navigation drawer is available by either tapping this icon or swiping from left to right across the edge of the left screen. Most model activities and SPC Mesoanalysis make use of this UI element. As a sidenote this icon is sometimes referred to as a “hamburger icon”.

### What is the difference between the back arrow in the top left versus the back button in the navigation bar at the far bottom(Android only)?

The back arrow at bottom will take you back to where you last were. In general the back arrow at top left will take you back to the main screen regardless of how deep down you are in the program.

### I have enabled storm tracks in radar, why are some longer than others?

The length of the storm track is used to indicate the estimated speed of the storm. In particular the end of the track itself is where the storm is estimated to be in 60 minutes based on NWS algorithms.

### Why does the Notification Check Interval in Settings->Notifications no longer make a difference when changed? Is the Widget check interval related to the notification check interval(Android only)?

NOTE: The change that causes this will not go into effect until late 2017. Newer version of Android force application developers to use the new “JobService” framework which only allows a minimum refresh of 15 minutes ( to conserve battery ). If you are running Android 7.0 or later you will be impacted by this which impacts all background data fetch including warning and alert data. If you are going to make changes the widget check interval, please ensure that the notification check interval remains set at a lower value then the widget check interval.

### For sharing of data, what apps are supported? Where are the files stored(Android only)?

At this time email (such as gmail) as the only supported apps for sharing text or image content. Facebook requires 3rd party code integration and is not supported. Screenshots and Videos from the screen recorder are now saved to Android/data/joshuatee.wx/files/Movies and DCIM. This change is needed to work with scoped storage in Android Q and later. Apologies for any inconvenience that google’s more restrictive permissions will cause.

### In nexrad radar, how do I set it to update frequently, keep the screen on (don’t let display turn off/lock) and update my GPS position?
From the main screen go to settings -> radar and make these changes. Then go out to the main screen and into the radar via “lightning icon”:
* “Location marker follow GPS” - on
* “Screen on, auto refresh” - on
* “Refresh interval” ( number picker ) - 1 (pull data every minute)

### Why are widgets not updating(Android only)?

In general some users have had widgets that don’t update. It is also possible that immediately following an update the widget will not update until the next cycle. I think in general the vast number of vendor, hardware, operating system, launcher combinations makes it hard to troubleshoot. I would not consider Android widgets the most reliable feature of the operating system and so for this reason I would consider all widgets as a permanent “Beta” feature. A quick google illustrates many issues over the years for other apps as well. In only one case I’ve been able to replicate a users issue in the past 5 years which makes it very difficult to solve issues. Nonetheless, if you are having issues and those issues are not apparent in the main app (for example you are using a 7 day forecast widget which is not working but you can see the 7 day forecast in the main app itself) please email me this data as a data point. If I see an issue or am able to reproduce the issue I will respond back:
* In settings -> notifications send the value for the number picker "Notification check interval(m)"
* In settings -> widgets ensure the very top “slider” shows widgets as enabled.
* In settings -> widgets, send the value for the number picker "Widget check interval(m)"
* Your hardware device and operating system version
* Your launcher application if not the default ( for example “Nova” )
* A screenshot of the widget having issues
* Additionally, two things you could do (but might not want to for obvious reasons) are to restart your device and/or to wipe cache/data for the app. While these should not be necessary it could be used as a last resort.


### Is there any additional documentation available(Android only)?

Yes, a kind user has contributed his own beginner documentation in this blog post complete with many screenshots:
[https://drartaudnonpolitical.wordpress.com/2019/03/16/2397/](https://drartaudnonpolitical.wordpress.com/2019/03/16/2397/)


### Are keyboard shortcuts available (for Chromebooks, etc)?

Yes (these are still being solidified):
* Control-r - nexrad radar
* Control-i - wfo text viewer
* Control-g - goes viewer
* Control-s - settings
* Control-e - severe dashboard

### Is there a desktop version available?

For Chromebook, wX can be installed from the Play Store and should offer a decent experience. Please see the keyboard shortcuts listed in Settings -> About wX. Additionally in radar, trackpad two finger pan works along with pinch zoom. I personally have a number of unreleased desktop versions but will likely refrain from officially offering something. However, if you are interested in a Qt/C++ or a GTK3 or 4/C++(or Vala) version and are comfortable compiling from source code I might make the source code available but no support would be offered.

### Is there a version available for iOS?
Yes, The iOS version “wXL23” has now been released on the Apple app store since late 2018. While not as full featured (for example, no notifications, no widgets, no color palette editor, no support for more than one nexrad radar in the home screen, no nexrad screen recording, drawing tool, distance measurer) it should provide most other core features:
[https://itunes.apple.com/us/app/wxl23/id1171250052?mt=8](https://itunes.apple.com/us/app/wxl23/id1171250052?mt=8)

### Is lightning data available in radar or integration with other providers?

No. Unfortunately the National Weather Service does not offer lightning data. Additionally, since wX is open source software it makes it theoretically difficult to integrate with non-open data providers who may offer lightning data. The original goal of this program was to make it easy to ingest the best data that the NWS has to offer in the mobile space.

### Why is the nexrad radar not updating and what can I do about it?

Occasionally, you will see the update time for the radar in the nexrad viewer will be red in color. This indicates the radar image is old. To see why “long press” ( press and hold ) and then choose the “radar status: Your_radar_id” and hopefully you will see some text from the NWS indicating why your radar is down. You can also use this same “long press” to select your next closest radar until your main site is back up. In settings -> Radar you can select “remember location” which will keep your radar / production selection, zoom level, and lat/lon center location between radar sessions. In settings -> Homescreen you can also add additional nexrad “fixed” radars or delete the default one.

### (May 2019) Why are notifications not showing in the status bar in Android Q Beta, if I slide down the notifications are there(Android only)?

Unknown at this time why this is occurring but it’s possible it’s related to a new Android feature that can be turned off (settings -> notifications on the emulators crashes so I can’t test this but I am speculating this will fix it):
Slide down on the taskbar and select the Settings icon.
In the settings menu, tap on Apps and notifications.
In the Apps and notifications menu, tap on Notifications.
Toggle the Automatic Notification Prioritizer setting on or off.

### Can I suggest new features or report bugs?

Of course, these programs have been in development since last 2013 and many user suggested features have been implemented (most notably dual and quad pane nexrad radar). Please suggest any features or bugs via email to joshua.tee@gmail.com. Please do keep in mind I maintain ports for 2 platforms (Android Kotlin, iOS Swift) and this is a hobby for me. When I go on vacation I might not respond for multiple weeks  - I’m not ignoring, I’m just somewhere else. So I won’t state if I will implement the feature or even estimate if or when a feature will be completed. I also need to look at the ongoing maintenance cost that any new feature would add. With that said, if I see value in it it usually *eventually* gets done. In my opinion these programs are now “feature complete” for me and efforts will continue to be invested in keeping up with Google and Apple’s non-trivial changes requiring developer effort (in particular when a new version of iOS/Android is released), fixing bugs, and reacting to upstream NWS API changes. The wealth of information accessible through these programs also means there are a wealth of ways in which NWS can change their data and break things.

Along those same lines I’ve had many requests of donations of money/other and while I do appreciate such gestures it’s not necessary. I enjoy programming and I enjoy the weather. Money just tends to complicate things and I would not want to be accepting of donations especially for any future development commitment.

### Why is NWS the only data presented and will there be integration with personal weather stations? 

The NWS (National Weather Service) is the only provider of weather data in the US that is in the public domain and can be used freely and without limits (your tax dollars hard at work) This is what allows wX to truly be free - both free as in no cost to you and free as in Open Source. Unfortunately, NWS does not provide data or an interface to any personal weather stations and thus there is no plan to provide data for personal weather stations.


### Is there a beta program(Android only)?

Yes, please email me the email you use with google play and then after I add you you’ll need to visit this URL from your phone to enroll:
[https://play.google.com/apps/testing/joshuatee.wx](https://play.google.com/apps/testing/joshuatee.wx)

### Why is the current conditions notification not updating the temperature in the status bar?

It was observed with one user that if the notification is changed to “silent” it will not update the icon. This notification does not make noise anyway so if you have problems please remove it from being “silent”.

### Where does the 7 day forecast come from, it doesn’t quite match forecast.weather.gov (Mar 2021 - the new API is no longer the default, reverted back to the older API used by forecast.weather.gov due to ongoing issues with new API)?

In 2017 the NWS release a new “API” to access weather data which is documented here:
[https://forecast-v3.weather.gov/documentation](https://forecast-v3.weather.gov/documentation)
At the time the impression was given that the NWS would switch over to it so all partners ( such as me ) should switch to it as well as the older data would then be deprecated. I did update wX in the summer of 2017 to use the new API. The NWS still has not updated forecast.weather.gov to use it but they are coming closer, this notice below is actually now postponed:
[https://www.weather.gov/media/notification/scn16-55forecast_govaaf.pdf](https://www.weather.gov/media/notification/scn16-55forecast_govaaf.pdf)
From time to time there have been issues with the new API but in general the number of issues in the past year has gone done (This changed around 12/2020 - things go worse). Additionally I have observed the forecast does not always match between the new and old API. In particular snowfall totals appear inaccurate in some cases, this issue was reported to NWS in Jan 2020.

### How is warning data downloaded for use in nexrad radar(Android only)?

In the interests of transparency and understanding:

In version 55206 (target release June 2019)  the way in which polygon warnings for flash flood, tornado, and severe thunderstorm is acquired has changed. 

Previously, data was acquired in the background (even when the app is not running) according to a defined interval which can be changed in settings -> notifications - "Notification check interval in minutes". It was done this way because multiple features of the program can make use of this warning data including and so it makes sense to download in the background and be shared among items:
* the tab headers if configured ( numeric count )
* severe dashboard - octagon icon on main screen
* nws radar mosaic customer overlay
* nexrad radar
* prior GOES imagery (no longer available)

In developing iOS/Swift and Flutter/Dart ports, the nexrad interface is more responsive in that polygon data is queried on demand (neither of these ports have background tasks and so there is no choice). With version 55206 or later of the Android/Kotlin version, a supplementary method has been added for the three main polygons listed above so that data is queried and kept more up to date when using nexrad radar and severe dashboard. Other warnings (like marine warning) and watch/mcd/mpd will be moved to this new method as time allows.

Now, if you navigate to the severe dashboard or nexrad radar the polygon data will be fetched if the current data is older then 3 minutes but this can be changed to a minimum of 1 minute ( this can be configured in settings -> radar -> "refresh interval". This timing interval is also shared with the setting "screen on and auto refresh".  If you navigate or use the nexrad interface for another minutes ( or whatever that config is set to ), the next time you fetch data such as a product or radar site change it will fetch new polygon data. Additionally if you have "screen on and auto refresh" then essentially the radar data and the polygon data will be fetched at roughly the same time. The result is as expected - is a better view of active alerts. As always you should be mindful of data usage. When there are 20 active severe thunderstorm warnings the file downloaded can be large so please tune "refresh interval" accordingly if you have data limitations.

### Where is the source code?

[https://gitlab.com/users/joshua.tee/projects](https://gitlab.com/users/joshua.tee/projects)

### In screens such as Nexrad radar and national text products there is a star in the lower toolbar, what does this do(Android only)?

This allows you to mark the currently selected site or product as a “favorite” that is then accessible via the drop-down menu at the top right.

### Why Are notifications not working if I’ve enabled sound and choose a custom ringtone in settings -> notifications?

When you select a new "sound" (ringtone) in settings -> notification the sounds presented to you were a mix of internal and external storage based ringtones. If wX does not have storage permission when it goes to send a notification it crashes because it does not have permission for the audio file that is on external storage. Two fixes: 1) grant storage permission or 2) choose a sound that is not on external storage.

### (Android only) When using the screen recorder, after the notification is gone how can I access the images?

Screenshots and Videos from the screen recorder are now saved to Android/data/joshuatee.wx/files/Movies and DCIM. This change is needed to work with scoped storage in Android Q and later. Apologies for any inconvenience that google’s more restrictive permissions will cause.

### (iOS only) What shortcuts exist in the Nexrad radar?

For single pane nexrad radar you can tap on the timestamp to jump to dual pane radar. If warnings are enabled you can tap on the warning counts to go to the “severe dashboard”. You can long press (“press and hold”) to bring up a contextual menu based on where you press. For example if you long press inside of a warning polygon and select “show warning” you will get to see the text for the warning.

### How do I zoom in on images?

For screens that have multiple images you can single tap on an image and it will open in a dedicated image viewer. From there you can double-tap to zoom in, double-tap to zoom out, and pan.

### How can I show up as a “spotter” (by default pink dots if enabled in nexrad radar)? 
You would need to register here:
[https://www.spotternetwork.org/](https://www.spotternetwork.org/)
And then use something to update your location. This website is not at all related to my app, I simply consume data provided by it.

### Should I use wX for timely tornado warnings?

That’s up to you but it should not be your only source. Please view the app disclaimer at the top of this page and in settings -> about in the app. I personally recommend the following:
* Always staying weather aware
* Tornado siren / local media
* WEA alerts (cell phone)

### Does the iOS version have notifications?

No it does not. Unlike Android in order to do this properly you need to use push notifications. I am unwilling to take on that extra cost (since I generate no revenue by choice from this personal hobby) and complexity.
		
### App status history (primary NWS data issues)

Various parts of wX/wXL23 use api.weather.gov so you might see disruptions or degradations:

SENIOR DUTY METEOROLOGIST NWS ADMINISTRATIVE MESSAGE
NWS NCEP CENTRAL OPERATIONS COLLEGE PARK MD
2040Z TUE SEP 28 2021

...API.WEATHER.GOV DEGRADED...

API remains degraded following patching. NCO is investigating the
issue.

Liddick/SDM/NCO/NCEP

Resolved before 4am EDT 9/18 
9/17 3pm EDT: Current conditions for all locations are not updating, for example:
https://tgftp.nws.noaa.gov//data/observations/metar/decoded/KWHP.TXT
NWS TOC was contacted and they were already aware and tracking under INC0300383
Fri Aug 27 6am EDT: NCEP Models and NWS WPC content not working (or showing old data) due to NWS website not responding: https://mag.ncep.noaa.gov/ 
https://www.wpc.ncep.noaa.gov/
GOES also not current: https://www.star.nesdis.noaa.gov/GOES/index.php

More details at: https://www.nco.ncep.noaa.gov/status/messages/

Thur Aug 12 (resolved same day but please note below) - Lightning graphics are showing but showing no lightning strikes. NOTE: This data provider has had a number of outages this year and so an alternative is being looked into. The only suitable alternative I have found so far is the following and this will likely become the default in the next month:
https://www.star.nesdis.noaa.gov/GOES/conus_band.php?sat=G16&band=EXTENT&length=12

Sat Aug 7 - NHC Storm is not displaying any details for NHC PTC Jimena. (storm is no longer active anyway as of 6:45am EDT)

2021-07-19 12:10pm EDT https://tgftp.nws.noaa.gov/ not responding or showing old data impacting current conditions, nexrad radar. Example of old data (all radar sites are impacted)
https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.kcys/

UPDATE 4:30pm EDT: appears to be resolving.


2021-06-03 12:00pm EDT - some nexrad radar sites not updated on https://tgftp.nws.noaa.gov 
since roughly 10:45am EDT. You can see status here https://radar3pub.ncep.noaa.gov/
https://www.nco.ncep.noaa.gov/status/messages/

UPDATE: 1pm EDT - per web page above (https://radar3pub.ncep.noaa.gov/) things are back to normal for Nexrad Level 3 data.

2021-05-25 1:00pm EDT https://tgftp.nws.noaa.gov/ not responding impacting current conditions, nexrad radar.

2021-05-14 12:00pm EDT - NWS not updating for 7day/ hourly / some text products

2021-04-26 Many NWS WPC image products and an advertised “current” MPD are from 2020. (last less then one day)
https://www.wpc.ncep.noaa.gov/#page=ovw
https://www.wpc.ncep.noaa.gov/metwatch/metwatch_mpd_multi.php

Sun 4/11 - lightning images are not working (non-NWS provider). Example:
http://images.lightningmaps.org/blitzortung/america/index.php?map=usa_big&period=0.25

Mon Mar 29 9am EDT - Tue afternoon
Major NWS IT outage (started Mon morning) impacting most products presented by wX app. Some things such as AWC Radar Mosaic and GOES images might continue to work but they are the exception. Updates being posted here (this URL is not really working as of Tue morning)
https://www.nco.ncep.noaa.gov/status/messages/

SENIOR DUTY METEOROLOGIST NWS ALERT ADMINISTRATIVE MESSAGE
NWS NCEP CENTRAL OPERATIONS COLLEGE PARK MD
2027Z TUE MAR 30 2021

The earlier network firewall issue that impacted several NWS
applications
and services was corrected around 1745Z...external customers
should see
most/all impacts mitigated at this point. The few residual
internal NWS
network issues are being updated on the NWS IT Status Dashboard.

Handel/SDM/NCO/NCEP

Upcoming NWS outage Mar 27 impacting Level 2 Nexrad:
https://www.weather.gov/media/notification/pdf2/pns21-17national_level_II_outage.pdf

The NWS Radar Operations Center will perform required network maintenance at its data center in Norman, OK, on Saturday, March 27, from 8 am to 10 am EDT. The date and time of this required maintenance window was determined using forecast information to occur at a period of lower weather activity and risk. During this 2-hour period, NEXRAD and Terminal Doppler Weather Radar (TDWR) National Level II data will be unavailable. These data are primarily provided to the commercial, private sector and academia, and some mobile apps or third-party software may be affected. NEXRAD and TDWR Level III data will be disseminated as normal.

2021 Mar 11 - Mar 20 - Lightning maps does not appear to be working, default images uses this URL:
https://images.lightningmaps.org/blitzortung/america/index.php?map=usa_big&period=0.25
I’ll need to investigate if they have changed the URL or if it’s a legitimate server issue. UPDATE: appears to be a data center issue per the front page. Service might not be restored for days. (Outage 3/11/2021 - 3/20/2021)

3/9 (15min): 7 day forecast (old API) not responding as seen on forecast.weather.gov (12:45pm EDT)

3/2: Looks like image based widgets for those using them and running the latest version of Android might not be working. Appears to be caused by new restrictions set forward by Google in the latest Android version when app is target SDK 30. A fix has been submitted to google for approval (noon EDT 3/2) and is now available for update.

3/2: Update to both Android and iOS version released in the past day, should resolve all known issues related to flaky 7 day forecast, traditional radar mosaic no longer available, and severe weather alerts not showing or causing crashes.

	UPDATE 2/24: the iOS version released on Feb 24 resolves issues #2 and #3 below. Android version submitted for approval on March 1. New version is no longer using the new NWS API by default for 7 day forecast.

It was noticed on Feb 25 that a suspected change in the NWS data url for alerts is causing a crash for 
Long press in nexrad to show severe warnings
Tapping for details on severe warnings in severe dashboard
	This will be looked into the next time severe warnings are present during hours I am available to work on it. A fix is already released in Beta for Android (without testing). Hoping for scenarios to test with today. This impact other things related to individual alerts such as notifications.
Dec 20 2020: NWS has temporarily suspended the default Radar Mosaic images until Feb 26, 2021. This change appears related to the main NWS nexrad radar page update but no advanced notice was given on this suspension of mosaic data. In the meantime you can go to Settings -> UI and choose to use the “AWC” radar mosaic images instead. It’s unclear if the URLs will change on Feb 26 so an update to the app might be needed as well.Update, there is no longer a date given so AWC will be the only option going forward unless things change, see https://www.weather.gov/media/notification/pdf2/scn20-117radar_emwinaaa.pdf
(the next version of wX/wXL23 will no longer use the new NWS API for 7 day) No need to report 7 day or hourly issues, please see below): 

July 17 2020:  Earlier this week a user reported an issue with the 7 day forecast. Upon contacting NWS I received the following reply (below). The bottomline is until they fix this issue there is no need to report an issue to me as when I report it to them they will just state what is below. Please note in many cases you can add another location (~30 miles) away, and if it’s in another forecast zone it should work fine until your original location starts working again. However, if your zone doesn’t work for more then one week and you are able to share your forecast zone URL (settings -> About , at the bottom) , I can share these with NWS.:
NWS TOC response: We have a ticket opened for  (500, 502, 503 API errors). Our programming/developing team, are looking to resolve the issue with a SW patch, after it's been successfully tested on our DEV system. How long will that take? I don't know, but I can tell you it's being worked. I'll add you to the ticket so you can keep track of developments.

I suspect it’s this.

Fri 2/26 3pm EST - looks like radar data is showing old data all of a sudden from around 10am this morning, example can be seen here (likely impacting all nexrad directories) https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.kcle/ ( look at sn.last )  NWS TOC notified. Update 3:15pm EST (TOC stated service should be restored “shortly”) UPDATE2: at 6:30pm EST issue appears resolved.


Mon 2/15 Afternoon - NWS API not working that well impacting 7 day, hazards. 


1/26 7pm EDT: Nexrad radar (Level 3) not current past ~6:15pm EDT. NWS notified (and responded with estimated resolution before 9pm EDT). For example see sn.last file in 
https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.klot/

(2021/01/24 8pm EDT) https://api.weather.gov shows “bad gateway”, emailed NWS TOC 5AM Sat impacts 7day/hourly/alerts. Mostly resolved Sat night but issue returned Sun night, resolved by Monday 9am per TOC INC0247201


(2021/01/23) https://api.weather.gov shows “bad gateway”, emailed NWS TOC 5AM Sat impacts 7day/hourly/alerts. Mostly resolved Sat night. TOC INC0247201

(2021/01/21) Upcoming NWS outage impacting Level 2: Jan 21 12 to 07z following day. Details.

10/28 pm 5:15pm EDT  https://tgftp.nws.noaa.gov/ slow to respond (or not at all) impacting Nexrad radar and current conditions.

NWS IT Outage impacting Level 2 radar data Oct 22  1100z to 1700z
https://www.weather.gov/media/notification/SCN20-93_Updated_NOMADS_website_outage.pdf

NWS IT Outage Sep 28 (resched from 9/21) 06z-09z impacting numerous things including nexrad:
https://www.weather.gov/media/notification/pdf2/scn20-86noaaport_outage.pdf


2020-09-10 7:00am EDT, nexrad radar and observations intermittent due to issues with
http://https://tgftp.nws.noaa.gov

Wed 9/9 12:15pm EDT - looks like the website for nexrad radar data and location observations is not responding:
https://tgftp.nws.noaa.gov/
It looks like the website for 7 day / hourly / alerts is having an issue as well:
https://api.weather.gov/
Issue with MAG NCEP models as well.

2020-09-07 4:30am EDT - nexrad data files not updating at https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/ , last update roughly 06Z. NWS TOC notified.
Workaround use Radar mosaic.

Sunday 8/30 8:30am EDT - intermittent issues with https://api.weather.gov/ impacting 7day, hourly, alerts

(hurricane)Aug 26 12:00pm EDT https://tgftp.nws.noaa.gov/ intermittently responding impacting Nexrad radar and current conditions.

Aug 26 2:00pm EDT GOES imagery slow to respond if at all

Aug 26 8:00pm https://api.weather.gov not responding at all causing numerous products to not be available including 7day, hourly, alerts, some text products.

Aug 25 5:30pm EDT https://tgftp.nws.noaa.gov/ intermittently responding impacting Nexrad radar and current conditions.


Aug 16 7:00am - ~1:00pm EDT - NWS is not reliably providing radar data for Nexrad via TGFTP. (seems better @ 1:30pm)

Wed July 8, 4:15 am EDT - https://api.weather.gov is down for 7 day forecasts and hourly, TOC notified. Issue appears *somewhat* resolved by noon EDT but NWS has not officially confirmed and did mention they are making changes later this summer to prevent such issues from happening.
Thu 7:00am EDT It would appear the problem is more widespread again as forecasts are now showing as expired for many locations (For my reference the NWS ticket is INC0224255)
Thu 6:00pm EDT, still no confirmation of resolution but things seem a little better.


Monday June 29, 10:10am EDT - https://api.weather.gov is down for 7 day forecasts and hourly, TOC notified. (appears to have gotten better as the day progressed)

Thursday June 25, 12:50pm EDT - it appears https://tgftp.nws.noaa.gov is down impacting Nexrad radar, current conditions, and other more minor things. NWS TOC emailed. 
1:00pm EDT - appears to be working again

2020-06-17(wed) 9:00am - 9:45am am EDT - NWS API not available impacting 7 day / warnings. 
2020-05-14(thur) 3:00pm  EDT - NWS API not available impacting 7 day forecast / hourly / warnings / adding new US locations.  NWS TOC notified, open issue INC0219267. Last update 6pm EDT - ticket was priority “critical” and they are looking at an infrastructure issue. 
https://api.weather.gov/
Fri 2:10am EDT - services appear to be working now with sporadic issues. NWS has not updated status via the incident above.
Fri 3:45am EDT - service continues to be stable, moving app status to green. 
Fri 9:00am EDT - issue has returned
Fri 9:30am EDT - working again sporadically
Fri 11:30am EDT - NWS updated the critical ticket with actions they are taking to restore service but there is no estimate for restoration time. It does appear to be working sporadically.  
Fri 18:00 EDT - services appear to be restored, please email me if issues.


2020-05-12(tue) 2:15 pm (lasted less than 30min)  EDT - NWS API not available impacting 7 day / warnings. NWS TOC notified with estimation restoration within 1 hour.


NWS is planning IT work causing radar and forecast (and others) to not work on May 5 1200Z-14:30Z
https://www.weather.gov/media/notification/scn20-49awips_migration.pdf

4/29/20 Nexrad Radar animations have gaps. It looks like TGFTP data structure is not correct but is recovering. For example GRR is as follows. This should resolve over time.

sn.024229-Apr-2020 13:51 43K
sn.024329-Apr-2020 13:54 43K
sn.024429-Apr-2020 13:56 43K
sn.024529-Apr-2020 13:59 43K
sn.024629-Apr-2020 14:02 44K ←-
sn.024729-Apr-2020 00:09 33K ←-
sn.024829-Apr-2020 00:13 33K
sn.024929-Apr-2020 00:16 32K
sn.025029-Apr-2020 00:19 32K
sn.last29-Apr-2020 14:25 44K

4/25/20 NHC EPAC storm detail is now showing correctly in the Android/Kotlin version. FIX will enter Beta today with production release by 5/31 or sooner if NHC tracked storm is present.

Sunday April 19, 2020 12:30pm EDT api.weather.gov is not responding causing no 7 day forecasts
12:45pm resolved

Sat Apr 11, 10:00am EDT - 7 day forecast for zones controlled by RAH (Raleigh, NC) not working. NWS TOC notified.

Thur Apr 9, 2:40pm EDT - appears to be working again
Thur Apr 9, 2:15pm EDT
Any service relying on NWS API such as forecast, 7 day, warnings is down. https://api.weather.gov , NWS TOC notified


4/8/2020 8:00pm EDT - Level 2 data files do not appear to be complete from NWS site:
https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/
NWS TOC notified.
	8:40pm EDT update: some radar files are displaying but may be 
30-40 minutes old.
	10:00pm EDT update: looks like things are normal
As a reminder there is a FAQ item below titled “Why is Level 2 radar not the default?” I *suspect* this problem is caused by load on the NWS servers given the very active weather event underway. In situations like this, it is best to use Level 3 IMHO unless you are in a situation which calls for Level 2. It appears the servers for Level 3 files are doing fine.


App status:(9:15am appears resolved)
4/3/2020 8:30am EDT - Nexrad radar, current conditions, 7 day forecast, hourly (possibly other) not working. NWS notified.
https://tgftp.nws.noaa.gov
https://api.weather.gov

 Degraded 7 day forecasts for some locations
Mar 27, 2020 1:00pm EDT, NWS notified
May 28, 2020 9:00am EDT, appears resolved

Wed 3/25 6am EDT - 7 day forecast not working for most US locations. NWS TOC notified. 

Tue 2/25 4:00pm EST - NWS API impacting 7 day forecast, alerts, and services appears to be down.
Tue 2/25 5:15pm EST - NWS has resolved the issue

