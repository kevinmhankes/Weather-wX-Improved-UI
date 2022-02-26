// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class ObjectDateTime {

    var dateTime = Date()

    static func fromObs(_ time: String) -> ObjectDateTime {
        // time comes in as follows 2018.02.11 2353 UTC
        // https://valadoc.org/glib-2.0/GLib.DateTime.DateTime.from_iso8601.html
        // https://en.wikipedia.org/wiki/ISO_8601
        var returnTime = time.strip()
        returnTime = returnTime.replace(" UTC", "")
        returnTime = returnTime.replace(".", "")
        returnTime = returnTime.replace(" ", "T") + "00.000Z"
        // time should now be as "20220225T095300.000Z"
        // text has a timezone "Z" so 2nd arg is null

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss.SSSZ"
        let dateTime = dateFormatter.date(from: returnTime)
        print("ZZZ Decode:" + returnTime)

        let objectDateTime = ObjectDateTime()
        objectDateTime.dateTime = dateTime ?? Date()
        return objectDateTime
    }
    
    //
    // start of core static methods
    //
    static func getCurrentTimeInUTC() -> Date {
        return Date()
    }

    // is difference between t1 and t2 less then 20min
    static func timeDifference(_ t1: Date, _ t2: Date, _ m: Int) -> Bool {
        let date = t2.addingTimeInterval(Double(m) * 60)
        return date > t1
        //return (t1.difference(t2) / 60000000.0) < m;
    }

}
