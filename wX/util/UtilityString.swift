/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityString {

    static func shortenTime(_ str: String) -> String {
        let longTime = str
            .replace("-09:00", "")
            .replace("-10:00", "")
            .replace("-05:00", "")
            .replace("T", " ")
            .replace("-04:00", "")
            .replaceAll(":00 ", " ")
            .replaceAll("[0-9]{4}-", "")
        return longTime.replace("-06:00", "").replace("-07:00", "")
    }

    static func split(_ str: String, _ splitStr: String) -> [String] { str.components(separatedBy: splitStr) }

    static func substring(_ str: String, _ start: Int, _ end: Int) -> String {
        var retStr = ""
        str.indices.forEach {
            let intValue = str.distance(from: str.startIndex, to: $0)
            if intValue >= start && intValue < end { retStr += String(str[$0]) }
        }
        return retStr
    }

    static func substring(_ str: String, _ start: Int) -> String {
        var retStr = ""
        str.indices.forEach {
            let intValue = str.distance(from: str.startIndex, to: $0)
            if intValue >= start && intValue < str.count { retStr += String(str[$0]) }
        }
        return retStr
    }

    static func insert(_ str: String, _ idx: Int, _ text: Character) -> String {
        let index = str.index(str.startIndex, offsetBy: idx)
        var retStr = str
        retStr.insert(text, at: index)
        return retStr
    }

    static func replaceAll(_ str: String, _ a: String, _ b: String) -> String {
        let toArray = str.components(separatedBy: a)
        return toArray.joined(separator: b)
    }

    static func replaceAllRegexp(_ str: String, _ a: String, _ b: String) -> String {
        if let regex = try? NSRegularExpression(pattern: a, options: []) {
            let modString = regex.stringByReplacingMatches(
                in: str,
                options: .withTransparentBounds,
                range: NSRange(location: 0, length: str.count),
                withTemplate: b
            )
            return(modString)
        }
        return str
    }

    static func removeLineBreaks(_ html: String) -> String { html.replaceAll("\n\n", "<BR>").replaceAll("\n", " ").replaceAll("<BR>", "\n") }

    static func parseHelper(_ regex: String!, _ text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            var match = [String]()
            results.forEach { result in
                (0..<result.numberOfRanges).forEach {
                    if $0 % 2 != 0 {
                        match.append(nsString.substring(with: result.range(at: $0)))
                    }
                }
            }
            return match
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    static func parse(_ str: String, _ regexpStr: String) -> String {
        let retArr = parseHelper(regexpStr, str)
        if retArr.count > 0 { return retArr[retArr.count - 1] } else { return "" }
    }

    static func parseFirst(_ str: String, _ regexpStr: String) -> String {
        let retArr = parseHelper(regexpStr, str)
        if retArr.count > 0 { return retArr[0] } else { return "" }
    }

   	static func parseLastMatch(_ str: String, _ regexpStr: String) -> String { str.parse(regexpStr) }

    static func parseColumn(_ str: String, _ regexpStr: String) -> [String] { parseHelper(regexpStr, str) }

    static func parseColumnAll(_ str: String, _ regexpStr: String) -> [String] { parseHelper(regexpStr, str) }

    static func parseAndCount(_ str: String, _ regexpStr: String) -> Int { str.parseColumn(regexpStr).count }
    
    static func parseMultiple(_ str: String, _ matchStr: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: matchStr, options: [])
            let nsString = str as NSString
            let results = regex.matches(in: str, options: [], range: NSRange(location: 0, length: nsString.length))
            var match = [String]()
            results.forEach { result in
                (0..<result.numberOfRanges).forEach { match.append(nsString.substring(with: result.range(at: $0))) }
            }
            if match.count > 1 { match.remove(at: 0) }
            return match
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    static func getLastXChars(_ string: String, _ count: Int) -> String {
        if string.count == count {
            return string
        } else if string.count > count {
            return string.substring(string.count - count)
        } else {
            return string
        }
    }

    static func addPeriodBeforeLastTwoChars(_ str: String) -> String { str.insert(str.count - 2, ".") }

    static func fixedLengthString(_ string: String, _ length: Int) -> String {
        if string.count < length {
            var stringLocal = string
            (string.count...length).forEach { _ in stringLocal += " " }
            return stringLocal
        } else {
            return string
        }
    }

    static func extractPre(_ html: String) -> String {
        let separator = "ABC123E"
        let htmlOneLine = html.replaceAll(MyApplication.newline, separator)
        let parsedText = htmlOneLine.parse(MyApplication.pre2Pattern)
        return parsedText.replaceAll(separator, MyApplication.newline)
    }

    static func extractPreLsr(_ html: String) -> String {
        let separator = "ABC123E"
        let htmlOneLine = html.replace(MyApplication.newline, separator)
        let parsedText = htmlOneLine.parse(MyApplication.prePattern)
        return parsedText.replace(separator, MyApplication.newline)
    }
}
