/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

extension String {
    
    func startsWith(_ pattern: String) -> Bool { self.hasPrefix(pattern) }
    
    func parseLastMatch(_ pattern: String) -> String { UtilityString.parseLastMatch(self, pattern) }
    
    func trim() -> String { self.trimmingCharacters(in: NSCharacterSet.whitespaces) }
    
    func removeDuplicateSpaces() -> String { self.replace("   ", " ") }
    
    func fixedLengthString(_ length: Int) -> String { UtilityString.fixedLengthString(self, length) }
    
    func getDataFromUrl() -> Data { UtilityDownload.getDataFromUrl(self) }
    
    func removeHtml() -> String { self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) }
    
    func removeSingleLineBreaks() -> String { self.replace("\n\n", "ABZXCZ13").replace("\n", " ").replace("ABZXCZ13", "\n\n") }
    
    func removeLineBreaks() -> String { UtilityString.removeLineBreaks(self).replace("  ", " ") }
    
    func getHtml() -> String { UtilityDownload.getStringFromUrl(self) }
    
    func getHtmlSep() -> String { UtilityDownload.getStringFromUrlSep(self) }
    
    func getNwsHtml() -> String { UtilityDownloadNws.getStringFromUrl(self) }
    
    func getImage() -> Bitmap { UtilityDownload.getBitmapFromUrl(self) }
    
    func parseColumn(_ pattern: String) -> [String] { UtilityString.parseColumn(self, pattern) }
    
    func parseColumnAll(_ pattern: String) -> [String] { UtilityString.parseColumnAll(self, pattern) }
    
    func parse(_ pattern: String) -> String { UtilityString.parse(self, pattern) }
    
    func parseFirst(_ pattern: String) -> String { UtilityString.parseFirst(self, pattern) }
    
    func firstToken(_ delim: String) -> String {
        let tokens = self.split(delim)
        if tokens.count > 0 {
            return tokens[0]
        } else {
            return ""
        }
    }
    
    func firstToken() -> String { self.firstToken(":") }
    
    func truncate(_ length: Int) -> String {
        if self.count > length {
            let index =  self.index(self.startIndex, offsetBy: length)
            return String(self[..<index])
        } else {
            return self
        }
    }
    
    func insert(_ index: Int, _ string: String) -> String {
        let str1 = self.substring(0, index)
        let str2 = self.substring(index)
        return str1 + string + str2
    }
    
    func contains(_ str: String) -> Bool { self.range(of: str) != nil }
    
    func replaceAll(_ a: String, _ b: String) -> String { UtilityString.replaceAll(self, a, b) }
    
    func replaceAllRegexp(_ a: String, _ b: String) -> String { UtilityString.replaceAllRegexp(self, a, b) }
    
    func matches(regexp: String) -> Bool { (self.range(of: regexp, options: .regularExpression) != nil) }
    
    func replace(_ a: String, _ b: String) -> String { self.replaceAll(a, b) }
    
    func split(_ delim: String) -> [String] { UtilityString.split(self, delim) }
    
    func substring(_ start: Int) -> String { UtilityString.substring(self, start) }
    
    func substring(_ start: Int, _ end: Int) -> String { UtilityString.substring(self, start, end) }
    
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
            regex.enumerateMatches(in: self,
                                   options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                   range: all) {(result: NSTextCheckingResult?, _, _) in
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
    
    func roundToString() -> String { UtilityMath.roundDToString(self) }
    
    func celsiusToFarenheit() -> String { UtilityMath.celsiusDToFarenheit(self) }
    
    func farenheitToCelsius() -> String { UtilityMath.farenheitTocelsius(self) }
    
    // for SunCalc
    static let radPerDegree = Double.pi / 180.0
}

extension UInt8 {
    func toColor() -> CGFloat { CGFloat(Float(self) / 255.0) }
    
    func toColor() -> Float { Float(self) / 255.0 }
}

extension Int {
    func toColor() -> CGFloat { CGFloat(Float(self) / 255.0) }
    
    func red() -> UInt8 { Color.red(self) }
    
    func green() -> UInt8 { Color.green(self) }
    
    func blue() -> UInt8 { Color.blue(self) }
    
    func isEven() -> Bool { self & 1 == 0 }
}

extension UIImage {
    func getWidth() -> CGFloat { self.size.width }
    
    func getHeight() -> CGFloat { self.size.height }
}

extension UIColor {
    var coreImageColor: CoreImage.CIColor { CoreImage.CIColor(color: self) }
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

extension UIStackView {
    func removeViews() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    func removeArrangedViews() {
        self.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func goToVC(_ target: UIViewController) {
        UtilityActions.goToVc(self, target)
    }
}

extension Array where Element == String {
    func safeGet(_ index: Int) -> String {
        if self.count <= index {
            return ""
        } else {
            return self[index]
        }
    }
}

extension UIAlertAction {
    convenience init(_ title: String, _ handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: .default, handler: handler)
    }
    
    convenience init(_ title: Int, _ handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: String(title), style: .default, handler: handler)
    }
}

// for SunCalc
extension Date {
    static let j0 = 0.0009
    static let j1970 = 2440588.0
    static let j2000 = 2451545.0
    static let secondsPerDay = 86400.0
    
    init(julianDays days: Double) {
        let timeInterval = (days + 0.5 - Date.j1970) * Date.secondsPerDay
        self.init(timeIntervalSince1970: timeInterval)
    }
    
    var julianDays: Double { timeIntervalSince1970 / Date.secondsPerDay - 0.5 + Date.j1970 }
    
    var daysSince2000: Double { julianDays - Date.j2000 }
    
    func hoursLater(_ h: Double) -> Date { addingTimeInterval(h * 3600.0) }
    
    // Beginning time of a day, aka. 0:00 or midnight in GMT.
    func beginning() -> Date {
        let calender = Calendar.init(identifier: .gregorian)
        var comp = calender.dateComponents(in: TimeZone(identifier: "GMT")!, from: self)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        return calender.date(from: comp)!
    }
}
