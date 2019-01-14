/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityPlayList {

    static let formatTimeString = "MM-dd HH:mm"

    static func add(_ prod: String, _ text: String, _ uiv: UIViewController, _ menuButton: ObjectToolbarIcon) {
        let prodLocal = prod.uppercased()
        if !MyApplication.playlistStr.contains(prodLocal) {
            editor.putString("PLAYLIST", MyApplication.playlistStr + ":" + prodLocal)
            MyApplication.playlistStr += ":" + prodLocal
            _ = ObjectToast(prodLocal + " saved to playlist: " + String(text.count), uiv, menuButton)
        } else {
            _ = ObjectToast(prodLocal + " already in playlist: " + String(text.count), uiv, menuButton)
        }
        let formattedDate = UtilityTime.getDateAsString(formatTimeString)
        Utility.writePref("PLAYLIST_" + prodLocal, text)
        Utility.writePref("PLAYLIST_" + prodLocal + "_TIME", formattedDate)
    }

    static func checkAndSave(_ prod: String, _ text: String) {
        let prodLocal = prod.uppercased()
        let formattedDate = UtilityTime.getDateAsString(formatTimeString)
        if MyApplication.playlistStr.contains(prodLocal) {
            Utility.writePref("PLAYLIST_" + prodLocal, text)
            Utility.writePref("PLAYLIST_" + prodLocal + "_TIME", formattedDate)
        }
    }

    static func downloadAll() {
        var resultStr = ""
        let arr = MyApplication.playlistStr.split(":")
        var text = ""
        let formattedDate = UtilityTime.getDateAsString(formatTimeString)
        arr.forEach {
            text = UtilityDownload.getTextProduct($0)
            if $0.contains("SWO") {
                text = text.replaceAll("^<br>", "")
            }
            if text != "" {
                Utility.writePref("PLAYLIST_" + $0, text)
                Utility.writePref("PLAYLIST_" + $0 + "_TIME", formattedDate)
            }
            resultStr += $0 + " " + String(text.count) + " "
        }
        let formattedDate2 = UtilityTime.getDateAsString("MM-dd-yy HH:mm:SS Z")
        Utility.writePref("PLAYLIST_STATUS", formattedDate2 + MyApplication.newline + resultStr)
    }
}
