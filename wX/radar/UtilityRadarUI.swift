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

    static func getLatLonFromScreenPosition(
        _ uiv: UIViewController,
        _ wxMetal: WXMetalRender,
        _ numberOfPanes: Int,
        _ ortInt: Float,
        _ x: CGFloat,
        _ y: CGFloat
        ) -> LatLon {
        let width = Double(uiv.view.bounds.size.width)
        let height = Double(uiv.view.bounds.size.height)
        var yModified = Double(y)
        var xModified = Double(x)
        if numberOfPanes != 1 {
            if y > uiv.view.frame.height / 2.0 {
                yModified -= Double(uiv.view.frame.height) / 2.0
            }
        }
        if numberOfPanes == 4 {
            if x > uiv.view.frame.width / 2.0 {
                xModified -= Double(uiv.view.frame.width) / 2.0
            }
        }
        var density = Double(ortInt * 2) / width
        if numberOfPanes == 4 {
            density = 2.0 * Double(ortInt * 2.0) / width
        }
        var yMiddle = 0.0
        var xMiddle = 0.0
        if numberOfPanes == 1 {
            yMiddle = height / 2.0
        } else {
            yMiddle = height / 4.0
        }
        if numberOfPanes == 4 {
            xMiddle = width / 4.0
        } else {
            xMiddle = width / 2.0
        }
        let diffX = density * (xMiddle - xModified) / Double(wxMetal.zoom)
        let diffY = density * (yMiddle - yModified) / Double(wxMetal.zoom)
        let radarLocation = LatLon(preferences.getString("RID_" + wxMetal.rid + "_X", "0.00"),
                                   preferences.getString("RID_" + wxMetal.rid + "_Y", "0.00"))
        let ppd = wxMetal.pn.oneDegreeScaleFactor
        let newX = radarLocation.lon + (Double(wxMetal.xPos) / Double(wxMetal.zoom) + diffX) / ppd
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4 + radarLocation.lat * (Double.pi / 180) / 2.0))
        var newY = test2 + (Double(-wxMetal.yPos) / Double(wxMetal.zoom) + diffY) / ppd
        newY = (180.0 / Double.pi * (2 * atan(exp(newY * Double.pi / 180.0)) - Double.pi / 2.0))
        return LatLon.reversed(newX, newY)
    }
}
