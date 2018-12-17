/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityRadarUI {

    static func showPolygonText(_ location: LatLon, _ uiv: UIViewController) {
        let warningText = UtilityWXOGL.showTextProducts(location)
        if warningText != "" {
            ActVars.usalertsDetailUrl = warningText
            uiv.goToVC("usalertsdetail")
        }
    }

    static func getMetar(_ location: LatLon, _ uiv: UIViewController) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityMetar.findClosestMetar(location)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = html
                uiv.goToVC("textviewer")
            }
        }
    }

    static func getForecast(_ location: LatLon, _ uiv: UIViewController) {
        ActVars.ADHOCLOCATION = location
        uiv.goToVC("adhoclocation")
    }

    static func getMeteogram(_ location: LatLon, _ uiv: UIViewController) {
        let obsSite = UtilityMetar.findClosestObservation(location)
        ActVars.IMAGEVIEWERurl = "http://www.nws.noaa.gov/mdl/gfslamp/meteo.php?"
            + "BackHour=0&TempBox=Y&DewBox=Y&SkyBox=Y&WindSpdBox=Y&WindDirBox="
            + "Y&WindGustBox=Y&CigBox=Y&VisBox=Y&ObvBox=Y&PtypeBox=N&PopoBox=Y&LightningBox=Y&ConvBox=Y&sta="
            + obsSite.name
        uiv.goToVC("imageviewer")
    }

    static func getRadarStatus(_ uiv: UIViewController, _ rid: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let radarStatus = getRadarStatusMessage(rid)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = radarStatus
                uiv.goToVC("textviewer")
            }
        }
    }

    static func getRadarStatusMessage(_ radarSite: String) -> String {
        var ridSmall = radarSite
        if radarSite.count == 4 {
            ridSmall.remove(at: radarSite.startIndex)
        }
        var message = UtilityDownload.getTextProduct("FTM" + ridSmall.uppercased())
        if message == "" {
            message = "The current radar status for " + radarSite + " is not available."
        }
        return message
    }
}
