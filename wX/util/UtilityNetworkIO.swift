/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityNetworkIO {
        
    static func getStringFromUrl(_ url: String) -> String {
        print("getStringFromUrl: " + url)
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
        print("getStringFromUrlSep: " + url)
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
        print("getBitmapFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return Bitmap()
        }
        let imageData = try? Data(contentsOf: safeUrl)
        if let image = imageData {
            return Bitmap(image)
        } else {
            return Bitmap()
        }
    }
    
    static func getDataFromUrl(_ url: String) -> Data {
        print("getDataFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return Data()
        }
        let imageData = try? Data(contentsOf: safeUrl)
        var data = Data()
        if let dataTmp = imageData { data = dataTmp }
        return data
    }
}
