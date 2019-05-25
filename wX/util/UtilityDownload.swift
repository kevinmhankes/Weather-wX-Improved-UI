/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityDownload {

    static func getStringFromUrl(_ url: String) -> String {
        guard let safeUrl = URL(string: url) else {
            return ""
        }
        do {
            return try String(contentsOf: safeUrl, encoding: .ascii)
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    static func getStringFromUrlSep(_ url: String) -> String {
        guard let safeUrl = URL(string: url) else {
            return ""
        }
        do {
            return try String(contentsOf: safeUrl, encoding: .ascii)
        } catch _ {
            //print("Error: \(error)")
        }
        return ""
    }

    static func getBitmapFromUrl(_ url: String) -> Bitmap {
        guard let safeUrl = URL(string: url) else {
            return Bitmap()
        }
        let imageData = try?  Data(contentsOf: safeUrl)
        if let image = imageData {
            return Bitmap(image)
        } else {
            return Bitmap()
        }
    }

    static func getDataFromUrl(_ url: String) -> Data {
        guard let safeUrl = URL(string: url) else {
            return Data()
        }
        let imageData = try? Data(contentsOf: safeUrl)
        var data = Data()
        if let dataTmp = imageData {
            data = dataTmp
        }
        return data
    }

    static func getTextProduct(_ produ: String) -> String {
        var text = ""
        let prod = produ.uppercased()
        if prod == "AFDLOC" {
            text = getTextProduct("afd" + Location.wfo.lowercased())
        } else if prod == "HWOLOC" {
            text = getTextProduct("hwo" + Location.wfo.lowercased())
        } else if prod == "SUNMOON" {
            text = UtilitySunMoon.computeData()
        } else if prod == "HOURLY" {
            let textArr = UtilityHourly.getHourlyString(Location.getCurrentLocation())
            text = textArr.0
        } else if prod == "SWPC3DAY" {
            text = ("http://services.swpc.noaa.gov/text/3-day-forecast.txt").getHtml()
        } else if prod == "SWPC27DAY" {
            text = ("http://services.swpc.noaa.gov/text/27-day-outlook.txt").getHtml()
        } else if prod == "SWPCWWA" {
            text = ("http://services.swpc.noaa.gov/text/advisory-outlook.txt").getHtml()
        } else if prod == "SWPCHIGH" {
            text = ("http://services.swpc.noaa.gov/text/weekly.txt").getHtml()
        } else if prod == "SWPCDISC" {
            text = ("http://services.swpc.noaa.gov/text/discussion.txt").getHtml()
        } else if prod == "SWPC3DAYGEO" {
            text = ("http://services.swpc.noaa.gov/text/3-day-geomag-forecast.txt").getHtml()
        } else if prod.contains("MIATCP") || prod.contains("MIATCM")
            || prod.contains("MIATCD") || prod.contains("MIAPWS")
            || prod.contains("MIAHS") {
            let textUrl = "http://www.nhc.noaa.gov/text/" + prod + ".shtml"
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
        } else if prod.contains("MIAT") {
            text = ("http://www.nhc.noaa.gov/ftp/pub/forecasts/discussion/" + prod).getHtmlSep()
            if UIPreferences.nwsTextRemovelinebreaks && prod == "MIATWOAT"
                || prod == "MIATWDAT" || prod == "MIATWOEP"
                || prod == "MIATWDEP" {
                text = text.replaceAll("<br><br>", "<BR><BR>")
                text = text.replaceAll("<br>", " ")
            }
        } else if prod.hasPrefix("SCCNS") {
            let textUrl = "/discussions/nfd" + prod.lowercased().replace("ns", "") + ".html"
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
            if UIPreferences.nwsTextRemovelinebreaks {
                text = text.removeLineBreaks()
            }
        } else if prod.contains("SPCMCD") {
            let no = prod.substring(6)
            let textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/md" + no + ".html"
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
            if UIPreferences.nwsTextRemovelinebreaks {
                text = text.removeLineBreaks()
            }
        } else if prod.contains("SPCWAT") {
            let no = prod.substring(6)
            let textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + no + ".html"
            text = textUrl.getHtmlSep()
            text = text.parseFirst(MyApplication.pre2Pattern)
            if UIPreferences.nwsTextRemovelinebreaks {
                text = text.removeLineBreaks()
            }
        } else if prod.contains("WPCMPD") {
            let no = prod.substring(6)
            let textUrl = MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd_multi.php?md=" + no
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
            if UIPreferences.nwsTextRemovelinebreaks {
                text = text.removeLineBreaks()
            }
        } else if prod.hasPrefix("GLF") && !prod.contains("%") {
            text = getTextProduct(prod + "%")
        } else if prod.contains("FOCN45") {
            text = "http://tgftp.nws.noaa.gov/data/raw/fo/focn45.cwwg..txt".getHtmlSep()
            if UIPreferences.nwsTextRemovelinebreaks {
                text = text.removeLineBreaks()
            }
        } else if prod.hasPrefix("AWCN") {
            text = ("http://tgftp.nws.noaa.gov/data/raw/aw/" + prod.lowercased() + ".cwwg..txt").getHtmlSep()
        } else if prod.contains("NFD") {
            text = ("http://www.opc.ncep.noaa.gov/mobile/mobile_product.php?id=" + prod.uppercased()).getHtml()
        } else if prod.contains("FWDDY38") {
            let textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/exper/fire_wx/"
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
        } else if prod.contains("FXCN01") {
            // FIXME not working - now 4 products
            // http://collaboration.cmc.ec.gc.ca/cmc/cmop/FXCN/20190410/fx_d1-3_west_2019041000.html
            // http://collaboration.cmc.ec.gc.ca/cmc/cmop/FXCN/20190410/
            // http://dd.weather.gc.ca/doc/LICENCE_GENERAL.txt
            text = "http://tgftp.nws.noaa.gov/data/raw/fx/fxcn01.cwao..txt".getHtmlSep()
        } else if prod.contains("FPCN48") {
            text = "http://tgftp.nws.noaa.gov/data/raw/fp/fpcn48.cwao..txt".getHtmlSep()
        } else if prod.contains("QPFPFD") {
            let textUrl = MyApplication.nwsWPCwebsitePrefix + "/discussions/hpcdiscussions.php?disc=qpfpfd"
            text = textUrl.getHtmlSep()
            text = text.parse(MyApplication.pre2Pattern)
        } else {
            let t1 = prod.substring(0, 3)
            let t2 = prod.substring(3).replace("%", "")
            let html = ("https://api.weather.gov/products/types/" + t1 + "/locations/" + t2).getNwsHtml()
            let urlProd = "https://api.weather.gov/products/" + html.parseFirst("\"id\": \"(.*?)\"")
            let prodHtml = urlProd.getNwsHtml()
            text = prodHtml.parseFirst("\"productText\": \"(.*?)\\}")
            text = text.replace("\\n\\n", "\n")
            text = text.replace("\\n", " ")
        }
        UtilityPlayList.checkAndSave(prod, text)
        return text
    }

    static func getTextProductWithVersion(_ product: String, _ version: Int) -> String {
        var text = ""
        let prodLocal = product.uppercased()
        let t1 = prodLocal.substring(0, 3)
        let t2 = prodLocal.substring(3)
        let textUrl = "http://forecast.weather.gov/product.php?site=NWS&product=" + t1
            + "&issuedby=" + t2 + "&version=" + String(version)
        text = textUrl.getHtmlSep()
        text = text.parse(MyApplication.prePattern)
        text = text
            .replace("Graphics available at <a href=\"/basicwx/basicwx_wbg.php\">"
                + "<u>www.wpc.ncep.noaa.gov/basicwx/basicwx_wbg.php</u></a>", "")
        text = text.replaceAll("^<br>", "")
        if UIPreferences.nwsTextRemovelinebreaks && t1 != "RTP" {
            text = text.removeLineBreaks()
        }
        return text
    }

    static func getImageProduct(_ product: String) -> Bitmap {
        var url = ""
        var bitmap = Bitmap()
        var needsBitmap = true
        switch product {
        case "VIS_1KM":
            needsBitmap = false
            bitmap = Bitmap()
        case "GOES16":
            needsBitmap = false
            bitmap = UtilityGoes.getImage(
                Utility.readPref("GOES16_PROD", "02"),
                Utility.readPref("GOES16_SECTOR", "cgl")
            )
        case "VIS_MAIN":
            needsBitmap = false
            bitmap = Bitmap()
        case "VIS_CONUS":
            needsBitmap = false
            bitmap = UtilityGoes.getImage("GEOCOLOR", "CONUS")
        case "CARAIN":
            if Location.x.contains("CANADA") {
                needsBitmap = false
                var rid = Location.rid
                if rid == "NAT" {
                    rid = "CAN"
                }
                if rid == "CAN" || rid == "PAC" || rid == "WRN" || rid == "ONT" || rid == "QUE" || rid == "ERN" {
                    bitmap = UtilityCanadaImg.getRadarMosaicBitmapOptionsApplied(rid)
                } else {
                    bitmap = UtilityCanadaImg.getRadarBitmapOptionsApplied(rid, "")
                }
            }
        case "WEATHERSTORY":
            needsBitmap = false
            bitmap = Bitmap("http://www.weather.gov/images/" + Location.wfo.lowercased() + "/wxstory/Tab2FileL.png")
        case "RAD_1KM": break
        case "IR_2KM":
            needsBitmap = false
            bitmap = Bitmap()
        case "WV_2KM":
            needsBitmap = false
            bitmap = Bitmap()
        case "VIS_2KM":
            needsBitmap = false
            bitmap = Bitmap()
        case "RAD_2KM":
            needsBitmap = false
            if !UIPreferences.useAwcRadarMosaic {
                bitmap = UtilityUSImgNWSMosaic.getLocalRadarMosaic()
            } else {
                var product = "rad_rala"
                let prefTokenSector = "AWCMOSAIC_SECTOR_LAST_USED"
                let prefTokenProduct = "AWCMOSAIC_PRODUCT_LAST_USED"
                var sector = "us"
                sector = Utility.readPref(prefTokenSector, sector)
                product = Utility.readPref(prefTokenProduct, product)
                bitmap = UtilityAwcRadarMosaic.get(sector, product)
            }
        case "FMAP":   url = MyApplication.nwsWPCwebsitePrefix + "/noaa/noaa.gif"
        case "FMAP12": url = MyApplication.nwsWPCwebsitePrefix + "/basicwx/92fwbg.gif"
        case "FMAP24": url = MyApplication.nwsWPCwebsitePrefix + "/basicwx/94fwbg.gif"
        case "FMAP36": url = MyApplication.nwsWPCwebsitePrefix + "/basicwx/96fwbg.gif"
        case "FMAP48": url = MyApplication.nwsWPCwebsitePrefix + "/basicwx/98fwbg.gif"
        case "FMAP3D": url = MyApplication.nwsWPCwebsitePrefix + "/medr/9jhwbg_conus.gif"
        case "FMAP4D": url = MyApplication.nwsWPCwebsitePrefix + "/medr/9khwbg_conus.gif"
        case "FMAP5D": url = MyApplication.nwsWPCwebsitePrefix + "/medr/9lhwbg_conus.gif"
        case "FMAP6D": url = MyApplication.nwsWPCwebsitePrefix + "/medr/9mhwbg_conus.gif"
        case "QPF1":   url = MyApplication.nwsWPCwebsitePrefix + "/qpf/fill_94qwbg.gif"
        case "QPF2":   url = MyApplication.nwsWPCwebsitePrefix + "/qpf/fill_98qwbg.gif"
        case "QPF3":   url = MyApplication.nwsWPCwebsitePrefix + "/qpf/fill_99qwbg.gif"
        case "QPF1-2": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/d12_fill.gif"
        case "QPF1-3": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/d13_fill.gif"
        case "QPF4-5": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/95ep48iwbg_fill.gif"
        case "QPF6-7": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/97ep48iwbg_fill.gif"
        case "QPF1-5": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/p120i.gif"
        case "QPF1-7": url = MyApplication.nwsWPCwebsitePrefix + "/qpf/p168i.gif"
        case "SWOD1":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("1", getAllImages: false)[0]
        case "SWOD2":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("2", getAllImages: false)[0]
        case "SWOD3":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("3", getAllImages: false)[0]
        case "SPCMESO1":
            let param = "500mb"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_500":
            let param = "500mb"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_MSLP":
            let param = "pmsl"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_TTD":
            let param = "ttd"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_RGNLRAD":
            let param = "rgnlrad"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_LLLR":
            let param = "lllr"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_LAPS":
            let param = "laps"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO"
                + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "CONUSWV":
            needsBitmap = false
            bitmap = UtilityGoes.getImage("09", "CONUS")
        case "LTG":
            needsBitmap = false
            bitmap = UtilityLightning.getImage(
                Utility.readPref("LIGHTNING_SECTOR", "usa_big"),
                Utility.readPref("LIGHTNING_PERIOD", "0.25")
            )
        case "SND":
            let nwsOffice = UtilityLocation.getNearestSoundingSite(Location.latlon)
            needsBitmap = false
            bitmap = UtilitySpcSoundings.getImage(nwsOffice)
        case "STRPT": url = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/today.gif"
        default:
            bitmap = Bitmap()
            needsBitmap = false
        }
        if needsBitmap {
            bitmap = Bitmap(url)
        }
        return bitmap
    }
}
