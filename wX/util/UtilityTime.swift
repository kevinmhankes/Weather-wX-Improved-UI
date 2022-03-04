// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import MapKit

final class UtilityTime {
    
    static func monthWordToNumber(_ month: String) -> String {
        month.replaceAll("Jan", "01")
            .replaceAll("Feb", "02")
            .replaceAll("Mar", "03")
            .replaceAll("Apr", "04")
            .replaceAll("May", "05")
            .replaceAll("Jun", "06")
            .replaceAll("Jul", "07")
            .replaceAll("Aug", "08")
            .replaceAll("Sep", "09")
            .replaceAll("Oct", "10")
            .replaceAll("Nov", "11")
            .replaceAll("Dec", "12")
    }
    
    static func gmtTime() -> String {
        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return "GMT: " + formatter.string(from: UTCDate)
    }
    
    static func convertFromUTCForMetar(_ time: String) -> String {
        // time comes in as follows 2018.02.11 2353 UTC
        var returnTime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd' 'HHmm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: time.replace("+00:00", ""))
        dateFormatter.dateFormat = "MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone.current
        if let goodDate = date {
            returnTime = dateFormatter.string(from: goodDate)
        }
        return returnTime
    }
    
    static func dayOfWeek(_ year: Int, _ month: Int, _ day: Int) -> String {
        var futureDateComp = DateComponents()
        futureDateComp.year = year
        futureDateComp.month = month
        futureDateComp.day = day
        let calendar = Calendar.current
        let futureDate = calendar.date(from: futureDateComp)!
        let dayIndex = calendar.component(.weekday, from: futureDate)
        switch dayIndex {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
    
    static func getYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }
    
    static func secondsFromUTC() -> Int {
        TimeZone.current.secondsFromGMT()
    }
    
    static func genModelRuns(_ time: String, _ hours: Int, _ dateStr: String) -> [String] {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(secondsFromGMT: 0)
        dateFmt.dateFormat = dateStr
        let date = dateFmt.date(from: time)
        var runs = [String]()
        (1...4).forEach {
            let timeChange = 60.0 * 60.0 * Double(hours) * Double($0)
            runs.append(dateFmt.string(from: (date! - timeChange) as Date))
        }
        return runs
    }
    
    static func getDateAsString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // "MMMM dd yyyy"
        return dateFormatter.string(from: Date())
    }
    
    static func currentTimeMillis() -> Int {
        Int((Date().timeIntervalSince1970 * 1000.0).rounded())
    }
    
    static func getCurrentHourInUTC() -> Int {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.hour], from: date)
        return components.hour ?? 0
    }
    
    static func getLocalTimeAsString() -> String {
        getDateAsString("yyyy-MM-dd HH:mm:ss")
    }
    
    static func isRadarTimeOld(_ fileStorage: FileStorage) -> Bool {
        // 1 min is 60,000 ms
        print(fileStorage.radarAgeMilli)
        if fileStorage.radarAgeMilli > 20 * 60000 {
            return true
        }
        return false
    }
        
    static func isVtecCurrent(_ vtec: String ) -> Bool {
         // example 190512T1252Z-190512T1545Z
         let timeRange = vtec.parse("-([0-9]{6}T[0-9]{4})Z")
         let timeInMinutes = decodeVtecTime(timeRange)
         let currentTimeInMinutes = decodeVtecTime(getGmtTimeForVtec())
         return currentTimeInMinutes < timeInMinutes
     }
    
    private static func decodeVtecTime(_ timeRangeOriginal: String) -> Date {
        // Y2K issue
        let timeRange = timeRangeOriginal.replace("T", "")
        let year = to.Int("20" + timeRange.parse("([0-9]{2})[0-9]{4}[0-9]{4}"))
        let month = to.Int(timeRange.parse("[0-9]{2}([0-9]{2})[0-9]{2}[0-9]{4}"))
        let day = to.Int(timeRange.parse("[0-9]{4}([0-9]{2})[0-9]{4}"))
        let hour = to.Int(timeRange.parse("[0-9]{6}([0-9]{2})[0-9]{2}"))
        let minute = to.Int(timeRange.parse("[0-9]{6}[0-9]{2}([0-9]{2})"))
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.hour = hour
        dateComponents.minute = minute
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        // print("DATE: " + date!.description)
        return date!
    }
    
    static func getGmtTimeForVtec() -> String {
        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: UTCDate)
    }
    
    static func translateTimeForHourly(_ originalTime: String) -> String {
        let originalTimeComponents = originalTime.replace("T", "-").split("-")
        let year = to.Int(originalTimeComponents[0])
        let month = to.Int(originalTimeComponents[1])
        let day = to.Int(originalTimeComponents[2])
        let hour = to.Int(originalTimeComponents[3].replace(":00:00", ""))
        let hourString = String(hour)
        let dayOfTheWeek: String
        var futureDateComp = DateComponents()
        futureDateComp.year = year
        futureDateComp.month = month
        futureDateComp.day = day
        let calendar = Calendar.current
        let futureDate = calendar.date(from: futureDateComp)!
        let dayOfTheWeekIndex = calendar.component(.weekday, from: futureDate)
        switch dayOfTheWeekIndex {
        case 2:
            dayOfTheWeek = "Mon"
        case 3:
            dayOfTheWeek = "Tue"
        case 4:
            dayOfTheWeek = "Wed"
        case 5:
            dayOfTheWeek = "Thu"
        case 6:
            dayOfTheWeek = "Fri"
        case 7:
            dayOfTheWeek = "Sat"
        case 1:
            dayOfTheWeek = "Sun"
        default:
            dayOfTheWeek = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayString = dateFormatter.string(from: futureDate)
        // print("ZZZ " + dayOfTheWeek + " " + dayString)
        return dayOfTheWeek + " " + hourString
    }
}
