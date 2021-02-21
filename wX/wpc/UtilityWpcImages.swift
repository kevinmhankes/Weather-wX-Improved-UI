/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWpcImages {

    static let titles = [
        ObjectMenuTitle("Surface Analysis", 7),
        ObjectMenuTitle("Forecast Maps", 22),
        ObjectMenuTitle("QPF", 27),
        ObjectMenuTitle("Snow / Ice", 21),
        ObjectMenuTitle("National Digital Forecast Database", 15),
        ObjectMenuTitle("CPC Outlooks", 24),
        ObjectMenuTitle("Aviation", 16),
        ObjectMenuTitle("Space Weather", 3)
    ]

    static let labels = [
        "WPC Analysis, Radar, Warnings",
        "Surface Analysis with Obs (CONUS)",
        "Surface Analysis with Obs (NHEM)",
        "Analysis with Satellite (CONUS)",
        "Analysis with Satellite (NHEM)",
        "Analysis with Satellite (NHEM+PAC)",
        "High resolution surface analysis",

        "National Forecast Chart Day 1",
        "National Forecast Chart Day 2",
        "National Forecast Chart Day 3",
        "WPC Fronts/NDFD Weather Type - 12hr",
        "WPC Fronts/NDFD Weather Type - 24hr",
        "WPC Fronts/NDFD Weather Type - 36hr",
        "WPC Fronts/NDFD Weather Type - 48hr",
        "WPC Fronts/NDFD Weather Type - 72hr",
        "WPC Fronts/NDFD Weather Type - 96hr",
        "WPC Fronts/NDFD Weather Type - 120hr",
        "WPC Fronts/NDFD Weather Type - 144hr",
        "WPC Fronts/NDFD Weather Type - 168hr",
        "WPC Fronts - 3day" ,
        "WPC Fronts - 4day",
        "WPC Fronts - 5day",
        "WPC Fronts - 6day",
        "WPC Fronts - 7day",
        "Forecast map - 3day (NHEM)" ,
        "Forecast map - 4day (NHEM)" ,
        "Forecast map - 5day (NHEM)" ,
        "Forecast map - 6day (NHEM)" ,
        "Forecast map - 7day (NHEM)" ,

        "QPF Day 1",
        "QPF Day 2",
        "QPF Day 3",
        "QPF Day 1-2",
        "QPF Day 1-3",
        "QPF Day 4-5",
        "QPF Day 6-7",
        "QPF 5 Day Total",
        "QPF 7 Day Total",
        "WPC Day 1 Excessive Rainfall Outlook",
        "WPC Day 2 Excessive Rainfall Outlook",
        "WPC Day 3 Excessive Rainfall Outlook",
        "QPF Day 1 00-06 hr",
        "QPF Day 1 06-12 hr",
        "QPF Day 1 12-18 hr",
        "QPF Day 1 18-24 hr",
        "QPF Day 1 24-30 hr",
        "QPF Day 2 30-36 hr",
        "QPF Day 2 36-42 hr",
        "QPF Day 2 42-48 hr",
        "QPF Day 2 48-54 hr",
        "QPF Day 3 54-60 hr",
        "QPF Day 3 60-66 hr",
        "QPF Day 3 66-72 hr",
        "QPF Day 3 72-78 hr",
        "QPF Day 3 1/2 78-84 hr",
        "QPF Day 3 1/2 84-90 hr",

        "Snow Day 1 Prob > 4in",
        "Snow Day 1 Prob > 8in",
        "Snow Day 1 Prob > 12in",
        "Ice Day 1 Prob > 0.25in",
        "Snow Day 2 Prob > 4in",
        "Snow Day 2 Prob > 8in",
        "Snow Day 2 Prob > 12in",
        "Ice Day 2 Prob > 0.25in",
        "Snow Day 3 Prob > 4in",
        "Snow Day 3 Prob > 8in",
        "Snow Day 3 Prob > 12in",
        "Ice Day 3 Prob > 0.25in",
        "Snow/Sleet Day 4 Prob (experimental)",
        "Snow/Sleet Day 5 Prob (experimental)",
        "Snow/Sleet Day 6 Prob (experimental)",
        "Snow/Sleet Day 7 Prob (experimental)",
        "GLSEA Ice Analysis",
        "GL ice concentration",
        "GL estimated max thickness of level ice",
        "GL Traditional Composite - West",
        "GL Traditional Composite - East",

        "High Temperature",
        "Min Temperature",
        "Prob Precip (12hr)",
        "Predominant Weather",
        "Hazards",
        "Temperature",
        "Dewpoint",
        "Wind Speed (kts)",
        "Wind Gust (kts)",
        "Sky Cover",
        "Snow Amount (6hr)",
        "Ice Accumulation (6hr)",
        "Wave Height",
        "Apparent Temp",
        "Relative Humidity",

        "6 to 10 Day Outlooks - Temperature",
        "6 to 10 Day Outlooks - Precipitation",
        "8 to 14 Day Outlooks - Temperature",
        "8 to 14 Day Outlooks - Precipitation",
        "6-10 Day Heat Index Outlook",
        "8-14 Day Heat Index Outlook",
        "6-10 Day Lowest Wind Chill Outlook",
        "8-14 Day Lowest Wind Chill Outlook",
        "Week 3-4 Outlooks - Temperature ( Experimental )",
        "Week 3-4 Outlooks - Precipitation ( Experimental )",
        "One Month Outlook - Temperature",
        "One Month Outlook - Precipitation",
        "Three Month Outlook - Temperature",
        "Three Month Outlook - Precipitation",
        "US Monthly Drought Outlook",
        "US Seasonal Drought Outlook",
        "US Drought Monitor",
        "UV Index Forecast Day 1",
        "UV Index Forecast Day 2",
        "UV Index Forecast Day 3",
        "UV Index Forecast Day 4",
        "Day 3-7 U.S. Hazards Outlook",
        "Day 8-14 U.S. Hazards Outlook",
        "Global Tropics Hazards and Benefits Outlook",

        "AWC Convective Sigmets",
        "AWC Turbulence Sigmets",
        "AWC Icing Sigmets",
        "Aviation - WPC Surface Analysis",
        "Aviation - WPC 06 hour Forecast",
        "Aviation - WPC 12 hour Forecast",
        "Aviation - WPC 18 hour Forecast",
        "Aviation - WPC 24 hour Forecast",
        "Aviation - WPC 36 hour Forecast",
        "Aviation - WPC 48 hour Forecast",
        "Aviation - WPC 60 hour Forecast",
        "Aviation - WPC 3 day Forecast",
        "Aviation - WPC 4 day Forecast",
        "Aviation - WPC 5 day Forecast",
        "Aviation - WPC 6 day Forecast",
        "Aviation - WPC 7 day Forecast",

        "Aurora Forecast - North",
        "Aurora Forecast - South",
        "Estimated Planetary K index"
    ]

    static let urls =  [
        GlobalVariables.nwsWPCwebsitePrefix + "/images/wwd/radnat/NATRAD_24.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/namussfcwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/90fwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/ussatsfc.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/satsfcnps.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/satsfc.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/sfc/lrgnamsfc09wbg.gif",

        GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad1.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad2.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad3.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/92fwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/94fwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/96fwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/98fwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf072.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf096.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf120.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf144.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf168.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9jhwbg_conus.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9khwbg_conus.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9lhwbg_conus.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9mhwbg_conus.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9nhwbg_conus.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9jh.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9kh.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9lh.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9mh.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/medr/9nh.gif",

        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_94qwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_98qwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_99qwbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d12_fill.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d13_fill.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/95ep48iwbg_fill.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/97ep48iwbg_fill.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p120i.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p168i.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/94ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/98ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/99ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_91ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_92ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_93ewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9eewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9fewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9gewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9hewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9iewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9jewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9kewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9lewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9oewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9newbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9pewbg.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_9qewbg.gif",

        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day1_psnow_gt_04.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day1_psnow_gt_08.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day1_psnow_gt_12.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day1_pice_gt_25.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day2_psnow_gt_04.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day2_psnow_gt_08.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day2_psnow_gt_12.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day2_pice_gt_25.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day3_psnow_gt_04.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day3_psnow_gt_08.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day3_psnow_gt_12.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/day3_pice_gt_25.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/pwpf_d47/gif/prbww_sn25_f096.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/pwpf_d47/gif/prbww_sn25_f120.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/pwpf_d47/gif/prbww_sn25_f144.gif",
        GlobalVariables.nwsWPCwebsitePrefix + "/wwd/pwpf_d47/gif/prbww_sn25_f168.gif",
        "https://coastwatch.glerl.noaa.gov/glsea/cur/glsea_cur.png",
        "https://www.weather.gov/images/cle/ICE/dist9_concentration.jpg",
        "https://www.weather.gov/images/cle/ICE/dist9_thickness.jpg",
        "https://www.weather.gov/images/cle/ICE/egg_west.jpg",
        "https://www.weather.gov/images/cle/ICE/egg_east.jpg",

        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/MaxT",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/MinT",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/PoP12",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/Wx",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/WWA",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/T",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/Td",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/WindSpd",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/WindGust",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/Sky",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/SnowAmt",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/IceAccum",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/WaveHeight",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/ApparentT",
        GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/RH",

        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/610day/610temp.new.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/610day/610prcp.new.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/814day/814temp.new.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/814day/814prcp.new.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/short_range/heat/himx.wcp0.08.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/short_range/heat/himx.wcp0.11.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/short_range/cold/LWCF.5.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/short_range/cold/LWCF.7.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/WK34/gifs/WK34temp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/WK34/gifs/WK34prcp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/30day/off15_temp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/30day/off15_prcp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/long_range/lead01/off01_temp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/long_range/lead01/off01_prcp.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/expert_assessment/month_drought.png",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/expert_assessment/sdohomeweb.png",
        "https://droughtmonitor.unl.edu/data/png/current/current_usdm.png",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/stratosphere/uv_index/gif_files/uvi_usa_f1_wmo.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/stratosphere/uv_index/gif_files/uvi_usa_f2_wmo.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/stratosphere/uv_index/gif_files/uvi_usa_f3_wmo.gif",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/stratosphere/uv_index/gif_files/uvi_usa_f4_wmo.gif",
        "https://www.wpc.ncep.noaa.gov/threats/final/hazards_d3_7_contours.png",
        "https://www.cpc.ncep.noaa.gov/products/predictions/threats/hazards_d8_14_contours.png",
        GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/precip/CWlink/ghazards/images/gth_full_update.png",

        GlobalVariables.nwsAWCwebsitePrefix + "/adds/data/airmets/airmets_CB.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/adds/data/airmets/airmets_TB.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/adds/data/airmets/airmets_IC.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/adds/data/progs/hpc_sfc_analysis.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F006_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F012_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F018_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F024_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F036_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F048_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F060_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F072_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F096_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F120_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F144_wpc_prog.gif",
        GlobalVariables.nwsAWCwebsitePrefix + "/data/products/progs/F168_wpc_prog.gif",

        "https://services.swpc.noaa.gov/images/animations/ovation/north/latest.jpg",
        "https://services.swpc.noaa.gov/images/animations/ovation/south/latest.jpg",
        "https://services.swpc.noaa.gov/images/planetary-k-index.gif"
    ]
}
