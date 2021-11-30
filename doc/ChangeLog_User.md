
# wXL23 ChangeLog

Service outages with NWS data will be posted in the [FAQ](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/FAQ.md) as I become aware of them. 
FAQ can be accessed via Settings -> About

### version **56142** - released on 2021/11/27
* [FIX] GOES Viewer, eep Eastern East Pacific image was not working after NOAA changed image resolution
* [ADD] National Images - add "_conus" to end of filename for SNOW/ICE Day1-3 for better graphic
* [ADD] SPC HRRR - add back SCP/STP param
* [ADD] switch to non-experimental WPC winter weather forecasts day 4-7
* [ADD] SPC Meso in "Multi-Parameter Fields" add "Bulk Shear - Sfc-3km / Sfc-3km MLCAPE"
* [FIX] SPC Meso in "Upper Air" change ordering for "Sfc Frontogenesis" to match SPC website

### version **56141** - released on 2021/10/23
* FIX - navigation bottom bar was truncated on first launch for large iphone devices after compiling with xcode13

### version **56140** - released on 2021/10/21
* FIX - NWS html format changed caused 7 day forecast icons to break
* ChangeLog and FAQ now stored in gitlab and not google docs
* Add additional GOES products FireTemperature, Dust, GLM

