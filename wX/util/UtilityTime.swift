/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

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
    
    static func convertFromUTC(_ time: String) -> String {
        // time comes in as follows 2017-02-17 06:53:00+00:00
        var returnTime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: time.replace("+00:00", ""))
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone.current
        if let goodDate = date { returnTime = dateFormatter.string(from: goodDate) }
        return returnTime
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
        if let goodDate = date { returnTime = dateFormatter.string(from: goodDate) }
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
    
    static func getYear() -> Int { Calendar.current.component(.year, from: Date()) }
    
    static func getMonth() -> Int { Calendar.current.component(.month, from: Date()) }
    
    static func getDay() -> Int { Calendar.current.component(.day, from: Date()) }
    
    static func secondsFromUTC() -> Int { TimeZone.current.secondsFromGMT() }
    
    static func genModelRuns(_ time: String, _ hours: Int) -> [String] {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(secondsFromGMT: 0)
        dateFmt.dateFormat =  "yyyyMMddHH"
        let date = dateFmt.date(from: time)
        var runs = [String]()
        (1...4).forEach {
            let timeChange = 60.0 * 60.0 * Double(hours) * Double($0)
            runs.append(dateFmt.string(from: (date! - timeChange) as Date))
        }
        return runs
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
    
    static func getDateAsString(_ date: Date, _ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func currentTimeMillis64() -> Int64 { Int64(Date().timeIntervalSince1970 * 1000) }
    
    static func currentTimeMillis() -> Int { Int((Date().timeIntervalSince1970 * 1000.0).rounded()) }
    
    static func getCurrentHourInUTC() -> Int {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.hour], from: date)
        return components.hour ?? 0
    }
    
    static func getCurrentHour() -> Int {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let components = calendar.dateComponents([.hour], from: date)
        return components.hour ?? 0
    }
    
    static func getCurrentLocalTimeAsString() -> String { getDateAsString("yyyy-MM-dd HH:mm:ss") }
    
    static func isRadarTimeOld(_ radarTime: String) -> Bool {
        let radarTimeComponents = radarTime.split(":")
        if radarTimeComponents.count < 3 {
            // something went wrong
            return false
        }
        let radarTimeHours = Int(radarTimeComponents[0]) ?? 0
        let radarTimeMinutes = Int(radarTimeComponents[1]) ?? 0
        let radarTimeTotalMinutes = radarTimeHours * 60 + radarTimeMinutes
        let currentTime = Utility.safeGet(getCurrentLocalTimeAsString().split(" "), 1)
        let currentTimeComponents = currentTime.split(":")
        if currentTimeComponents.count < 3 {
            // something went wrong
            return false
        }
        let currentTimeHours = Int(currentTimeComponents[0]) ?? 0
        let currentTimeMinutes = Int(currentTimeComponents[1]) ?? 0
        let currentTimeTotalMinutes = currentTimeHours * 60 + currentTimeMinutes
        if currentTimeTotalMinutes < 30 {
            // TODO find out how to handle midnight
            return false
        }
        if radarTimeTotalMinutes > currentTimeTotalMinutes {
            // radar time should not be in the future, radar is down
            return true
        }
        if radarTimeTotalMinutes < (currentTimeTotalMinutes - 20) { return true }
        return false
    }
    
    /*static func isVtecCurrent(_ vtec: String ) ->  Bool {
     // example 190512T1252Z-190512T1545Z
     let timeRange = vtec.parse("-([0-9]{6}T[0-9]{4})Z")
     let timeInMinutes = decodeVtecTime(timeRange)
     let currentTimeInMinutes = decodeVtecTime(getGmtTimeForVtec())
     return currentTimeInMinutes.before(timeInMinutes)
     }
     
     private static func decodeVtecTime(_ timeRangeOriginal: String) -> Calendar {
     // Y2K issue
     let timeRange = timeRangeOriginal.replace("T","")
     let year = Int("20" + (timeRange).parse("([0-9]{2})[0-9]{4}[0-9]{4}")) ?? 0
     let month = Int((timeRange).parse("[0-9]{2}([0-9]{2})[0-9]{2}[0-9]{4}")) ?? 0
     let day = Int((timeRange).parse("[0-9]{4}([0-9]{2})[0-9]{4}"))  ?? 0
     let hour = Int((timeRange).parse("[0-9]{6}([0-9]{2})[0-9]{2}")) ?? 0
     let minute = Int((timeRange).parse("[0-9]{6}[0-9]{2}([0-9]{2})")) ?? 0
     let cal = Calendar.getInstance()
     cal.set(year, month - 1, day, hour, minute)
     return cal
     }
     
     static func getGmtTimeForVtec() -> String {
     let UTCDate = Date()
     let formatter = DateFormatter()
     formatter.dateFormat = "yyMMddHHmm"
     formatter.timeZone = TimeZone(secondsFromGMT: 0)
     return formatter.string(from: UTCDate)
     }*/
}
