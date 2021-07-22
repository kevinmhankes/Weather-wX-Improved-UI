/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityString {

//    static func shortenTime(_ s: String) -> String {
//        let longTime = s
//            .replace("-09:00", "")
//            .replace("-10:00", "")
//            .replace("-05:00", "")
//            .replace("T", " ")
//            .replace("-04:00", "")
//            .replaceAll(":00 ", " ")
//            .replaceAll("[0-9]{4}-", "")
//        return longTime.replace("-06:00", "").replace("-07:00", "")
//    }

    static func split(_ s: String, _ splitStr: String) -> [String] {
        s.components(separatedBy: splitStr)
    }

    static func substring(_ s: String, _ start: Int, _ end: Int) -> String {
        var retStr = ""
        s.indices.forEach {
            let intValue = s.distance(from: s.startIndex, to: $0)
            if intValue >= start && intValue < end {
                retStr += String(s[$0])
            }
        }
        return retStr
    }

    static func substring(_ s: String, _ start: Int) -> String {
        var retStr = ""
        s.indices.forEach {
            let intValue = s.distance(from: s.startIndex, to: $0)
            if intValue >= start && intValue < s.count {
                retStr += String(s[$0])
            }
        }
        return retStr
    }

    static func insert(_ s: String, _ idx: Int, _ text: Character) -> String {
        let index = s.index(s.startIndex, offsetBy: idx)
        var retStr = s
        retStr.insert(text, at: index)
        return retStr
    }

    static func replaceAll(_ s: String, _ a: String, _ b: String) -> String {
        let toArray = s.components(separatedBy: a)
        return toArray.joined(separator: b)
    }

    static func replaceAllRegexp(_ s: String, _ a: String, _ b: String) -> String {
        if let regex = try? NSRegularExpression(pattern: a, options: []) {
            let modString = regex.stringByReplacingMatches(
                in: s,
                options: .withTransparentBounds,
                range: NSRange(location: 0, length: s.count),
                withTemplate: b
            )
            return(modString)
        }
        return s
    }

    static func removeLineBreaks(_ html: String) -> String {
        html.replaceAll("\n\n", "<BR>").replaceAll("\n", " ").replaceAll("<BR>", "\n")
    }

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

    static func parse(_ s: String, _ regexpStr: String) -> String {
        let retArr = parseHelper(regexpStr, s)
        if retArr.count > 0 {
            return retArr[retArr.count - 1]
        } else {
            return ""
        }
    }

    static func parseFirst(_ s: String, _ regexpStr: String) -> String {
        let retArr = parseHelper(regexpStr, s)
        if retArr.count > 0 {
            return retArr[0]
        } else {
            return ""
        }
    }

   	static func parseLastMatch(_ s: String, _ regexpStr: String) -> String {
        s.parse(regexpStr)
    }

    static func parseColumn(_ s: String, _ regexpStr: String) -> [String] {
        parseHelper(regexpStr, s)
    }

    static func parseColumnAll(_ s: String, _ regexpStr: String) -> [String] {
        parseHelper(regexpStr, s)
    }

    static func parseAndCount(_ s: String, _ regexpStr: String) -> Int {
        s.parseColumn(regexpStr).count
    }

    static func parseMultiple(_ s: String, _ matchStr: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: matchStr, options: [])
            let nsString = s as NSString
            let results = regex.matches(in: s, options: [], range: NSRange(location: 0, length: nsString.length))
            var match = [String]()
            results.forEach { result in
                (0..<result.numberOfRanges).forEach { match.append(nsString.substring(with: result.range(at: $0))) }
            }
            if match.count > 1 {
                match.remove(at: 0)
            }
            return match
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    static func getLastXChars(_ s: String, _ count: Int) -> String {
        if s.count == count {
            return s
        } else if s.count > count {
            return s.substring(s.count - count)
        } else {
            return s
        }
    }

    static func addPeriodBeforeLastTwoChars(_ s: String) -> String {
        s.insert(s.count - 2, ".")
    }

    static func fixedLengthString(_ s: String, _ length: Int) -> String {
        if s.count < length {
            var stringLocal = s
            (s.count...length).forEach { _ in stringLocal += " " }
            return stringLocal
        } else {
            return s
        }
    }

    static func extractPre(_ html: String) -> String {
        let separator = "ABC123E"
        let htmlOneLine = html.replaceAll(GlobalVariables.newline, separator)
        let parsedText = htmlOneLine.parse(GlobalVariables.pre2Pattern)
        return parsedText.replaceAll(separator, GlobalVariables.newline)
    }

    static func extractPreLsr(_ html: String) -> String {
        let separator = "ABC123E"
        let htmlOneLine = html.replace(GlobalVariables.newline, separator)
        let parsedText = htmlOneLine.parse(GlobalVariables.prePattern)
        return parsedText.replace(separator, GlobalVariables.newline)
    }

    //
    // Legacy forecast/hourly support
    //
    static func parseXml(_ payloadF: String, _ delim: String) -> [String] {
        var payload = payloadF
        if delim == "start-valid-time" {
            payload = payload.replaceAllRegexp("<end-valid-time>.*?</end-valid-time>", "").replaceAllRegexp("<layout-key>.*?</layout-key>", "")
        }
        payload = payload.replaceAllRegexp("<name>.*?</name>", "").replaceAllRegexp("</" + delim + ">", "")
        return payload.split("<" + delim + ">")
    }

    static func parseXmlExt(_ regexpList: [String], _ html: String) -> [String] {
        var items = Array(repeating: "", count: regexpList.count)
        for i in 0..<regexpList.count {
            items[i] = parseFirst(html, regexpList[i])
        }
        return items
    }
    
    static func parseXmlValue(_ payloadF: String) -> [String] {
        var payload = payloadF
        payload = UtilityString.replaceAllRegexp(payload, "<name>.*?</name>", "")
        payload = UtilityString.replaceAllRegexp(payload, "</value>", "")
        return payload.split(GlobalVariables.xmlValuePattern)
    }
}
