/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityRadarUI {

    static func zoomOutByKey(_ wxMetal: [WXMetalRender?]) {
        wxMetal.forEach {
            if $0!.zoom > WXMetalSurfaceView.minZoom {
                WXMetalSurfaceView.setModifiedZoom($0!.zoom * 0.8, $0!.zoom, $0!)
                $0?.zoom *= 0.8
                $0?.setZoom()
                $0?.wxMetalTextObject.refreshTextLabels()
            }
        }
        wxMetal.forEach { $0?.demandRender() }
    }

    static func zoomInByKey(_ wxMetal: [WXMetalRender?]) {
        wxMetal.forEach {
            if $0!.zoom < WXMetalSurfaceView.maxZoom {
                WXMetalSurfaceView.setModifiedZoom($0!.zoom * 1.25, $0!.zoom, $0!)
                $0?.zoom *= 1.25
                $0?.setZoom()
                $0?.wxMetalTextObject.refreshTextLabels()
            }
        }
        wxMetal.forEach { $0?.demandRender() }
    }

    static func moveByKey(_ wxMetal: [WXMetalRender?], _ direction: KeyDirections) {
        var xChange: Float = 0.0
        var yChange: Float = 0.0
        switch direction {
        case .up:
            yChange = -25.0
        case .leftUp:
            yChange = -25.0
            xChange = 25.0
        case .rightUp:
            yChange = -25.0
            xChange = -25.0
        case .leftDown:
            yChange = 25.0
            xChange = 25.0
        case .rightDown:
            yChange = 25.0
            xChange = -25.0
        case .down:
            yChange = 25.0
        case .right:
            xChange = -25.0
        case .left:
            xChange = 25.0
        }
        wxMetal.forEach {
            $0?.xPos += xChange
            $0?.yPos += yChange
            $0?.wxMetalTextObject.refreshTextLabels()
        }
        wxMetal.forEach { $0?.demandRender() }
    }

    static func showPolygonText(_ location: LatLon, _ uiv: UIViewController) {
        let warningText = UtilityWXOGL.showTextProducts(location)
        if warningText != "" {
            Route.alertDetail(uiv, warningText)
        }
    }

    static func showNearestProduct(_ type: PolygonEnum, _ location: LatLon, _ uiv: UIViewController) {
        let txt = UtilityWatch.show(location, type)
        let token = String(describing: type) + txt
        // print("DEBUG: " + token)
        // token = "WPC" + type.string.replaceAll("PolygonType.", "") + txt
        // token =  "SPC" + type.string.replaceAll("PolygonType.", "").replaceAll("WATCH", "WAT") + txt
        let vc = vcSpcWatchMcdMpd()
        if token.hasPrefix("WPCMPD") && token != "WPCMPD" {
            vc.watchMcdMpdNumber = token.replace("WPCMPD", "")
            vc.watchMcdMpdType = .WPCMPD
        }
        if token.hasPrefix("SPCMCD") && token != "SPCMCD" {
            vc.watchMcdMpdNumber = token.replace("SPCMCD", "")
            vc.watchMcdMpdType = .SPCMCD
        }
        if token.hasPrefix("SPCWAT") && token != "SPCWAT" {
            vc.watchMcdMpdNumber = token.replace("SPCWAT", "")
            vc.watchMcdMpdType = .SPCWAT
        }
        if token != "SPCWAT" && token != "SPCMCD" && token != "WPCMPD" && token != "" {
            uiv.goToVC(vc)
        }
    }

    static func getMetar(_ location: LatLon, _ uiv: UIViewController) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityMetar.findClosestMetar(location)
            DispatchQueue.main.async { Route.textViewer(uiv, html) }
        }
    }

    static func getForecast(_ location: LatLon, _ uiv: UIViewController) {
        let vc = vcAdhocLocation()
        vc.adhocLocation = location
        uiv.goToVC(vc)
    }

    static func getMeteogram(_ location: LatLon, _ uiv: UIViewController) {
        let obsSite = UtilityMetar.findClosestObservation(location)
        let url = "https://www.nws.noaa.gov/mdl/gfslamp/meteo.php?"
        + "BackHour=0&TempBox=Y&DewBox=Y&SkyBox=Y&WindSpdBox=Y&WindDirBox="
        + "Y&WindGustBox=Y&CigBox=Y&VisBox=Y&ObvBox=Y&PtypeBox=N&PopoBox=Y&LightningBox=Y&ConvBox=Y&sta="
        + obsSite.name
        Route.imageViewer(uiv, url)
    }

    static func getRadarStatus(_ uiv: UIViewController, _ radarSite: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let status = getRadarStatusMessage(radarSite)
            DispatchQueue.main.async { Route.textViewer(uiv, status) }
        }
    }

    static func getRadarStatusMessage(_ radarSite: String) -> String {
        var ridSmall = radarSite
        // TODO adjustment when convert to 4char radar site code
        if radarSite.count == 4 {
            ridSmall.remove(at: radarSite.startIndex)
        }
        let message = UtilityDownload.getTextProduct("FTM" + ridSmall.uppercased())
        if message == "" {
            return "The current radar status for " + radarSite + " is not available."
        } else {
            return message
        }
    }

    static func getLatLonFromScreenPosition(_ uiv: UIViewController, _ wxMetal: WXMetalRender, _ numberOfPanes: Int, _ ortInt: Float, _ x: CGFloat, _ y: CGFloat) -> LatLon {
        let width = Double(uiv.view.bounds.size.width)
        let height = Double(uiv.view.bounds.size.height)
        var yModified = Double(y)
        var xModified = Double(x)
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                if y > uiv.view.frame.height / 2.0 { yModified -= Double(uiv.view.frame.height) / 2.0 }
            } else {
                if x > uiv.view.frame.width / 2.0 { xModified -= Double(uiv.view.frame.width) / 2.0 }
            }
        }
        if numberOfPanes == 4 {
            if y > uiv.view.frame.height / 2.0 { yModified -= Double(uiv.view.frame.height) / 2.0 }
            if x > uiv.view.frame.width / 2.0 { xModified -= Double(uiv.view.frame.width) / 2.0 }
        }
        var density = Double(ortInt * 2) / width
        if numberOfPanes == 4 {
            density = 2.0 * Double(ortInt * 2.0) / width
        }
        // if numberOfPanes == 2 && UtilityUI.isLandscape() {
            // density = 0.5 * Double(ortInt * 0.5) / width
            // density = Double(ortInt * 2) / width
        // }
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
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                xMiddle = width / 2.0
                yMiddle = height / 4.0
            } else {
                xMiddle = width / 4.0
                yMiddle = height / 2.0
            }
        }
        let diffX = density * (xMiddle - xModified) / Double(wxMetal.zoom)
        let diffY = density * (yMiddle - yModified) / Double(wxMetal.zoom)
        let radarLocation = LatLon(Utility.getRadarSiteX(wxMetal.rid), Utility.getRadarSiteY(wxMetal.rid))
        let ppd = wxMetal.projectionNumbers.oneDegreeScaleFactor
        let newX = radarLocation.lon + (Double(wxMetal.xPos) / Double(wxMetal.zoom) + diffX) / ppd
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4 + radarLocation.lat * (Double.pi / 180) / 2.0))
        var newY = test2 + (Double(-wxMetal.yPos) / Double(wxMetal.zoom) + diffY) / ppd
        newY = (180.0 / Double.pi * (2 * atan(exp(newY * Double.pi / 180.0)) - Double.pi / 2.0))
        return LatLon.reversed(newX, newY)
    }
}
