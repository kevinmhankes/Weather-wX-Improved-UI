/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

extension String {

    func removeSingleLineBreaks() -> String {
        return self.replace("\n\n", "ABZXCZ13").replace("\n", " ").replace("ABZXCZ13", "\n\n")
    }

    func removeLineBreaks() -> String {
        return UtilityString.removeLineBreaksS(self)
    }

    func getHtml() -> String {
        return UtilityDownload.getStringFromUrl(self)
    }

    func getHtmlSep() -> String {
        return UtilityDownload.getStringFromUrlSep(self)
    }

    func getNwsHtml() -> String {
        return UtilityDownloadNWS.getNWSStringFromURLS(self)
    }

    func getImage() -> Bitmap {
        return UtilityDownload.getBitmapFromUrl(self)
    }

    func parseColumn(_ pattern: String) -> [String] {
        return UtilityString.parseColumnS(self, pattern)
    }

    func parseColumnAll(_ pattern: String) -> [String] {
        return UtilityString.parseColumnAllS(self, pattern)
    }

    func parse(_ pattern: String) -> String {
        return UtilityString.parseS(self, pattern)
    }

    func parseFirst(_ pattern: String) -> String {
        return UtilityString.parseFirstS(self, pattern)
    }

    func firstToken(_ delim: String) -> String {
        let tokens = self.split(delim)
        if tokens.count > 0 {
            return tokens[0]
        } else {
            return ""
        }
    }

    func firstToken() -> String {
        return self.firstToken(":")
    }

    func truncate(_ length: Int) -> String {
        if self.count > length {
            let index =  self.index(self.startIndex, offsetBy: length)
            return String(self[..<index])
        } else {return self}
    }

    func insert(_ index: Int, _ string: String) -> String {
        let str1 = self.substring(0, index)
        let str2 = self.substring(index)
        return str1 + string + str2
    }

    func contains(_ str: String) -> Bool {
        return self.range(of: str) != nil
    }

    func replaceAll(_ a: String, _ b: String) -> String {
        return UtilityString.replaceAllS(self, a, b)
    }

    func replaceAllRegexp(_ a: String, _ b: String) -> String {
        return UtilityString.replaceAllRegexp(self, a, b)
    }

    func matches(regexp: String) -> Bool {
        return (self.range(of: regexp, options: .regularExpression) != nil)
    }

    func replace(_ a: String, _ b: String) -> String {
        return self.replaceAll(a, b)
    }

    func split(_ delim: String) -> [String] {
        return UtilityString.splitS(self, delim)
    }

    func substring(_ start: Int) -> String {
        return UtilityString.substringS(self, start)
    }

    func substring(_ start: Int, _ end: Int) -> String {
        return UtilityString.substringS(self, start, end)
    }

    func delete(_ str: String) -> String {
        let stringToArray = self.components(separatedBy: str)
        return stringToArray.joined(separator: "")
    }

    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches = [String]()
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {(result: NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func roundToString() -> String {
        return UtilityMath.roundDToString(self)
    }

    func celsiusToFarenheit() -> String {
        return UtilityMath.celsiusDToFarenheit(self)
    }

    func farenheitToCelsius() -> String {
        return UtilityMath.farenheitTocelsius(self)
    }
}

extension UIImage {
    func getWidth() -> CGFloat {return self.size.width}
    func getHeight() -> CGFloat {return self.size.height}
}

extension UIColor {
    var coreImageColor: CoreImage.CIColor {
        return CoreImage.CIColor(color: self)
    }
    var components: (red: Int, green: Int, blue: Int) {
        var r = 0
        var g = 0
        var b = 0
        let color = coreImageColor
        r = Int(color.red * 255)
        g = Int(color.green * 255)
        b = Int(color.blue * 255)
        return (r, g, b)
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension UIViewController {
    func goToVC(_ target: String) {
        UtilityActions.goToVCS(self, target)
    }
}
