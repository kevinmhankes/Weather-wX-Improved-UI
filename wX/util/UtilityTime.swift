/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import MapKit

final class UtilityTime {

    static func monthWordToNumber(_ month: String) -> String {
        return month.replaceAll("Jan", "01")
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
        if let goodDate = date {
            returnTime = dateFormatter.string(from: goodDate)
        }
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
        if let goodDate = date {
            returnTime = dateFormatter.string(from: goodDate)
        }
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

    static func getYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }

    static func getMonth() -> Int {
        return Calendar.current.component(.month, from: Date())
    }

    static func getDay() -> Int {
        return Calendar.current.component(.day, from: Date())
    }

    static func secondsFromUTC() -> Int {
        return TimeZone.current.secondsFromGMT()
    }

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

    static func currentTimeMillis() -> Int {
        return Int((Date().timeIntervalSince1970 * 1000.0).rounded())
    }

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
        /*let coordinates = CLLocationCoordinate2D(
            latitude: Location.latlon.lat as CLLocationDegrees,
            longitude: Location.latlon.lon as CLLocationDegrees
        )
        let solar = Solar(coordinate: coordinates)
        let sunrise = solar?.sunrise
        let sunset = solar?.sunset
        return "Sunrise: " + getDateAsString(sunrise!, "h:mm") + "  Sunset: " + getDateAsString(sunset!, "h:mm")*/

        let sunCalc = SunCalc()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        var sunrise = ""
        var sunset = ""
        do {
            let rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            sunrise = formatter.string(from: rise)
            let set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
            sunset = formatter.string(from: set)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return "Sunrise: " + sunrise + "  Sunset: " + sunset
    }

    static func getSunriseSunsetFromObs(_ obs: RID) -> (Date, Date) {
        /*let coordinates = CLLocationCoordinate2D(
            latitude: obs.location.lat as CLLocationDegrees,
            longitude: obs.location.lon as CLLocationDegrees
        )
        let solar = Solar(coordinate: coordinates)
        let sunrise = solar?.sunrise
        let sunset = solar?.sunset
        return (sunrise!, sunset!)*/
        var rise = Date()
        var set = Date()
        let sunCalc = SunCalc()
        let now = Date()
        let location = SunCalc.Location(latitude: obs.location.lat, longitude: obs.location.lon)
        do {
            rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return(rise, set)
    }
}
