/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import MapKit

final class UtilityTime {

    static func monthWordToNumber(_ month: String) -> String {
        var monthStr = month.replaceAll("Jan", "01")
        monthStr = monthStr.replaceAll("Feb", "02")
        monthStr = monthStr.replaceAll("Mar", "03")
        monthStr = monthStr.replaceAll("Apr", "04")
        monthStr = monthStr.replaceAll("May", "05")
        monthStr = monthStr.replaceAll("Jun", "06")
        monthStr = monthStr.replaceAll("Jul", "07")
        monthStr = monthStr.replaceAll("Aug", "08")
        monthStr = monthStr.replaceAll("Sep", "09")
        monthStr = monthStr.replaceAll("Oct", "10")
        monthStr = monthStr.replaceAll("Nov", "11")
        return monthStr.replaceAll("Dec", "12")
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
        if let goodDate = date {returnTime = dateFormatter.string(from: goodDate)}
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
        if let goodDate = date {returnTime = dateFormatter.string(from: goodDate)}
        return returnTime
    }

    static func dayOfWeek(_ year: Int, _ month: Int, _ day: Int) -> String {
        var dayOfTheWeek = ""
        var futureDateComp = DateComponents()
        futureDateComp.year = year
        futureDateComp.month = month
        futureDateComp.day = day
        let calendar = Calendar.current
        let futureDate = calendar.date(from: futureDateComp)!
        let dayIndex = calendar.component(.weekday, from: futureDate)
        switch dayIndex {
        case 1: dayOfTheWeek = "Sun"
        case 2: dayOfTheWeek = "Mon"
        case 3: dayOfTheWeek = "Tue"
        case 4: dayOfTheWeek = "Wed"
        case 5: dayOfTheWeek = "Thu"
        case 6: dayOfTheWeek = "Fri"
        case 7: dayOfTheWeek = "Sat"
        default: break
        }
        return dayOfTheWeek
    }

    static func getYear() -> Int {return Calendar.current.component(.year, from: Date())}

    static func getMonth() -> Int {return Calendar.current.component(.month, from: Date())}

    static func getDay() -> Int {return Calendar.current.component(.day, from: Date())}

    static func secondsFromUTC() -> Int {return TimeZone.current.secondsFromGMT()}

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

    static func currentTimeMillis64() -> Int64 {
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble * 1000)
    }

    static func currentTimeMillis() -> Int {return Int((Date().timeIntervalSince1970 * 1000.0).rounded())}

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

    static func getSunriseSunset() -> String {
        let coordinates = CLLocationCoordinate2D(latitude: Location.latlon.lat as CLLocationDegrees,
                                                 longitude: Location.latlon.lon as CLLocationDegrees)
        let solar = Solar(coordinate: coordinates)
        let sunrise = solar?.sunrise
        let sunset = solar?.sunset
        return "Sunrise: " + getDateAsString(sunrise!, "h:mm") + "  Sunset: " + getDateAsString(sunset!, "h:mm")
    }

    static func getSunriseSunsetFromObs(_ obs: RID) -> (Date, Date) {
        let coordinates = CLLocationCoordinate2D(latitude: obs.location.lat as CLLocationDegrees,
                                                 longitude: obs.location.lon as CLLocationDegrees)
        let solar = Solar(coordinate: coordinates)
        let sunrise = solar?.sunrise
        let sunset = solar?.sunset
        return (sunrise!, sunset!)
    }

    static func isNight() -> Bool {
        // FIXME based on LAT/LON SUNRISE/SUNSET OF OBS
        let hour = getCurrentHour()
        if hour < 7 || hour > 19 {
            return true
        }
        return false
    }
}
