/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class Utility {
    
    static func getRadarSiteName(_ radarSite: String) -> String { UtilityRadar.radarIdToName[radarSite] ?? "" }
    
    static func getRadarSiteLatLon(_ radarSite: String) -> LatLon {
        let lat = UtilityRadar.radarSiteToLat[radarSite] ?? ""
        let lon = "-" + (UtilityRadar.radarSiteToLon[radarSite] ?? "")
        return LatLon(lat, lon)
    }
    
    static func getRadarSiteX(_ radarSite: String) -> String { UtilityRadar.radarSiteToLat[radarSite] ?? "" }
    
    static func getRadarSiteY(_ radarSite: String) -> String { UtilityRadar.radarSiteToLon[radarSite] ?? "" }
    
    static func getWfoSiteName(_ wfo: String) -> String { UtilityRadar.wfoIdToName[wfo] ?? "" }
    
    static func getWfoSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadar.wfoSitetoLat[wfo] ?? ""
        let lon = UtilityRadar.wfoSitetoLon[wfo] ?? ""
        return LatLon(lat, lon)
    }
    
    static func getSoundingSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadar.soundingSiteToLat[wfo] ?? ""
        let lon = "-" + (UtilityRadar.soundingSiteToLon[wfo] ?? "")
        return LatLon(lat, lon)
    }
    
    static func getSoundingSiteName(_ wfo: String) -> String {
        var site = UtilityRadar.wfoIdToName[wfo] ?? ""
        if site == "" { site = UtilityRadar.soundingIdToName[wfo] ?? "" }
        return site
    }
    
    /*static func generateSoundingNameList() -> [String] {
     var list = <String>[]
     GlobalArrays.soundingSites.sort()
     GlobalArrays.soundingSites.forEach((data) {
     list.add(data + ": " + getSoundingSiteName(data))
     });
     return list
     }*/
    
    static func getCurrentHazards(_ uiv: UIViewController, _ locNum: Int) -> ObjectHazards {
        if Location.isUS(locNum) {
            return ObjectHazards(uiv, locNum)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectHazards.createForCanada(html)
        }
    }
    
    static func getHazards(_ url: String) -> String { url.parse("<!-- AddThis Button END -->   <hr /><br />(.*?)</div>") }
    
    static func safeGet(_ list: [String], _ index: Int) -> String {
        if list.count <= index { return "" } else { return list[index] }
    }
    
    static func readPref(_ key: String, _ value: Float) -> Float { GlobalVariables.preferences.getFloat(key, value) }
    
    static func readPref(_ key: String, _ value: Int) -> Int { GlobalVariables.preferences.getInt(key, value) }
    
    static func readPref(_ key: String, _ value: String) -> String { GlobalVariables.preferences.getString(key, value) }
    
    static func writePref(_ key: String, _ value: Float) {
        GlobalVariables.editor.putFloat(key, value)
    }
    
    static func writePref(_ key: String, _ value: Int) {
        GlobalVariables.editor.putInt(key, value)
    }
    
    static func writePref(_ key: String, _ value: String) {
        GlobalVariables.editor.putString(key, value)
    }
    
    static func getClassName(_ uiv: UIViewController) -> String { String(describing: uiv).split(":").safeGet(0).replace("<", "") }
    
    static func showMainScreenShortCuts() -> String {
            "Ctrl-r: Nexrad radar" + MyApplication.newline +
            "Ctrl-m: Show submenu" + MyApplication.newline +
            "Ctrl-d: Severe Dashboard" + MyApplication.newline +
            "Ctrl-c: Goes Viewer" + MyApplication.newline +
            "Ctrl-a: Local text product viewer" + MyApplication.newline +
            "Ctrl-s: Settings" + MyApplication.newline +
            "Ctrl-2: Dual Pane Radar" + MyApplication.newline +
            "Ctrl-4: Quad Pane Radar" + MyApplication.newline +
            "Ctrl-w: US Alerts" + MyApplication.newline +
            "Ctrl-e: SPC Mesoanalysis" + MyApplication.newline +
            "Ctrl-n: NCEP Models" + MyApplication.newline +
            "Ctrl-h: Hourly" + MyApplication.newline +
            "Ctrl-t: NHC" + MyApplication.newline +
            "Ctrl-l: Lightning" + MyApplication.newline +
            "Ctrl-i: National images" + MyApplication.newline +
            "Ctrl-z: National text discussions" + MyApplication.newline +
            "<-: Previous tab" + MyApplication.newline +
            "->: Next tab" + MyApplication.newline
    }
    
    static func showRadarShortCuts() -> String {
            "Ctrl-a: Animate" + MyApplication.newline +
            "Ctrl-a: Stop animate" + MyApplication.newline +
            "Ctrl-2: Show dual pane radar" + MyApplication.newline +
            "Ctrl-4: Show quad pane radar" + MyApplication.newline +
            "Alt-UpArrow: Zoom out" + MyApplication.newline +
            "Alt-DownArrow: Zoom in" + MyApplication.newline +
            "Arrow keys: pan radar" + MyApplication.newline
    }
    
    static func showDiagnostics() -> String {
        MyApplication.newline + "Is Tablet?: " + String(UtilityUI.isTablet()) + MyApplication.newline + GlobalVariables.forecastZone
    }
}
